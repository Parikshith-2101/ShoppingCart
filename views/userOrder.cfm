<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Checkout</title>
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
        <cfset local.addressArray = application.productManagementObj.getAddress()>
        <cfset local.cartArray = application.cartObj.getCart()>
        <main>
            <div class="products-container">
                <div class="accordion" id="checkoutAccordion">
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="headingAddress">
                            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="##collapseAddress" aria-expanded="true" aria-controls="collapseAddress">
                                📍 Shipping Address
                            </button>
                        </h2>
                        <div id="collapseAddress" class="accordion-collapse collapse show" aria-labelledby="headingAddress" data-bs-parent="##checkoutAccordion">
                            <cfloop array="#local.addressArray.address#" item="addressItem">
                                <div class="d-flex">
                                    <input type="radio" class="ms-2" name="addresRadio" value="#addressItem.addressId#">
                                    <div class="accordion-body">
                                        <h6 class="fw-bold">#addressItem.firstName# #addressItem.lastName#</h6>
                                        <p class="mb-1">#addressItem.addressLine1#, #addressItem.addressLine2#</p>
                                        <p class="mb-1">#addressItem.city#, #addressItem.state# - #addressItem.pincode#</p>
                                        <p class="mb-1"><strong>Phone:</strong> #addressItem.phone#</p>
                                    </div>
                                </div>
                            </cfloop>
                        </div>
                    </div>
                
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="headingOrder">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="##collapseOrder" aria-expanded="false" aria-controls="collapseOrder">
                                🛒 Order Summary
                            </button>
                        </h2>
                        <div id="collapseOrder" class="accordion-collapse collapse" aria-labelledby="headingOrder" data-bs-parent="##checkoutAccordion">
                            <div class="accordion-body">
                                <ul class="list-group mb-3">
                                    <cfloop array="#local.cartArray.cart#" item="cartItem">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            <div class="d-flex align-items-center">
                                                <cfset local.decryptedProductId = application.productManagementObj.decryptDetails(data = cartItem.productId)>
                                                <img src="../uploads/product#local.decryptedProductId#/#cartItem.imageFile#" alt="Product" class="rounded me-3" width="50" height="50">
                                                <div>
                                                    <h6 class="mb-1">#cartItem.ProductName#</h6>
                                                    <div class="d-flex align-items-center">
                                                        <button class="btn btn-sm btn-outline-secondary" onclick="updateQuantity('#cartItem.productId#', -1)">-</button>
                                                        <span id="quantity-#cartItem.productId#" class="mx-2">#cartItem.quantity#</span>
                                                        <button class="btn btn-sm btn-outline-secondary" onclick="updateQuantity('#cartItem.productId#', 1)">+</button>
                                                    </div>
                                                    <p class="mb-0 text-muted">Price: ₹#cartItem.unitPrice#</p>
                                                </div>
                                            </div>
                                            <span class="fw-bold" id="totalPrice-#cartItem.productId#">₹#(cartItem.unitPrice * cartItem.quantity)#</span>
                                        </li>            
                                    </cfloop>                  
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="headingPrice">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="##collapsePrice" aria-expanded="false" aria-controls="collapsePrice">
                                💰 PaymentMethods
                            </button>
                        </h2>
                        <div id="collapsePrice" class="accordion-collapse collapse" aria-labelledby="headingPrice" data-bs-parent="##checkoutAccordion">
                            <div class="accordion-body">
                                <div class="d-flex flex-column">
                                    CardNumber:<input type="tel" class="mb-1">
                                    Cvv:<input type="tel" class="mb-1">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-3 text-center">
                        <button class="btn btn-success w-100" onclick="placeOrder()">✅ Place Order</button>
                    </div>

                </div>
            </div>
        </main>
    </cfoutput>
    <footer class="mt-5 w-100"></footer>
    
    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/user.js"></script>
</body>
</html>
