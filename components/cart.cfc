<cfcomponent>
    <cffunction name = "getCart" access = "public" returnType = "struct">
        <cfargument name = "productId" required = false type = "string"> 
        <cfset local.result = {
            'error' : false,
            'cart' : []
        }>
        <cftry>
            <cfquery name = "local.qryCart" datasource = "#application.dataSource#">
                SELECT 
                    C.fldCart_Id,
                    C.fldUserId,
                    C.fldProductId,
                    C.fldQuantity,
                    P.fldProductName,
                    P.fldUnitPrice,
                    P.fldUnitTax,
                    P.fldSubCategoryId,
                    P.fldDescription,
                    PI.fldImageFilePath,
                    PI.fldDefaultImage
                FROM 
                    tblcart C 
                LEFT JOIN tblproduct P ON P.fldProduct_Id = C.fldProductId
                LEFT JOIN tblproductimages PI ON P.fldProduct_Id = PI.fldProductId AND PI.fldDefaultImage = 1
                WHERE 
                    C.fldUserId = <cfqueryparam value = "#session.loginUserId#" cfsqltype = "integer">
                    <cfif structKeyExists(arguments,"productId")>
                        <cfset local.decrytedProductId = application.productManagementObj.decryptDetails(data = arguments.productId)>
                        AND C.fldProductId = <cfqueryparam value = "#local.decrytedProductId#" cfsqltype = "integer"> 
                    </cfif>
            </cfquery>
            <cfloop query = "local.qryCart">
                <cfset local.encryptedCartId = application.productManagementObj.encryptDetails(data = local.qryCart.fldCart_Id)>
                <cfset local.encryptedUserId = application.productManagementObj.encryptDetails(data = local.qryCart.fldUserId)>
                <cfset local.encryptedProductId = application.productManagementObj.encryptDetails(data = local.qryCart.fldProductId)>
                <cfset local.encryptedSubCategoryId = application.productManagementObj.encryptDetails(data = local.qryCart.fldSubCategoryId)>
                <cfset arrayAppend(local.result['cart'],{
                    'cartId' : local.encryptedCartId,
                    'userId' : local.encryptedUserId,
                    'productId' : local.encryptedProductId,
                    'subCategoryId' : local.encryptedSubCategoryId,
                    'quantity' : local.qryCart.fldQuantity,
                    'productName' : local.qryCart.fldProductName,
                    'unitPrice' : local.qryCart.fldUnitPrice,
                    'unitTax' : local.qryCart.fldUnitTax,
                    'description' : local.qryCart.fldDescription,
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
            'error' : true,
            'message' : ""
        }>
        <cfset local.cartData = getCart(productId = arguments.productId)>
        <cfset local.decryptedProductId = application.productManagementObj.decryptDetails(data = arguments.productId)>
        <cftry>  
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

    <cffunction name = "deleteCart" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "cartId" required = true type = "string">
        <cfset local.decryptedCartId = application.productManagementObj.decryptDetails(data = arguments.cartId)>
        <cfset local.result = {
            'error' : false,
            'cartQuantity' : 0,
            'getCartData' : []
        }>
        <cftry>
            <cfquery datasource = "#application.dataSource#">
                DELETE FROM tblcart
                WHERE
                    fldCart_Id = <cfqueryparam value = "#local.decryptedCartId#" cfsqltype = "integer">
            </cfquery>
            <cfset local.getCartData = getCart()>
            <cfset local.result['cartQuantity'] = arrayLen(getCartData.cart)>
            <cfset local.result['getCartData'] = local.getCartData.cart>
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

    <cffunction  name = "modifyQuantity" access = "remote" returnType = "any" returnFormat = "JSON">
        <cfargument name = "modifyStatus" required = true type = "string">
        <cfargument name = "productId" required = true type = "string">
        <cfset local.result = {
            'error' : false,
            'getCartData' : []
        }>
        <cfset local.decryptedProductId = application.productManagementObj.decryptDetails(data = arguments.productId)>
        <cfset local.quantityCount = 0>
        <cftry>
            <cfset local.getCartData = getCart(productId = arguments.productId)>
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
        <cfset local.getCart = getCart()>
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
            <cfset local.decryptedAddressId = application.productManagementObj.decryptDetails(data = arguments.addressId)>
            <cfset local.productIdArray = ListToArray(arguments.productId)>
            <cfset local.quantityArray = ListToArray(arguments.quantity)>
            <cfset local.unitPriceArray = ListToArray(arguments.unitPrice)>
            <cfset local.unitTaxArray = ListToArray(arguments.unitTax)>
            <cftry>
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
                        <cfset local.decryptedProductId = application.productManagementObj.decryptDetails(data = local.productIdArray[i])>
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
                            <cfset local.decryptedProductId = application.productManagementObj.decryptDetails(data = local.productIdArray[i])>
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

<!---     <cffunction name = "getOrder">
        <cfquery>
            SELECT  
                fldOrder_Id,
                fldUserId,
                fldAddressId, 
                fldCardNumber, 
                fldTotalPrice, 
                fldTotalTax, 
                fldOrderDate
            FROM
                tblorder
            WHERE
                fldUserID = <cfqueryparam value = "#session.loginUserId#" cfsqltype = "integer">
        </cfquery>
    </cffunction>

    <cffunction name = "getOrderItems">
        <cfquery>
            SELECT  
                fldOrderItem_Id, 
                fldOrderId, 
                fldProductId, 
                fldQuantity, 
                fldUnitPrice, 
                fldUnitTax
            FROM
                tblorderitems             
        </cfquery>
    </cffunction> --->
</cfcomponent>