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
    <cfset getProductsData = application.productManagementObj.getProduct(limit = 8)>
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
            <div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel">
                <ol class="carousel-indicators">
                    <li data-bs-target="##carouselExampleIndicators" data-bs-slide-to="0" class="active"></li>
                    <li data-bs-target="##carouselExampleIndicators" data-bs-slide-to="1"></li>
                    <li data-bs-target="##carouselExampleIndicators" data-bs-slide-to="2"></li>
                </ol>
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img class="d-block w-100 carousel-image" src="../assets/images/designImages/banner1.jpg" alt="First slide">
                    </div>
                    <div class="carousel-item">
                        <img class="d-block w-100 carousel-image" src="../assets/images/designImages/banner2.jpg" alt="Second slide">
                    </div>
                    <div class="carousel-item">
                        <img class="d-block w-100 carousel-image" src="../assets/images/designImages/banner3.webp" alt="Third slide">
                    </div>
                </div>
                <a class="carousel-control-prev" href="##carouselExampleIndicators" role="button" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </a>
                <a class="carousel-control-next" href="##carouselExampleIndicators" role="button" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </a>
            </div>
            <!---products--->
            <div class="row g-4 mt-4">
                <h3>Random Products</h3>
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
    <script src="../assets/script/user.js"></script>
</cfoutput>
</body>
</html>
