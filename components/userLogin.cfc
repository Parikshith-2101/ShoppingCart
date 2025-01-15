<cfcomponent>
    <cffunction name = "adminLogin" access = "remote" returnFormat = "JSON" returnType = "Struct">
        <cfargument name = "userName" required = "yes" type = "string">
        <cfargument name = "password" required = "yes" type = "string">
        <cfset local.loginResult = structNew()>
        <cftry>

            <cfquery name = "local.getSaltString">
                SELECT 
                    fldUserSaltString
                FROM 
                    tbluser
                WHERE
                    (fldEmail = <cfqueryparam value = "#arguments.userName#" cfsqltype = "varchar">
                    OR fldPhone = <cfqueryparam value = "#arguments.userName#" cfsqltype = "varchar">)
            </cfquery>
            <cfset local.pwd = arguments.password & local.getSaltString.fldUserSaltString>
            <cfset local.encrypted_pass = Hash(local.pwd, 'SHA-512')/>
            <cfquery name = "local.qryFetchData">
                SELECT 
                    U.fldUser_Id,
                    U.fldRoleId,
                    U.fldFirstName,
                    U.fldLastName,
                    U.fldEmail,
                    U.fldPhone,
                    U.fldHashedPassword,
                    U.fldUserSaltString,
                    R.fldRoleName
                FROM 
                    tbluser u
                    INNER JOIN tblrole r ON U.fldRoleId = R.fldRole_Id
                WHERE
                    (U.fldEmail = <cfqueryparam value = "#arguments.userName#" cfsqltype = "varchar">
                    OR U.fldPhone = <cfqueryparam value = "#arguments.userName#" cfsqltype = "varchar">)
                    AND U.fldHashedPassword = <cfqueryparam value = "#local.encrypted_pass#" cfsqltype = "varchar">
                    AND U.fldActive = <cfqueryparam value = "1" cfsqltype = "integer">
                    AND R.fldRoleName = <cfqueryparam value = "admin" cfsqltype = "varchar">
            </cfquery>
            <cfif local.qryFetchData.RecordCount>
                <cfset session.adminUserId = local.qryFetchData.fldUser_Id>
                <cfset session.email = local.qryFetchData.fldEmail>
                <cfset session.firstName = local.qryFetchData.fldFirstName>
                <cfset session.lastName = local.qryFetchData.fldLastName>
                <cfset local.loginResult['resultMsg'] = "Login SuccessFull">
                <cfset local.loginResult['errorStatus'] = "true">
            <cfelse>
                <cfset local.loginResult['resultMsg'] = "Invalid User">
                <cfset local.loginResult['errorStatus'] = "false">
            </cfif>
            <cfcatch type = "exception">          
                <cfset local.loginResult['resultMsg'] = "An error occurred: #cfcatch.message#">
                <cfset local.loginResult['errorStatus'] = "false">
            </cfcatch>
        </cftry>
        <cfreturn local.loginResult>
    </cffunction>

    <cffunction name = "logout" access = "remote" returnType = "void">
        <cfset structClear(session)>
    </cffunction>
</cfcomponent>