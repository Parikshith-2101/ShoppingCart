<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/home.css">
    <link rel="stylesheet" href="../assets/style/Cart.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />

</head>

<body>
    <cfoutput>
        <cfset getCategoryArray=application.productManagementObj.getCategory()>
        <cfset getCartArray=application.productManagementObj.getCart()>
        <header>
            <nav class="navbar navbar-expand-lg fixed-top">
                <div class="container-fluid">
                    <a href="userHome.cfm" class="navbar-brand d-flex align-items-center">
                        <img src="../assets/images/designImages/cartIcon.png" alt="cartIcon" width="40"
                            class="me-2">
                        <span class="fs-4 nav-brand">ShoppingCart</span>
                    </a>
                    <form method="post" class="d-flex m-0" action="userSearch.cfm">
                        <input class="form-control me-2" name="searchForProducts" type="search"
                            placeholder="Search for products..." aria-label="Search">
                        <button class="btn btn-primary" name="searchProductsBtn" type="submit">Search</button>
                    </form>

                    <ul class="navbar-nav">
                        <li class="nav-item me-3">
                            <a class="nav-link" href="userCart.cfm">
                                <i class="fa-solid fa-cart-shopping position-relative">
                                    <span
                                        class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                        <cfif structKeyExists(session, "cartQuantity")>
                                            <div class="cart-quantity">#session.cartQuantity#</div>
                                        <cfelse>
                                            0
                                        </cfif>
                                    </span>
                                </i>
                                <span>Cart</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <cfif structKeyExists(session, "email" )>
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
                                    <a class="nav-link"
                                        href="userCategories.cfm?categoryId=#categoryItem.categoryId#"
                                        id="#categoryItem.categoryId#" role="button">
                                        #categoryItem.categoryName#
                                    </a>
                                    <ul class="dropdown-menu" aria-labelledby="#categoryItem.categoryId#">
                                        <cfset
                                            getSubCategoryArray=application.productManagementObj.getSubCategory(categoryId=categoryItem.categoryId)>
                                        <cfloop array="#getSubCategoryArray#" item="subCategoryItem">
                                            <li>
                                                <a class="dropdown-item"
                                                    href="userSubCategories.cfm?subCategoryId=#subCategoryItem.subCategoryId#&subCategoryName=#subCategoryItem.subCategoryName#">
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
            <div class="main-container d-flex">
                <div class="container-left">
                    <div class="card-head d-flex">
                        <div class="headDiv d-flex">
                            <p>From Saved Addresses</p>
                            <button>Enter Delivery Pincode</button>
                        </div>
                    </div>
                    <cfset local.totalAmount = 0>
                    <cfset local.totalPrice = 0>
                    <cfset local.totalTax = 0>
                    <cfloop array="#getCartArray#" item="cartItem">
                        <div class="card-product" id="#cartItem.cartId#">
                            <div class="product d-flex">
                                <div class="product-image d-flex">
                                    <img src="../assets/images/product#cartItem.productId#/#cartItem.imageFile#" class="w-100 object-fit-contain" alt="product" height="112">
                                </div>
                                <div class="product-details d-flex flex-column">
                                    <p class="product-name">#cartItem.productName#</p>
                                    <div class="price-tag fs-7 d-flex align-items-center">
                                        Actual Price :  
                                        <i class="fa-solid fa-indian-rupee-sign mx-1"></i>
                                        #cartItem.unitPrice#
                                        <span class="green mx-auto">Tax : <i class="fa-solid fa-indian-rupee-sign me-1"></i>#cartItem.unitTax#</span>
                                    </div>
                                    <div class="price-tag fs-5 mt-auto fw-bold">
                                        <i class="fa-solid fa-indian-rupee-sign"></i>
                                        #cartItem.unitPrice + cartItem.unitTax#
                                    </div>
                                </div>
                                <div class="product-delivery">
                                    <p>Delivery by Tue Oct 8 |
                                </div>
                            </div>                    
                            <div class="quantity d-flex">
                                <div class="btnDiv d-flex">
                                    <div class="rounded"><button id="removeBtn#cartItem.productId#" onclick="modifyQuantity(#cartItem.productId#,'remove')">-</button></div>
                                    <div class="rectangle"><input type="text" id="quantity#cartItem.productId#" value="#cartItem.quantity#" align="center"></div>
                                    <div class="rounded"><button onclick="modifyQuantity(#cartItem.productId#,'add')">+</button></div>
                                </div>
                                <a href="" class="tit">SAVE FOR LATER</a>
                                <a href="##" class="tit" onclick="deleteCartItem(#cartItem.cartId#)">REMOVE</a>
                            </div>
                        </div>
                        <cfset local.totalPrice += (cartItem.unitPrice * cartItem.quantity)>
                        <cfset local.totalTax += (cartItem.unitTax * cartItem.quantity)>
                        <cfset local.totalAmount += (cartItem.unitPrice + cartItem.unitTax) * cartItem.quantity>
                    </cfloop>

                    <div class="card-order">
                        <div class="button"><button>PLACE ORDER</button></div>
                    </div>
                </div>
                <div class="container-right">
                    <div class="card-right">
                        <p class="title">PRICE DETAILS</p>
                        <div class="checkoutDiv">
                            <div class="checkout">
                                <p class="price">Price </p>
                                <p class="number">
                                    <i class="fa-solid fa-indian-rupee-sign"></i> 
                                    <span class="totalPriceDiv">#local.totalPrice#</span>
                                </p>
                            </div>
                            <div class="checkout">
                                <p class="price">Total Tax</p>
                                <p class="number">
                                    <span class="green">
                                        <i class="fa-solid fa-indian-rupee-sign"></i>
                                        <span class="totalTaxDiv">#local.totalTax#</span>
                                    </span>
                                </p>
                            </div>
                            <div class="final d-flex">
                                <p class="bold">Total Amount</p>
                                <p class="number">
                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                    <span class="totalAmountDiv">#local.totalAmount#</span>
                                </p>
                            </div>
                        </div>
                        <div class="bottom-text d-flex">
                            <img src="../assets/images/designImages/shield.svg" alt="shield" width="31" height="38">
                            <p>Safe and Secure Payments.Easy returns.100% Authentic products.</p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </cfoutput>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/user.js"></script>
    <script src="../assets/script/userProducts.js"></script>
</body>

</html>