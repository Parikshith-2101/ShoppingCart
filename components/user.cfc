<cfcomponent>
    <cffunction name = "userLogin" access = "public" returnType = "struct">
        <cfargument name = "userName" required = "yes" type = "string">
        <cfargument name = "password" required = "yes" type = "string">
        <cfset local.result = {
            'error' : "false",
            'message' : "Invalid User , Please Signup"
        }>
        <cfquery name = "local.qryFetchUserData">
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
                AND fldROleId = 2
                AND (fldEmail = <cfqueryparam value = "#arguments.userName#" cfsqltype = "varchar">
                    OR fldPhone = <cfqueryparam value = "#arguments.userName#" cfsqltype = "varchar">);
        </cfquery>
        <cfif local.qryFetchUserData.RecordCount>
            <cfset local.saltString = local.qryFetchUserData.fldUserSaltString>
            <cfset local.hashedPassword = hmac(arguments.password, local.saltString, 'hmacSHA256')>
            <cfif local.qryFetchUserData.fldHashedPassword EQ local.hashedPassword>
                <cfset session.userId = local.qryFetchUserData.fldUser_Id>
                <cfset session.email = local.qryFetchUserData.fldEmail>
                <cfset session.firstName = local.qryFetchUserData.fldFirstName>
                <cfset session.lastName = local.qryFetchUserData.fldLastName>
                <cfset local.result['message'] = "Login Successful">
                <cfset local.result['error'] = "true">
            </cfif>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "userSignUp" access = "public" returnType = "struct">
        <cfargument name = "firstName" required = "yes" type = "string">
        <cfargument name = "lastName" required = "yes" type = "string">
        <cfargument name = "email" required = "yes" type = "string">
        <cfargument name = "phone" required = "yes" type = "string">
        <cfargument name = "password" required = "yes" type = "string">
        <cfset local.result = {
            'error': false,
            'message': ""
        }>
        <cftry>
            <cfquery name = "local.qryFetchUserData" datasource = "shoppingCart">
                SELECT 
                    fldUser_Id
                FROM
                    tbluser
                WHERE
                    fldActive = 1
                    AND fldRoleId = 2
                    AND (
                        fldEmail = <cfqueryparam value = "#arguments.email#" cfsqltype = "varchar">
                        OR fldPhone = <cfqueryparam value = "#arguments.phone#" cfsqltype = "varchar">
                    );
            </cfquery>

            <cfif local.qryFetchUserData.RecordCount>
                <cfset local.result['error'] = false>
                <cfset local.result['message'] = "User already exists.">
            <cfelse>
                <cfset local.saltString = generateSecretKey('AES')>
                <cfset local.hashedPassword = hmac(arguments.password, local.saltString, "hmacSHA256")>

                <cfquery datasource = "shoppingCart">
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
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Account created successfully.">
            </cfif>
        <cfcatch>
            <cfset local.result['error'] = false>
            <cfset local.result['message'] = "An error occurred: #cfcatch.message#">
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>
</cfcomponent>