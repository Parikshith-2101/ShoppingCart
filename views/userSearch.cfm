<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>userHome</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/home.css">    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
<cfoutput>
    <cfset getCategories = application.productManagementObj.getCategory()>
    <cfif structKeyExists(form, "searchForProducts") AND len(trim(form.searchForProducts))>
        <cfset getProductsData = application.productManagementObj.getProduct(searchForProducts = form.searchForProducts)>
    <cfelse>
        <cflocation  url="userHome.cfm" addToken="No">
    </cfif>
    <header>
        <nav class="navbar navbar-expand-lg fixed-top">
            <div class="container-fluid">
                <a href="userHome.cfm" class="navbar-brand d-flex align-items-center">
                    <img src="../assets/images/designImages/cartIcon.png" alt="cartIcon" width="40" class="me-2">
                    <span class="fs-4 nav-brand">ShoppingCart</span>
                </a> 
                <form method="get" class="d-flex m-0" action="userSearch.cfm">                    
                    <input class="form-control me-2" name="searchForProducts" type="search" placeholder="Search for products..." aria-label="Search">
                    <button class="btn btn-primary" name="searchProductsBtn" type="submit">Search</button>
                </form>                        
                <ul class="navbar-nav">
                    <li class="nav-item me-3">
                        <a class="nav-link" href="cart.cfm">
                            <i class="fa-solid fa-cart-shopping position-relative">
                                <span 
                                    class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    3 
                                </span>
                            </i>
                            <span>Cart</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="##">
                            <cfif structKeyExists(session, "email")>    
                                <i class="fa-solid fa-sign-out-alt"></i>
                                <span>Logout</span>
                            <cfelse>
                                <i class="fa-solid fa-user-plus"></i>
                                <span>Login</span>
                            </cfif>
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
        <nav class="navbar-expand-lg categories-navbar fixed-top">
            <div class="container-fluid">
                <div class="collapse navbar-collapse" id="categoriesNavbar">
                    <ul class="navbar-nav justify-content-evenly w-100">
                        <cfloop index="i" from="1" to="#arrayLen(getCategories.categoryId)#">
                            <li class="nav-item dropdown">
                                <a class="nav-link" href="userCategories.cfm?categoryId=#getCategories.categoryId[i]#" id="#getCategories.categoryId[i]#" role="button">
                                    #getCategories.categoryName[i]#
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="#getCategories.categoryId[i]#">
                                    <cfset getSubCategories = application.productManagementObj.getSubCategory(categoryId = getCategories.categoryId[i])>
                                    <cfloop index="i" from="1" to="#arrayLen(getSubCategories.subCategoryId)#">
                                        <li>
                                            <a class="dropdown-item" href="userSubCategories.cfm?subCategoryId=#getSubCategories.subCategoryId[i]#&subCategoryName=#getSubCategories.subCategoryName[i]#">
                                                #getSubCategories.subCategoryName[i]#
                                            </a>
                                        </li>
                                    </cfloop>
                                </ul>
                            </li>
                        </cfloop>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <main>
        <div class="container products-container">
            <!---products--->
            <div class="row g-4 mt-4">
                <h3>Showing Results for '#form.searchForProducts#'</h3>
                <cfloop index="i" from="1" to="#arrayLen(getProductsData.productId)#">
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <div class="product-card pb-0">
                            <a href="userProducts.cfm?productId=#getProductsData.productId[i]#">
                                <img src="../assets/images/product#getProductsData.productId[i]#/#getProductsData.imageFile[i]#" alt="Electronics">
                            </a>
                            <div class="card-body text-start">
                                <h5 class="card-title text-truncate">#getProductsData.productName[i]#</h5>
                                <p class="card-text text-muted small mb-1">
                                    <strong>Brand:</strong> #getProductsData.brandName[i]#
                                </p>
                                <p class="card-text product-desc text-muted small mb-1">
                                    <strong>Description:</strong> #getProductsData.description[i]#
                                </p>
                                <p class="card-text text-muted small mb-1">
                                    <strong>Price:</strong> Rs.#getProductsData.unitPrice[i]#/-
                                </p>
                            </div>
                        </div>
                    </div>
                </cfloop> 
            </div>
        </div>
    </main>
    <footer class="mt-5 w-100">
        
    </footer>
    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
</cfoutput>
</body>
</html>
