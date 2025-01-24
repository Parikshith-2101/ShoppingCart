function updateMainImage(imageElement) {
    console.log(imageElement)
    const mainImage = $('#mainImage');
    const thumbnails = $('.product-images img');   
    thumbnails.removeClass('active');  
    $(imageElement).addClass('active'); 
    mainImage.attr('src', $(imageElement).attr('src'));
}
function deleteCartItem(cartId){
    if(confirm("Remove! Are you sure?")){
        $.ajax({
            url: "../components/productManagement.cfc?method=deleteCart",
            method: "POST",
            data: {
                cartId : cartId
            },
            success: function(response) {
                const Data = JSON.parse(response);
                console.log(Data)
                $('#' + cartId).remove();
                let totalPrice = 0;
                let totalTax = 0;
                let totalAmount = 0;
                for(let i = 0; i < Data.getCartData.cartId.length ; i++){
                    totalPrice += Data.getCartData.unitPrice[i] * Data.getCartData.quantity[i];
                    totalTax += Data.getCartData.unitTax[i] * Data.getCartData.quantity[i];
                    totalAmount += (Data.getCartData.unitPrice[i] + Data.getCartData.unitTax[i]) * Data.getCartData.quantity[i];
                }
                $('.cart-quantity').text(Data.cartQuantity);
                $('.totalPriceDiv').text(totalPrice);
                $('.totalTaxDiv').text(totalTax);
                $('.totalAmountDiv').text(totalAmount);
            }
        });
    }
}

function modifyQuantity(productId,modifyStatus){
    $(`#removeBtn${productId}`).prop("disabled", false);
    $.ajax({
        url: "../components/productManagement.cfc?method=modifyQuantity",
        method: "POST",
        data: {
            productId : productId,
            modifyStatus : modifyStatus
        },
        success: function(response) {
            const Data = JSON.parse(response);
            console.log(Data);
            if (Data.error === "false") {
                $(`#removeBtn${productId}`).prop("disabled", true);
            }
            let totalPrice = 0;
            let totalTax = 0;
            let totalAmount = 0;
            for(let i = 0; i < Data.getCartData.cartId.length ; i++){
                totalPrice += Data.getCartData.unitPrice[i] * Data.getCartData.quantity[i];
                totalTax += Data.getCartData.unitTax[i] * Data.getCartData.quantity[i];
                totalAmount += (Data.getCartData.unitPrice[i] + Data.getCartData.unitTax[i]) * Data.getCartData.quantity[i];
                $(`#quantity${Data.getCartData.productId[i]}`).val(Data.getCartData.quantity[i]);
            }
            $('.totalPriceDiv').text(totalPrice);
            $('.totalTaxDiv').text(totalTax);
            $('.totalAmountDiv').text(totalAmount);
        }
    });
}
