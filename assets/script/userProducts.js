function updateMainImage(imageElement) {
    const mainImage = $('#mainImage');
    const thumbnails = $('.product-images img');   
    thumbnails.removeClass('active');  
    $(imageElement).addClass('active'); 
    mainImage.attr('src', $(imageElement).attr('src'));
}

function deleteCartItem(productId) {
    Swal.fire({
        title: "Are you sure?",
        text: "You won't be able to revert this!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, delete it!"
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: "../components/cart.cfc?method=deleteCart",
                method: "POST",
                data: { productId: productId },
                success: function () {
                    document.getElementById(productId).remove();
                    $.ajax({
                        url: "../components/cart.cfc?method=getCartDetails",
                        method: "POST",
                        success: function (response) {
                            const getCart = JSON.parse(response);

                            if (getCart.cart.length === 0) {
                                window.location.reload();
                                return;
                            }

                            let totalPrice = 0,
                                totalTax = 0,
                                totalAmount = 0;

                            getCart.cart.forEach(item => {
                                totalPrice += item.unitPrice * item.quantity;
                                totalTax += item.unitTax * item.quantity;
                                totalAmount += (item.unitPrice + item.unitTax) * item.quantity;
                            });

                            $(".cart-quantity").text(getCart.cart.length);
                            $(".totalPriceDiv").text(totalPrice.toFixed(2));
                            $(".totalTaxDiv").text(totalTax.toFixed(2));
                            $(".totalAmountDiv").text(totalAmount.toFixed(2));
                            Swal.fire({
                                title: "Deleted!",
                                text: "Your item has been deleted.",
                                icon: "success"
                            });
                        }
                    });
                },
            });
        }
    });
}

function modifyQuantity(productId,modifyStatus){ 
    const removebtn = document.getElementById(`removeBtn${productId}`);
    removebtn.disabled = false;
    $.ajax({
        url: "../components/cart.cfc?method=manageCart",
        method: "POST",
        data: {
            productId : productId,
            modifyStatus : modifyStatus
        },
        success: function(response) {
            const Data = JSON.parse(response);
            if (Data.error === true) {
                removebtn.disabled = true;
            }
            $.ajax({
                url: "../components/cart.cfc?method=getCartDetails",
                method: "POST",
                success: function(response) {
                    const getCart = JSON.parse(response);
                    let totalPrice = 0, totalTax = 0, totalAmount = 0;
                    for(let i = 0; i < getCart.cart.length ; i++){
                        if(document.getElementById(`quantity${getCart.cart[i].productId}`)){
                            totalPrice += getCart.cart[i].unitPrice * getCart.cart[i].quantity;
                            totalTax += getCart.cart[i].unitTax * getCart.cart[i].quantity;
                            totalAmount += (getCart.cart[i].unitPrice + getCart.cart[i].unitTax) * getCart.cart[i].quantity;
                            document.getElementById(`quantity${getCart.cart[i].productId}`).value = getCart.cart[i].quantity;
                        }
                        if(document.getElementById(`price${getCart.cart[i].productId}`)){
                            document.getElementById(`price${getCart.cart[i].productId}`).textContent = (getCart.cart[i].quantity*(getCart.cart[i].unitPrice + getCart.cart[i].unitTax)).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                        }
                    }
                    $('.totalPriceDiv').text(totalPrice.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }));
                    $('.totalTaxDiv').text(totalTax.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }));
                    $('.totalAmountDiv').text(totalAmount.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }));
                    if($('#totalPrice')){
                        $('#totalPrice').val(totalPrice);
                    }
                    if($('#totalTax')){
                        $('#totalTax').val(totalTax);
                    }
                }
            })
        }
    });
}

$(document).ready(function () {
    if ($("#orderSuccessMessage").length) {
        Swal.fire({
            title: "Good job!",
            text: "You order placed successfully!",
            icon: "success",
            showConfirmButton: false,
            footer: '<a href="userOrderDetails.cfm" class="btn btn-outline-primary">See Your Order History</a>'
        });
    }
    if($("#orderErrorMessage").length){
        const errorMsg = $("#orderErrorMessage").attr("data-errorMessage");
        Swal.fire({
            icon: "error",
            title: "Oops...",
            text: `${errorMsg}!`
        });
    }

    $('#confirmPayment').click(function () {
        const cardName = $('#cardName').val();
        const cardNumber = $('#cardNumber').val().replace(/\s+/g, '');
        const expiryDate = $('#expiryDate').val();
        const cvv = $('#cvv').val();
    
        let isValid = true;
        $('.error-message').remove();

        if (!cardName || cardName.length < 4) {
            isValid = false;
            $('#cardName').parent().append('<div class="error-message text-danger">Please enter a valid cardholder name (letters only).</div>');
        }
        if (!cardNumber || cardNumber.length < 12) {
            isValid = false;
            $('#cardNumber').parent().append('<div class="error-message text-danger">Please enter a valid card number (12 digits).</div>');
        }
 
        if (!expiryDate) {
            isValid = false;
            $('#expiryDateDiv').append('<div class="error-message text-danger">Please enter a valid expiry date (MM/YY format).</div>');
        }
    
        if (!cvv || cvv.length < 3) {
            isValid = false;
            $('#cvvDiv').append('<div class="error-message text-danger">Please enter a valid CVV (3-4 digits).</div>');
        }
    
        if (isValid) {
            $('.placeOrderBtn').prop("disabled", false);
            $('#confirmPaymentDiv').hide();
        }
    });
});
