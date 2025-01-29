<cfcomponent>
    <cffunction name = "userLogin" access = "public" returnType = "struct">
        <cfargument name = "userName" required = true type = "string">
        <cfargument name = "password" required = true type = "string">
        <cfset local.result = {
            'error' : true,
            'message' : "Invalid User , Please Signup"
        }>
        <cftry>
            <cfquery name = "local.qryFetchUserData" dataSource = "shoppingCart">
                SELECT 
                    U.fldUser_Id,
                    U.fldRoleId,
                    U.fldFirstName,
                    U.fldLastName,
                    U.fldEmail,
                    U.fldPhone,
                    U.fldHashedPassword,
                    U.fldUserSaltString,
                    COUNT(C.fldProductId) AS cartQuantity
                FROM
                    tbluser U
                LEFT JOIN tblcart C ON U.fldUser_Id = C.fldUserId
                WHERE
                    U.fldActive = 1
                    AND (U.fldEmail = <cfqueryparam value = "#arguments.userName#" cfsqltype = "varchar">
                        OR U.fldPhone = <cfqueryparam value = "#arguments.userName#" cfsqltype = "varchar">)
                GROUP BY
                    U.fldUser_Id,
                    U.fldRoleId,
                    U.fldFirstName,
                    U.fldLastName,
                    U.fldEmail,
                    U.fldPhone,
                    U.fldHashedPassword,
                    U.fldUserSaltString;
            </cfquery>
            
            <cfif local.qryFetchUserData.RecordCount>
                <cfset local.saltString = local.qryFetchUserData.fldUserSaltString>
                <cfset local.hashedPassword = hmac(arguments.password, local.saltString, 'hmacSHA256')>
                <cfif local.qryFetchUserData.fldHashedPassword EQ local.hashedPassword>
                    <cfset session.userId = local.qryFetchUserData.fldUser_Id>
                    <cfset session.email = local.qryFetchUserData.fldEmail>
                    <cfset session.firstName = local.qryFetchUserData.fldFirstName>
                    <cfset session.lastName = local.qryFetchUserData.fldLastName>
                    <cfset session.roleId = local.qryFetchUserData.fldRoleId>
                    <cfset session.cartQuantity = local.qryFetchUserData.cartQuantity>
                    <cfset local.result['message'] = "Login Successful">
                    <cfset local.result['error'] = false>
                </cfif>
            </cfif>
            <cfcatch>
                <cfset local.result['error'] = true>
                <cfset local.result['message'] = "Error : #cfcatch.message#">
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
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

    <cffunction name = "logout" access = "remote" returnType = "void">
        <cfset structClear(session)>
    </cffunction>
</cfcomponent>