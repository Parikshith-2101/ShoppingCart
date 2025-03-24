<cfcomponent>
    <cffunction name = "productController" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "productId" required = "false" type = "string" default = "">
        <cfargument name = "productImageId" required = "false" type = "integer" default = 0>
        <cfargument name = "productName" required = "false" type = "string" default = "">
        <cfargument name = "subCategoryId" required = "false" type = "string" default = "">
        <cfargument name = "categoryId" required = "false" type = "string" default = "">
        <cfargument name = "limit" required = "false" type = "integer" default = 0>
        <cfargument name = "offset" required = "false" type = "integer" default = 0>
        <cfargument name = "sortType" required = "false" type = "string" default = "">
        <cfargument name = "minPrice" required = "false" type = "numeric" default = 0>
        <cfargument name = "maxPrice" required = "false" type = "numeric" default = 0>
        <cfargument name = "searchKey" required = "false" type = "string" default = "">
        <cfargument name = "maxRowNumber" required = "false" type = "integer" default = 0>
        <cfargument name = "isRand" required = "false" type = "boolean" default = false>

        <cfset local.decryptedProductId = len(arguments.productId) ? application.productManagementObj.decryptData(arguments.productId) : 0>
        <cfset local.decryptedSubCategoryId = len(arguments.subCategoryId) ? application.productManagementObj.decryptData(arguments.subCategoryId) : 0>
        <cfset local.decryptedCategoryId = len(arguments.categoryId) ? application.productManagementObj.decryptData(arguments.categoryId) : 0>

        <cfset local.result = application.productManagementObj.getProduct(
            productId = local.decryptedProductId,
            subCategoryId = local.decryptedSubCategoryId,
            categoryId = local.decryptedCategoryId,
            productImageId = arguments.productImageId,
            productName = arguments.productName,
            limit = arguments.limit,
            offset = arguments.offset,
            sortType = arguments.sortType,
            minPrice = arguments.minPrice,
            maxPrice = arguments.maxPrice,
            searchKey = arguments.searchKey,
            maxRowNumber = arguments.maxRowNumber,
            isRand = arguments.isRand 
        )>
    
        <cfreturn local.result>
    </cffunction>
</cfcomponent>