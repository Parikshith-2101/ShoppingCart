<cfcomponent>
    <cffunction name = "adminLogin" access = "remote" returnFormat = "JSON" returnType = "Struct">
        <cfargument name = "userName">
        <cfargument name = "password">
        <cfset local.loginResult = structNew()>
        <cfquery name = "local.getSaltString">
            SELECT 
                fldUserSaltString
            FROM 
                tbluser
            WHERE
                (fldEmail = <cfqueryparam value = "#arguments.userName#" cfsqltype = "cf_sql_varchar">
                OR fldPhone = <cfqueryparam value = "#arguments.userName#" cfsqltype = "cf_sql_varchar">)
        </cfquery>
        <cfset local.pwd = arguments.password & local.getSaltString.fldUserSaltString>
        <cfset local.encrypted_pass = Hash(local.pwd, 'SHA-512')/>
        <cfquery name = "local.qryFetchData">
            SELECT 
                u.fldUser_Id,
                u.fldRoleId,
                u.fldFirstName,
                u.fldLastName,
                u.fldEmail,
                u.fldPhone,
                u.fldHashedPassword,
                u.fldUserSaltString,
                r.fldRoleName
            FROM 
                tbluser u
                INNER JOIN tblrole r ON u.fldRoleId = r.fldRole_Id
            WHERE
                (u.fldEmail = <cfqueryparam value = "#arguments.userName#" cfsqltype = "cf_sql_varchar">
                OR u.fldPhone = <cfqueryparam value = "#arguments.userName#" cfsqltype = "cf_sql_varchar">)
                AND u.fldHashedPassword = <cfqueryparam value = "#local.encrypted_pass#" cfsqltype = "cf_sql_varchar">
                AND u.fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
                AND r.fldRoleName = <cfqueryparam value = "admin" cfsqltype = "cf_sql_varchar">
        </cfquery>
        <cfif local.qryFetchData.RecordCount>
            <cfset session.userId = local.qryFetchData.fldUser_Id>
            <cfset session.email = local.qryFetchData.fldEmail>
            <cfset session.firstName = local.qryFetchData.fldFirstName>
            <cfset session.lastName = local.qryFetchData.fldLastName>
            <cfset local.loginResult['resultMsg'] = "Login SuccessFull">
            <cfset local.loginResult['errorStatus'] = "true">
        <cfelse>
            <cfset local.loginResult['resultMsg'] = "Invalid User">
            <cfset local.loginResult['errorStatus'] = "false">
        </cfif>
        <cfreturn local.loginResult>
    </cffunction>

    <cffunction name = "logout" access = "remote" returnType = "void">
        <cfset structClear(session)>
    </cffunction>

    <cffunction name = "addCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "categoryName">
        <cfquery name = "local.fetchCategoryName">
            SELECT 
                fldCategory_Id,
                fldCategoryName
            FROM
                tblcategory
            WHERE
                fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "cf_sql_varchar">
                AND fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
        </cfquery>
        <cfif local.fetchCategoryName.RecordCount>
            <cfset local.result['resultMsg'] = "Catergory Already Exists">
            <cfset local.result['errorStatus'] = "false">
        <cfelse>
            <cfquery name = "local.qryAddCategory" result = "local.categoryId">
                INSERT INTO tblcategory(
                    fldCategoryName,
                    fldCreatedBy
                ) 
                VALUES(
                    <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_varchar">
                );
            </cfquery>
            <cfset local.result['resultMsg'] = "Catergory Created">
            <cfset local.result['errorStatus'] = "true">
        </cfif>
        <cfreturn local.result>
    </cffunction>
    
    <cffunction name = "qryCategoryData" access = "public" returnType = "query">
        <cfargument name = "categoryId" required = "no">
        <cfargument name = "categoryName" required = "no">
        <cfquery name = "local.fetchCategoryData">
            SELECT 
                fldCategory_Id,
                fldCategoryName
            FROM
                tblcategory
            WHERE           
                fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
                <cfif structKeyExists(arguments, "categoryId") AND len(trim(arguments.categoryId))>
                    AND fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">
                </cfif>
                <cfif structKeyExists(arguments, "categoryName") AND len(trim(arguments.categoryName))>
                    AND fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "cf_sql_varchar">
                </cfif>;
        </cfquery>
        <cfreturn local.fetchCategoryData>
    </cffunction>

    <cffunction name = "viewCategory" access = "remote" returnType = "Struct" returnFormat = "JSON">
        <cfargument name = "categoryId">
        <cfset local.categoryData = qryCategoryData(arguments.categoryId)>
        <cfset local.category['categoryName'] = local.categoryData.fldCategoryName>
        <cfset local.category['categoryId'] = local.categoryData.fldCategory_Id>
        <cfreturn local.category>
    </cffunction>

    <cffunction name = "editCategory" access = "remote" returnType = "Struct" returnFormat = "JSON">
        <cfargument name = "categoryId"> 
        <cfargument name = "categoryName"> 
        <cfset local.categoryData = qryCategoryData(arguments.categoryId,arguments.categoryName)>
        <cfif local.categoryData.RecordCount>
            <cfset local.output['resultMsg'] = "Category Already Exists">
            <cfset local.output['errorStatus'] = "false">
        <cfelse>
            <cfquery name = "local.qryEditCategory">
                UPDATE 
                    tblcategory
                SET 
                    fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "cf_sql_varchar">,
                    fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">,
                    fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_timestamp">
                WHERE
                    fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">
                    AND fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">;
            </cfquery>
            <cfset local.output['resultMsg'] = "Category Edited SuccessFully">
            <cfset local.output['errorStatus'] = "true">
        </cfif>
        <cfreturn local.output>
    </cffunction>

    <cffunction name = "deleteCategory" access = "remote" returnType = "void">
        <cfargument name = "contactId">
        <cfquery name = "local.qryDeleteCategory">
            UPDATE 
                tblcategory
            SET 
                fldActive = <cfqueryparam value = "0" cfsqltype = "cf_sql_integer">,
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">,
                fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_timestamp">
            WHERE
                fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">;
        </cfquery>
    </cffunction>

    <cffunction name = "addSubCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "subCategoryName">
        <cfargument name = "categoryId">
        <cfquery name = "local.fetchSubCategoryName">
            SELECT 
                fldSubCategory_Id,
                fldCategoryId,
                fldSubCategoryName
            FROM
                tblsubcategory
            WHERE
                fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "cf_sql_varchar">
                AND fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
                AND fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">;
        </cfquery>
        <cfif local.fetchSubCategoryName.RecordCount>
            <cfset local.result['resultMsg'] = "SubCatergory Already Exists">
            <cfset local.result['errorStatus'] = "false">
        <cfelse>
            <cfquery name = "local.qryAddSubCategory" result = "local.subCategoryId">
                INSERT INTO tblsubcategory(
                    fldSubCategoryName,
                    fldCategoryId,
                    fldCreatedBy
                ) 
                VALUES(
                    <cfqueryparam value = "#arguments.SubCategoryName#" cfsqltype = "cf_sql_varchar">,
                    <cfqueryparam value = "#arguments.CategoryId#" cfsqltype = "cf_sql_integer">,
                    <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_integer">
                );
            </cfquery>
            <cfset local.result['resultMsg'] = "SubCatergory Created">
            <cfset local.result['errorStatus'] = "true">
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "qrySubCategoryData" returnType = "query">
        <cfargument name = "categoryId" required = "no">
        <cfargument name = "subCategoryId" required = "no">
        <cfquery name = "local.qrySubCategoryData">
            SELECT 
                fldSubCategory_Id,
                fldCategoryId,
                fldSubCategoryName
            FROM
                tblsubcategory
            WHERE
                fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">
                AND fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">;
        </cfquery>
        <cfreturn local.qrySubCategoryData>
    </cffunction>

    <cffunction name = "viewSubCategory" access = "remote" returnType = "Struct" returnFormat = "JSON">
        <cfargument name = "name">
    </cffunction> 
</cfcomponent>