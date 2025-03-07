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

    <cffunction name = "addCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "categoryName" required = true type = "string">
        <cfset local.result = {
            'error' : false,
            'message' : ""
        }>
        <cftry>                
            <cfset local.fetchCategoryData = getCategory(
                categoryName = arguments.categoryName
            )>
            <cfif len(trim(arguments.categoryName)) GT 32>
                <cfset local.result['message'] = "Maximum Length of CategoryName Should be 32">
                <cfset local.result['error'] = true>
            <cfelseif NOT reFindNoCase("^[A-Za-z &'']+$", arguments.categoryName)>
                <cfset local.result['message'] = "Invalid category name">
                <cfset local.result['error'] = true>
            <cfelseif arrayLen(local.fetchCategoryData.category)>
                <cfset local.result['message'] = "Catergory Already Exists">
                <cfset local.result['error'] = true>
            <cfelse>
                <cfquery result = "local.categoryId" datasource = "#application.dataSource#">
                    INSERT INTO tblcategory(
                        fldCategoryName,
                        fldCreatedBy
                    ) 
                    VALUES(
                        <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">
                    );
                </cfquery>
                <cfset local.result['message'] = "Catergory Created">
                <cfset local.result['error'] = false>
            </cfif>
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

    <cffunction name = "editCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "categoryId" required = true type = "string"> 
        <cfargument name = "categoryName" required = true type = "string"> 
        <cfset local.result = {
            'error' : false,
            'message' : ""
        }>
        <cftry>     
            <cfset local.fetchCategoryData = getCategory(
                categoryName = arguments.categoryName
            )>  
            <cfif len(trim(arguments.categoryName)) GT 32>
                <cfset local.result['message'] = "Maximum Length of CategoryName Should be 32">
                <cfset local.result['error'] = true>
            <cfelseif NOT reFindNoCase("^[A-Za-z &'']+$", arguments.categoryName)>
                <cfset local.result['message'] = "Invalid category name">
                <cfset local.result['error'] = true>
            <cfelseif arrayLen(local.fetchCategoryData.category) 
                AND (local.fetchCategoryData.category[1].categoryId NEQ arguments.categoryId)>
                <cfset local.result['message'] = "Category Already Exists">
                <cfset local.result['error'] = true>
            <cfelse>
                <cfset local.decryptedCategoryId = decryptData(data = arguments.categoryId)>
                <cfquery datasource = "#application.dataSource#">
                    UPDATE 
                        tblcategory
                    SET 
                        fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "varchar">,
                        fldUpdatedBy = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                        fldUpdatedDate = #now()#
                    WHERE
                        fldCategory_Id = <cfqueryparam value = "#val(local.decryptedCategoryId)#" cfsqltype = "integer">
                        AND fldActive = 1;
                </cfquery>
                <cfset local.result['message'] = "Category Edited SuccessFully">
                <cfset local.result['error'] = false>
            </cfif>
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

    <cffunction name = "deleteCategory" access = "remote" returnType = "void">
        <cfargument name = "categoryId" required = true type = "string">
        <cftry>
            <cfset local.decryptedCategoryId = decryptData(data = arguments.categoryId)>
            <cfquery datasource = "#application.dataSource#">
                UPDATE 
                    tblcategory C
                        JOIN tblsubcategory SC ON SC.fldCategoryId = C.fldCategory_Id AND SC.fldActive = 1
                    LEFT JOIN tblproduct P ON P.fldSubcategoryId = SC.fldSubcategory_Id AND P.fldActive = 1
                    LEFT JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id AND PI.fldActive = 1
                SET 
                    C.fldActive = 0,
                    C.fldUpdatedBy = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                    C.fldUpdatedDate = #now()#,
                    SC.fldActive = 0,
                    SC.fldUpdatedBy = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                    SC.fldUpdatedDate = #now()#,
                    P.fldActive = 0,
                    P.fldUpdatedBy = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                    P.fldUpdatedDate = #now()#,
                    PI.fldActive = 0,
                    PI.fldDeactivatedBy = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                    PI.fldDeactivatedDate = #now()#
                WHERE
                    C.fldCategory_Id = <cfqueryparam value = "#val(local.decryptedCategoryId)#" cfsqltype = "integer">
                    AND C.fldActive = 1;
            </cfquery>
            <cfcatch>
                <cfset sendErrorEmail(
                    subject = getFunctionCalledName(),
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
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

    <cffunction name = "addSubCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "subCategoryName" required = true type = "string">
        <cfargument name = "categoryId" required = true type = "string">
        <cfset local.result = {
            'error' : false,
            'message' : ""
        }>
        <cftry>
            <cfset local.fetchSubCategoryData = getSubCategory(
                subCategoryName = arguments.subCategoryName,
                categoryId = arguments.categoryId
            )>
            <cfif len(trim(arguments.subCategoryName)) GT 32>
                <cfset local.result['message'] = "Maximum Length of SubCategoryName Should be 32">
                <cfset local.result['error'] = true>
            <cfelseif NOT reFindNoCase("^[A-Za-z &'']+$", arguments.subCategoryName)>
                <cfset local.result['message'] = "Invalid SubCategory name">
                <cfset local.result['error'] = true>
            <cfelseif arrayLen(local.fetchSubCategoryData.subCategory)>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "SubCatergory Already Exists">
            <cfelse>
                <cfset local.decryptedCategoryId = decryptData(data = arguments.categoryId)>
                <cfquery result = "local.subCategoryId" datasource = "#application.dataSource#">
                    INSERT INTO tblsubcategory(
                        fldSubCategoryName,
                        fldCategoryId,
                        fldCreatedBy
                    ) 
                    VALUES(
                        <cfqueryparam value = "#arguments.SubCategoryName#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#val(local.decryptedCategoryId)#" cfsqltype = "integer">,
                        <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">
                    );
                </cfquery>
                <cfset local.result['error'] = false>
                <cfset local.result['message'] = "SubCatergory Created">
            </cfif>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Error in #local.currentFunction#: #cfcatch.message#">
                <cfset sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "editSubCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "subCategoryId" required = true type = "string"> 
        <cfargument name = "subCategoryName" required = true type = "string">
        <cfargument name = "categoryId" required = true type = "string">
        <cfargument name = "newCategoryId" required = true type = "string">
        <cfset local.result = {
            'error' : false,
            'message' : ""
        }>
        <cftry>
            <cfset local.fetchSubCategoryData = getSubCategory(
                subCategoryName = arguments.subCategoryName,
                categoryId = arguments.newCategoryId
            )>
            <cfif len(trim(arguments.subCategoryName)) GT 32>
                <cfset local.result['message'] = "Maximum Length of SubCategoryName Should be 32">
                <cfset local.result['error'] = true>
            <cfelseif NOT reFindNoCase("^[A-Za-z &'']+$", arguments.subCategoryName)>
                <cfset local.result['message'] = "Invalid SubCategory name">
                <cfset local.result['error'] = true>
            <cfelseif arrayLen(local.fetchSubCategoryData.subCategory) 
                AND (local.fetchSubCategoryData.subCategory[1].subCategoryId NEQ arguments.subCategoryId)>
                <cfset local.result['message'] = "Category Already Exists">
                <cfset local.result['error'] = true>
            <cfelse>
                <cfset local.decryptedCategoryId = decryptData(data = arguments.categoryId)>
                <cfset local.decryptedNewCategoryId = decryptData(data = arguments.newCategoryId)>
                <cfset local.decryptedSubCategoryId = decryptData(data = arguments.subCategoryId)>
                <cfquery datasource = "#application.dataSource#">
                    UPDATE 
                        tblsubcategory
                    SET 
                        fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "varchar">,
                        fldCategoryId = <cfqueryparam value = "#val(local.decryptedNewCategoryId)#" cfsqltype = "integer">,
                        fldUpdatedBy = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                        fldUpdatedDate = #now()#
                    WHERE
                        fldSubCategory_Id = <cfqueryparam value = "#val(local.decryptedSubCategoryId)#" cfsqltype = "integer">
                        AND fldCategoryId = <cfqueryparam value = "#val(local.decryptedCategoryId)#" cfsqltype = "integer">
                        AND fldActive = 1;
                </cfquery>
                <cfset local.result['message'] = "Category Edited SuccessFully">
                <cfset local.result['error'] = false>
            </cfif>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.result['message'] = "Error in #local.currentFunction#: #cfcatch.message#">
                <cfset local.result['error'] = true>
                <cfset sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "deleteSubCategory" access = "remote" returnType = "void">
        <cfargument name = "subCategoryId" required = true type = "string">
        <cfargument name = "categoryId" required = true type = "string">
        <cftry>
            <cfset local.decryptedSubCategoryId = decryptData(data = arguments.subCategoryId)>
            <cfset local.decryptedCategoryId = decryptData(data = arguments.categoryId)> 
            <cfquery datasource = "#application.dataSource#">
                UPDATE 
                    tblsubcategory SC
                    LEFT JOIN tblproduct P ON P.fldSubcategoryId = SC.fldSubcategory_Id AND P.fldActive = 1
                    LEFT JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id AND PI.fldActive = 1
                SET 
                    SC.fldActive = 0,
                    SC.fldUpdatedBy = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                    SC.fldUpdatedDate = #now()#,
                    P.fldActive = 0,
                    P.fldUpdatedBy = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                    P.fldUpdatedDate = #now()#,
                    PI.fldActive = 0,
                    PI.fldDeactivatedBy = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                    PI.fldDeactivatedDate = #now()#
                WHERE
                    SC.fldSubCategory_Id = <cfqueryparam value = "#val(local.decryptedSubCategoryId)#" cfsqltype = "integer">
                    AND SC.fldCategoryId = <cfqueryparam value = "#val(local.decryptedCategoryId)#" cfsqltype = "integer">
                    AND SC.fldActive = 1;
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

    <cffunction name = "getSingleProduct" access = "remote" returnType = "struct" returnFormat = "JSON">  
        <cfargument name = "productId" required = true type = "string"> 
        <cfargument name = "productImageId" required = false type = "integer"> 
        <cfset local.result = {
            'error' : false,
            'product' : []
        }>    
        <cftry>
            <cfset local.decryptedProductId = decryptData(data = arguments.productId)>
            <cfquery name = "local.qryProduct" datasource = "#application.dataSource#">
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
                    GROUP_CONCAT(PI.fldDefaultImage ORDER BY PI.fldDefaultImage DESC) AS defaultImage
                FROM
                    tblproduct P 
                    INNER JOIN tblbrand B ON B.fldBrand_Id = P.fldBrandId
                    INNER JOIN tblsubcategory SC ON SC.fldSubCategory_Id = P.fldSubCategoryId
                    INNER JOIN tblcategory C ON C.fldCategory_Id = SC.fldCategoryId
                    LEFT JOIN tblproductimages PI ON P.fldProduct_Id = PI.fldProductId AND PI.fldActive = 1
                WHERE
                    P.fldActive = 1
                    AND SC.fldActive = 1
                    AND C.fldActive = 1
                    AND P.fldProduct_Id = <cfqueryparam value = "#val(local.decryptedProductId)#" cfsqltype = "integer">
                    <cfif structKeyExists(arguments, "productImageId")>
                        AND PI.fldProductImage_Id = <cfqueryparam value = "#val(arguments.productImageId)#" cfsqltype = "integer">
                    </cfif>
                GROUP BY 
                    P.fldProduct_Id;
            </cfquery>
            <cfloop query = "local.qryProduct">
                <cfset arrayAppend(local.result['product'],{
                    'productId' : encryptData(data = local.qryProduct.fldProduct_Id),
                    'subCategoryId' : encryptData(data = local.qryProduct.fldSubCategoryId),
                    'categoryId' : encryptData(data = local.qryProduct.fldCategory_Id),
                    'brandId' : encryptData(data = local.qryProduct.fldBrandId),
                    'productName' : local.qryProduct.fldProductName,
                    'subCategoryName' : local.qryProduct.fldSubCategoryName,
                    'categoryName' : local.qryProduct.fldCategoryName,
                    'brandName' : local.qryProduct.fldBrandName,
                    'description' : local.qryProduct.fldDescription,
                    'unitPrice' : local.qryProduct.fldUnitPrice,
                    'unitTax' : local.qryProduct.fldUnitTax,
                    'productImageId' : local.qryProduct.productImageId,
                    'imageFile' : local.qryProduct.imageFiles,
                    'defaultImage' : local.qryProduct.defaultImage
                })>
            </cfloop>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = cfcatch.message>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "getProduct" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "productName" required = false type = "string">
        <cfargument name = "subCategoryId" required = false type = "string" default = "">     
        <cfargument name = "limit" required = false type = "integer"> 
        <cfargument name = "offset" required = false type = "integer" default = 0> 
        <cfargument name = "sortType" required = false type = "string">
        <cfargument name = "minPrice" required = false type = "string"> 
        <cfargument name = "maxPrice" required = false type = "string"> 
        <cfargument name = "searchKey" required = false type = "string"> 
        <cfset local.result = {
            'error' : false,
            'product' : []
        }>    
        <cfset local.decryptedSubCategoryId = "">
        <cfset local.sort = "RAND()">
        <cfif structKeyExists(arguments, "sortType")>
            <cfset local.sort = "P.fldUnitPrice #arguments.sortType#,P.fldProductName">
        </cfif>
        <cftry>
            <cfif arguments.subCategoryId NEQ "">
                <cfset local.decryptedSubCategoryId = decryptData(data = arguments.subCategoryId)>
            </cfif>
            <cfquery name = "local.qryProduct" datasource = "#application.dataSource#">
                SELECT 
                    P.fldProduct_Id,
                    P.fldProductName,
                    P.fldSubCategoryId,
                    P.fldBrandId,
                    B.fldBrandName,
                    P.fldDescription,
                    P.fldUnitPrice,
                    P.fldUnitTax,
                    PI.fldImageFilePath,
                    PI.fldDefaultImage,
                    SC.fldSubCategoryName,
                    C.fldCategoryName,
                    C.fldCategory_Id
                FROM
                    tblproduct P
                    INNER JOIN tblbrand B ON B.fldBrand_Id = P.fldBrandId
                    INNER JOIN tblsubcategory SC ON SC.fldSubCategory_Id = P.fldSubCategoryId
                    INNER JOIN tblcategory C ON C.fldCategory_Id = SC.fldCategoryId
                    LEFT JOIN tblproductimages PI ON P.fldProduct_Id = PI.fldProductId AND PI.fldDefaultImage = 1
                WHERE
                    P.fldActive = 1
                    AND SC.fldActive = 1
                    AND C.fldActive = 1
                    <cfif arguments.subCategoryId NEQ "">
                        AND P.fldSubCategoryId = <cfqueryparam value = "#val(local.decryptedSubCategoryId)#" cfsqltype = "integer">
                    </cfif>
                    <cfif structKeyExists(arguments, "productName") AND len(trim(arguments.productName))>
                        AND P.fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype = "varchar">
                    </cfif>
                    <cfif structKeyExists(arguments, "searchKey") AND len(trim(arguments.searchKey))>
                        AND 
                        (
                            P.fldProductName LIKE <cfqueryparam value = "%#arguments.searchKey#%" cfsqltype = "varchar">
                            OR P.fldDescription LIKE <cfqueryparam value = "%#arguments.searchKey#%" cfsqltype = "varchar">
                            OR B.fldBrandName LIKE <cfqueryparam value = "%#arguments.searchKey#%" cfsqltype = "varchar">
                            OR SC.fldSubCategoryName LIKE <cfqueryparam value = "%#arguments.searchKey#%" cfsqltype = "varchar">
                            OR C.fldCategoryName LIKE <cfqueryparam value = "%#arguments.searchKey#%" cfsqltype = "varchar">
                        )
                    </cfif>
                    <cfif (structKeyExists(arguments, "minPrice") AND len(trim(arguments.minPrice))) 
                        AND (structKeyExists(arguments, "maxPrice") AND len(trim(arguments.maxPrice)))>
                            AND (P.fldUnitPrice BETWEEN <cfqueryparam value = "#arguments.minPrice#"> 
                                AND <cfqueryparam value = "#arguments.maxPrice#">)
                    </cfif>
                <cfif arguments.subCategoryId EQ "" OR structKeyExists(arguments, "sortType") AND len(trim(arguments.sortType))>
                    ORDER BY #local.sort# 
                </cfif>
                <cfif structKeyExists(arguments, "limit")>
                    LIMIT <cfqueryparam value = "#val(arguments.offset)#" cfsqltype = "integer">,
                    <cfqueryparam value = "#val(arguments.limit)#" cfsqltype = "integer">   
                </cfif>
            </cfquery>
            <cfloop query = "local.qryProduct">
                <cfset arrayAppend(local.result['product'],{
                    'productId' : encryptData(data = local.qryProduct.fldProduct_Id),
                    'subCategoryId' : encryptData(data = local.qryProduct.fldSubCategoryId),
                    'categoryId' : encryptData(data = local.qryProduct.fldCategory_Id),
                    'brandId' : encryptData(data = local.qryProduct.fldBrandId),
                    'decryptedProductId': local.qryProduct.fldProduct_Id,
                    'productName' : local.qryProduct.fldProductName,
                    'subCategoryName' : local.qryProduct.fldSubCategoryName,
                    'brandName' : local.qryProduct.fldBrandName,
                    'description' : local.qryProduct.fldDescription,
                    'unitPrice' : local.qryProduct.fldUnitPrice,
                    'unitTax' : local.qryProduct.fldUnitTax,
                    'imageFile' : local.qryProduct.fldImageFilePath,
                    'defaultImage' : local.qryProduct.fldDefaultImage
                })>
            </cfloop>
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

    <cffunction name = "addProduct" access = "public" returnType = "struct">
        <cfargument name = "categoryId" required = true type = "string">
        <cfargument name = "subCategoryId" required = true type = "string">
        <cfargument name = "productName" required = true type = "string">
        <cfargument name = "productBrandId" required = true type = "string">
        <cfargument name = "productDesc" required = true type = "string">
        <cfargument name = "productPrice" required = true type = "numeric">
        <cfargument name = "productTax" required = true type = "numeric">
        <cfargument name = "productImage" required = true type = "string">  
        <cfset local.result = {
            'error' : false,
            'message' : ""
        }>
        <cftry>  
            <cfif len(trim(arguments.productName)) LT 2 OR NOT reFind("^[a-zA-Z0-9\s]+$", arguments.productName)>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Product Name must be a string and at least 2 characters long">
            <cfelseif len(trim(arguments.productDesc)) LT 5 OR NOT reFind("^[a-zA-Z0-9\s,.]+$", arguments.productDesc)>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Product Description must be at least 5 characters long">
            <cfelseif arguments.productPrice LTE 0>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Product Price must be greater than 0">
            <cfelseif arguments.productTax LT 0>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Product Tax cannot be negative">
            <cfelse>
                <cfset local.decryptedSubCategoryId = decryptData(data = arguments.subCategoryId)>
                <cfset local.decryptedBrandId = decryptData(data = arguments.productBrandId)>
                <cfset local.FetchProduct = getProduct(
                    productName = arguments.productName,
                    subCategoryId = arguments.subCategoryId
                )>
                <cfif arrayLen(local.FetchProduct.product)>
                    <cfset local.result['error'] = true>
                    <cfset local.result['message'] = "ProductName Already Exists">
                <cfelse>
                    <cfquery result = "local.resultProductId" datasource = "#application.dataSource#">
                        INSERT INTO tblproduct(
                            fldSubCategoryId,
                            fldProductName,
                            fldBrandId,
                            fldDescription,
                            fldUnitPrice,
                            fldUnitTax,
                            fldCreatedBy
                        )
                        VALUES(
                            <cfqueryparam value = "#val(local.decryptedSubCategoryId)#" cfsqltype = "integer">,
                            <cfqueryparam value = "#arguments.productName#" cfsqltype = "varchar">,
                            <cfqueryparam value = "#val(local.decryptedBrandId)#" cfsqltype = "integer">,
                            <cfqueryparam value = "#arguments.productDesc#" cfsqltype = "varchar">,
                            <cfqueryparam value = "#val(arguments.productPrice)#" cfsqltype = "integer">,
                            <cfqueryparam value = "#val(arguments.productTax)#" cfsqltype = "integer">,
                            <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">
                        );
                    </cfquery>
                    <cfset local.encryptedProductId = encryptData(data = local.resultProductId.generatedkey)>
                    <cfdirectory action = "create" directory = "#expandPath('../uploads/products/product#local.resultProductId.generatedkey#')#">
                    <cffile
                        action = "uploadall"
                        destination = "#expandPath('../uploads/products/product#local.resultProductId.generatedkey#')#"
                        nameconflict = "MakeUnique"
                        strict = true
                        result = "local.imageUploadedResult"
                    >
                    <cfquery datasource = "#application.dataSource#">
                        INSERT INTO tblproductimages(
                            fldProductId,
                            fldImageFilePath,
                            fldDefaultImage,
                            fldCreatedBy
                        )
                        VALUES
                        <cfloop array = "#local.imageUploadedResult#" item = "imagesArr" index = "imageIndex">               
                            (
                                <cfqueryparam value = "#val(local.resultProductId.generatedkey)#" cfsqltype = "integer">,
                                <cfqueryparam value = "#imagesArr.SERVERFILE#" cfsqltype = "varchar">,
                                <cfif imageIndex EQ 1>
                                    <cfqueryparam value = 1 cfsqltype = "integer">
                                <cfelse>
                                    <cfqueryparam value = 0 cfsqltype = "integer">
                                </cfif>,
                                <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">
                            )
                            <cfif imageIndex LT arrayLen(local.imageUploadedResult)>,</cfif>
                        </cfloop>;
                    </cfquery>
                    <cfset local.result['error'] = false>
                    <cfset local.result['message'] = "ProductName Added Succesfully">
                </cfif>
            </cfif>         
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Error in #local.currentFunction#: #cfcatch.message#">
                <cfset sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>        
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "editProduct" access = "public" returnType = "struct">
        <cfargument name = "categoryId" required = true type = "string">
        <cfargument name = "subCategoryId" required = true type = "string">
        <cfargument name = "productName" required = true type = "string">
        <cfargument name = "productBrandId" required = true type = "string">
        <cfargument name = "productDesc" required = true type = "string">
        <cfargument name = "productPrice" required = true type = "numeric">
        <cfargument name = "productTax" required = true type = "numeric">
        <cfargument name = "productImage" required = true type = "string">
        <cfargument name = "productId" required = true type = "string">
        <cfset local.result = {
            'error' : false,
            'message' : ""
        }>
        <cftry>
            <cfif len(trim(arguments.productName)) LT 2 OR NOT reFind("^[a-zA-Z0-9\s]+$", arguments.productName)>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Product Name must be a string and at least 2 characters long">
            <cfelseif len(trim(arguments.productDesc)) LT 5 OR NOT reFind("^[a-zA-Z0-9\s,.]+$", arguments.productDesc)>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Product Description must be at least 5 characters long">
            <cfelseif arguments.productPrice LTE 0>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Product Price must be greater than 0">
            <cfelseif arguments.productTax LT 0>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Product Tax cannot be negative">
            <cfelse> 
                <cfset local.decryptedSubCategoryId = decryptData(data = arguments.subCategoryId)>
                <cfset local.decryptedBrandId = decryptData(data = arguments.productBrandId)>
                <cfset local.decryptedProductId = decryptData(data = arguments.productId)>
                <cfset local.FetchProduct = getProduct(
                    productName = arguments.productName,
                    subCategoryId = arguments.subCategoryId
                )>
                <cfif arrayLen(local.FetchProduct.product) 
                    AND (local.FetchProduct.product[1].productId NEQ arguments.productId)>
                    <cfset local.result['error'] = true>
                    <cfset local.result['message'] = "ProductName Already Exists">
                <cfelse>
                    <cfquery datasource = "#application.dataSource#">  
                        UPDATE 
                            tblproduct
                        SET
                            fldSubCategoryId = <cfqueryparam value = "#val(local.decryptedSubCategoryId)#" cfsqltype = "integer">,
                            fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype = "varchar">,
                            fldBrandId = <cfqueryparam value = "#val(local.decryptedBrandId)#" cfsqltype = "integer">,
                            fldDescription = <cfqueryparam value = "#arguments.productDesc#" cfsqltype = "varchar">,
                            fldUnitPrice = <cfqueryparam value = "#val(arguments.productPrice)#" cfsqltype = "integer">,
                            fldUnitTax = <cfqueryparam value = "#val(arguments.productTax)#" cfsqltype = "integer">,
                            fldUpdatedBy = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                            fldUpdatedDate = #now()#
                        WHERE
                            fldProduct_Id = <cfqueryparam value = "#val(local.decryptedProductId)#" cfsqltype = "integer">
                            AND fldSubCategoryId = <cfqueryparam value = "#val(local.decryptedSubCategoryId)#" cfsqltype = "integer">
                            AND fldActive = 1
                    </cfquery>
                    <cfif len(trim(arguments.productImage))>                    
                        <cffile
                            action = "uploadall"
                            destination = "#expandPath('../uploads/products/product#local.decryptedProductId#')#"
                            nameconflict = "MakeUnique"
                            strict = true
                            result = "local.imageUploadedResult"
                        >
                        <cfquery datasource = "#application.dataSource#">
                            INSERT INTO tblproductimages(
                                fldProductId,
                                fldImageFilePath,
                                fldCreatedBy
                            )
                            VALUES
                            <cfloop array = "#local.imageUploadedResult#" item = "imagesArr" index = "imageIndex">               
                                (
                                    <cfqueryparam value = "#val(local.decryptedProductId)#" cfsqltype = "integer">,
                                    <cfqueryparam value = "#imagesArr.SERVERFILE#" cfsqltype = "varchar">,
                                    <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">
                                )
                                <cfif imageIndex LT arrayLen(local.imageUploadedResult)>,</cfif>
                            </cfloop>;
                        </cfquery>
                    </cfif>
                    <cfset local.result['error'] = false>
                    <cfset local.result['message'] = "ProductName Edited Succesfully">
                </cfif>
            </cfif>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Error in #local.currentFunction#: #cfcatch.message#">
                <cfset sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>       
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "deleteProduct" access = "remote" returnType = "void">
        <cfargument name = "productId" required = true type = "string">
        <cfargument name = "subCategoryId" required = true type = "string">
        <cftry>
            <cfset local.decryptedProductId = decryptData(data = arguments.productId)>
            <cfset local.decryptedSubCategoryId = decryptData(data = arguments.subCategoryId)>
            <cfquery datasource = "#application.dataSource#"> 
                UPDATE  
                    tblproduct
                SET
                    fldActive = 0,
                    fldUpdatedBy = <cfqueryparam value = "#val(session.loginUserId)#" cfsqltype = "integer">,
                    fldUpdatedDate = #now()#
                WHERE
                    fldProduct_Id = <cfqueryparam value = "#val(local.decryptedProductId)#" cfsqltype = "integer">
                    AND fldSubCategoryId = <cfqueryparam value = "#val(local.decryptedSubCategoryId)#" cfsqltype = "integer">
                    AND fldActive = 1;
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

    <cffunction name = "setDefaultProductImage" access = "remote" returnType = "void">
        <cfargument name = "productImageId" required = true type = "integer">
        <cfargument name = "productId" required = true type = "string">
        <cftry>
            <cfset local.decryptedProductId = decryptData(data = arguments.productId)>
            <cfquery datasource = "#application.dataSource#">
                UPDATE
                    tblproductimages
                SET
                    fldDefaultImage = 0
                WHERE
                    fldDefaultImage = 1
                    AND fldActive = 1
                    AND fldProductId = <cfqueryparam value = "#val(local.decryptedProductId)#" cfsqltype = "integer">;
            </cfquery>
            <cfquery datasource = "#application.dataSource#">
                UPDATE
                    tblproductimages
                SET
                    fldDefaultImage = 1
                WHERE
                    fldProductImage_Id = <cfqueryparam value = "#val(arguments.productImageId)#" cfsqltype = "integer">
                    AND fldProductId = <cfqueryparam value = "#val(local.decryptedProductId)#" cfsqltype = "integer">
                    AND fldActive = 1
                    AND fldDefaultImage = 0;
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

    <cffunction name = "deleteProductImage" access = "remote">
        <cfargument name = "productImageId" required = true type = "integer">
        <cfargument name = "productId" required = true type = "string">
        <cfset productImageData = getSingleProduct(
            productId = arguments.productId,
            productImageId = arguments.productImageId
        )>
        <cftry>
            <cfset local.decryptedProductId = decryptData(data = productImageData.product[1].productId)>
            <cfquery datasource = "#application.dataSource#">
                DELETE FROM
                    tblproductimages
                WHERE
                    fldProductImage_Id = <cfqueryparam value = "#val(arguments.productImageId)#" cfsqltype = "integer">
                    AND fldActive = 1;
            </cfquery>
            <cffile action = "delete" file = "#expandPath('../uploads/products/product#local.decryptedProductId#/#productImageData.product[1].imageFile#')#">   
            <cfcatch>
               <cfset local.currentFunction = getFunctionCalledName()>
                <cfset sendErrorEmail(
                    subject = local.currentFunction,
                    errorMessage = cfcatch.message
                )>
            </cfcatch>
        </cftry>
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