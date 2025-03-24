<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>subCategories</title>
    <link rel="stylesheet" href="../../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/style/adminLogin.css">
    <link rel="stylesheet" href="../../assets/style/products.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<body>
    <cfoutput>
        <nav class="navbar fixed-top p-0">
            <a href="categories.cfm" class="nav-link">
                <div class="d-flex nav-brand">
                    <img src="../../assets/images/designImages/cartIcon.png" alt="cartIcon" width="40" class="me-1">
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
    </cfoutput>