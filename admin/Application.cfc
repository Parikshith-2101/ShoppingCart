<cfset this.name = "ShoppingCartAdmin">
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout = createTimeSpan(0, 1, 0, 0)>
    <cfset this.applicationTimeout = createTimeSpan(1, 0, 0, 0)>
 
    <cffunction name = "onApplicationStart">
        <cfset application.productManagementObj = createObject("component", "model.adminSpecific")>
        <cfset application.userObj = createObject("component", "model.user")>     
        <cfset application.getDataControllerObj = createObject("component", "controller.getDataController")>     
        <cfset application.adminLoginObj = createObject("component", "model.adminLogin")>     
        <cfset application.key = "BUQBxvUmpT5zrGJ1tHLThA==">
        <cfset application.dataSource = "shoppingCart">
    </cffunction>   

    <cffunction name = "onRequestStart" returnType = "boolean">
        <cfargument type = "String" name = "targetPage" required = true>
        <cfif structKeyExists(url, "reload") AND url.reload EQ 1>
            <cfif structKeyExists(session, "roleId") AND session.roleId EQ 1>
                <cfset onApplicationStart()>
            </cfif>
        </cfif>
        <cfreturn true>
    </cffunction>

    <cffunction name = "onRequest" returnType = "void">
        <cfargument name = "requestPage">
        <cfset local.adminPages = ["categories.cfm","products.cfm","subCategories.cfm"]>
        
        <cfif arrayFindNoCase(local.adminPages, ListLast(CGI.SCRIPT_NAME,'/'))>
            <cfif structKeyExists(session, "roleId") AND session.roleId EQ 1>
                <cfinclude template = "#arguments.requestPage#">
            <cfelse>
                <cfinclude template = "/ShoppingCart/admin/view/adminLogin.cfm">
            </cfif>
        <cfelse>
            <cfinclude template = "/ShoppingCart/admin/view/adminLogin.cfm">
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
                <a href="/view/userHome.cfm">Click here to go to Home Page<a>
            </cfoutput>
            <cfreturn true>
            <cfcatch>
                <cfreturn false>
            </cfcatch>
        </cftry>
    </cffunction>