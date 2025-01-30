$(document).ready(function () {
    // Logout
    $('#logoutCategory').on('click', function () {
        if (confirm("Logout! Are you sure?")) {
            $.ajax({
                url: "../components/userLogin.cfc?method=logout",
                method: "POST",
                success: function () {
                    window.location.reload();
                }
            });
        }
    });
    //productModal
    $('#addProductBtn').on('click', function(){
        const searchParams = new URLSearchParams(window.location.search);
        const categoryId = searchParams.get('categoryId');
        const subCategoryId = searchParams.get('subCategoryId');
        $('#categoryDropdown').on('change', function() {
            var thisCategoryId = this.value;
            console.log(thisCategoryId);
            $.ajax({
                url: "../components/productManagement.cfc?method=getSubCategory",
                method: "POST",
                data:{
                    categoryId : thisCategoryId
                },
                success: function(response){
                    const serverData = JSON.parse(response);
                    const data = serverData.subCategory;
                    console.log(data)
                    $('#subCategoryDropdown').empty();
                    for(let i in data){
                        const optionTag = `<option value = ${data[i].subCategoryId}>${data[i].subCategoryName}</option>`;
                        $('#subCategoryDropdown').append(optionTag);
                    }
                }
            });
        });
        $('#categoryDropdown').val(categoryId);
        $('#subCategoryDropdown').val(subCategoryId);
        $('#productName').val('');
        $('#productName-error').text('');
        $('#productBrand').val('');
        $('#productBrand-error').text('');
        $('#productDesc').val('');
        $('#productDesc-error').text('');
        $('#productPrice').val('');
        $('#productPrice-error').text('');
        $('#productTax').val('');
        $('#productTax-error').text('');
        $('#productImage').val('');
        $('#productImage-error').text('');
        $('#saveProduct').val('');
        $('#productIdHolder').val('');
        $('#productModal').modal('show');
    });
});

//view productmodal
function editProduct(productId,subCategoryId,categoryId){
    $('#productName-error').text('');
    $('#productBrand-error').text('');
    $('#productDesc-error').text('');
    $('#productPrice-error').text('');
    $('#productTax-error').text('');
    $('#productImage-error').text('');
    $.ajax({
        url: "../components/productManagement.cfc?method=getProduct",
        method: "POST",
        data:{
            subCategoryId : subCategoryId,
            productId : productId
        },
        success: function(product){
            const serverData = JSON.parse(product);
            const data = serverData.product;
            console.log(data);
            $('#categoryDropdown').val(categoryId);
            $('#subCategoryDropdown').val(subCategoryId);
            $('#productName').val(data[0].productName);
            $('#productBrand').val(data[0].brandId);
            $('#productDesc').val(data[0].description);
            $('#productPrice').val(data[0].unitPrice);
            $('#productTax').val(data[0].unitTax);
            $('#productIdHolder').val(data[0].productId);
            $('#productModal').modal('show');
        }
    });
}

//delete Product
function deleteProduct(productId,subCategoryId,divId){
    if(confirm("Delete! Are you sure?")){
        $.ajax({
            url: "../components/productManagement.cfc?method=deleteProduct",
            method: "POST",
            data: {
                subCategoryId : subCategoryId,
                productId : productId
            },
            success: function() {
                $(`#${divId}`).remove();
            }
        });
    }     
}

$(document).on("click", function(){
    $(".errorServerSide").hide();
});

function productValidation(event){
    const categoryId = $('#categoryDropdown').val();
    const subCategoryId = $('#subCategoryDropdown').val();
    const productName = $('#productName').val();
    const productBrand = $('#productBrand').val();
    const productDesc = $('#productDesc').val();
    const productPrice = $('#productPrice').val();
    const productTax = $('#productTax').val();
    const productImage = $('#productImage').val();
    const productId = $('#productIdHolder').val();
    $('#productName-error').text('');
    $('#productBrand-error').text('');
    $('#productDesc-error').text('');
    $('#productPrice-error').text('');
    $('#productTax-error').text('');
    $('#productImage-error').text('');
    
    let isValid = true;
    if(!productName){
        $('#productName-error').text('Enter Product Name');
        isValid = false;
    }
    if(!productBrand){
        $('#productBrand-error').text('Enter Product Brand');
        isValid = false;
    }     
    if(!productDesc){
        $('#productDesc-error').text('Enter Product Desc');
        isValid = false;
    }     
    if(!productPrice){
        $('#productPrice-error').text('Enter Product Price');
        isValid = false;
    }     
    if(!productTax){
        $('#productTax-error').text('Enter Product Tax');
        isValid = false;
    }
    if(!productId){
        if(!productImage){
            $('#productImage-error').text('Choose Image File');
            isValid = false;
        }
    }      
    
    return isValid;
}

//productImageModal
function editImage(thisProductId,decryptedProductId){
    console.log(thisProductId)
    $.ajax({
        url: "../components/productManagement.cfc?method=getSingleProduct",
        method: "POST",
        data: {
            productId : thisProductId
        },
        success: function(response){
            const serverData = JSON.parse(response);
            const data = serverData.product[0];
            console.log(data);
            const imageIdArray = data.productImageId.split(',');
            const imagefileArray = data.imageFile.split(',');
            const defaultArray = data.defaultImage.split(',');
            $('#displayProductImage').empty();
            for(let i = 0; i < imageIdArray.length; i++){
                let active = "";
                let checkbox = `
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex btn btn-outline-secondary p-0 px-1 fs-12px">
                                <label class="text-nowrap me-1">Set</label>
                                <input type="radio" class="m-0 btn" name="productImageCheck" onclick="setDefaultImage('${imageIdArray[i]}','${data.productId}')">
                            </div>
                            <button class="btn btn-outline-danger py-0 px-1 fs-12px" onclick="deleteImage('${imageIdArray[i]}','${data.productId}')">Delete</button>
                        </div>
                    `;
                if(defaultArray[i] === '1'){
                    active = "active";
                    checkbox = `
                        <div class="d-flex align-items-center p-0 btn border fs-12px">
                            <div class="text-nowrap ps-1">Current Thumbnail</div>
                            <input type="radio" name="productImageCheck" class="m-0" checked>
                        </div>
                    `;
                }
                const carouselItem = `
                    <div class="${active} carousel-imageDiv" id="${imageIdArray[i]}">
                        <img src="../uploads/product${decryptedProductId}/${imagefileArray[i]}" class="d-block w-100 carousel-image rounded mb-2" alt="carsl-img">
                        ${checkbox}
                    </div>
                `;
                $('#displayProductImage').append(carouselItem);
            }
            $('#productImageModal').modal('show');
        }
    }); 
}

function setDefaultImage(productImageId,productId){
    $.ajax({
        url: "../components/productManagement.cfc?method=setDefaultProductImage",
        method: "POST",
        data: {
            productImageId : productImageId,
            productId : productId
        },
        success: function(){
            
        }
    });
}

function deleteImage(productImageId,productId){
    console.log(productImageId , productId)
    if(confirm("Delete! Are you sure?")){
        $.ajax({
            url: "../components/productManagement.cfc?method=deleteProductImage",
            method: "POST",
            data: {
                productImageId : productImageId,
                productId : productId
            },
            success: function() {
                $('#' + productImageId).remove();
            }
        });
    } 
}