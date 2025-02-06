<cfcomponent>
    <cffunction name = "getCartDetails" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "productId" required = false type = "string"> 
        <cfset local.result = {
            'error' : false,
            'cart' : []
        }>
        <cfset local.decrytedProductId = "">
        <cftry>
            <cfif structKeyExists(arguments,"productId")>
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
                    tblcart C INNER JOIN tblproduct P ON P.fldProduct_Id = C.fldProductId
                    LEFT JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id AND PI.fldDefaultImage = 1
                WHERE 
                    C.fldUserId = <cfqueryparam value = "#session.loginUserId#" cfsqltype = "integer">
                    <cfif len(trim(local.decrytedProductId))>                        
                        AND C.fldProductId = <cfqueryparam value = "#local.decrytedProductId#" cfsqltype = "integer"> 
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

    <cffunction name = "addCart" access = "public" returnType = "struct">
        <cfargument name = "productId" required = true type = "string">
        <cfset local.result = {
            'error' : false,
            'message' : ""
        }>
        <cfset local.cartData = getCartDetails(productId = arguments.productId)>
        <cftry>  
            <cfset local.decryptedProductId = application.productManagementObj.decryptData(data = arguments.productId)>
            <cfif arrayLen(local.cartData.cart)>
                <cfset local.quantityCount = local.cartData.cart[1].quantity + 1>
                <cfquery datasource = "#application.dataSource#">
                    UPDATE
                        tblcart
                    SET
                        fldQuantity = #local.quantityCount#  
                    WHERE 
                        fldProductId = <cfqueryparam value = "#local.decryptedProductId#" cfsqltype = "integer">
                        AND fldUserId = <cfqueryparam value = "#session.loginUserId#" cfsqltype = "integer">
                </cfquery>
                <cfset local.result['error'] = false>
                <cfset local.result['message'] = "Edited">
            <cfelse>
                <cfquery datasource = "#application.dataSource#">
                    INSERT INTO tblcart(
                        fldUserId,
                        fldProductId,
                        fldQuantity       
                    )
                    VALUES(
                        <cfqueryparam value = "#session.loginUserId#" cfsqltype = "integer">,
                        <cfqueryparam value = "#local.decryptedProductId#" cfsqltype = "integer">,
                        1
                    );
                </cfquery>
                <cfset local.result['error'] = false>
                <cfset local.result['message'] = "Added">
            </cfif>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Error in  #local.currentFunction#: #cfcatch.message#">
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
                    fldProductId = <cfqueryparam value = "#local.decryptedProductId#" cfsqltype = "integer">
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

    <cffunction  name = "modifyQuantity" access = "remote" returnType = "any" returnFormat = "JSON">
        <cfargument name = "modifyStatus" required = true type = "string">
        <cfargument name = "productId" required = true type = "string">
        <cfset local.result = {
            'error' : false,
            'getCartData' : []
        }>
        <cfset local.decryptedProductId = application.productManagementObj.decryptData(data = arguments.productId)>
        <cfset local.quantityCount = 0>
        <cftry>
            <cfset local.getCartData = getCartDetails(productId = arguments.productId)>
            <cfif arguments.modifyStatus EQ "add">
                <cfset local.quantityCount = local.getCartData.cart[1].quantity + 1>
                <cfquery datasource = "#application.dataSource#">
                    UPDATE
                        tblcart
                    SET
                        fldQuantity = <cfqueryparam value = "#local.quantityCount#" cfsqltype = "integer"> 
                    WHERE 
                        fldProductId = <cfqueryparam value = "#local.decryptedProductId#" cfsqltype = "integer">
                        AND fldUserId = <cfqueryparam value = "#session.loginUserId#" cfsqltype = "integer">
                </cfquery>
            <cfelseif (arguments.modifyStatus EQ "remove") AND (local.getCartData.cart[1].quantity GT 1)>
                <cfset local.quantityCount = local.getCartData.cart[1].quantity - 1>
                <cfquery datasource = "#application.dataSource#">
                    UPDATE
                        tblcart
                    SET
                        fldQuantity = <cfqueryparam value = "#local.quantityCount#" cfsqltype = "integer">
                    WHERE 
                        fldProductId = <cfqueryparam value = "#local.decryptedProductId#" cfsqltype = "integer">
                        AND fldUserId = <cfqueryparam value = "#session.loginUserId#" cfsqltype = "integer">
                </cfquery>
            <cfelse>
                <cfset local.result['error'] = true>
            </cfif>
            <cfcatch>
                <cfset local.result['error'] = true>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset application.productManagementObj.sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
        <cfset local.getCart = getCartDetails()>
        <cfset local.result['getCartData'] = local.getCart.cart>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "placeOrder" access = "public" returnType = "struct">
        <cfargument name = "addressId" required = true type = "string">
        <cfargument name = "cardNumber" required = true type = "string">
        <cfargument name = "cvv" required = true type = "integer">
        <cfargument name = "totalPrice" required = true type = "string">
        <cfargument name = "totalTax" required = true type = "string">
        <cfargument name = "productId" required = true type = "string">
        <cfargument name = "quantity" required = true type = "string">
        <cfargument name = "unitPrice" required = true type = "string">
        <cfargument name = "unitTax" required = true type = "string">
        <cfset local.result = {
            'error' : false,
            'message' : ""
        }>
        <cfset local.cardNumber = replace(arguments.cardNumber, " ", "", "all")>
        <cfif local.cardNumber EQ 111111111111 AND arguments.cvv EQ 111>
            <cfset local.productIdArray = ListToArray(arguments.productId)>
            <cfset local.quantityArray = ListToArray(arguments.quantity)>
            <cfset local.unitPriceArray = ListToArray(arguments.unitPrice)>
            <cfset local.unitTaxArray = ListToArray(arguments.unitTax)>
            <cftry>
                <cfset local.decryptedAddressId = application.productManagementObj.decryptData(data = arguments.addressId)>
                <cfset local.orderId = createUUID()>
                <cfquery datasource = "#application.dataSource#" result = "local.orderResult">
                    INSERT INTO tblorder(
                        fldOrder_Id,
                        fldUserId,
                        fldAddressId, 
                        fldCardNumber, 
                        fldTotalPrice, 
                        fldTotalTax
                    )VALUES(
                        <cfqueryparam value = "#local.orderId#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#session.loginUserId#" cfsqltype = "integer">,
                        <cfqueryparam value = "#local.decryptedAddressId#" cfsqltype = "integer">,
                        <cfqueryparam value = "#local.cardNumber#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#arguments.totalPrice#" cfsqltype = "integer">,
                        <cfqueryparam value = "#arguments.totalTax#" cfsqltype = "integer">
                    );
                </cfquery>
                <cfquery datasource = "#application.dataSource#">
                    INSERT INTO tblorderitems(
                        fldOrderId, 
                        fldProductId, 
                        fldQuantity, 
                        fldUnitPrice, 
                        fldUnitTax
                    )VALUES
                    <cfloop from = "1" to = "#arrayLen(local.productIdArray)#" index = "i">
                        <cfset local.decryptedProductId = application.productManagementObj.decryptData(data = local.productIdArray[i])>
                        (
                            <cfqueryparam value = "#local.orderId#" cfsqltype = "varchar">,
                            <cfqueryparam value = "#local.decryptedProductId#" cfsqltype = "integer">,
                            <cfqueryparam value = "#local.quantityArray[i]#" cfsqltype = "integer">,
                            <cfqueryparam value = "#local.unitPriceArray[i]#" cfsqltype = "decimal">,
                            <cfqueryparam value = "#local.unitTaxArray[i]#" cfsqltype = "decimal">
                        )<cfif i LT arrayLen(local.productIdArray)>,</cfif>
                    </cfloop>
                </cfquery>
                <cfquery datasource = "#application.dataSource#">
                    DELETE FROM tblcart
                    WHERE fldProductId IN (
                        <cfloop from = "1" to = "#arrayLen(local.productIdArray)#" index = "i">
                            <cfset local.decryptedProductId = application.productManagementObj.decryptData(data = local.productIdArray[i])>
                            <cfqueryparam value = "#local.decryptedProductId#" cfsqltype = "integer">
                            <cfif i LT arrayLen(local.productIdArray)>,</cfif>
                        </cfloop>
                    )  
                    AND fldUserId = <cfqueryparam value = "#session.loginUserId#" cfsqltype = "integer">                
                </cfquery>
                <cfset local.result['error'] = false>
                <cfset local.result['message'] = "Order Placed Successfully">
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
        <cfelse>
            <cfset local.result['error'] = true>
            <cfset local.result['message'] = "Card Details Doesn't Match">
        </cfif>
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
                    GROUP_CONCAT(OI.fldProductId ORDER BY OI.fldUnitPrice DESC) AS productId, 
                    GROUP_CONCAT(OI.fldQuantity ORDER BY OI.fldUnitPrice DESC) AS productQuantity,
                    GROUP_CONCAT(OI.fldUnitPrice ORDER BY OI.fldUnitPrice DESC) AS unitPrice, 
                    GROUP_CONCAT(OI.fldUnitTax ORDER BY OI.fldUnitPrice DESC) AS unitTax,  
                    GROUP_CONCAT(P.fldProductName ORDER BY OI.fldUnitPrice DESC) AS productName, 
                    GROUP_CONCAT(PI.fldImageFilePath ORDER BY OI.fldUnitPrice DESC) AS productImage,
                    GROUP_CONCAT(B.fldBrandName ORDER BY OI.fldUnitPrice DESC) AS brandName
                FROM
                    tblorder O INNER JOIN tblorderitems OI ON OI.fldOrderId = O.fldOrder_Id
                    INNER JOIN tbladdress A ON A.fldAddress_Id = O.fldAddressId
                    INNER JOIN tblproduct P ON P.fldProduct_Id = OI.fldProductId
                    LEFT JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id AND fldDefaultImage = 1
                    INNER JOIN tblbrand B ON B.fldBrand_Id = P.fldBrandId
                WHERE
                    O.fldUserID = <cfqueryparam value = "#session.loginUserId#" cfsqltype = "integer"> 
                    AND A.fldActive = 1
                    AND P.fldActive = 1
                    <cfif structKeyExists(arguments, "orderId")>
                        AND O.fldOrder_Id = <cfqueryparam value = "#arguments.orderId#" cfsqltype = "varchar"> 
                    </cfif>
                GROUP BY
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
                    A.fldPhone
                ORDER BY O.fldOrderDate DESC;
            </cfquery>
            <cfloop query = "local.qryOrder">
                <cfset arrayAppend(local.result['order'], {
                    'orderId' : local.qryOrder.fldOrder_Id,
                    'totalPrice' : local.qryOrder.fldTotalPrice, 
                    'totalTax' : local.qryOrder.fldTotalTax, 
                    'orderDate' : local.qryOrder.fldOrderDate, 
                    'firstName' : local.qryOrder.fldFirstName, 
                    'lastName' : local.qryOrder.fldLastName, 
                    'addressLine1' : local.qryOrder.fldAddressLine1, 
                    'addressLine2' : local.qryOrder.fldAddressLine2, 
                    'city' : local.qryOrder.fldCity, 
                    'state' : local.qryOrder.fldState, 
                    'pincode' : local.qryOrder.fldPincode,
                    'phone' : local.qryOrder.fldPhone,
                    'productId' : local.qryOrder.productId, 
                    'quantity' : local.qryOrder.productQuantity,
                    'unitPrice' : local.qryOrder.unitPrice, 
                    'unitTax' : local.qryOrder.unitTax,  
                    'productName' : local.qryOrder.productName, 
                    'productImage' : local.qryOrder.productImage,
                    'brandName' : local.qryOrder.brandName
                })>
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

