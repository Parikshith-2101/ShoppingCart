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
    <cfset getCategoriesData = application.productManagementObj.getCategory()>
    <cfset qrySubCategoryData =  application.productManagementObj.qrySubCategoryData(categoryId = url.categoryId)>
    <cfset qryBrandData = application.productManagementObj.qryBrandData()>
    <cfset qryProductData = application.productManagementObj.qryProductData(subCategoryId = url.subCategoryId)>
    <cfoutput>
        <nav class="navbar fixed-top p-0">
            <a href="##" class="nav-link">
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
                            <div class="text-uppercase login-title fs-4 px-2">#url.subCategoryName#</div>
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
                                            <div class="d-flex flex-column">
                                                <label for="categoryDropdown">Category</label>
                                                <select id="categoryDropdown" name="categoryDropdown">                                                 
                                                    <cfloop index="i" from="1" to="#arrayLen(getCategoriesData.categoryId)#">
                                                        <option value="#getCategoriesData.categoryId[i]#">#getCategoriesData.categoryName[i]#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                            <div class="d-flex flex-column">
                                                <label for="subCategoryDropdown">SubCategory</label>
                                                <select id="subCategoryDropdown" name="subCategoryDropdown">
                                                    <cfloop query="qrySubCategoryData">
                                                        <option value="#qrySubCategoryData.fldSubCategory_Id#">#qrySubCategoryData.fldSubCategoryName#</option>
                                                    </cfloop>                                          
                                                </select>
                                            </div>
                                            <div>     
                                                <label for="productName">Product Name*</label>                                           
                                                <input type="text" name="productName" id="productName" placeholder="Product Name">
                                                <div id="productName-error" class="fw-bold text-danger"></div>
                                            </div>
                                            <div>
                                                <label for="productBrand">Product Brand*</label>
                                                <select id="productBrand" name="productBrand">                                                  
                                                    <option value="" disabled selected>Select Brand Name</option>
                                                    <cfloop query="qryBrandData">
                                                        <option value="#qryBrandData.fldBrand_Id#">#qryBrandData.fldBrandName#</option>
                                                    </cfloop>                                          
                                                </select>
                                                <div id="productBrand-error" class="fw-bold text-danger"></div>
                                            </div>
                                            <div>
                                                <label for="productDesc">Product Description*</label>
                                                <input type="text" name="productDesc" id="productDesc" placeholder="Product Description">
                                                <div id="productDesc-error" class="fw-bold text-danger"></div>
                                            </div>
                                            <div>
                                                <label for="productPrice">Product Price*</label>
                                                <input type="number" name="productPrice" id="productPrice" placeholder="Product Price">
                                                <div id="productPrice-error" class="fw-bold text-danger"></div>
                                            </div>
                                            <div>
                                                <label for="productTax">Product Tax*</label>
                                                <input type="number" name="productTax" id="productTax" placeholder="Product Tax">
                                                <div id="productTax-error" class="fw-bold text-danger"></div>
                                            </div>
                                            <div>
                                                <label for="productImage">Product Image*</label>
                                                <input type="file" name="productImage" id="productImage" multiple accept="image/*">
                                                <div id="productImage-error" class="fw-bold text-danger"></div>
                                            </div>
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

                        <div class="modal fade" id="productImageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg w-50">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="imageModalLabel">Image Carousel</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">                                      
                                        <div id="displayProductImage" class="d-flex justify-content-evenly">

                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-primary" onclick="location.reload()">Save Changes</button>
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <cfif structKeyExists(form, "saveProduct")>
                            <cfset local.addProductResult = application.productManagementObj.addProduct(
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
                            <cfif local.addProductResult.errorStatus EQ "true">
                                <cflocation url = "products.cfm?subCategoryId=#url.subCategoryId#&subCategoryName=#url.subCategoryName#&categoryId=#url.categoryId#" addToken="No">
                                <div class="text-success fw-bold errorServerSide">#local.addProductResult.resultMsg#</div>
                            <cfelse>
                                <div class="text-danger fw-bold errorServerSide">#local.addProductResult.resultMsg#</div>
                            </cfif>
                                
                        </cfif>

                        <div class="d-flex flex-column w-100 mt-3">
                            <cfloop query="qryProductData">
                                <div class="card shadow-lg mb-3" id="#qryProductData.fldProduct_Id#">
                                    <div class="d-flex align-items-center p-3">
                                        <div class="me-4 d-flex flex-column align-items-center cursor-pointer" onclick="editImage(#qryProductData.fldProduct_Id#)">
                                            <img src="../assets/images/product#qryProductData.fldProduct_Id#/#qryProductData.fldImageFilePath#" width="80" class="rounded">
                                        </div>
                                        <div class="flex-grow-1">
                                            <h3 class="card-title mb-1">#qryProductData.fldProductName#</h3>
                                            <p class="card-text mb-1"><span class="fldName">Brand</span>: #qryProductData.fldBrandName#</p>
                                            <p class="card-text mb-1"><span class="fldName">Description</span>: #qryProductData.fldDescription#</p>
                                            <p class="card-text mb-1"><span class="fldName">Price</span>: Rs.#qryProductData.fldUnitPrice#</p>
                                            <p class="card-text mb-1"><span class="fldName">Tax</span>: Rs.#qryProductData.fldUnitTax#</p>
                                        </div>
                                        <div class="d-flex align-items-center">
                                            <button onclick="editProduct(#qryProductData.fldProduct_Id#,#url.subCategoryId#,#url.categoryId#)" class="btn btn-outline-info mx-1" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button onclick="deleteProduct(#qryProductData.fldProduct_Id#,#url.subCategoryId#)" class="btn btn-outline-danger mx-1" title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </cfloop>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </cfoutput>

    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/products.js"></script>
</body>

</html>