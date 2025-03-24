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
    <cfparam name = "url.productId" default = "">
    <cfif structKeyExists(form, "addToCartBtn")>
        <cfif structKeyExists(session, "loginUserId")>
            <cfset addToCartResult = application.cartObj.manageCart(
                productId = form.addToCartBtn,
                modifyStatus = "add"
            )>
            <cfif addToCartResult.message EQ "Added">
                <cfset session.cartLen +=1> 
            </cfif>
        <cfelse>
            <cflocation url="userLogin.cfm?productId=#urlEncodedFormat(url.productId)#">
        </cfif>
    </cfif>
    <header>
        <cfinclude template="userHeader.cfm">
    </header>

    <main>
        <cfset getSingleProductArray = application.getDataControllerObj.productController(productId = url.productId)>
        <div class="container products-container mt-5">         
            <cfif arrayLen(getSingleProductArray.product)>
                <cfloop array="#getSingleProductArray.product#" item="productItem">
                    <cfset decryptedProductId = application.productManagementObj.decryptData(data = productItem.productId)>
                    <div class="row mt-5">
                        <div class="col-md-6">
                            <ul class="breadcrumb">
                                <li><a href="userCategories.cfm?categoryId=#getSingleProductArray.product[1].categoryId#">#getSingleProductArray.product[1].categoryName#</a><i class="fa-solid fa-chevron-right mx-1"></i></li>
                                <li><a href="userSubCategories.cfm?subCategoryId=#getSingleProductArray.product[1].subCategoryId#">#getSingleProductArray.product[1].subCategoryName#</a><i class="fa-solid fa-chevron-right mx-1"></i></li>
                                <li><span class="text-muted">#getSingleProductArray.product[1].productName#</span></li>
                            </ul>
                            <div class="main-product-image mb-3">
                                <cfset defaultImage = ListGetAt(getSingleProductArray.product[1].imageFile, 1)>
                                <img src="../uploads/products/product#decryptedProductId#/#defaultImage#" id="mainImage" alt="Main Product" height="300">
                            </div>
                            <div class="product-images">
                                <cfset imagecount = 0>
                                <cfloop list="#getSingleProductArray.product[1].imageFile#" item="productImageItem">
                                    <cfset imageCount += 1>
                                    <cfif imageCount LT 6>
                                        <img src="../uploads/products/product#decryptedProductId#/#productImageItem#" alt="Product Image 1" onmouseover="updateMainImage(this)">
                                    <cfelse>
                                        <img src="../assets/images/designImages/more.jpg" alt="more">
                                        <cfbreak>
                                    </cfif>
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
                                    <cfif structKeyExists(form, "addToCartBtn")>  
                                        <a href="userCart.cfm" class="btn btn-outline-secondary">Go to Cart</a>
                                    <cfelse>
                                        <button type="submit" value="#productItem.productId#" name="addToCartBtn" class="btn btn-primary">Add to Cart</button>
                                    </cfif>                            
                                    <a href="userOrder.cfm?productId=#urlEncodedFormat(productItem.productId)#" class="btn btn-success">Buy Now</a>
                                </form>
                            </div>
                        </div>
                    </div>
                </cfloop>
            <cfelse>
                <div class="d-flex flex-column">
                    <img src="../assets/images/designImages/no_result.gif" alt="No Products Found" class="w-75">
                    <a href="userHome.cfm" class="btn btn-primary mx-auto w-25 mb-3"><i class="fas fa-shopping-bag me-2"></i>Back To Home</a>
                </div> 
            </cfif>
        </div>
    </main>
    <cfinclude template="userFooter.cfm">
    <script src="../assets/script/userProducts.js"></script>
</cfoutput>
</body>
</html>
