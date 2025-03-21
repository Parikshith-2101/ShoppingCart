<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subcategories</title>
    <link rel="stylesheet" href="../../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/style/home.css">    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
<cfoutput>
    <header>
        <cfinclude template="userHeader.cfm">
    </header>
    <main>
        <cfparam name = "url.subCategory" default = ""> 
        <cfset sortType = "">
        <cfset minPrice = "">
        <cfset maxPrice = "">
        <cfset params = {
            subCategoryId = url.subCategoryId,
            limit = 4
        }> 
        <cfif structKeyExists(url, "sortBtn")>
            <cfset params["sortType"] = url.sortBtn>
            <cfset sortType = url.sortBtn>
        </cfif>
        <cfset params["minPrice"] = (url.minPrice EQ "custom") ? url.minPriceCustom : url.minPrice>
        <cfset params["maxPrice"] = (url.maxPrice EQ "custom") ? url.maxPriceCustom : url.maxPrice>
        <cfset getProductArray = application.productManagementObj.getProduct(argumentCollection=params)>
        <form method="get">
            <input type="hidden" value="#url.subCategoryId#" name="subCategoryId">
            <div class="container products-container">
                <div class="row g-4 mt-3">
                    <cfif arraylen(getProductArray.product)>
                        <div class="d-flex justify-content-between align-items-center">
                            <h3 class="m-0">#getProductArray.product[1].subCategoryName#</h3>
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
                                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                            <li>
                                                <div class="d-flex px-2 pb-1">
                                                    <div>
                                                        <select name="minPrice" id="minPrice" class="form-control p-1" onchange="toggleCustomInput(this, 'minPriceCustom')">
                                                            <option value="0">Min</option>
                                                            <option value="10000">10,000</option>
                                                            <option value="20000">20,000</option>
                                                            <option value="30000">30,000</option>
                                                            <option value="custom">Custom</option>
                                                        </select>
                                                        <input type="number" name="minPriceCustom" id="minPriceCustom" class="form-control my-2 p-1 d-none" placeholder="Min">
                                                    </div>
                                                    <div class="mx-2 text-muted">to</div>
                                                    <div>
                                                        <select name="maxPrice" id="maxPrice" class="form-control p-1" onchange="toggleCustomInput(this, 'maxPriceCustom')">
                                                            <option value="1000000">Max</option>
                                                            <option value="20000">20,000</option>
                                                            <option value="30000">30,000</option>
                                                            <option value="40000">40,000</option>
                                                            <option value="custom">Custom</option>
                                                        </select>
                                                        <input type="number" name="maxPriceCustom" id="maxPriceCustom" class="form-control my-2 p-1 d-none" placeholder="Max">
                                                    </div>
                                                </div>
                                            </li>
                                            <li>
                                                <div class="mx-2">
                                                    <button type="submit" name="priceFilterBtn" id="filterBtn" class="form-control btn btn-success">Filter</button>
                                                </div>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row g-4" id="product-container">
                            <cfloop array="#getProductArray.product#" item="productItem">
                                <cfset decryptedProductId = application.productManagementObj.decryptData(data = productItem.productId)>
                                <a href="userProducts.cfm?productId=#urlEncodedFormat(productItem.productId)#" class="col-12 col-sm-6 col-md-4 col-lg-3 text-decoration-none text-dark">
                                    <div class="product-card pb-0 shadow-sm">
                                        <img src="../../uploads/products/product#decryptedProductId#/#productItem.imageFile#" alt="#productItem.productName#">
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
                            <button id="viewMoreBtn" class="btn btn-outline-primary w-25 ms-auto" type="button" onclick="viewMoreProducts('#url.subCategoryId#','#sortType#','#minPrice#','#maxPrice#','')">View More</button>
                        </cfif>
                    <cfelse>
                        <div class="d-flex flex-column">
                            <img src="../../assets/images/designImages/no_result.gif" alt="No Products Found" class="w-75">
                            <a href="userHome.cfm" class="btn btn-primary mx-auto w-25"><i class="fas fa-shopping-bag me-2"></i>Back To Home</a>
                        </div> 
                    </cfif>
                </div>
            </div>
        </form>
        
    </main>
    <cfinclude template="userFooter.cfm">
</cfoutput>
</body>
</html>
