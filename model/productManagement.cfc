<cfcomponent>
    <cffunction name = "sendErrorEmail">
        <cfargument name = "subject" required = true type = "string">
        <cfargument name = "errorMessage" required = true type = "string">
        <cfset local.emailFrom = "parikshith2101@gmail.com">
        <cfset local.emailTo = "parikshith2k23@gmail.com">       
        <cfmail 
            from = "#local.emailFrom#"
            to = "#local.emailTo#"
            subject = "Error in #arguments.subject#"
            type = "html"
        >
            <p><strong>Error Message:</strong> #arguments.errorMessage#</p>
        </cfmail>
    </cffunction>

    <cffunction name = "encryptData" access = "public" returnType = "string">
        <cfargument name = "data" required = true type = "string">
        <cfset local.encryptedData = encrypt(arguments.data, application.key,"AES","base64")>
        <cfreturn local.encryptedData>
    </cffunction>

    <cffunction name = "decryptData" access = "public" returnType = "string">
        <cfargument name = "data" required = true type = "string">
        <cfset local.decryptedData = "">
        <cftry>
            <cfset local.decryptedData = decrypt(arguments.data, application.key,"AES","base64")>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
                <cfreturn local.decryptedData>
            </cfcatch>
        </cftry>
        <cfreturn local.decryptedData>
    </cffunction>

    <!---Category--->
    <cffunction name = "getCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "categoryId" required = false type = "string">
        <cfargument name = "categoryName" required = false type = "string">
        <cfset local.result = {
            'error' : false,
            'category' : []
        }>
        <cfset local.decryptedCategoryId = "">
        <cftry>
            <cfif structKeyExists(arguments, "categoryId")>
                <cfset local.decryptedCategoryId = decryptData(data = arguments.categoryId)>
            </cfif>
            <cfquery name = "local.qryCategoryData" dataSource = "#application.dataSource#">
                SELECT 
                    fldCategory_Id,
                    fldCategoryName
                FROM
                    tblcategory
                WHERE
                    fldActive = 1
                    <cfif val(local.decryptedCategoryId)>
                        AND fldCategory_Id = <cfqueryparam value = "#val(local.decryptedCategoryId)#" cfsqltype = "integer">
                    </cfif>
                    <cfif structKeyExists(arguments, "categoryName") AND len(trim(arguments.categoryName))>
                        AND fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "varchar">
                    </cfif>;
            </cfquery>
            <cfloop query = "local.qryCategoryData">
                <cfset arrayAppend(local.result['category'], {
                    'categoryId' : encryptData(data = local.qryCategoryData.fldCategory_Id),
                    'categoryName' : local.qryCategoryData.fldCategoryName
                })>
            </cfloop>
            <cfcatch>
                <cfset sendErrorEmail(
                    subject = getFunctionCalledName(),
                    errorMessage = cfcatch.message
                )>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = cfcatch.message>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <!---SubCategory--->
    <cffunction name = "getSubCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "categoryId" required = true type = "string" default = "0">
        <cfargument name = "subCategoryId" required = false type = "string">
        <cfargument name = "subCategoryName" required = false type = "string">
        <cfset local.result = {
            'error' : false,
            'subCategory' : []
        }>
        <cfset local.decryptedCategoryId = "">
        <cfset local.decryptedSubCategoryId = "">
        <cftry>
            <cfif arguments.categoryId NEQ "0">
                <cfset local.decryptedCategoryId = decryptData(data = arguments.categoryId)>
            </cfif>
            <cfif structKeyExists(arguments, "subCategoryId")>
                <cfset local.decryptedSubCategoryId = decryptData(data = arguments.subCategoryId)>
            </cfif>
            <cfquery name = "local.qrySubCategoryData" datasource = "#application.dataSource#">
                SELECT 
                    SC.fldSubCategory_Id,
                    SC.fldCategoryId,
                    SC.fldSubCategoryName,
                    C.fldCategoryName
                FROM
                    tblsubcategory SC 
                    INNER JOIN tblcategory C ON C.fldCategory_Id = SC.fldCategoryId
                WHERE
                    SC.fldActive = 1
                    AND C.fldActive = 1
                    <cfif arguments.categoryId NEQ "0">
                        AND SC.fldCategoryId = <cfqueryparam value = "#val(local.decryptedCategoryId)#" cfsqltype = "integer">
                    </cfif>
                    <cfif val(local.decryptedSubCategoryId)>
                        AND SC.fldSubCategory_Id = <cfqueryparam value = "#val(local.decryptedSubCategoryId)#" cfsqltype = "integer">
                    </cfif>
                    <cfif structKeyExists(arguments, "subCategoryName") AND len(trim(arguments.subCategoryName))>
                        AND SC.fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "varchar">
                    </cfif>;
            </cfquery>
            <cfloop query = "local.qrySubCategoryData">
                <cfset arrayAppend(local.result['subCategory'],{
                    'subCategoryId' : encryptData(data = local.qrySubCategoryData.fldSubCategory_Id),
                    'categoryId' : encryptData(data = local.qrySubCategoryData.fldCategoryId),
                    'subCategoryName' : local.qrySubCategoryData.fldSubCategoryName,
                    'categoryName' :  local.qrySubCategoryData.fldCategoryName
                })>
            </cfloop>
            <cfcatch>
                <cfset sendErrorEmail(
                    subject = getFunctionCalledName(),
                    errorMessage = cfcatch.message
                )>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = cfcatch.message>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "getBrand" access = "public" returnType = "struct">
        <cfset local.result = {
            'error' : false,
            'brand': []
        }>
        <cftry>
            <cfquery name = "local.qryBrand" datasource = "#application.dataSource#">
                SELECT 
                    fldBrand_Id,
                    fldBrandName
                FROM 
                    tblbrand
                WHERE
                    fldActive = 1;
            </cfquery>
            <cfloop query = "local.qryBrand">
                <cfset arrayAppend(local.result['brand'],{
                    'brandId' : encryptData(data = local.qryBrand.fldBrand_Id),
                    'brandName' : local.qryBrand.fldBrandName
                })>
            </cfloop>
            <cfcatch>
                <cfset local.result['error'] = true>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "getProduct" access = "public" returnType = "struct">
        <cfargument name = "productId" required = false type = "integer">
        <cfargument name = "productImageId" required = false type = "integer">
        <cfargument name = "productName" required = false type = "string">
        <cfargument name = "subCategoryId" required = false type = "integer">
        <cfargument name = "categoryId" required = false type = "integer">
        <cfargument name = "limit" required = false type = "integer">
        <cfargument name = "offset" required = false type = "integer" default = 0>
        <cfargument name = "sortType" required = false type = "string">
        <cfargument name = "minPrice" required = false type = "numeric">
        <cfargument name = "maxPrice" required = false type = "numeric">
        <cfargument name = "searchKey" required = false type = "string">
        <cfargument name = "maxRowNumber" required = false type = "integer">
        <cfargument name = "isRand" required = false type = "boolean" default = false>
         
        <cfset local.result = { 'error': false, 'product': [] ,'totalRows' : 0}>
        <cfset local.sort = "P.fldProductName ASC"> 

        <cfif len(arguments.sortType)>
            <cfset local.sort = arguments.sortType EQ "DESC" ? "P.fldUnitPrice DESC, P.fldProductName ASC" : "P.fldUnitPrice ASC, P.fldProductName ASC">
        <cfelseif arguments.isRand>
            <cfset local.sort = "RAND()"> 
        </cfif>
        <cfset local.ifDefaultImage = arguments.productId NEQ 0 ? "" : "AND PI.fldDefaultImage = 1">
        
        <cftry>
            <cfquery name = "local.qryProduct" datasource = "#application.dataSource#">
                WITH products AS (
                    SELECT 
                        P.fldProduct_Id,
                        P.fldProductName,
                        P.fldSubCategoryId,
                        SC.fldSubCategoryName,
                        P.fldBrandId,
                        B.fldBrandName,
                        P.fldDescription,
                        P.fldUnitPrice,
                        P.fldUnitTax,
                        C.fldCategory_Id,
                        C.fldCategoryName,
                        GROUP_CONCAT(PI.fldProductImage_Id ORDER BY PI.fldDefaultImage DESC) AS productImageId,
                        GROUP_CONCAT(PI.fldImageFilePath ORDER BY PI.fldDefaultImage DESC) AS imageFiles,
                        GROUP_CONCAT(PI.fldDefaultImage ORDER BY PI.fldDefaultImage DESC) AS defaultImage,
                        ROW_NUMBER() OVER (PARTITION BY P.fldSubCategoryId) AS rowNumber,
                        COUNT(*) OVER() AS totalRows
                    FROM
                        tblproduct P 
                        INNER JOIN tblbrand B ON B.fldBrand_Id = P.fldBrandId
                        INNER JOIN tblsubcategory SC ON SC.fldSubCategory_Id = P.fldSubCategoryId
                        INNER JOIN tblcategory C ON C.fldCategory_Id = SC.fldCategoryId
                        LEFT JOIN tblproductimages PI ON P.fldProduct_Id = PI.fldProductId AND PI.fldActive = 1 #local.ifDefaultImage#
                    WHERE
                        P.fldActive = 1
                        AND SC.fldActive = 1
                        AND C.fldActive = 1
                        <cfif arguments.productId NEQ 0>
                            AND P.fldProduct_Id = <cfqueryparam value = "#val(arguments.productId)#" cfsqltype="integer">
                        </cfif>
                        <cfif arguments.productImageId NEQ 0>
                            AND PI.fldProductImage_Id = <cfqueryparam value = "#val(arguments.productImageId)#" cfsqltype="integer">
                        </cfif>
                        <cfif arguments.subCategoryId NEQ 0>
                            AND P.fldSubCategoryId = <cfqueryparam value = "#val(arguments.subCategoryId)#" cfsqltype="integer">
                        </cfif>
                        <cfif arguments.categoryId NEQ 0>
                            AND C.fldCategory_Id = <cfqueryparam value = "#val(arguments.categoryId)#" cfsqltype="integer">
                        </cfif>
                        <cfif structKeyExists(arguments, "productName") AND len(trim(arguments.productName))>
                            AND P.fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype="varchar">
                        </cfif>
                        <cfif structKeyExists(arguments, "searchKey") AND len(trim(arguments.searchKey))>
                            AND (
                                P.fldProductName LIKE <cfqueryparam value = "%#arguments.searchKey#%" cfsqltype="varchar">
                                OR P.fldDescription LIKE <cfqueryparam value = "%#arguments.searchKey#%" cfsqltype="varchar">
                                OR B.fldBrandName LIKE <cfqueryparam value = "%#arguments.searchKey#%" cfsqltype="varchar">
                                OR SC.fldSubCategoryName LIKE <cfqueryparam value = "%#arguments.searchKey#%" cfsqltype="varchar">
                                OR C.fldCategoryName LIKE <cfqueryparam value = "%#arguments.searchKey#%" cfsqltype="varchar">
                            )
                        </cfif>
                        <cfif arguments.maxPrice NEQ 0>
                            AND P.fldUnitPrice BETWEEN <cfqueryparam value = "#arguments.minPrice#" cfsqltype="numeric">
                                AND <cfqueryparam value = "#arguments.maxPrice#" cfsqltype="numeric">
                        </cfif>
                    GROUP BY 
                        P.fldProduct_Id
                    ORDER BY #local.sort#         
                )
                SELECT * FROM products
                <cfif arguments.maxRowNumber NEQ 0>
                    WHERE rowNumber <= <cfqueryparam value = "#arguments.maxRowNumber#" cfsqltype="integer">
                </cfif>
                <cfif arguments.limit NEQ 0>
                    LIMIT <cfqueryparam value = "#val(arguments.limit)#" cfsqltype="integer">
                    <cfif arguments.offset NEQ 0>
                        OFFSET <cfqueryparam value = "#val(arguments.offset)#" cfsqltype="integer">
                    </cfif>
                </cfif>
            </cfquery>
            <cfloop query = "local.qryProduct">
                <cfset arrayAppend(local.result['product'],{
                    'productId': encryptData(local.qryProduct.fldProduct_Id),
                    'subCategoryId': encryptData(local.qryProduct.fldSubCategoryId),
                    'categoryId': encryptData(local.qryProduct.fldCategory_Id),
                    'brandId': encryptData(local.qryProduct.fldBrandId),
                    'productName': local.qryProduct.fldProductName,
                    'subCategoryName': local.qryProduct.fldSubCategoryName,
                    'categoryName': local.qryProduct.fldCategoryName,
                    'brandName': local.qryProduct.fldBrandName,
                    'description': local.qryProduct.fldDescription,
                    'unitPrice': local.qryProduct.fldUnitPrice,
                    'unitTax': local.qryProduct.fldUnitTax,
                    'productImageId': local.qryProduct.productImageId,
                    'imageFile': local.qryProduct.imageFiles,
                    'defaultImage': local.qryProduct.defaultImage,
                    'decryptedProductId' : local.qryProduct.fldProduct_Id
                })>
            </cfloop>
           <cfset local.result['totalRows'] = local.qryProduct.totalRows> 
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
                <cfset local.result['error'] = true>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "getAddress" access = "public" returnType = "struct">
        <cfset local.result = {
            'error' : false,
            'address' : []
        }>
        <cftry>
            <cfquery name = "local.qryAddress" dataSource = "#application.dataSource#">
                SELECT 
                    fldAddress_Id,
                    fldUserId,
                    fldFirstName,
                    fldLastName,
                    fldAddressLine1,
                    fldAddressLine2,
                    fldCity,
                    fldState,
                    fldPincode,
                    fldPhone
                FROM
                    tbladdress
                WHERE
                    fldActive = 1
                    AND fldUserId = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">
            </cfquery>
            <cfloop query = "local.qryAddress">   
                <cfset arrayAppend(local.result['address'], {
                    'addressId' : encryptData(data = local.qryAddress.fldAddress_Id),
                    'firstName' : local.qryAddress.fldFirstName,
                    'lastName' : local.qryAddress.fldLastName,
                    'addressLine1' : local.qryAddress.fldAddressLine1,
                    'addressLine2' : local.qryAddress.fldAddressLine2,
                    'city' : local.qryAddress.fldCity,
                    'state' : local.qryAddress.fldState,
                    'pincode' : local.qryAddress.fldPincode,
                    'phone' : local.qryAddress.fldPhone
                })>
            </cfloop>
            <cfcatch>
                <cfset local.result['error'] = true>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "addAddress" access = "public" returType = "struct">
        <cfargument name = "firstName" required = true type = "string">
        <cfargument name = "lastName" required = true type = "string">
        <cfargument name = "addressLine1" required = true type = "string">
        <cfargument name = "addressLine2" required = true type = "string">
        <cfargument name = "city" required = true type = "string">
        <cfargument name = "state" required = true type = "string">
        <cfargument name = "pincode" required = true type = "string">
        <cfargument name = "phone" required = true type = "string">
        <cfset local.result = {
            'error' : false,
            'message' : ""
        }>
        <cftry>
            <cfquery dataSource = "#application.dataSource#">
                INSERT INTO tbladdress(
                    fldUserId,
                    fldFirstName,
                    fldLastName,
                    fldAddressLine1,
                    fldAddressLine2,
                    fldCity,
                    fldState,
                    fldPincode,
                    fldPhone
                )VALUES(
                    <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                    <cfqueryparam value = "#arguments.firstName#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.lastName#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.addressLine1#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.addressLine2#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.city#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.state#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.pincode#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.phone#" cfsqltype = "varchar">
                );
            </cfquery>
            <cfset local.result['error'] = false>
                <cfset local.result['message'] = "address added">
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "error in #local.currentFunction# : #cfcatch.message#">
                 <cfset sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "deleteAddress" access = "remote" returnType = "void">
        <cfargument name = "addressId" required = true type = "string">
        <cftry>
            <cfset local.decryptedAddressId = decryptData(data = arguments.addressId)>
            <cfquery dataSource = "#application.dataSource#">  
                UPDATE 
                    tbladdress
                SET
                    fldActive = 0,
                    fldDeactivatedDate = #now()#
                WHERE
                    fldActive = 1
                    AND fldAddress_Id = <cfqueryparam value = "#val(local.decryptedAddressId)#" cfsqltype = "integer">
            </cfquery>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                 <cfset sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>