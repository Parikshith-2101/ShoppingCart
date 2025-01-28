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
            <cfset decryptedCategoryId = application.productManagementObj.decryptDetails(data = url.categoryId)>
            <cfset getSubCategoryArray = application.productManagementObj.getSubCategory(categoryId = decryptedCategoryId)>
            <div class="container products-container">
                <cfloop array="#getSubCategoryArray#" item="subCategoryItem">
                    <cfset getProductArray = application.productManagementObj.getProduct(subCategoryId = subCategoryItem.subCategoryId)>
                    <cfif arraylen(getProductArray)>
                        <div class="row g-4 mt-3">
                            <h3>#subCategoryItem.subCategoryName#</h3>
                            <cfloop array="#getProductArray#" item="productItem">
                                <cfset encryptedProductId = application.productManagementObj.encryptDetails(data = productItem.productId)>
                                <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                                    <div class="product-card pb-0">
                                        <a href="userProducts.cfm?productId=#urlEncodedFormat(encryptedProductId)#">
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