<cffunction name="downloadInVoice" access="public">
    <cfargument name="orderId" required="true" type="string"> 
    <cftry>
        <cfset local.getOrderDetails = getOrderDetails(orderId = arguments.orderId)>
        <cfset local.FileName = "order_#arguments.orderId#.pdf">
        
        <cfdocument format="PDF" filename="#expandPath('../uploads/invoice/#local.FileName#')#" name="outputDocument" orientation="landscape" overwrite="yes">  
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
                        #local.getOrderDetails.order[1].firstName# #local.getOrderDetails.order[1].lastName#<br>
                        #local.getOrderDetails.order[1].addressLine1#,#local.getOrderDetails.order[1].addressLine2#,
                        #local.getOrderDetails.order[1].city#, #local.getOrderDetails.order[1].state# - #local.getOrderDetails.order[1].pincode#<br>
                        <strong>Phone : </strong>#local.getOrderDetails.order[1].phone#
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
                            <cfloop from="1" to="#arrayLen(local.getOrderDetails.order)#" index="i">
                                <cfset productName = listToArray(local.getOrderDetails.order[i].productName)>
                                <cfset unitPrices = listToArray(local.getOrderDetails.order[i].unitPrice)>
                                <cfset unitTaxes = listToArray(local.getOrderDetails.order[i].unitTax)>
                                <cfset quantities = listToArray(local.getOrderDetails.order[i].quantity)>            
                                <cfloop from="1" to="#arrayLen(unitPrices)#" index="j">
                                    <tr>
                                        <td>#j#</td>
                                        <td>#productName[j]#</td>
                                        <td>#quantities[j]#</td>
                                        <td>&##8377; #val(unitPrices[j])#</td>
                                        <td>&##8377; #val(unitTaxes[j])#</td>
                                        <td>&##8377; #val(unitPrices[j] + unitTaxes[j]) * val(quantities[j])#</td>
                                    </tr>
                                </cfloop>
                            </cfloop>
                            <tr>
                                <td colspan="4"></td>
                                <td><b>Total</b></td>
                                <td><b>&##8377; #numberFormat(local.getOrderDetails.order[1].totalPrice, "999,999.00")#</b></td>
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
</cffunction>
</cfcomponent>