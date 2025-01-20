<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/home.css">    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
<cfoutput>
    <cfset getCategories = application.productManagementObj.getCategory()>
    <header>
        <nav class="navbar navbar-expand-lg fixed-top">
            <div class="container-fluid">
                <a href="userHome.cfm" class="navbar-brand d-flex align-items-center">
                    <img src="../assets/images/designImages/cartIcon.png" alt="cartIcon" width="40" class="me-2">
                    <span class="fs-4 nav-brand">ShoppingCart</span>
                </a> 
                <div class="d-flex">                        
                    <input class="form-control me-2" type="search" placeholder="Search for products..." aria-label="Search">
                    <button class="btn btn-primary" type="submit">Search</button>
                </div>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="##">
                            <i class="fa-solid fa-right-to-bracket"></i>
                            <span>Login</span>
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
        <nav class="navbar-expand-lg categories-navbar fixed-top">
            <div class="container-fluid">
                <div class="collapse navbar-collapse" id="categoriesNavbar">
                    <ul class="navbar-nav justify-content-evenly w-100">
                        <cfloop index="i" from="1" to="#arrayLen(getCategories.categoryId)#">
                            <li class="nav-item dropdown">
                                <a class="nav-link" href="userCategories.cfm?categoryId=#getCategories.categoryId[i]#" id="#getCategories.categoryId[i]#" role="button">
                                    #getCategories.categoryName[i]#
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="#getCategories.categoryId[i]#">
                                    <cfset getSubCategories = application.productManagementObj.getSubCategory(categoryId = getCategories.categoryId[i])>
                                    <cfloop index="i" from="1" to="#arrayLen(getSubCategories.subCategoryId)#">
                                        <li>
                                            <a class="dropdown-item" href="userSubCategories.cfm?subCategoryId=#getSubCategories.subCategoryId[i]#&subCategoryName=#getSubCategories.subCategoryName[i]#">
                                                #getSubCategories.subCategoryName[i]#
                                            </a>
                                        </li>
                                    </cfloop>
                                </ul>
                            </li>
                        </cfloop>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <main>
        <div class="container products-container">
            <!---products--->
            
        </div>
    </main>
    <footer class="mt-5 w-100">
        
    </footer>
    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
</cfoutput>
</body>
</html>
