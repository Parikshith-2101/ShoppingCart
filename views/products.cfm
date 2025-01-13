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
    <cfset qryCategoryData =  application.shoppingCart.qryCategoryData()>
    <cfset qrySubCategoryData =  application.shoppingCart.qrySubCategoryData(categoryId = url.categoryId)>
    <cfoutput>
        <nav class="navbar fixed-top p-0">
            <a href="##" class="nav-link">
                <div class="d-flex nav-brand">
                    <img src="../assets/images/cartIcon.png" alt="cartIcon" width="40" class="me-1">
                    <span class="fs-4">ShoppingCart</span>
                </div>
            </a>
            <ul class="d-flex list-unstyled my-0">
                <li class="nav-item">
                    <a class="nav-link" id="logoutCategory">
                        <i class="fa-solid fa-right-to-bracket"></i>
                        <span>Logout</span>
                    </a>
                </li>
            </ul>
        </nav>
        <div class="container my-5 d-flex flex-column p-0 w-50 bg-white position-relative">
            <div class="d-flex justify-content-center">
                <div class="border rounded shadow-heavy w-100">
                    <div class="py-4 px-3 align-items-center d-flex flex-column" id="categoryDiv">
                        <div class="d-flex w-100 align-items-center">
                            <div class="text-uppercase login-title fs-4 px-2">#url.subCategoryName#</div>
                            <div class="border border-2 rounded fw-bold px-2 ms-2 fs-small addPageBtn" id="addProductBtn">Add+</div>
                        </div>

                        <div class="modal fade" id="productModal" data-bs-backdrop="static" data-bs-keyboard="false"
                            tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
                            <div class="modal-dialog w-50">
                                <div class="modal-content">
                                    <form method="post" enctype="multipart/form-data" name="productForm">
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
                                                    <cfloop query="qryCategoryData">
                                                        <option value="#qryCategoryData.fldCategory_Id#">#qryCategoryData.fldCategoryName#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                            <div class="d-flex flex-column">
                                                <label for="subCategoryDropdown">SubCategory</label>
                                                <select id="subCategoryDropdown" name="subCategoryDropdown">  qrySubCategoryData
                                                    <cfloop query="qrySubCategoryData">
                                                        <option value="#qrySubCategoryData.fldSubCategory_Id#">#qrySubCategoryData.fldSubCategoryName#</option>
                                                    </cfloop>                                          
                                                </select>
                                            </div>
                                            <div>     
                                                <label for="productPrice">Product Name*</label>                                           
                                                <input type="text" name="productName" id="productName" placeholder="Product Name">
                                                <div id="productName-error" class="fw-bold"></div>
                                            </div>
                                            <div>
                                                <label for="productPrice">Product Brand*</label>
                                                <input type="text" name="productBrand" id="productBrand" placeholder="Product Brand">
                                                <div id="productBrand-error" class="fw-bold"></div>
                                            </div>
                                            <div>
                                                <label for="productPrice">Product Description*</label>
                                                <input type="text" name="productDesc" id="productDesc" placeholder="Product Description">
                                                <div id="productDesc-error" class="fw-bold"></div>
                                            </div>
                                            <div>
                                                <label for="productPrice">Product Price*</label>
                                                <input type="number" name="productPrice" id="productPrice" placeholder="Product Price">
                                                <div id="productPrice-error" class="fw-bold"></div>
                                            </div>
                                            <div>
                                                <label for="productImage">Product Image*</label>
                                                <input type="file" name="productImage" id="productImage" multiple>
                                                <div id="productImage-error" class="fw-bold"></div>
                                            </div>
                                        </div>

                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Close</button>
                                            <button type="button" class="btn btn-primary" id="saveProduct">Save</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex flex-column w-100 mt-3">
                            Product
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