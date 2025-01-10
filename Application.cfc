<cfcomponent>
    <cfset this.name = "ShoppingCartApplication">
    <cfset this.sessionManagement = true>
    <cfset this.datasource = "shoppingCart">
    <cfset application.shoppingCart = createObject("component", "components.shoppingCart")>

    <cffunction name = "onRequest" returnType = "void">
        <cfargument name = "requestPage">
        <cfif structKeyExists(session, "email") 
            OR arguments.requestPage EQ "/ShoppingCart/views/adminLogin.cfm">
            <cfinclude template = "#arguments.requestPage#">
        <cfelse> 
            <cfinclude template = "/ShoppingCart/views/adminLogin.cfm">
        </cfif>
    </cffunction>
</cfcomponent>