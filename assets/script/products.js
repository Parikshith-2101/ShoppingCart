$(document).ready(function () {
    //productModal
    $('#addProductBtn').on('click', function(){
        const searchParams = new URLSearchParams(window.location.search);
        const categoryId = searchParams.get('categoryId');
        const subCategoryId = searchParams.get('subCategoryId');
        $('#categoryDropdown').on('change', function() {
            var thisCategoryId = this.value;
            console.log(thisCategoryId);
            $.ajax({
                url: "../components/shoppingCart.cfc?method=qrySubCategoryData",
                method: "POST",
                data:{
                    categoryId : thisCategoryId
                },
                success: function(response){
                    const serverData = JSON.parse(response);
                    $('#subCategoryDropdown').empty();
                    for(let i in serverData.DATA){
                        const optionTag = `<option value = ${serverData.DATA[i][0]}>${serverData.DATA[i][2]}</option>`;
                        $('#subCategoryDropdown').append(optionTag);
                    }
                }
            });
        });
        $('#categoryDropdown').val(categoryId);
        $('#subCategoryDropdown').val(subCategoryId);
        $('#productName').val('');
        $('#productName-error').val('');
        $('#productBrand').val('');
        $('#productBrand-error').val('');
        $('#productDesc').val('');
        $('#productDesc-error').val('');
        $('#productPrice').val('');
        $('#productPrice-error').val('');
        $('#productImage').val('');
        $('#productImage-error').val('');
        $('#saveProduct').val('');
        $('#productModal').modal('show');
    });

    //saveProduct
    $('#saveProduct').on('click',function(){
        const categoryId = $('#categoryDropdown').val();
        const subCategoryId = $('#subCategoryDropdown').val();
        const productName = $('#productName').val();
        const productBrand = $('#productBrand').val();
        const productDesc = $('#productDesc').val();
        const productPrice = $('#productPrice').val();

        const fileInput = document.getElementById('productImage');
        const uploadedFiles = fileInput.files;
        const productImage = new FormData();
        for (let i = 0; i < uploadedFiles.length; i++) {
            productImage.append(`file${i + 1}`, uploadedFiles[i]);
        }

        const productId = $('#saveProduct').val();
        $('#productName-error').addClass('text-danger').removeClass('text-success');
        $('#productBrand-error').addClass('text-danger').removeClass('text-success');
        $('#productDesc-error').addClass('text-danger').removeClass('text-success');
        $('#productPrice-error').addClass('text-danger').removeClass('text-success');
        $('#productImage-error').addClass('text-danger').removeClass('text-success');
        $('#productName-error').text('');
        $('#productBrand-error').text('');
        $('#productDesc-error').text('');
        $('#productPrice-error').text('');
        $('#productImage-error').text('');
        if(!productName){
            $('#productName-error').text('Enter Product Name');
        }
        if(!productBrand){
            $('#productBrand-error').text('Enter Product Brand');
        }     
        if(!productDesc){
            $('#productDesc-error').text('Enter Product Desc');
        }     
        if(!productPrice){
            $('#productPrice-error').text('Enter Product Price');
        }     
        if(!productImage){
            $('#productImage-error').text('Choose Image File');
        } 
        /* if(!productId){
            alert("create")
            $.ajax({
                url: '../components/shoppingCart.cfc?method=addProduct',
                type: 'POST',
                data: {
                    categoryId: categoryId,
                    subCategoryId: subCategoryId,
                    productName : productName,
                    productBrand : productBrand,
                    productDesc : productDesc,
                    productPrice : productPrice,
                    productImage : productImage
                },
                success: function (serverResponse) {

                }
            });      
        } 
        else{
            alert("edit")
        }    */
    });
});