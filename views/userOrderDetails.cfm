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
        <main>
            <div class="container products-container">
                <cfloop array="#orderDetails.order#" item="orderItem">
                    <div class="card p-4 mb-4 shadow-sm">
                        <h4 class="mb-3">Order Summary</h4>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <p class="mb-1"><strong>Order ID:</strong> #orderItem.orderId#</p>
                            <p class="mb-1"><strong>Date:</strong> #dateTimeFormat(orderItem.orderDate.toString())#</p>
                            <p class="mb-1"><strong>Ordered By:</strong> <span class="">#orderItem.firstName# #orderItem.lastName#</span></p>
                        </div>
                        <ul class="list-group mb-3">
                            <cfset productIdArray = listToArray(orderItem.productId)>
                            <cfset productImageArray = listToArray(orderItem.productImage)>
                            <cfset productNameArray = listToArray(orderItem.productName)>
                            <cfset quantityArray = listToArray(orderItem.quantity)>
                            <cfset unitPriceArray = listToArray(orderItem.unitPrice)>
                            <cfset unitTaxArray = listToArray(orderItem.unitTax)>
                            <cfloop from="1" to="#arrayLen(productIdArray)#" index="i">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center">
                                        <img src="../uploads/product#productIdArray[i]#/#productImageArray[i]#" alt="Product" class="rounded me-3" width="50" height="50">
                                        <div>
                                            <h6 class="mb-1">#productNameArray[i]#</h6>
                                            <p class="mb-0 text-muted">Qty: #quantityArray[i]# | Price: ₹#unitPriceArray[i]# | Tax: ₹#unitTaxArray[i]#</p>
                                        </div>
                                    </div>
                                    <span class="text-success fw-bold">₹#((unitPriceArray[i] + unitTaxArray[i]) * quantityArray[i])#</span>
                                </li>
                            </cfloop>
                        </ul>
                        <div class="d-flex justify-content-between">
                            <p class="mb-1">Total Price:</p>
                            <p class="mb-1">₹#orderItem.totalPrice#</p>
                        </div>
                        <div class="d-flex justify-content-between">
                            <p class="mb-1">Total Tax:</p>
                            <p class="mb-1">₹#orderItem.totalTax#</p>
                        </div>
                        <div class="d-flex justify-content-between fw-bold">
                            <p class="mb-1">Total:</p>
                            <p class="mb-1 text-success">₹#(orderItem.totalTax + orderItem.totalPrice)#</p>
                        </div>
                        <div class="d-flex justify-content-between mt-3 align-items-center">
                            <p class="mb-1"><strong>Address:</strong> #orderItem.addressLine1#, #orderItem.addressLine2#, #orderItem.city#, #orderItem.state# - #orderItem.pincode#</p>
                            <button class="btn btn-primary">Download Invoice</button>
                        </div>
                    </div>
                </cfloop>
            </div>
            
        </main>
    </cfoutput>
    <footer class="mt-5 w-100">
        
    </footer>
    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/user.js"></script>
</body>
</html>
