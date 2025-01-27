<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subcategories</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/home.css">    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
<cfoutput>
    <cfset getCategoryArray = application.productManagementObj.getCategory()>
    <cfset getProductArray = application.productManagementObj.getProduct(subCategoryId = url.subCategoryId)>
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
        <cfif structKeyExists(form, "sortBtn")>
            <cfset getProductArray = application.productManagementObj.getProduct(
                subCategoryId = url.subCategoryId,
                sortType = form.sortBtn
            )>
        </cfif>
        <cfif structKeyExists(form, "priceFilterBtn")>
             <cfset getProductArray = application.productManagementObj.getProduct(
                subCategoryId = url.subCategoryId,
                minPrice = form.minPrice,
                maxPrice = form.maxPrice,
                priceRange = (structKeyExists(form, "priceRange")? form.priceRange : "")
            )>
        </cfif>
        <form method="post">
            <div class="container products-container">
                <!---products--->
                <div class="row g-4 mt-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3 class="m-0">#url.subCategoryName#</h3>
                        <div class="d-flex">
                            <div class="d-flex">
                                <h4 class="m-0">Sort By</h4>
                                <button type="submit" class="sort-btn" name="sortBtn" value="ASC">
                                    <i class="fas fa-sort-amount-up"></i> Min
                                </button>
                                <button type="submit" class="sort-btn" name="sortBtn" value="DESC">
                                    <i class="fas fa-sort-amount-down"></i> Max
                                </button>
                            </div>
                            <div class="price-filter ms-3">
                                <div class="dropdown">
                                    <button class="btn btn-info dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        Filter
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li>
                                            <div class="d-flex px-2 pb-1">
                                                <input type="number" name="minPrice" id="minPrice" placeholder="Min" class="w-50 form-control p-0">
                                                <div class="mx-2">to</div>
                                                <input type="number" name="maxPrice" id="maxPrice" placeholder="Max" class="w-50 form-control p-0">
                                            </div> 
                                        </li> 
                                        <li class="d-flex m-2"><input type="radio" name="priceRange" value="low" class="dropdown-item priceFilter me-1">₹10000 - ₹20000</li>
                                        <li class="d-flex m-2"><input type="radio" name="priceRange" value="mid" class="dropdown-item priceFilter me-1">₹20000 - ₹30000</li>
                                        <li class="d-flex m-2"><input type="radio" name="priceRange" value="high" class="dropdown-item priceFilter me-1">₹30000+</li>
                                        <li>
                                            <div class="mx-2">
                                                <button type="submit" name="priceFilterBtn" class="form-control btn btn-success">Filter</button>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
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
            </div>
        </form>
        
    </main>
    <footer class="mt-5 w-100">
        
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" 
        integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/user.js"></script>
</cfoutput>
</body>
</html>
