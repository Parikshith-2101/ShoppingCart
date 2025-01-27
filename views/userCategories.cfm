<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/home.css">    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
<cfoutput>
    
    <cfset getCategoryArray = application.productManagementObj.getCategory()>
    <cfset getSubCategoryArray = application.productManagementObj.getSubCategory(categoryId = url.categoryId)>
    <header>
        <nav class="navbar navbar-expand-lg fixed-top">
            <div class="container-fluid">
                <a href="userHome.cfm" class="navbar-brand d-flex align-items-center">
                    <img src="../assets/images/designImages/cartIcon.png" alt="cartIcon" width="40" class="me-2">
                    <span class="fs-4 nav-brand">ShoppingCart</span>
                </a> 
                <form method="post" class="d-flex m-0" action="userSearch.cfm">                    
                    <input class="form-control me-2" name="searchForProducts" type="search" placeholder="Search for products..." aria-label="Search">
                    <button class="btn btn-primary" name="searchProductsBtn" type="submit">Search</button>
                </form> 
                <ul class="navbar-nav">
                    <li class="nav-item me-3">
                        <a class="nav-link" href="userCart.cfm">
                            <i class="fa-solid fa-cart-shopping position-relative">
                                <cfif structKeyExists(session, "cartQuantity")>
                                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                        #session.cartQuantity#
                                    </span>
                                </cfif>
                            </i>
                            <span>Cart</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="##">
                            <i class="fa-solid fa-right-to-bracket"></i>
                            <span>Login</span>
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
        <nav class="navbar-expand-lg categories-navbar fixed-top">
            <div class="container-fluid">
                <div class="collapse navbar-collapse" id="categoriesNavbar">
                    <ul class="navbar-nav justify-content-evenly w-100">
                        <cfloop array="#getCategoryArray#" item="categoryItem">
                            <li class="nav-item dropdown">
                                <a class="nav-link" href="userCategories.cfm?categoryId=#categoryItem.categoryId#" id="#categoryItem.categoryId#" role="button">
                                    #categoryItem.categoryName#
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="#categoryItem.categoryId#">
                                    <cfset getSubCategories = application.productManagementObj.getSubCategory(categoryId = categoryItem.categoryId)>
                                    <cfloop array="#getSubCategories#" item="subCatItem">
                                        <li>
                                            <a class="dropdown-item" href="userSubCategories.cfm?subCategoryId=#subCatItem.subCategoryId#&subCategoryName=#subCatItem.subCategoryName#">
                                                #subCatItem.subCategoryName#
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
            <cfloop array="#getSubCategoryArray#" item="subCategoryItem">
                <cfset getProductArray = application.productManagementObj.getProduct(subCategoryId = subCategoryItem.subCategoryId)>
                <cfif arraylen(getProductArray)>
                    <div class="row g-4 mt-3">
                        <h3>#subCategoryItem.subCategoryName#</h3>
                        <cfloop array="#getProductArray#" item="productItem">
                            <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                                <div class="product-card pb-0">
                                    <a href="userProducts.cfm?productId=#productItem.productId#">
                                        <img src="../assets/images/product#productItem.productId#/#productItem.imageFile#" alt="Electronics">
                                    </a>
                                    <div class="card-body text-start">
                                        <h5 class="card-title text-truncate">#productItem.productName#</h5>
                                        <p class="card-text text-muted small mb-1">
                                            <strong>Brand:</strong> #productItem.brandName#
                                        </p>
                                        <p class="card-text product-desc text-muted small mb-1">
                                            <strong>Description:</strong> #productItem.description#
                                        </p>
                                        <p class="card-text text-muted small mb-1">
                                            <strong>Price:</strong> Rs.#productItem.unitPrice#/-
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </cfloop> 
                    </div>
                </cfif>
            </cfloop>
        </div>
    </main>
    <footer class="mt-5 w-100">
        
    </footer>
    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
</cfoutput>
</body>
</html>
