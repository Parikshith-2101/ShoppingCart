<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Checkout</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/home.css">    
    <link rel="stylesheet" href="../assets/style/Cart.css">    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
    <header>
        <cfinclude template="userHeader.cfm">
    </header>
    <cfoutput>
        <cfset addressArray = application.productManagementObj.getAddress()>
        <cfif structKeyExists(url, "productId")>
            <cfset cartArray = application.cartObj.getCartDetails(productId = url.productId)>
            <cfif arrayIsEmpty(cartArray.cart)>
                <cfset addToCartResult = application.cartObj.manageCart(
                    productId = url.productId,
                    modifyStatus = "add"
                )>
                <cfset cartArray = application.cartObj.getCartDetails(productId = url.productId)>
            </cfif>
        <cfelse>    
            <cfset cartArray = application.cartObj.getCartDetails()>
        </cfif>
        <form method="post">
            <main>
                <div class="main-container">
                    <div class="d-flex w-100">
                        <div class="accordion container-left" id="checkoutAccordion">
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingAddress">
                                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="##collapseAddress" aria-expanded="false" aria-controls="collapseAddress">
                                        📍 Shipping Address
                                    </button>
                                </h2>
                                <div id="collapseAddress" class="accordion-collapse collapse show" aria-labelledby="headingAddress" data-bs-parent="##checkoutAccordion">
                                    <cfloop array="#addressArray.address#" index="i" item="addressItem">
                                        <div class="d-flex addressDiv border" onclick="this.querySelector('input[type=radio]').checked = true">
                                            <cfif i EQ 1>
                                                <cfset checked = "checked">
                                            <cfelse>
                                                <cfset checked = "">
                                            </cfif>
                                            <input type="radio" class="ms-3" name="addressRadio" value="#addressItem.addressId#" #checked#>
                                            <div class="accordion-body">
                                                <h6 class="fw-bold">#addressItem.firstName# #addressItem.lastName#</h6>
                                                <p class="mb-1">#addressItem.addressLine1#, #addressItem.addressLine2#</p>
                                                <p class="mb-1">#addressItem.city#, #addressItem.state# - #addressItem.pincode#</p>
                                                <p class="mb-1"><strong>Phone:</strong> #addressItem.phone#</p>
                                            </div>
                                        </div>
                                    </cfloop>
                                    <div class="d-flex">
                                        <button class="mx-auto btn btn-secondary" type="button" data-bs-toggle="collapse" data-bs-target="##collapseOrder" aria-expanded="true" aria-controls="collapseOrder">Next</button>
                                    </div>
                                </div>
                            </div>
                        
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingOrder">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="##collapseOrder" aria-expanded="true" aria-controls="collapseOrder">
                                        🛒 Order Summary
                                    </button>
                                </h2>
                                <div id="collapseOrder" class="accordion-collapse collapse" aria-labelledby="headingOrder" data-bs-parent="##checkoutAccordion">
                                    <div class="accordion-body pb-0">
                                        <ul class="list-group">
                                            <cfset totalPrice = 0>
                                            <cfset totalTax = 0>
                                            <cfset totalAmount = 0>
                                            <cfloop array="#cartArray.cart#" item="cartItem">
                                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                                    <div class="d-flex align-items-center">
                                                        <input type="hidden" name="productId" value="#cartItem.productId#">
                                                        <cfset decryptedProductId = application.productManagementObj.decryptData(data = cartItem.productId)>
                                                        <img src="../uploads/products/product#decryptedProductId#/#cartItem.imageFile#" alt="Product" class="rounded me-3" width="50" height="50">
                                                        <div>
                                                            <h6 class="mb-2">#cartItem.ProductName#</h6>
                                                            <div class="d-flex align-items-center w-50">
                                                                <button type="button" id="removeBtn#cartItem.productId#" class="btn p-0 px-2 border-secondary" onclick="modifyQuantity('#cartItem.productId#','remove')">-</button>
                                                                <input type="text" id="quantity#cartItem.productId#" name="productQuantity" value="#cartItem.quantity#" class="w-25 text-center border-0">
                                                                <button type="button" class="btn p-0 px-2 border-secondary" onclick="modifyQuantity('#cartItem.productId#','add')">+</button>
                                                            </div>
                                                            <p class="my-1 text-muted">Price: ₹#cartItem.unitPrice#</p>
                                                            <input type="hidden" name="unitPrice" value="#cartItem.unitPrice#">
                                                            <p class="mb-0 text-muted">Tax: ₹#cartItem.unitTax#</p>
                                                            <input type="hidden" name="unitTax" value="#cartItem.unitTax#">
                                                        </div>
                                                    </div>
                                                    <div class="fw-bold">₹ <span id="price#cartItem.productId#">#numberFormat((cartItem.quantity*(cartItem.unitPrice + cartItem.unitTax)), "0.00")#</span></div>
                                                </li>
                                                <cfset totalPrice += (cartItem.unitPrice * cartItem.quantity)>
                                                <cfset totalTax += (cartItem.unitTax * cartItem.quantity)>
                                                <cfset totalAmount += (cartItem.unitPrice + cartItem.unitTax) * cartItem.quantity>   
                                            </cfloop>                  
                                            <input type="hidden" value="#totalPrice#" name="totalPrice">         
                                            <input type="hidden" value="#totalTax#" name="totalTax">         
                                        </ul>
                                        <div class="d-flex">
                                            <button class="mx-auto btn btn-secondary" type="button" data-bs-toggle="collapse" data-bs-target="##collapsePrice" aria-expanded="true" aria-controls="collapsePrice">Next</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingPrice">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="##collapsePrice" aria-expanded="true" aria-controls="collapsePrice">
                                        💰 Payment Methods
                                    </button>
                                </h2>
                                <div id="collapsePrice" class="accordion-collapse collapse" aria-labelledby="headingPrice" data-bs-parent="##checkoutAccordion">
                                    <div class="accordion-body">
                                        <div class="d-flex flex-column">
                                            <div class="mb-2">                                                
                                                <label for="cardName" class="form-label">Cardholder Name:</label>
                                                <input type="text" id="cardName" name="cardName" class="form-control" required 
                                                    oninput="this.value = this.value.replace(/[^a-zA-Z\s]/g, '')"
                                                    placeholder="Andrew Paulson">
                                            </div> 
                                            <div class="mb-2">
                                                <label for="cardNumber" class="form-label">Card Number:</label>
                                                <input type="tel" id="cardNumber" name="cardNumber" class="form-control" maxlength="14" 
                                                    pattern="[0-9\s]{13,15}" required
                                                    oninput="this.value = this.value.replace(/\D/g, '').replace(/(\d{4})/g, '$1 ').trim(); 
                                                        if (this.value.endsWith(' ')) { this.value = this.value.slice(0, -1); } 
                                                        this.value = this.value.slice(0, 15);"
                                                    placeholder="1234 5678 9012">
                                            </div>   
                                            <div class="d-flex align-items-center my-2">
                                                <div id="expiryDateDiv" class="w-50">
                                                    <div class="d-flex align-items-center me-3">
                                                        <label for="expiryDate" class="form-label text-nowrap me-2">Expiry Date (MM/YY):</label>
                                                        <input type="text" id="expiryDate" name="expiryDate" class="form-control mb-2" required 
                                                            pattern="(0[1-9]|1[0-2])\/([0-9]{2})"
                                                            oninput="this.value = this.value.replace(/[^0-9\/]/g, '').replace(/^(\d{2})(\d)/, '$1/$2').slice(0,5)"
                                                            placeholder="MM/YY">
                                                    </div>
                                                </div>
                                                <div id="cvvDiv" class="w-50">
                                                    <div class="d-flex align-items-center">
                                                        <label for="cvv" class="form-label me-2">CVV:</label>
                                                        <input type="tel" id="cvv" name="cvv" class="form-control mb-2" maxlength="3" required 
                                                            pattern="[0-9]{3,4}"
                                                            oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                                            placeholder="123">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="confirmPaymentDiv">
                                            <button class="mx-auto btn btn-info" id="confirmPayment" type="button">Confirm To Pay ₹ #totalAmount#</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card-order">
                                <div class="button"><button type="submit" name="placeOrderBtn" class="btn btn-success w-100 placeOrderBtn" disabled>✅ Place Order</button></div>
                            </div>
                        </div>
                        <div class="container-right">
                            <div class="card-right">
                                <p class="title">PRICE DETAILS</p>
                                <div class="checkoutDiv">
                                    <div class="checkout">
                                        <p class="price">Price</p>
                                        <p class="number">
                                            <i class="fa-solid fa-indian-rupee-sign"></i> 
                                            <span class="totalPriceDiv">#numberFormat(totalPrice, "0.00")#</span>
                                        </p>
                                    </div>
                                    <div class="checkout">
                                        <p class="price">Total Tax</p>
                                        <p class="number">
                                            <span class="green">
                                                <i class="fa-solid fa-indian-rupee-sign"></i>
                                                <span class="totalTaxDiv">#numberFormat(totalTax, "0.00")#</span>
                                            </span>
                                        </p>
                                    </div>
                                    <div class="final d-flex">
                                        <p class="bold">Total Amount</p>
                                        <p class="number">
                                            <i class="fa-solid fa-indian-rupee-sign"></i>
                                            <span class="totalAmountDiv">#numberFormat(totalAmount, "0.00")#</span>
                                        </p>
                                    </div>
                                </div>
                                <div class="bottom-text d-flex">
                                    <img src="../assets/images/designImages/shield.svg" alt="shield" width="31" height="38">
                                    <p>Safe and Secure Payments.Easy returns.100% Authentic products.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </form>
        <cfif structKeyExists(form, "placeOrderBtn")>
            <cfset placeOrderResult = application.cartObj.placeOrder(
                addressId = form.addressRadio,
                cardNumber = form.cardNumber,
                cvv = form.cvv,
                totalPrice = form.totalPrice,
                totalTax = form.totalTax,
                productId = form.productId,
                quantity = form.productQuantity,
                unitPrice = form.unitPrice,
                unitTax = form.unitTax
            )>
            <cfif placeOrderResult.error EQ false>
                <div id="orderSuccessMessage"></div>
            <cfelse>
                <div id="orderErrorMessage" data-errorMessage="#placeOrderResult.message#"></div>
            </cfif>
        </cfif>
    </cfoutput>
    <footer class="mt-5 w-100"></footer>
    
    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/user.js"></script>
    <script src="../assets/script/userProducts.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>
