function updateMainImage(imageElement) {
    console.log(imageElement)
    const mainImage = $('#mainImage');
    const thumbnails = $('.product-images img');   
    thumbnails.removeClass('active');  
    $(imageElement).addClass('active'); 
    mainImage.attr('src', $(imageElement).attr('src'));
}
function deleteCartItem(productId){
    if(confirm("Remove! Are you sure?")){
        $.ajax({
            url: "../components/cart.cfc?method=deleteCart",
            method: "POST",
            data: {
                productId : productId
            },
            success: function() {
                document.getElementById(productId).remove();
                $.ajax({
                    url: "../components/cart.cfc?method=getCartDetails",
                    method: "POST",
                    success: function(response) {
                        const getCart = JSON.parse(response);
                        console.log(getCart)
                        let totalPrice = 0, totalTax = 0, totalAmount = 0;
                        for(let i = 0; i < getCart.cart.length ; i++){
                            totalPrice += getCart.cart[i].unitPrice * getCart.cart[i].quantity;
                            totalTax += getCart.cart[i].unitTax * getCart.cart[i].quantity;
                            totalAmount += (getCart.cart[i].unitPrice + getCart.cart[i].unitTax) * getCart.cart[i].quantity;
                        }
                        $('.cart-quantity').text(getCart.cart.length);
                        $('.totalPriceDiv').text(totalPrice.toFixed(2));
                        $('.totalTaxDiv').text(totalTax.toFixed(2));
                        $('.totalAmountDiv').text(totalAmount.toFixed(2));
                    }
                })
            }
        });
    }
}

function modifyQuantity(productId,modifyStatus){ 
    const removebtn = document.getElementById(`removeBtn${productId}`);
    removebtn.disabled = false;
    $.ajax({
        url: "../components/cart.cfc?method=modifyQuantity",
        method: "POST",
        data: {
            productId : productId,
            modifyStatus : modifyStatus
        },
        success: function(response) {
            const Data = JSON.parse(response);
            console.log(Data);
            if (Data.error === true) {
                removebtn.disabled = true;
            }
            let totalPrice = 0;
            let totalTax = 0;
            let totalAmount = 0;
            for(let i = 0; i < Data.getCartData.length ; i++){
                if(document.getElementById(`quantity${Data.getCartData[i].productId}`)){
                    totalPrice += Data.getCartData[i].unitPrice * Data.getCartData[i].quantity;
                    totalTax += Data.getCartData[i].unitTax * Data.getCartData[i].quantity;
                    totalAmount += (Data.getCartData[i].unitPrice + Data.getCartData[i].unitTax) * Data.getCartData[i].quantity;
                    document.getElementById(`quantity${Data.getCartData[i].productId}`).value = Data.getCartData[i].quantity;
                }
                if(document.getElementById(`price${Data.getCartData[i].productId}`)){
                    document.getElementById(`price${Data.getCartData[i].productId}`).textContent = (Data.getCartData[i].quantity*(Data.getCartData[i].unitPrice + Data.getCartData[i].unitTax)).toFixed(2);
                }
            }
            $('.totalPriceDiv').text(totalPrice.toFixed(2));
            $('.totalTaxDiv').text(totalTax.toFixed(2));
            $('.totalAmountDiv').text(totalAmount.toFixed(2));
        }
    });
}

$(document).ready(function () {
    const successMessage = $("#orderSuccessMessage");
    if (successMessage.length) {
        $("body").append('<div class="modal-backdrop fade show"></div>');
        setTimeout(function() {
            $(".modal-backdrop").remove();
            successMessage.hide();
            window.location.href = "userOrderDetails.cfm";
        }, 3000);
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
