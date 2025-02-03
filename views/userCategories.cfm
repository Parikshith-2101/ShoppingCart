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
                <cfloop array="#getSubCategoryArray.subCategory#" item="subCategoryItem">
                    <cfset getProductArray = application.productManagementObj.getProduct(subCategoryId = subCategoryItem.subCategoryId)>
                    <cfif arraylen(getProductArray.product)>
                        <div class="row g-4 mt-3">
                            <h3>#subCategoryItem.subCategoryName#</h3>
                            <cfloop array="#getProductArray.product#" item="productItem">
                                <cfset decryptedProductId = application.productManagementObj.decryptDetails(data = productItem.productId)>
                                <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                                    <div class="product-card pb-0">
                                        <a href="userProducts.cfm?productId=#urlEncodedFormat(productItem.productId)#">
                                            <img src="../uploads/product#decryptedProductId#/#productItem.imageFile#" alt="#productItem.productName#">
                                        </a>
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
                                </div>
                            </cfloop> 
                        </div>
                    </cfif>
                </cfloop>
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
