<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>userHome</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/home.css">    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
    <header>
        <cfinclude template="userHeader.cfm">
    </header>
    <cfoutput>
        <cfset orderDetails = application.cartObj.getOrderDetails()>
        <form method="post"> 
            <main>
                <div class="container products-container">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 id="search-for" class="m-0 text-secondary"></h4>
                        <input type="search" id="searchOrder" class="form-control w-25 shadow-sm border-2" placeholder="Search orders...">
                    </div>
                    <cfloop array="#orderDetails.order#" item="orderItem">
                        <div class="card p-4 mb-4 shadow-sm border-2 orderDetailsDiv" id="#orderItem.orderId#">
                            <h4 class="mb-3">Order Summary</h4>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <p class="mb-1"><strong>Order ID:</strong> #orderItem.orderId#</p>
                                <p class="mb-1"><strong>Date:</strong> #orderItem.orderDate#</p>
                                <p class="mb-1"><strong>Ordered By:</strong> <span class="">#orderItem.firstName# #orderItem.lastName#</span></p>
                            </div>
                            <ul class="list-group mb-3 border-0">
                                <cfloop from="1" to="#arrayLen(orderItem.productId)#" index="i">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <div class="d-flex align-items-center">
                                            <img src="../uploads/products/product#orderItem.productId[i]#/#orderItem.productImage[i]#" alt="Product" class="rounded me-3" width="50" height="50">
                                            <div>
                                                <h6 class="mb-1">#orderItem.productName[i]#</h6>
                                                <p class="mb-0 text-muted">Qty: #orderItem.quantity[i]# | Price: ₹#orderItem.unitPrice[i]# | Tax: ₹#orderItem.unitTax[i]#</p>
                                            </div>
                                        </div>
                                        <span class="text-dark fw-bold">₹#numberFormat((orderItem.unitPrice[i] + orderItem.unitTax[i]) * orderItem.quantity[i], "99,999.00")#</span>
                                    </li>
                                </cfloop>
                            </ul>
                            <div class="d-flex justify-content-between">       
                                <div>                              
                                    <div class="d-flex">
                                        <p class="mb-1 me-1">Total Price :</p>
                                        <p class="mb-1">₹#numberFormat(orderItem.totalPrice, "99,999.00")#</p>
                                    </div>
                                    <div class="d-flex">
                                        <p class="mb-1 me-1">Total Tax :</p>
                                        <p class="mb-1">₹#numberFormat(orderItem.totalTax, "99,999.00")#</p>
                                    </div>
                                </div>
                                <div class="d-flex fw-bold mt-2">
                                    <h5 class="mb-1 me-1">Total :</h5>
                                    <h5 class="mb-1 text-success">₹#numberFormat(orderItem.totalTax + orderItem.totalPrice, "99,999.00")#</h5>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between mt-2 align-items-center">
                                <p class="mb-1"><strong>Address:</strong> #orderItem.addressLine1#, #orderItem.addressLine2#, #orderItem.city#, #orderItem.state# - #orderItem.pincode#</p>
                                <button type="submit" id="downloadInvoice" name="downloadInvoiceBtn" value="#orderItem.orderId#" class="btn btn-primary">Download Invoice</button>
                            </div>
                        </div>
                    </cfloop>
                </div>
                <cfif structKeyExists(form, "downloadInvoiceBtn")>
                    <cfset local.result =  application.cartObj.downloadInVoice(orderId = form.downloadInvoiceBtn)>
                    <cfif local.result.error EQ false>
                        <div id="checkInvoiceBtn"></div>
                    </cfif>
                </cfif>
            </main>
        </form>
    </cfoutput>
    <footer class="mt-5 w-100">
        
    </footer>
    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/user.js"></script>
</body>
</html>
