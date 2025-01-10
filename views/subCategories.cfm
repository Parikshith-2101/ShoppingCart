<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>subCategories</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/adminLogin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<body>
    <cfoutput>
        <cfset subCategoryData =  application.shoppingCart.qrySubCategoryData(url.categoryId)>
        
        <nav class="navbar fixed-top p-0">
            <a href="##" class="nav-link">
                <div class="d-flex nav-brand">
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
                            <div class="text-uppercase login-title fs-4 px-2">SubCategories</div>
                            <div class="border border-2 rounded fw-bold px-2 ms-2 fs-small addPageBtn" id="addSubCategoryBtn">Add+</div>
                        </div>

                        <div class="modal fade" id="subCategoryModal" data-bs-backdrop="static" data-bs-keyboard="false"
                            tabindex="-1" aria-labelledby="subCategoryLabel" aria-hidden="true">
                            <div class="modal-dialog w-50">
                                <div class="modal-content">
                                    <form method="post" enctype="multipart/form-data" name="subCategoryForm">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
                                            <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="d-flex flex-column">
                                                <label for="categoryDropdown">Category</label>
                                                <select id="categoryDropdown" name="categoryDropdown">
                                                    <!--- <cfif>
                                                        <option value="" selected>Select a category</option>
                                                    </cfif> --->
                                                    <option value="" disabled selected>Select a category</option>
                                                    <cfloop query="qryCategoriesData">
                                                        <option value="#qryCategoriesData.fldCategory_Id#">#qryCategoriesData.fldCategoryName#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                            <div>
                                                <label for="subCategoryName">SubCategory Name*</label>
                                                <input type="text" name="subCategoryName" id="subCategoryValue">
                                                <div id="subCategory-error" class="fw-bold"></div>
                                            </div>
                                        </div>

                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Close</button>
                                            <button type="button" class="btn btn-primary" id="saveSubCategory">Save</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex flex-column w-100 mt-3">
                            
                            <cfloop query = "subCategoryData">

                                <div class="card shadow-lg" id = "#subCategoryData.fldSubCategory_Id#">
                                    <div class="d-flex align-items-center">
                                        <div class="categoryName">
                                            #subCategoryData.fldSubCategoryName#
                                        </div>
                                        <div class="d-flex ms-auto">
                                            <button class="btn btn-outline-info mx-1 d-flex align-items-center justify-content-center" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button  class="btn btn-outline-danger mx-1 d-flex align-items-center justify-content-center" title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                            <button  class="btn btn-outline-success mx-1 d-flex align-items-center justify-content-center" title="Go to Category">
                                                <i class="fas fa-arrow-right"></i>
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
    <script src="../assets/script/script.js"></script>
</body>

</html>