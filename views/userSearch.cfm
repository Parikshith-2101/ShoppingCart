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
    <cfif structKeyExists(form, "searchKey") AND len(trim(form.searchKey))>
        <cfset getProductArray = application.productManagementObj.getProduct(
            searchKey = form.searchKey,
            limit = 4,
            sortType = 'ASC'
        )>
    <cfelse>
        <cflocation  url="userHome.cfm" addToken="No">
    </cfif>
    <header>
        <cfinclude template="userHeader.cfm">
    </header>

    <main>
        <div class="container products-container">
            <h3 class="mt-5">Showing Results for '#form.searchKey#'</h3>
            <cfif arrayLen(getProductArray.product)>
                <div class="row g-4 my-4" id="product-container">
                    <cfloop array="#getProductArray.product#" item="productItem">
                        <a href="userProducts.cfm?productId=#urlEncodedFormat(productItem.productId)#" class="col-12 col-sm-6 col-md-4 col-lg-3 text-decoration-none text-dark">
                            <div class="product-card pb-0 shadow-sm">
                                <cfset decryptedProductId = application.productManagementObj.decryptData(data = productItem.productId)>
                                <img src="../uploads/products/product#decryptedProductId#/#productItem.imageFile#" alt="Electronics">
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
                <cfif arraylen(getProductArray.product) EQ 4>
                    <button id="viewMoreBtn" class="btn btn-outline-primary w-25 ms-auto d-block" type="button" onclick="viewMoreProducts('','ASC','','','#form.searchKey#')">View More</button>
                </cfif>
            <cfelse>
                <div class="w-100 text-center">
                    <img src="../assets/images/designImages/cart is empty.png" alt="Empty Cart" class="w-25">
                    <h4 class="mt-3 text-muted">Oops! No Products Found on '#form.searchKey#'</h4>
                    <p class="text-muted">Sorry for your inconvenience. Let's find something amazing for you!</p>
                    <a href="userHome.cfm" class="btn btn-primary mt-3"><i class="fas fa-shopping-bag me-2"></i>Back To Home</a>
                </div>
            </cfif>
        </div>
    </main>
    <cfinclude template="/views/userFooter.cfm">
</cfoutput>
</body>
</html>
