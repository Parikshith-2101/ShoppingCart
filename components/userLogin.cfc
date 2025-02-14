<cfcomponent>
    <cffunction name = "getUser" access = "public" returnType = "struct">
        <cfargument name = "userName" required = false type = "string">
        <cfargument name = "email" required = false type = "string">
        <cfargument name = "phone" required = false type = "string">
        <cfif NOT structKeyExists(arguments, "email") AND NOT structKeyExists(arguments, "phone")>
            <cfset arguments.email = arguments.userName>
            <cfset arguments.phone = arguments.userName>
        </cfif>
        <cfset local.result = {
            'error' : false,
            'user' : []
        }>
        <cftry>
             <cfquery name = "local.qryUser" datasource = "#application.dataSource#">
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
                    fldActive = 1
                    AND (fldEmail = <cfqueryparam value = "#arguments.email#" cfsqltype = "varchar">
                        OR fldPhone = <cfqueryparam value = "#arguments.phone#" cfsqltype = "varchar">);
            </cfquery> 
            <cfloop query = "local.qryUser">
                <cfset arrayAppend(local.result['user'],{
                    'userId' : local.qryUser.fldUser_Id,
                    'roleId' : local.qryUser.fldRoleId,
                    'firstName' : local.qryUser.fldFirstName,
                    'lastName' : local.qryUser.fldLastName,
                    'email' : local.qryUser.fldEmail,
                    'phone' : local.qryUser.fldPhone,
                    'hashedPassword' : local.qryUser.fldHashedPassword,
                    'saltString' : local.qryUser.fldUserSaltString
                })>
            </cfloop>  
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

    <cffunction name = "userLogin" access = "public" returnType = "struct">
        <cfargument name = "userName" required = true type = "string">
        <cfargument name = "password" required = true type = "string">
        <cfset local.result = {
            'error' : true,
            'message' : "Invalid User , Please Signup"
        }>
        <cftry>
            <cfset local.getUser = getUser(userName = arguments.userName)>
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

    <cffunction name = "userSignUp" access = "public" returnType = "struct">
        <cfargument name = "firstName" required = true type = "string">
        <cfargument name = "lastName" required = true type = "string">
        <cfargument name = "email" required = true type = "string">
        <cfargument name = "phone" required = true type = "string">
        <cfargument name = "password" required = true type = "string">
        <cfset local.result = {
            'error': true,
            'message': ""
        }>
        <cftry>
            <cfset local.getUser = getUser(
                email = arguments.email,
                phone = arguments.phone
            )>
            <cfif arrayLen(local.getUser.user)>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "User already exists.">
            <cfelse>
                <cfset local.saltString = generateSecretKey('AES')>
                <cfset local.hashedPassword = hmac(arguments.password, local.saltString, "hmacSHA256")>
                <cfquery datasource = "#application.dataSource#">
                    INSERT INTO tbluser (
                        fldRoleId,
                        fldFirstName,
                        fldLastName,
                        fldEmail,
                        fldPhone,
                        fldHashedPassword,
                        fldUserSaltString
                    ) VALUES (
                        2,
                        <cfqueryparam value = "#arguments.firstName#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#arguments.lastName#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#arguments.email#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#arguments.phone#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#local.hashedPassword#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#local.saltString#" cfsqltype = "varchar">
                    );
                </cfquery>
                <cfset local.result['error'] = false>
                <cfset local.result['message'] = "Account created successfully.">
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