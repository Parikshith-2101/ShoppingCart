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
    <main>
        <div class="container mt-5">
            <div class="card p-4 shadow-sm">
                <h4 class="mb-3">Order Summary</h4>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <p class="mb-1"><strong>Order ID:</strong> #orderItem.orderId#</p>
                        <p class="mb-1"><strong>Date:</strong> #orderItem.orderDate#</p>
                        <p class="mb-1"><strong>Status:</strong> <span class="badge bg-success">#orderItem.orderStatus#</span></p>
                    </div>
                    <button class="btn btn-outline-primary">Track Order</button>
                </div>
                <ul class="list-group mb-3">

                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                            <img src="#product.image#" alt="Product" class="rounded me-3" style="width: 50px; height: 50px;">
                            <div>
                                <h6 class="mb-1">#product.name#</h6>
                                <p class="mb-0 text-muted">Qty: #product.quantity# | Price: ₹#product.price#</p>
                            </div>
                        </div>
                        <span class="text-success fw-bold">₹#(product.price * product.quantity)#</span>
                    </li>

                </ul>
                <div class="d-flex justify-content-between">
                    <p class="mb-1">Subtotal:</p>
                    <p class="mb-1">₹#orderItem.subtotal#</p>
                </div>
                <div class="d-flex justify-content-between">
                    <p class="mb-1">Shipping:</p>
                    <p class="mb-1">₹#orderItem.shipping#</p>
                </div>
                <div class="d-flex justify-content-between fw-bold">
                    <p class="mb-1">Total:</p>
                    <p class="mb-1 text-success">₹#orderItem.total#</p>
                </div>
                <div class="d-flex justify-content-end mt-3">
                    <button class="btn btn-danger me-2" onclick="cancelOrder('#orderItem.orderId#')">Cancel Order</button>
                    <button class="btn btn-primary">Download Invoice</button>
                </div>
            </div>
        </div>
        
    </main>
    <footer class="mt-5 w-100">
        
    </footer>
    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/user.js"></script>
</body>
</html>
