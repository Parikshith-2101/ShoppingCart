<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>userHome</title>
    <link rel="stylesheet" href="../../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/style/home.css">    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
    <header>
        <cfinclude template="/views/user/userHeader.cfm">
    </header>
    <main>
        <cfoutput>
            <cfset getProductArray = application.productManagementObj.getProduct(limit = 8)>
            <div class="container products-container">
                <div id="carouselExampleIndicators" class="carousel slide mt-5" data-bs-ride="carousel">
                    <ol class="carousel-indicators">
                        <li data-bs-target="##carouselExampleIndicators" data-bs-slide-to="0" class="active"></li>
                        <li data-bs-target="##carouselExampleIndicators" data-bs-slide-to="1"></li>
                        <li data-bs-target="##carouselExampleIndicators" data-bs-slide-to="2"></li>
                        <li data-bs-target="##carouselExampleIndicators" data-bs-slide-to="3"></li>
                        <li data-bs-target="##carouselExampleIndicators" data-bs-slide-to="4"></li>
                    </ol>
                    <div class="carousel-inner">
                        <div class="carousel-item active" data-bs-interval="2000">
                            <img class="d-block w-100 carousel-image" src="../../assets/images/designImages/banner1.jpg" alt="First slide">
                        </div>
                        <div class="carousel-item" data-bs-interval="2000">
                            <img class="d-block w-100 carousel-image" src="../../assets/images/designImages/banner3.webp" alt="Second slide">
                        </div>
                        <div class="carousel-item" data-bs-interval="2000">
                            <img class="d-block w-100 carousel-image" src="../../assets/images/designImages/banner2.jpg" alt="Third slide">
                        </div>
                        <div class="carousel-item" data-bs-interval="2000">
                            <img class="d-block w-100 carousel-image" src="../../assets/images/designImages/banner4.webp" alt="fourth slide">
                        </div>
                        <div class="carousel-item" data-bs-interval="2000">
                            <img class="d-block w-100 carousel-image" src="../../assets/images/designImages/banner5.jpg" alt="fifth slide">
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
                <div class="row g-4 my-4">
                    <h3>Random Products</h3>
                    <cfloop array="#getProductArray.product#" item="productItem">
                        <cfset decryptedProductId = application.productManagementObj.decryptData(data = productItem.productId)>
                        <a href="/views/user/userProducts.cfm?productId=#urlEncodedFormat(productItem.productId)#" class="col-12 col-sm-6 col-md-4 col-lg-3 text-decoration-none text-dark">
                            <div class="product-card pb-0 shadow-sm">      
                                <img src="../../uploads/products/product#decryptedProductId#/#productItem.imageFile#" alt="Electronics">                         
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
            </div>
        </cfoutput>
    </main>
    <cfinclude template="/views/user/userFooter.cfm">
</body>
</html>
