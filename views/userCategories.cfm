<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/home.css">    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer"/>
</head>
<body>
    <header>
        <cfinclude  template="userHeader.cfm">
    </header>
    <main>
        <cfoutput>
            <cfset getSubCategoryArray = application.productManagementObj.getSubCategory(categoryId = url.categoryId)>
            <div class="container products-container">  
                <cfif arrayLen(getSubCategoryArray.subCategory)>               
                    <cfloop array="#getSubCategoryArray.subCategory#" item="subCategoryItem">
                        <cfset getProductArray = application.productManagementObj.getProduct(subCategoryId = subCategoryItem.subCategoryId)>
                        <cfif arraylen(getProductArray.product)>
                            <div class="row g-4 mt-3">
                                <a class="h3 text-decoration-none text-dark" href="userSubCategories.cfm?subCategoryId=#urlEncodedFormat(subCategoryItem.subCategoryId)#">
                                    #subCategoryItem.subCategoryName#
                                </a>
                                <cfloop array="#getProductArray.product#" item="productItem">
                                    <cfset decryptedProductId = application.productManagementObj.decryptData(data = productItem.productId)>
                                    <a href="userProducts.cfm?productId=#urlEncodedFormat(productItem.productId)#" class="col-12 col-sm-6 col-md-4 col-lg-3 text-decoration-none text-dark">
                                        <div class="product-card pb-0">
                                            <img src="../uploads/products/product#decryptedProductId#/#productItem.imageFile#" alt="#productItem.productName#">
                                            <div class="card-body text-start">
                                                <h5 class="card-title text-truncate">#productItem.productName#</h5>
                                                <p class="card-text text-muted small mb-1">
                                                    <strong>Brand:</strong> #productItem.brandName#
                                                </p>
                                                <p class="card-text product-desc text-muted small mb-1">
                                                    <strong>Description:</strong> #productItem.description#
                                                </p>
                                                <div class="fw-bold">Rs.#productItem.unitPrice#/-</div> 
                                            </div>
                                        </div>
                                    </a>
                                </cfloop> 
                            </div>
                        </cfif>
                    </cfloop> 
                <cfelse>
                    <div class="mt-5 w-100 text-center">
                        <img src="../assets/images/designImages/cart is empty.png" alt="Empty Cart" class="w-25 h-25">
                        <h4 class="mt-3 text-muted">Oops! Your Category is Empty</h4>
                        <p class="text-muted">Looks like you haven't added anything yet. Let's find something amazing for you!</p>
                        <a href="userHome.cfm" class="btn btn-primary mt-3"><i class="fas fa-shopping-bag me-2"></i>Back To Home</a>
                    </div>
                </cfif>
            </div>
        </cfoutput>
    </main>
    <footer class="mt-5 w-100">
        
    </footer>
    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/user.js"></script>
</body>
</html>
