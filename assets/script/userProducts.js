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
                document.getElementById(`${cartId}`).remove();
                let totalPrice = 0;
                let totalTax = 0;
                let totalAmount = 0;
                for(let i = 0; i < Data.getCartData.length ; i++){
                    totalPrice += Data.getCartData[i].unitPrice * Data.getCartData[i].quantity;
                    totalTax += Data.getCartData[i].unitTax * Data.getCartData[i].quantity;
                    totalAmount += (Data.getCartData[i].unitPrice + Data.getCartData[i].unitTax) * Data.getCartData[i].quantity;
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
    const removebtn = document.getElementById(`removeBtn${productId}`);
    removebtn.disabled = false;
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
            if (Data.error === true) {
                removebtn.disabled = true;
            }
            let totalPrice = 0;
            let totalTax = 0;
            let totalAmount = 0;
            for(let i = 0; i < Data.getCartData.length ; i++){
                totalPrice += Data.getCartData[i].unitPrice * Data.getCartData[i].quantity;
                totalTax += Data.getCartData[i].unitTax * Data.getCartData[i].quantity;
                totalAmount += (Data.getCartData[i].unitPrice + Data.getCartData[i].unitTax) * Data.getCartData[i].quantity;
                document.getElementById(`quantity${Data.getCartData[i].productId}`).value = Data.getCartData[i].quantity;
                document.getElementById(`price${Data.getCartData[i].productId}`).textContent = Data.getCartData[i].quantity*(Data.getCartData[i].unitPrice + Data.getCartData[i].unitTax);
            }
            $('.totalPriceDiv').text(totalPrice);
            $('.totalTaxDiv').text(totalTax);
            $('.totalAmountDiv').text(totalAmount);
        }
    });
}
