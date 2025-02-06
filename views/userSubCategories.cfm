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
    <header>
        <cfinclude template="userHeader.cfm">
    </header>
    <main>
        <cfset getProductArray = application.productManagementObj.getProduct(subCategoryId = url.subCategoryId)>
        <cfif structKeyExists(form, "sortBtn")>
            <cfset getProductArray = application.productManagementObj.getProduct(
                subCategoryId = url.subCategoryId,
                sortType = form.sortBtn
            )>
        </cfif>
        <cfif structKeyExists(form, "priceFilterBtn")>    
            <cfset minPrice = form.minPrice>
            <cfset maxPrice = form.maxPrice>
            <cfif minPrice EQ "custom">
                <cfset minPrice = form.minPriceCustom>
            </cfif>
            <cfif maxPrice EQ "custom">
                <cfset maxPrice = form.maxPriceCustom>
            </cfif>
            <cfset getProductArray = application.productManagementObj.getProduct(
                subCategoryId = url.subCategoryId,
                minPrice = minPrice,
                maxPrice = maxPrice
            )>
        </cfif>
        <form method="post">
            <div class="container products-container">
                <div class="row g-4 mt-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <cfset subCatName = application.productManagementObj.getSubCategory(subCategoryId = url.subCategoryId)>
                        <h3 class="m-0">#subCatName.subCategory[1].subCategoryName#</h3>
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
                                                        <option value="">Min</option>
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
                                                        <option value="">Max</option>
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
                    <cfif arraylen(getProductArray.product)>
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
                    <cfelse>
                        <div class="col-12 text-center">
                            <img src="../assets/images/designImages/no_result.gif" alt="No Products Found" class="w-75 h-75">
                        </div>
                    </cfif>
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
