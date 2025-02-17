<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/products.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<body>
    <cfset getCategoryArray = application.productManagementObj.getCategory()>
    <cfset getSubCategoryArray = application.productManagementObj.getSubCategory(categoryId = url.categoryId)>
    <cfset getBrandArray = application.productManagementObj.getBrand()>
    <cfset getProductArray = application.productManagementObj.getProduct(subCategoryId = url.subCategoryId)>

    <cfoutput>
        <nav class="navbar fixed-top p-0">
            <a href="categories.cfm" class="nav-link">
                <div class="d-flex nav-brand">
                    <img src="../assets/images/designImages/cartIcon.png" alt="cartIcon" width="40" class="me-1">
                    <span class="fs-4">ShoppingCart</span>
                </div>
            </a>
            <div class="nav-brand">Wellcome <strong>#session.firstName# #session.lastName#</strong></div>
            <ul class="d-flex list-unstyled my-0">
                <li class="nav-item">
                    <a class="nav-link" id="logoutCategory">
                        <i class="fa-solid fa-right-to-bracket"></i>
                        <span>Logout</span>
                    </a>
                </li>
            </ul>
        </nav>
        <div class="container my-5 d-flex flex-column p-0 bg-white position-relative">
            <div class="d-flex justify-content-center">
                <div class="border rounded shadow-heavy w-100">
                    <div class="py-4 px-3 align-items-center d-flex flex-column" id="categoryDiv">
                        <div class="d-flex w-100 align-items-center">
                            <cfset getSubCategoryName = application.productManagementObj.getSubCategory(subCategoryId = url.subCategoryId)>
                            <div class="text-uppercase login-title fs-4 px-2">#getSubCategoryName.subcategory[1].subCategoryName#</div>
                            <div class="border border-2 rounded fw-bold px-2 ms-2 fs-small addPageBtn" id="addProductBtn">Add+</div>
                        </div>
                        <!---modal--->
                        <div class="modal fade" id="productModal" data-bs-backdrop="static" data-bs-keyboard="false"
                            tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
                            <div class="modal-dialog w-50">
                                <div class="modal-content">
                                    <form method="post" enctype="multipart/form-data" name="productForm" id="productForm">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="exampleModalLabel">Add Product</h5>
                                            <button type="button" class="close btn btn-outline-danger px-2 py-0" data-bs-dismiss="modal" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="d-flex flex-column mb-2">
                                                <label for="categoryDropdown">Category</label>
                                                <select id="categoryDropdown" class="m-0" name="categoryDropdown">                                                 
                                                    <cfloop array="#getCategoryArray.category#" item="categoryItem">
                                                        <option value="#categoryItem.categoryId#">#categoryItem.categoryName#</option>
                                                    </cfloop>
                                                </select>
                                                <div id="category-error" class="fw-bold text-danger"></div>
                                            </div>
                                            <div class="d-flex flex-column mb-2">
                                                <label for="subCategoryDropdown">SubCategory</label>
                                                <select id="subCategoryDropdown" class="m-0" name="subCategoryDropdown"> 
                                                    <cfloop array="#getSubCategoryArray.subCategory#" item="subCategoryItem">
                                                        <option value="#subCategoryItem.subCategoryId#">#subCategoryItem.subCategoryName#</option>
                                                    </cfloop>                                         
                                                </select>
                                                <div id="subCategory-error" class="fw-bold text-danger"></div>
                                            </div>
                                            <div class="mb-2">     
                                                <label for="productName">Product Name*</label>                                           
                                                <input class="m-0" type="text" name="productName" id="productName" placeholder="Product Name">
                                                <div id="productName-error" class="fw-bold text-danger"></div>
                                            </div>
                                            <div class="mb-2">
                                                <label for="productBrand">Product Brand*</label>
                                                <select id="productBrand" class="m-0" name="productBrand">                                                  
                                                    <option value="" disabled selected>Select Brand Name</option>                                          
                                                    <cfloop array="#getBrandArray.brand#" item="brandItem">
                                                        <option value="#brandItem.brandId#">#brandItem.brandName#</option>
                                                    </cfloop>                                          
                                                </select>
                                                <div id="productBrand-error" class="fw-bold text-danger"></div>
                                            </div>
                                            <div class="mb-2">
                                                <label for="productDesc">Product Description*</label>
                                                <input class="m-0" type="text" name="productDesc" id="productDesc" placeholder="Product Description">
                                                <div id="productDesc-error" class="fw-bold text-danger"></div>
                                            </div>
                                            <div class="mb-2">
                                                <label for="productPrice">Product Price*</label>
                                                <input class="m-0" type="number" name="productPrice" id="productPrice" placeholder="Product Price">
                                                <div id="productPrice-error" class="fw-bold text-danger"></div>
                                            </div>
                                            <div class="mb-2">
                                                <label for="productTax">Product Tax*</label>
                                                <input class="m-0" type="number" name="productTax" id="productTax" placeholder="Product Tax">
                                                <div id="productTax-error" class="fw-bold text-danger"></div>
                                            </div>
                                            <div class="mb-2">
                                                <label for="productImage">Product Image*</label>
                                                <input class="m-0" type="file" name="productImage" id="productImage" multiple accept="image/*">
                                                <div id="productImage-error" class="fw-bold text-danger"></div>
                                            </div>
                                            <div class="mt-4 d-flex w-100 flex-wrap" id="productImageDiv"></div>
                                        </div>
                                        <input type="hidden" name="productIdHolder" id="productIdHolder">
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Close</button>
                                            <button type="submit" onclick="return productValidation(event)" class="btn btn-primary" id="saveProduct" name="saveProduct">Save</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!---imageModal--->

                        <div class="modal fade" id="productImageModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg w-50">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="imageModalLabel">Image Carousel</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">                                      
                                        <div id="displayProductImage" class="d-flex justify-content-evenly"></div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-primary" onclick="location.reload()">Save Changes</button>
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <cfif structKeyExists(form, "saveProduct")>
                            <cfif len(trim(form.productIdHolder))>
                                <cfset addProductResult = application.productManagementObj.editProduct(
                                    categoryId = form.categoryDropdown,
                                    subCategoryId = form.subCategoryDropdown,
                                    productName = form.productName,
                                    productBrandId = form.productBrand,
                                    productDesc = form.productDesc,
                                    productPrice = form.productPrice,
                                    productTax = form.productTax,
                                    productImage = form.productImage,
                                    productId = form.productIdHolder
                                )>
                            <cfelse>
                                <cfset addProductResult = application.productManagementObj.addProduct(
                                    categoryId = form.categoryDropdown,
                                    subCategoryId = form.subCategoryDropdown,
                                    productName = form.productName,
                                    productBrandId = form.productBrand,
                                    productDesc = form.productDesc,
                                    productPrice = form.productPrice,
                                    productTax = form.productTax,
                                    productImage = form.productImage
                                )>
                            </cfif>
                            <cfif addProductResult.error EQ false>
                                <cflocation url = "products.cfm?subCategoryId=#urlEncodedFormat(url.subCategoryId)#&categoryId=#urlEncodedFormat(url.categoryId)#" addToken="No">
                                <div class="text-success fw-bold errorServerSide">#addProductResult.message#</div>
                            <cfelse>
                                <div class="text-danger fw-bold errorServerSide">#addProductResult.message#</div>
                            </cfif>    
                        </cfif>

                        <div class="d-flex flex-column w-100 mt-3">
                            <div class="row g-4">
                                <cfif arrayLen(getProductArray.product)>                               
                                    <cfloop array="#getProductArray.product#" item="productItem">
                                        <cfset decryptedProductId = application.productManagementObj.decryptData(data = productItem.productId)>
                                        <div class="col-sm-6 col-md-4 col-lg-3" id="#productItem.productId#">
                                            <div class="card product-card shadow-sm">
                                                <div onclick="editImage('#productItem.productId#','#decryptedProductId#')" class="cursor-pointer">
                                                    <img src="../uploads/products/product#decryptedProductId#/#productItem.imageFile#" 
                                                        class="card-img-top" alt="#productItem.productName#">
                                                </div>
                                                <div class="card-body">
                                                    <h5 class="card-title text-truncate">#productItem.productName#</h5>
                                                    <p class="card-text text-muted small mb-1">
                                                        <strong>Brand:</strong> #productItem.brandName#
                                                    </p>
                                                    <p class="card-text product-desc text-muted small mb-1">
                                                        <strong>Description:</strong> #productItem.description#
                                                    </p>
                                                    <p class="card-text text-muted small mb-1">
                                                        <strong>Price:</strong> Rs.#productItem.unitPrice#
                                                    </p>
                                                    <p class="card-text text-muted small mb-3">
                                                        <strong>Tax:</strong> Rs.#productItem.unitTax#
                                                    </p>
                                                    <div class="d-flex justify-content-between">
                                                        <button class="btn btn-outline-info btn-sm" onclick="editProduct('#productItem.productId#','#url.subCategoryId#','#url.categoryId#','#decryptedProductId#')">
                                                            <i class="fas fa-edit"></i> Edit
                                                        </button>
                                                        <button class="btn btn-outline-danger btn-sm" onclick="deleteProduct('#productItem.productId#','#url.subCategoryId#')">
                                                            <i class="fas fa-trash"></i> Delete
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </cfloop>
                                <cfelse>
                                    <div class="mt-5 w-100 text-center">
                                        <img src="../assets/images/designImages/cart is empty.png" alt="Empty Cart" class="w-25 h-50">
                                        <h4 class="mt-3 text-muted">Your Product Page is Empty</h4>
                                        <p class="text-muted">ADD SOME PRODUCTS HERE!</p>
                                    </div>
                                </cfif>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </cfoutput>

    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/products.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</body>

</html>