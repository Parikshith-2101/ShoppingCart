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

    <nav class="navbar fixed-top p-0">
        <a href="" class="nav-link">
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
            <div class="right-content border rounded shadow-heavy w-100">
                <div class="p-4 align-items-center d-flex flex-column">
                    <div class="d-flex w-100 align-items-center">
                        <div class="text-uppercase login-title fs-4">Categories</div>
                        <div class="border border-2 rounded fw-bold px-2 ms-2 fs-small" id="addCategoryBtn" onclick="addCategory()">Add+</div>
                    </div>

                    <div class="modal fade" id="addCategory" data-bs-backdrop="static" data-bs-keyboard="false"
                        tabindex="-1" aria-labelledby="addCategoryLabel" aria-hidden="true">
                        <div class="modal-dialog w-50">
                            <div class="modal-content">
                                <form method="post" enctype="multipart/form-data" name="addCategoryForm">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
                                        <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <label for="categoryName">Category Name*</label>
                                        <input type="text" name="categoryName" id="categoryValue">
                                        <div id="category-error"></div>
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
                </div>
            </div>
        </div>
    </div>

    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/script.js"></script>
</body>

</html>