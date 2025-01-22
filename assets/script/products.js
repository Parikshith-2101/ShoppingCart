$(document).ready(function () {
    // Logout
    $('#logoutCategory').on('click', function () {
        if (confirm("Logout! Are you sure?")) {
            $.ajax({
                url: "../components/userLogin.cfc?method=logout",
                method: "POST",
                success: function () {
                    window.location.href = "adminLogin.cfm";
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
                    $('#subCategoryDropdown').empty();
                    for(let i in serverData.categoryId){
                        const optionTag = `<option value = ${serverData.subCategoryId[i]}>${serverData.subCategoryName[i]}</option>`;
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
        success: function(viewSubCategoryData){
            const data = JSON.parse(viewSubCategoryData);
            console.log(data);
            $('#categoryDropdown').val(categoryId);
            $('#subCategoryDropdown').val(subCategoryId);
            $('#productName').val(data.productName);
            $('#productBrand').val(data.brandId);
            $('#productDesc').val(data.description);
            $('#productPrice').val(data.unitPrice);
            $('#productTax').val(data.unitTax);
            $('#productIdHolder').val(data.productId);
            $('#productModal').modal('show');
        }
    });
}

//delete Product
function deleteProduct(productId,subCategoryId){
    if(confirm("Delete! Are you sure?")){
        $.ajax({
            url: "../components/productManagement.cfc?method=deleteProduct",
            method: "POST",
            data: {
                subCategoryId : subCategoryId,
                productId : productId
            },
            success: function() {
                $('#' + productId).remove();
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
function editImage(thisProductId){
    console.log(thisProductId)
    $.ajax({
        url: "../components/productManagement.cfc?method=getProductImage",
        method: "POST",
        data: {
            productId : thisProductId
        },
        success: function(response){
            const serverData = JSON.parse(response);
            console.log(serverData);
            $('#displayProductImage').empty();
            for(let i = 0; i < serverData.productImageId.length; i++){
                let active = "";
                let checkbox = `
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex btn btn-outline-secondary p-0 px-1 fs-12px">
                                <label class="text-nowrap me-1">Set</label>
                                <input type="radio" class="m-0 btn" name="productImageCheck" onclick="setDefaultImage(${serverData.productImageId[i]},${serverData.productId[i]})">
                            </div>
                            <button class="btn btn-outline-danger py-0 px-1 fs-12px" onclick="deleteImage(${serverData.productImageId[i]},${serverData.productId[i]})">Delete</button>
                        </div>
                    `;
                if(serverData.defaultImage[i] === 1){
                    active = "active";
                    checkbox = `
                        <div class="d-flex align-items-center p-0 btn border fs-12px">
                            <div class="text-nowrap ps-1">Current Thumbnail</div>
                            <input type="radio" name="productImageCheck" class="m-0" checked>
                        </div>
                    `;
                }
                const carouselItem = `
                    <div class="${active} carousel-imageDiv" id="${serverData.productImageId[i]}">
                        <img src="../assets/images/product${serverData.productId[i]}/${serverData.imageFile[i]}" class="d-block w-100 carousel-image rounded mb-2" alt="carsl-img">
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