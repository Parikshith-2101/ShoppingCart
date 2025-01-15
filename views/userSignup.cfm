<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>userLogin</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/adminLogin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
            integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
            crossorigin="anonymous" referrerpolicy="no-referrer"/>
</head>
<body>
    <body>
        <nav class="navbar fixed-top p-0">
            <a href="##" class="nav-link">
                <div class="d-flex nav-brand">
                    <img src="../assets/images/designImages/cartIcon.png" alt="cartIcon" width="40" class="me-1">
                    <span class="fs-4">Shopping Cart</span>
                </div>
            </a>
            <ul class = "d-flex list-unstyled my-0">
                <li class = "nav-item">
                    <a class = "nav-link" href = "##">
                        <i class="fa-solid fa-user-plus"></i>
                        <span>Login</span>
                    </a>
                </li>
            </ul>
        </nav>
        <div class="container my-5 d-flex flex-column p-0 w-50 bg-white position-relative">
            <div class = "d-flex justify-content-center">
                <div class="right-content border rounded shadow-heavy w-100">
                    <div class="p-4 align-items-center d-flex flex-column">
                        <div class="text-uppercase text-center login-title fs-2 mb-3">SignUp</div>
                        <form method="post" class="align-items-center d-flex flex-column w-100" enctype="multipart/form-data">
                            <div class="w-100 py-2">
                                <input type="text" id="userName" class="border-0 border-bottom w-100" placeholder="Username/PhoneNo.">
                                <div id = "userName-error" class="text-danger fw-bold"></div>
                            </div>
                            <div class="w-100 py-2">
                                <input type="password" id="password" class="border-0 border-bottom w-100" placeholder="Password">
                                <div id = "password-error" class="text-danger fw-bold"></div>
                            </div>
                            <button type="button" id="loginBtn" class="rounded-pill login-btn w-75 my-4 btn fw-bold">LOGIN</button>
                        </form>
                        <div id="resultMsg" class="fw-bold"></div>
                    </div>
                </div>
            </div>
        </div>
    
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/userLogin.js"></script>
</body>
</html>