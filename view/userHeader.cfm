<cfoutput>
    <cfset getCategoryArray = application.productManagementObj.getCategory()>
    <cfset getSubCategoryArray = application.productManagementObj.getSubCategory()>
    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container-fluid">
            <a href="/view/userHome.cfm" class="navbar-brand d-flex align-items-center">
                <img src="../assets/images/designImages/cartIcon.png" alt="cartIcon" width="40" class="me-2">
                <span class="fs-4 nav-brand">ShoppingCart</span>
            </a> 
            <form method="post" class="d-flex m-0" action="/view/userSearch.cfm">                    
                <input class="form-control me-2" name="searchKey" type="search" placeholder="Search for products..." aria-label="Search">
                <button class="btn btn-primary" name="searchProductsBtn" type="submit">Search</button>
            </form>
            <ul class="navbar-nav">
                <li class="nav-item me-3">
                    <a class="nav-link" href="/view/userCart.cfm">
                        <i class="fa-solid fa-cart-shopping position-relative">
                            <cfif structKeyExists(session, "loginUserId")>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-quantity">
                                    #session.cartLen#
                                </span>
                            </cfif>
                        </i>
                        <span>Cart</span>
                    </a>
                </li>
                <li class="nav-item">
                    <cfif structKeyExists(session, "email")>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="##" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fa-solid fa-user"></i>
                                <span>#session.firstName#</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li>
                                    <a class="dropdown-item d-flex align-items-center text-primary" href="/view/userProfile.cfm">
                                        <i class="fa-solid fa-user-circle me-2"></i>
                                        <span>Profile</span>
                                    </a>
                                </li>
                                <cfif session.roleId EQ 1>
                                    <li>
                                        <a class="dropdown-item d-flex align-items-center text-info" href="/admin/view/categories.cfm">
                                            <i class="fa-solid fa-user-cog me-2"></i>
                                            <span>Admin</span>
                                        </a>
                                    </li>
                                </cfif>
                                <li>
                                    <a class="dropdown-item d-flex align-items-center text-danger" href="##" id="logoutBtn">
                                        <i class="fa-solid fa-sign-out-alt me-2"></i> Logout
                                    </a>
                                </li>
                            </ul>
                        </li>
                    <cfelse>
                        <a class="nav-link" href="/view/userLogin.cfm">
                            <i class="fa-solid fa-user-plus"></i> Login
                        </a>
                    </cfif>
                </li>
            </ul>
        </div>
    </nav>
    <nav class="navbar-expand-sm categories-navbar fixed">
        <div id="categoriesNavbar">
            <ul class="navbar-nav justify-content-evenly w-100">
                <cfloop array="#getCategoryArray.category#" item="categoryItem">
                    <cfset divId = createUUID()>
                    <li class="nav-item dropdown">
                        <a class="nav-link" href="/view/userCategories.cfm?categoryId=#urlEncodedFormat(categoryItem.categoryId)#" id="#divId#" role="button">
                            #categoryItem.categoryName# 
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="#divId#">
                            <cfloop array="#getSubCategoryArray.subCategory#" item="subCategoryItem">
                                <cfif subCategoryItem.categoryId EQ categoryItem.categoryId>
                                    <li>
                                        <a class="dropdown-item" href="/view/userSubCategories.cfm?subCategoryId=#urlEncodedFormat(subCategoryItem.subCategoryId)#">
                                            #subCategoryItem.subCategoryName#
                                        </a>
                                    </li>
                                </cfif>
                            </cfloop>
                        </ul>
                    </li>
                </cfloop>
            </ul>
        </div>
    </nav>
</cfoutput>