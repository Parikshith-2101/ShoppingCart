<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/home.css">    
    <link rel="stylesheet" href="../assets/style/userProduct.css">    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
<cfoutput>
    <cfset getCategoryArray = application.productManagementObj.getCategory()>
    <cfset getProductArray = application.productManagementObj.getProduct(productId = url.productId)>
    <cfset getProductImageArray = application.productManagementObj.getProductImage(productId = url.productId)>
    <cfif structKeyExists(form, "addToCartBtn")>
        <cfif structKeyExists(session, "userId")>
            <cfset addToCartResult = application.productManagementObj.addCart(
                productId = form.addToCartBtn
            )>
        <cfelse>
            <cflocation url="userLogin.cfm?productId=#url.productId#">
        </cfif>
    </cfif>
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
                        <cfif structKeyExists(session, "email")>    
                            <a class="nav-link" href="##" id="logoutBtn">                                
                                <i class="fa-solid fa-sign-out-alt"></i>
                                <span>Logout</span>
                            </a>
                        <cfelse>
                            <a class="nav-link" href="##">
                                <i class="fa-solid fa-user-plus"></i>
                                <span>Login</span>
                            </a>
                        </cfif>
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
                                    <cfset getSubCategoryArray = application.productManagementObj.getSubCategory(categoryId = categoryItem.categoryId)>
                                    <cfloop array="#getSubCategoryArray#" item="subCategoryItem">
                                        <li>
                                            <a class="dropdown-item" href="userSubCategories.cfm?subCategoryId=#subCategoryItem.subCategoryId#&subCategoryName=#subCategoryItem.subCategoryName#">
                                                #subCategoryItem.subCategoryName#
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
        <div class="container products-container mt-5">
            <cfloop array="#getProductArray#" item="productItem">
                <div class="row mt-5">
                    <div class="col-md-6">
                        <div class="main-product-image mb-3">
                            <img src="../assets/images/product#productItem.productId#/#productItem.imageFile#" id="mainImage" alt="Main Product" height="300">
                        </div>
                        <div class="product-images">
                            <cfloop array="#getProductImageArray#" item="productImageItem">
                                <img src="../assets/images/product#productImageItem.productId#/#productImageItem.imageFile#" alt="Product Image 1" onmouseover="updateMainImage(this)">
                            </cfloop>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="product-details">
                            <div class="product-title">#productItem.productName#</div>
                            <div class="product-price">Rs. #productItem.unitPrice#</div>
                            <div class="product-description">
                                <p>#productItem.description#</p>
                            </div>
                            <form method="post" class="action-buttons">
                                <cfif structKeyExists(session, "userId")>
                                <cfset getCartData = application.productManagementObj.getCart(productId = productItem.productId)>
                                    <cfif arrayLen(getCartData)> 
                                        <a href="userCart.cfm" class="btn btn-outline-secondary">Go to Cart</a>
                                    <cfelse>
                                        <button type="submit" value="#productItem.productId#" name="addToCartBtn" class="btn btn-primary">Add to Cart</button>
                                    </cfif>
                                <cfelse>
                                    <button type="submit" value="#productItem.productId#" name="addToCartBtn" class="btn btn-primary">Add to Cart</button>
                                </cfif>
                                <button class="btn btn-success">Buy Now</button>
                            </form>
                        </div>
                    </div>
                </div>
            </cfloop>
        </div>
    </main>
    <footer class="mt-5 w-100">
        
    </footer>
    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/userProducts.js"></script>
    <script src="../assets/script/user.js"></script>
</cfoutput>
</body>
</html>
