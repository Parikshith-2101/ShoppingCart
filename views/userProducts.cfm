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
    <cfset getCategories = application.productManagementObj.getCategory()>
    <cfset getProductsData = application.productManagementObj.getProduct(productId = url.productId)>
    <cfset getProductImagesData = application.productManagementObj.getProductImage(productId = url.productId)>
    <cfif structKeyExists(form, "addToCartBtn")>
        <cfif structKeyExists(session, "userId")>
            <cfset addToCartResult = application.productManagementObj.addCart(
                productId = form.addToCartBtn
            )>
        <cfelse>
            <cflocation url="userLogin.cfm">
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
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    <cfif structKeyExists(session, "cartQuantity")>
                                        #session.cartQuantity#
                                    <cfelse>
                                        0
                                    </cfif> 
                                </span>
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
        <div class="container products-container mt-5">
            <cfloop index="i" from="1" to="#arrayLen(getProductsData.productId)#">
                <div class="row mt-5">
                    <div class="col-md-6">
                        <div class="main-product-image mb-3">
                            <img src="../assets/images/product#getProductsData.productId[i]#/#getProductsData.imageFile[i]#" id="mainImage" alt="Main Product" height="300">
                        </div>
                        <div class="product-images">
                            <cfloop index="j" from="1" to="#arrayLen(getProductImagesData.productImageId)#">
                                <img src="../assets/images/product#getProductImagesData.productId[j]#/#getProductImagesData.imageFile[j]#" alt="Product Image 1" onmouseover="updateMainImage(this)">
                            </cfloop>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="product-details">
                            <div class="product-title">#getProductsData.productName[i]#</div>
                            <div class="product-price">Rs. #getProductsData.unitPrice[i]#</div>
                            <div class="product-description">
                                <p>#getProductsData.description[i]#</p>
                            </div>
                            <form method="post" class="action-buttons">
                                <button type="submit" value="#getProductsData.productId[i]#" name="addToCartBtn" class="btn btn-primary">Add to Cart</button>
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
