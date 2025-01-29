<cfcomponent>
    <cfset this.name = "ShoppingCartApplication">
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout = createTimeSpan(0, 0, 30, 0)>
    <cfset this.applicationTimeout = createTimeSpan(1, 0, 0, 0)>
 
    <cffunction name = "onApplicationStart">
        <cfset application.productManagementObj = createObject("component", "components.productManagement")>
        <cfset application.userObj = createObject("component", "components.user")>     
        <cfset application.key = "BUQBxvUmpT5zrGJ1tHLThA==">
        <cfset application.dataSource = "shoppingCart">
    </cffunction>   

    <cffunction name = "onRequestStart" returnType = "boolean">
        <cfargument type = "String" name = "targetPage" required = true>
         <cfif structKeyExists(url, "reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif>
        <cfreturn true>
    </cffunction>

    <cffunction name = "onRequest" returnType = "void">
        <cfargument name = "requestPage">
        <cfset local.allowedPages = ["userLogin.cfm","userSignup.cfm","userHome.cfm","userCategories.cfm","userSubCategories.cfm","userProducts.cfm","userSearch.cfm"]>
        <cfif structKeyExists(session, "email") OR arrayFindNoCase(local.allowedPages, ListLast(CGI.SCRIPT_NAME,'/'))>        
            <cfinclude template = "#arguments.requestPage#">
        <cfelse> 
            <cfinclude template = "/ShoppingCart1/views/userLogin.cfm">
        </cfif>
    </cffunction>
    
    <cffunction name = "onError">
        <cfargument name = "Exception" required = true>
        <cfargument type = "String" name = "EventName" required = true>
        <cflog file = "#This.Name#" type = "error" text = "Event Name: #arguments.Eventname#">
        <cflog file = "#This.Name#" type = "error" text = "Message: #arguments.Exception.message#">
        <cfif NOT (arguments.EventName IS "onSessionEnd") OR (arguments.EventName IS "onApplicationEnd")>
        <cfoutput>
            <h2>An unexpected error occurred.</h2>
            <p>Please provide the following information to technical support:</p>
            <p>Error Event: #arguments.EventName#</p>
            <p>Error details:<br>
            <cfdump var = #arguments.Exception#></p>
            </cfoutput>
        </cfif>
    </cffunction>

    <cffunction name = "onMissingTemplate">
        <cfargument name = "targetPage" type = "string" required = true>
        <cftry>
            <cflog type = "error" text = "Missing template: #arguments.targetPage#">
            <cfoutput>
                <h3>#arguments.targetPage# could not be found.</h3>
                <p>You requested a non-existent ColdFusion page.<br>
                Please check the URL.</p>
            </cfoutput>
            <cfreturn true>
            <cfcatch>
                <cfreturn false>
            </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>