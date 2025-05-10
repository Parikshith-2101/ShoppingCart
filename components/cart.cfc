<cfcomponent>
    <cffunction name = "sendOrderPlacedMail" access = "public" returnType = "void">
        <cfargument name = "receiverMail" required = true type = "string">
        <cfargument name = "orderID" required = true type = "string">
        <cfargument name = "totalPrice" required = true type = "string">
        <cfargument name = "totalTax" required = true type = "string">
        <cftry>
            <cfset local.getOrderDetails = getOrderDetails(orderId = arguments.orderId)>
            <cfset local.orderDetails = local.getOrderDetails.order[1]>
            <cfset local.productNames = "">
            <cfloop array = "#local.orderDetails.product#" item="productItem">
                <cfset local.productNames &= "- #productItem.productName# (Quantity - #productItem.productName#)<br>">
            </cfloop>
            <cfmail 
                to = "#arguments.receiverMail#" 
                from = "parikshith2101@gmail.com" 
                subject = "Order Confirmation - #arguments.orderID#"
                type = "html"
            >
                <h2>Order Confirmation</h2>      
                <p>Dear #local.orderDetails.address.firstName# #local.orderDetails.address.lastName#,</p>
                <p>Thank you for your order! Below are the details:</p>
                <p><strong>Order ID:</strong> #arguments.orderID#</p>
                <p><strong>Order Date:</strong> #local.orderDetails.orderDate#</p>
                <p><strong>Phone:</strong> #local.orderDetails.address.phone#</p>
                <h3>Shipping Address:</h3>
                <p>#local.orderDetails.address.addressLine1#, #local.orderDetails.address.addressLine2#</p>
                <p>#local.orderDetails.address.city#, #local.orderDetails.address.state#, #local.orderDetails.address.pincode#</p>
                <h3>Products Ordered:</h3>
                <p>#local.productNames#</p>
                <h3>Payment Summary:</h3>
                <p><strong>Total Price:</strong> &##8377; #NumberFormat(arguments.totalPrice, "9,999.00")#</p>
                <p><strong>Total Tax:</strong> &##8377; #NumberFormat(arguments.totalTax, "9,999.00")#</p>
                <p><strong>Grand Total:</strong> &##8377; #NumberFormat(arguments.totalPrice + arguments.totalTax, "9,999.00")#</p>
                <p>We appreciate your business and will notify you once your order is shipped.</p>
                <p>Best Regards,<br><strong>Shopping Cart</strong></p>
            </cfmail>         
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset application.productManagementObj.sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name = "getCartDetails" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "productId" required = false type = "string"> 
        <cfset local.result = {
            'error' : false,
            'cart' : []
        }>
        <cfset local.decrytedProductId = "">
        <cftry>
            <cfif structKeyExists(arguments, "productId") AND arguments.productId NEQ 0>
                <cfset local.decrytedProductId = application.productManagementObj.decryptData(data = arguments.productId)>
            </cfif>
            <cfquery name = "local.qryCart" datasource = "#application.dataSource#">
                SELECT 
                    C.fldCart_Id,
                    C.fldProductId,
                    C.fldQuantity,
                    P.fldProductName,
                    P.fldUnitPrice,
                    P.fldUnitTax,
                    PI.fldImageFilePath
                FROM 
                    tblcart C 
                    INNER JOIN tblproduct P ON P.fldProduct_Id = C.fldProductId
                    LEFT JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id AND PI.fldDefaultImage = 1
                WHERE 
                    C.fldUserId = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">
                    AND P.fldActive = 1
                    <cfif local.decrytedProductId NEQ "">
                        AND C.fldProductId = <cfqueryparam value = "#val(local.decrytedProductId)#" cfsqltype = "integer"> 
                    </cfif>
            </cfquery>
            <cfloop query = "local.qryCart">
                <cfset arrayAppend(local.result['cart'],{
                    'cartId' : application.productManagementObj.encryptData(data = local.qryCart.fldCart_Id),
                    'productId' : application.productManagementObj.encryptData(data = local.qryCart.fldProductId),
                    'quantity' : local.qryCart.fldQuantity,
                    'productName' : local.qryCart.fldProductName,
                    'unitPrice' : local.qryCart.fldUnitPrice,
                    'unitTax' : local.qryCart.fldUnitTax,
                    'imageFile' : local.qryCart.fldImageFilePath
                })>
            </cfloop>
            <cfcatch>
                <cfset local.result['error'] = true>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset application.productManagementObj.sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "manageCart" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "modifyStatus" required = true type = "string">
        <cfargument name = "productId" required = true type = "string">   
        <cfset local.result = {
            'error' : false,
            'message' : ""
        }>
        
        <cftry>
            <cfset local.decryptedProductId = application.productManagementObj.decryptData(data = arguments.productId)>
            <cfset local.cartData = getCartDetails(productId = arguments.productId)>
            <cfset local.quantityCount = 0>        
            <cfif arguments.modifyStatus EQ "add">
                <cfif arrayLen(local.cartData.cart)>
                    <cfset local.quantityCount = local.cartData.cart[1].quantity + 1>
                    <cfquery datasource = "#application.dataSource#">
                        UPDATE tblcart
                        SET fldQuantity = <cfqueryparam value = "#val(local.quantityCount)#" cfsqltype = "integer">
                        WHERE fldProductId = <cfqueryparam value = "#val(local.decryptedProductId)#" cfsqltype = "integer">
                            AND fldUserId = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">
                    </cfquery>
                    <cfset local.result['message'] = "Edited">
                <cfelse>
                    <cfquery datasource = "#application.dataSource#">
                        INSERT INTO tblcart (fldUserId, fldProductId, fldQuantity)
                        VALUES (
                            <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                            <cfqueryparam value = "#val(local.decryptedProductId)#" cfsqltype = "integer">,
                            1
                        );
                    </cfquery>
                    <cfset local.result['message'] = "Added">
                </cfif>
            <cfelseif (arguments.modifyStatus EQ "remove") AND (arrayLen(local.cartData.cart) AND local.cartData.cart[1].quantity GT 1)>
                <cfset local.quantityCount = local.cartData.cart[1].quantity - 1>
                <cfquery datasource = "#application.dataSource#">
                    UPDATE 
                        tblcart
                    SET 
                        fldQuantity = <cfqueryparam value = "#val(local.quantityCount)#" cfsqltype = "integer">
                    WHERE 
                        fldProductId = <cfqueryparam value = "#val(local.decryptedProductId)#" cfsqltype = "integer">
                        AND fldUserId = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">
                </cfquery>
                <cfset local.result['message'] = "Removed">
            <cfelse>
                <cfset local.result['error'] = true>
            </cfif>           
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Error in #local.currentFunction#: #cfcatch.message#">
                <cfset application.productManagementObj.sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>     
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "deleteCart" access = "remote" returnType = "void">
        <cfargument name = "productId" required = true type = "string">
        <cfset local.result = {
            'error' : false
        }>
        <cftry>
            <cfset local.decryptedProductId = application.productManagementObj.decryptData(data = arguments.productId)>
            <cfquery datasource = "#application.dataSource#">
                DELETE FROM 
                    tblcart
                WHERE
                    fldProductId = <cfqueryparam value = "#val(local.decryptedProductId)#" cfsqltype = "integer">
                    AND fldUserId = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">
            </cfquery>
            <cfcatch>
                <cfset local.result['error'] = true>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset application.productManagementObj.sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>        
    </cffunction>

    <cffunction name = "placeOrder" access = "public">
        <cfargument name = "addressId" required = true type = "string">
        <cfargument name = "cardNumber" required = true type = "string">
        <cfargument name = "cvv" required = true type = "integer">
        <cfargument name = "productId" required = true type = "string">
        <cfset local.result = {
            'error' : false,
            'message' : ""
        }>
        <cfset local.orderId = createUUID()>
        <cfset local.cardNumber = replace(arguments.cardNumber, " ", "", "all")>
        <cftry>
            <cfif local.cardNumber EQ 111111111111 AND arguments.cvv EQ 111>
                <cfif listLen(arguments.productId) GT 1>
                    <cfset local.productId = "">
                    <cfset local.decryptedProductId = 0>
                <cfelse>
                    <cfset local.productId = "productId = #arguments.productId#">
                    <cfset local.decryptedProductId = application.productManagementObj.decryptData(data = arguments.productId)>
                </cfif>
                <cfset local.getCart = getCartDetails(local.productId)>
                <cfset local.decryptedAddressId = application.productManagementObj.decryptData(data = arguments.addressId)>
                <cfset local.totalPrice = 0>
                <cfset local.totalTax = 0>
                <cfloop array = "#local.getCart.cart#" item = "cartItem">
                    <cfset local.totalPrice += (cartItem.unitPrice * cartItem.quantity)>
                    <cfset local.totalTax += (cartItem.unitTax * cartItem.quantity)>
                </cfloop>
                <cfquery datasource = "#application.dataSource#">
                    CALL sp_placeOrder(
                        <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                        <cfqueryparam value = "#val(local.decryptedAddressId)#" cfsqltype = "integer">,
                        <cfqueryparam value = "#right(arguments.cardNumber, 4)#" cfsqltype = "varchar">, 
                        <cfqueryparam value = "#local.totalPrice#" cfsqltype = "decimal">,   
                        <cfqueryparam value = "#local.totalTax#" cfsqltype = "decimal">,
                        <cfqueryparam value = "#local.orderId#" cfsqltype = "varchar">,  
                        <cfqueryparam value = "#val(local.decryptedProductId)#" cfsqltype = "integer"> 
                    );
                </cfquery>
                <cfset local.result['error'] = false>
                <cfset local.result['message'] = "Order Placed Successfully">
                <cfset sendOrderPlacedMail(
                    receiverMail = session.email,
                    orderID = local.orderId,
                    totalPrice = local.totalPrice,
                    totalTax = local.totalTax
                )>       
            <cfelse>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Card Details Doesn't Match">
            </cfif>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "error in #local.currentFunction# : #cfcatch.message#">
                <cfset application.productManagementObj.sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>   

    <cffunction name = "getOrderDetails" access = "public" returnType = "struct">
        <cfargument name = "orderId" required = false type = "string">
        <cfset local.result = {
            'error' : false,
            'order' : []
        }>
        <cftry>
            <cfquery name = "local.qryOrder" datasource = "#application.dataSource#">
                SELECT  
                    O.fldOrder_Id,  
                    O.fldTotalPrice, 
                    O.fldTotalTax, 
                    O.fldOrderDate, 
                    A.fldFirstName, 
                    A.fldLastName, 
                    A.fldAddressLine1, 
                    A.fldAddressLine2, 
                    A.fldCity, 
                    A.fldState, 
                    A.fldPincode, 
                    A.fldPhone,
                    OI.fldProductId,
                    OI.fldQuantity,
                    OI.fldUnitPrice,
                    OI.fldUnitTax,
                    P.fldProductName,
                    PI.fldImageFilePath,
                    B.fldBrandName
                FROM
                    tblorder O
                    INNER JOIN tblorderitems OI ON OI.fldOrderId = O.fldOrder_Id
                    LEFT JOIN tbladdress A ON A.fldAddress_Id = O.fldAddressId
                    LEFT JOIN tblproduct P ON P.fldProduct_Id = OI.fldProductId
                    LEFT JOIN tblbrand B ON B.fldBrand_Id = P.fldBrandId
                    LEFT JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id AND fldDefaultImage = 1
                WHERE
                    O.fldUserID = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer"> 
                    <cfif structKeyExists(arguments, "orderId")>
                        AND O.fldOrder_Id = <cfqueryparam value = "#arguments.orderId#" cfsqltype = "varchar"> 
                    </cfif>
                ORDER BY 
                    O.fldOrderDate DESC;
            </cfquery>
            <cfloop query = "local.qryOrder">
                <cfset local.index = ArrayFind(local.result['order'], 
                    function(s) {
                        if(s.orderId == qryOrder.fldOrder_Id) return true;
                        return false;
                    }
                )>
                <cfif local.index GT 0>
                    <cfset arrayAppend(local.result['order'][local.index].product, {
                        'productId' : local.qryOrder.fldProductId,
                        'quantity' : local.qryOrder.fldQuantity,
                        'unitPrice' : local.qryOrder.fldUnitPrice, 
                        'unitTax' : local.qryOrder.fldUnitTax,  
                        'productName' : local.qryOrder.fldProductName, 
                        'productImage' : local.qryOrder.fldImageFilePath,
                        'brandName' : local.qryOrder.fldBrandName
                    })>
                <cfelse>
                    <cfset arrayAppend(local.result['order'], {
                        'orderId' : local.qryOrder.fldOrder_Id,
                        'totalPrice' : local.qryOrder.fldTotalPrice, 
                        'totalTax' : local.qryOrder.fldTotalTax,  
                        'orderDate' : dateTimeFormat(local.qryOrder.fldOrderDate.toString()),
                        'address' : {
                            'firstName' : local.qryOrder.fldFirstName, 
                            'lastName' : local.qryOrder.fldLastName, 
                            'addressLine1' : local.qryOrder.fldAddressLine1, 
                            'addressLine2' : local.qryOrder.fldAddressLine2, 
                            'city' : local.qryOrder.fldCity, 
                            'state' : local.qryOrder.fldState, 
                            'pincode' : local.qryOrder.fldPincode,
                            'phone' : local.qryOrder.fldPhone
                        },
                        'product' : [
                            {
                                'productId' : local.qryOrder.fldProductId,
                                'quantity' : local.qryOrder.fldQuantity,
                                'unitPrice' : local.qryOrder.fldUnitPrice, 
                                'unitTax' : local.qryOrder.fldUnitTax,  
                                'productName' : local.qryOrder.fldProductName, 
                                'productImage' : local.qryOrder.fldImageFilePath,
                                'brandName' : local.qryOrder.fldBrandName
                            }
                        ]
                    })>
                </cfif>
            </cfloop>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "error in #local.currentFunction# : #cfcatch.message#">
                <cfset application.productManagementObj.sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "downloadInVoice" access = "public" returnType = "struct">
        <cfargument name = "orderId" required = true type = "string"> 
        <cfset local.result = {
            'error' : false,
            'message' : ""
        }>
        <cftry>
            <cfset local.getOrderDetails = getOrderDetails(orderId = arguments.orderId)>
            <cfset local.orderData = local.getOrderDetails.order[1]>
            <cfdocument format = "PDF" orientation = "landscape" overwrite = "yes">  
                <cfoutput>
                    <style>
                        table {
                            width: 100%;
                        }
                        td, th {
                            padding: 10px;
                        }
                        .lineHeight{
                            line-height: 2;
                        }
                    </style>
                    <div>
                        <h2>Invoice</h2>  
                        <p><b>Order No:</b> #arguments.orderId#</p>
                        <p><b>Date:</b> #dateFormat(now(), "dd/mm/yyyy")#</p>        
                        <h3>Customer</h3>
                        <p class="lineHeight">
                            #local.orderData.address.firstName# #local.orderData.address.lastName#<br>
                            #local.orderData.address.addressLine1#,#local.orderData.address.addressLine2#,
                            #local.orderData.address.city#, #local.orderData.address.state# - #local.orderData.address.pincode#<br>
                            <strong>Phone : </strong>#local.orderData.address.phone#
                        </p>
                        <table border="2">
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Product Name</th>
                                    <th>Quantity</th>
                                    <th>Price/Unit</th>
                                    <th>Tax/Unit</th>
                                    <th>Price</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfloop array="#local.orderData.product#" item="productItem" index="i">         
                                    <tr>
                                        <td>#i#</td>
                                        <td>#productItem.productName#</td>
                                        <td>#productItem.quantity#</td>
                                        <td>&##8377; #numberFormat(productItem.unitPrice, "99,999.00")#</td>
                                        <td>&##8377; #numberFormat(productItem.unitTax, "99,999.00")#</td>
                                        <td>&##8377; #numberFormat((productItem.unitPrice + productItem.unitTax) * productItem.quantity, "99,999.00")#</td>
                                    </tr>                                 
                                </cfloop>
                                <tr>
                                    <td colspan="4"></td>
                                    <td><b>Total</b></td>
                                    <td><b>&##8377; #numberFormat((local.orderData.totalPrice + local.orderData.totalTax), "99,999.00")#</b></td>
                                </tr>        
                            </tbody>
                        </table>
                    </div>
                </cfoutput>
            </cfdocument>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Error in #local.currentFunction# : #cfcatch.message#">
                <cfset application.productManagementObj.sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>
</cfcomponent>