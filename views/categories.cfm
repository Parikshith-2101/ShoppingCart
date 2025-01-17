<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>categories</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/adminLogin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<body>

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
        <div class="container my-5 d-flex flex-column p-0 w-50 bg-white position-relative">
            <div class="d-flex justify-content-center">
                <div class="border rounded shadow-heavy w-100">
                    <div class="py-4 px-3 align-items-center d-flex flex-column" id="categoryDiv">
                        <div class="d-flex w-100 align-items-center">
                            <div class="text-uppercase login-title fs-4 px-2">Categories</div>
                            <div class="border border-2 rounded fw-bold px-2 ms-2 fs-small addPageBtn" id="addCategoryBtn">Add+</div>
                        </div>

                        <div class="modal fade" id="categoryModal" data-bs-backdrop="static" data-bs-keyboard="false"
                            tabindex="-1" aria-labelledby="addCategoryLabel" aria-hidden="true">
                            <div class="modal-dialog w-50">
                                <div class="modal-content">
                                    <form method="post" enctype="multipart/form-data" name="addCategoryForm">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="exampleModalLabel">Category</h5>
                                            <button type="button" class="close btn btn-outline-danger px-2 py-0" data-bs-dismiss="modal" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                        <div class="modal-body">
                                            <label for="categoryName">Category Name*</label>
                                            <input type="text" name="categoryName" id="categoryValue">
                                            <div id="category-error" class = "fw-bold"></div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Close</button>
                                            <button type="button" class="btn btn-primary" id="saveCategory">Save</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex flex-column w-100 mt-3">
                            <cfset getCategoriesData =  application.productManagementObj.getCategory()>                                                                                                   
                            <cfloop index="i" from="1" to="#arrayLen(getCategoriesData.categoryId)#">
                                <div class="card shadow-lg" id = "#getCategoriesData.categoryId[i]#">
                                    <div class="d-flex align-items-center">
                                        <div class="categoryName">
                                            #getCategoriesData.categoryName[i]#
                                        </div>
                                        <div class="d-flex ms-auto">
                                            <button onclick="editCategory(#getCategoriesData.categoryId[i]#)" class="btn btn-outline-info mx-1 d-flex align-items-center justify-content-center" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button onclick="deleteCategory(#getCategoriesData.categoryId[i]#)" class="btn btn-outline-danger mx-1 d-flex align-items-center justify-content-center" title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                            <a href="subCategories.cfm?categoryId=#getCategoriesData.categoryId[i]#&categoryName=#getCategoriesData.categoryName[i]#" class="btn btn-outline-success mx-1 d-flex align-items-center justify-content-center" title="Go to Category">
                                                <i class="fas fa-arrow-right"></i>
                                            </a>
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