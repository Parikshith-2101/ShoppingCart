<cfcomponent>
       <cffunction name = "userLogin" access = "public" returnType = "struct">
        <cfargument name = "userName" required = true type = "string">
        <cfargument name = "password" required = true type = "string">
        <cfset local.result = {
            'error' : true,
            'message' : "Invalid User , Please Signup"
        }>
        <cftry>
            <cfset local.getUser = application.userObj.getUser(userName = arguments.userName)>
            <cfif arrayLen(local.getUser.user)>
                <cfset local.saltString = local.getUser.user[1].saltString>
                <cfset local.hashedPassword = hmac(arguments.password, local.saltString, 'hmacSHA256')>
                <cfif local.getUser.user[1].hashedPassword EQ local.hashedPassword>
                    <cfset session.loginUserId = local.getUser.user[1].userId>
                    <cfset session.email = local.getUser.user[1].email>
                    <cfset session.firstName = local.getUser.user[1].firstName>
                    <cfset session.lastName = local.getUser.user[1].lastName>
                    <cfset session.phone = local.getUser.user[1].phone>
                    <cfset session.roleId = local.getUser.user[1].roleId>   
                    <cfset local.result['message'] = "Login Successful">
                    <cfset local.result['error'] = false>
                </cfif>
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

    <cffunction name = "logout" access = "remote" returnType = "void">
        <cfset structClear(session)>
    </cffunction>
</cfcomponent>