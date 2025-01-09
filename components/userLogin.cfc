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
                fldCategoryName
            FROM
                tblCatergory
            WHERE
                fldCreatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "cf_sql_varchar">
                AND fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
        </cfquery>
        <cfif local.fetchCategoryName.RecordCount>
            <cfset local.result['resultMsg'] = "Catergory Already Exists">
        <cfelse>
            <cfquery name = "local.qryAddCategory" result="local.catergoryId">
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
        </cfif>
        <cfreturn local.result>
    </cffunction>
</cfcomponent>