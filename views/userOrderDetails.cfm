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
<!---                 <cfdump  var="#orderDetails#"> --->
                <div class="container products-container">
                    <div class="d-flex justify-content-between align-items-center mt-5 mb-3">
                        <h4 id="search-for" class="m-0 text-secondary"></h4>
                        <input type="search" id="searchOrder" class="form-control w-25 ms-auto shadow-sm border-2" placeholder="Search orders...">
                    </div>
                    <h4 id="noOrdersFound" class="text-danger"></h4>
                    
                    <cfloop array="#orderDetails.order#" item="orderItem">
                        <div class="card p-4 mb-4 shadow-sm border-2 orderDetailsDiv" id="#orderItem.orderId#">
                            <h4 class="mb-3">Order Summary</h4>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <p class="mb-1"><strong>Order ID:</strong> #orderItem.orderId#</p>
                                <p class="mb-1"><strong>Date:</strong> #orderItem.orderDate#</p>
                                <p class="mb-1"><strong>Ordered By:</strong> <span class="">#orderItem.firstName# #orderItem.lastName#</span></p>
                            </div>
                            <ul class="list-group mb-3 border-0">
                                <cfloop array="#orderItem.product#" item="productItem">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <div class="d-flex align-items-center">
                                            <img src="../uploads/products/product#productItem.productId#/#productItem.productImage#" alt="Product" class="rounded me-3" width="50" height="50">
                                            <div>
                                                <h6 class="mb-1">#productItem.productName#</h6>
                                                <p class="mb-0 text-muted">Qty: #productItem.quantity# | Price: ₹#numberFormat(productItem.unitPrice, "9,999.00")# | Tax: ₹#numberFormat(productItem.unitTax, "9,999.00")#</p>
                                            </div>
                                        </div>
                                        <span class="text-dark fw-bold">₹#numberFormat((productItem.unitPrice + productItem.unitTax) * productItem.quantity, "9,999.00")#</span>
                                    </li>
                                </cfloop>
                            </ul>
                            <div class="d-flex justify-content-between">       
                                <div>                              
                                    <div class="d-flex">
                                        <p class="mb-1 me-1">Total Price :</p>
                                        <p class="mb-1">₹#numberFormat(orderItem.totalPrice, "9,999.00")#</p>
                                    </div>
                                    <div class="d-flex">
                                        <p class="mb-1 me-1">Total Tax :</p>
                                        <p class="mb-1">₹#numberFormat(orderItem.totalTax, "9,999.00")#</p>
                                    </div>
                                </div>
                                <div class="d-flex fw-bold mt-2">
                                    <h5 class="mb-1 me-1">Total :</h5>
                                    <h5 class="mb-1 text-success">₹#numberFormat(orderItem.totalTax + orderItem.totalPrice, "9,999.00")#</h5>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between mt-2 align-items-center">
                                <div>
                                    <p class="mb-1"><strong>Address:</strong> #orderItem.addressLine1#, #orderItem.addressLine2#, #orderItem.city#, #orderItem.state# - #orderItem.pincode#</p>
                                    <p class="mb-1"><strong>Phone:</strong> +91#orderItem.phone#</p>
                                </div>
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
    <cfinclude template="/views/userFooter.cfm">
</body>
</html>
