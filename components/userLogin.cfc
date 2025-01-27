<cfcomponent>
    <cffunction name = "adminLogin" access = "remote" returnFormat = "JSON" returnType = "struct">
        <cfargument name = "userName" required = "yes" type = "string">
        <cfargument name = "password" required = "yes" type = "string">
        <cfset local.loginResult = {
            'message' : "Invalid User",
            'error' :  "false"
        }>
        <cftry>
            <cfquery name = "local.qryFetchData" datasource = "shoppingCart">
                SELECT 
                    fldUser_Id,
                    fldRoleId,
                    fldFirstName,
                    fldLastName,
                    fldEmail,
                    fldPhone,
                    fldHashedPassword,
                    fldUserSaltString
                FROM 
                    tbluser                   
                WHERE
                    fldRoleId = 1
                    AND fldActive = 1
                    AND (fldEmail = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">
                        OR fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">);                
            </cfquery>
            <cfset local.pwd = arguments.password & local.qryFetchData.fldUserSaltString>
            <cfset local.encrypted_pass = Hash(local.pwd, 'SHA-512')>
            <cfif local.qryFetchData.RecordCount AND (local.qryFetchData.fldHashedPassword EQ local.encrypted_pass)>
                <cfset session.adminUserId = local.qryFetchData.fldUser_Id>
                <cfset session.roleId = local.qryFetchData.fldRoleId>
                <cfset session.email = local.qryFetchData.fldEmail>
                <cfset session.firstName = local.qryFetchData.fldFirstName>
                <cfset session.lastName = local.qryFetchData.fldLastName>
                <cfset local.loginResult['message'] = "Login Successful">
                <cfset local.loginResult['error'] = "true">
            </cfif>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.loginResult['message'] = "An error occurred: #cfcatch.message#">
                <cfset local.loginResult['error'] = "false">
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #functionName#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
        <cfreturn local.loginResult>
    </cffunction>

    <cffunction name = "logout" access = "remote" returnType = "void">
        <cfset structClear(session)>
    </cffunction>
</cfcomponent>