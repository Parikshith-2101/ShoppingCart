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
    <cfif structKeyExists(form, "addToCartBtn")>
        <cfif structKeyExists(session, "loginUserId")>
            <cfset addToCartResult = application.productManagementObj.addCart(
                productId = form.addToCartBtn
            )>
        <cfelse>
            <cflocation url="userLogin.cfm?productId=#url.productId#">
        </cfif>
    </cfif>
    <header>
        <cfinclude template="userHeader.cfm">
    </header>

    <main>
        <cfset getSingleProductArray = application.productManagementObj.getSingleProduct(productId = url.productId)>
        <div class="container products-container mt-5">          
            <cfloop array="#getSingleProductArray.product#" item="productItem">
                <cfset decryptedProductId = application.productManagementObj.decryptDetails(data = productItem.productId)>
                <div class="row mt-5">
                    <div class="col-md-6">
                        <div class="main-product-image mb-3">
                            <cfset defaultImage = ListGetAt(getSingleProductArray.product[1].imageFile, 1)>
                            <img src="../uploads/product#decryptedProductId#/#defaultImage#" id="mainImage" alt="Main Product" height="300">
                        </div>
                        <div class="product-images">
                            <cfloop list="#getSingleProductArray.product[1].imageFile#" item="productImageItem">
                                <img src="../uploads/product#decryptedProductId#/#productImageItem#" alt="Product Image 1" onmouseover="updateMainImage(this)">
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
                                <cfif structKeyExists(session, "loginUserId")>
                                    <cfset getCartData = application.productManagementObj.getCart(productId = productItem.productId)>
                                    <cfif arrayLen(getCartData.cart)> 
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
