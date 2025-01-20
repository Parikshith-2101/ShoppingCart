<cfcomponent>
    <cfset this.name = "ShoppingCartApplication">
    <cfset this.sessionManagement = true>
    <cfset this.datasource = "shoppingCart">

    <cffunction name = "onApplicationStart">
        <cfset application.userLoginObj = createObject("component", "components.userLogin")>
        <cfset application.productManagementObj = createObject("component", "components.productManagement")>
        <cfset application.userObj = createObject("component", "components.user")>
    </cffunction>   

    <cffunction name = "onRequest" returnType = "void">
        <cfargument name = "requestPage">
        <cfif structKeyExists(session, "email") 
            OR arguments.requestPage EQ "/ShoppingCart/views/adminLogin.cfm"
            OR arguments.requestPage EQ "/ShoppingCart/views/userLogin.cfm"
            OR arguments.requestPage EQ "/ShoppingCart/views/userSignup.cfm"
            OR arguments.requestPage EQ "/ShoppingCart/views/userHome.cfm"
            OR arguments.requestPage EQ "/ShoppingCart/views/userHomePage.cfm"
            OR arguments.requestPage EQ "/ShoppingCart/views/userSubCategories.cfm"
            OR arguments.requestPage EQ "/ShoppingCart/views/userCategories.cfm"
            OR arguments.requestPage EQ "/ShoppingCart/views/userProducts.cfm">
            <cfinclude template = "#arguments.requestPage#">
        <cfelse> 
            <cfinclude template = "/ShoppingCart/views/userLogin.cfm">
        </cfif>
        <cfif structKeyExists(url, "reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif>
    </cffunction>
</cfcomponent>