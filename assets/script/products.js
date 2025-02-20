$(document).ready(function () {
    // Logout
    $('#logoutCategory').on('click', function () {
        Swal.fire({
            title: "Are you sure?",
            text: "You will be logged out.",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#d33",
            cancelButtonColor: "#3085d6",
            confirmButtonText: "Yes, logout!"
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: "../components/userLogin.cfc?method=logout",
                    method: "POST",
                    success: function () {
                        Swal.fire({
                            title: "Logged Out!",
                            text: "You have been logged out successfully.",
                            icon: "success",
                            timer: 1500,
                            showConfirmButton: false
                        }).then(() => {
                            window.location.href = "userLogin.cfm";
                        });
                    }
                });
            }
        });
    });

    //productModal
    $('#addProductBtn').on('click', function(){
        const searchParams = new URLSearchParams(window.location.search);
        const categoryId = searchParams.get('categoryId');
        const subCategoryId = searchParams.get('subCategoryId');

        $('#categoryDropdown').val(categoryId);
        $('#category-error').text('');
        $('#subCategoryDropdown').val(subCategoryId);
        $('#subCategory-error').text('');
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

    $('#productImage').on('change',function(){
        const file = this.files;
        const dataTransfer = new DataTransfer();
        console.log(this.files);
    })

    $('#categoryDropdown').on('change', function() {
        var thisCategoryId = this.value;
        $.ajax({
            url: "../components/productManagement.cfc?method=getSubCategory",
            method: "POST",
            data:{
                categoryId : thisCategoryId
            },
            success: function(response){
                const serverData = JSON.parse(response);
                const data = serverData.subCategory;
                $('#subCategoryDropdown').empty();
                for(let i in data){
                    const optionTag = `<option value = ${data[i].subCategoryId}>${data[i].subCategoryName}</option>`;
                    $('#subCategoryDropdown').append(optionTag);
                }
            }
        });
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
        url: "../components/productManagement.cfc?method=getSingleProduct",
        method: "POST",
        data:{
            productId : productId
        },
        success: function(product){
            const serverData = JSON.parse(product);
            const data = serverData.product[0];          
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

$("#productImage").change(function () {
    $('#productImageDiv').empty();
    const files = this.files;
    let dataTransfer = new DataTransfer();
    if (files.length > 0) {
        for (let i = 0; i < files.length; i++) {
            dataTransfer.items.add(files[i]);
            let objectURL = URL.createObjectURL(files[i]);
            let imgContainer = $(`
                <div class="img-preview${i} d-flex" data-filename="${files[i].name}">
                    <img src="${objectURL}" width="60">
                    <button class="mb-auto btn" onclick="removeFile('img-preview${i}','${files[i].name}')"><i class="fa-solid fa-xmark"></i></button>
                </div>
            `);
            $("#productImageDiv").append(imgContainer);
        }
    }
    this.files = dataTransfer.files;
});
function removeFile(parentDiv,fileName) {
    const files = $('#productImage')[0].files;
    let dataTransfer = new DataTransfer();
    for (let i = 0; i < files.length; i++) {
        if (files[i].name !== fileName) {  
            dataTransfer.items.add(files[i]);
        }
    }
    $('.'+parentDiv).remove();
    $('#productImage')[0].files = dataTransfer.files;
}

//delete Product
function deleteProduct(productId, subCategoryId) {
    Swal.fire({
        title: "Are you sure?",
        text: "You won't be able to revert this!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#3085d6",
        confirmButtonText: "Yes, delete it!"
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: "../components/productManagement.cfc?method=deleteProduct",
                method: "POST",
                data: {
                    subCategoryId: subCategoryId,
                    productId: productId
                },
                success: function () {
                    document.getElementById(productId).remove();
                    Swal.fire({
                        title: "Deleted!",
                        text: "Your product has been deleted.",
                        icon: "success",
                        timer: 2000,
                        showConfirmButton: false
                    });
                }
            });
        }
    });
}

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
    $('#category-error').text('');
    $('#subCategory-error').text('');
    $('#productName-error').text('');
    $('#productBrand-error').text('');
    $('#productDesc-error').text('');
    $('#productPrice-error').text('');
    $('#productTax-error').text('');
    $('#productImage-error').text('');
    
    let isValid = true;

    if(!categoryId){
        $('#category-error').text('Select Category Name');
        isValid = false;
    }
    if(!subCategoryId){
        $('#subCategory-error').text('Select Subcategory Name');
        isValid = false;
    }
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
    $.ajax({
        url: "../components/productManagement.cfc?method=getSingleProduct",
        method: "POST",
        data: {
            productId : thisProductId
        },
        success: function(response){
            const serverData = JSON.parse(response);
            const data = serverData.product[0];
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
                        <img src="../uploads/products/product${decryptedProductId}/${imagefileArray[i]}" class="d-block w-100 carousel-image rounded mb-2" alt="carsl-img">
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
        }
    });
}

function deleteImage(productImageId, productId) {
    Swal.fire({
        title: "Are you sure?",
        text: "This image will be permanently deleted!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d33",
        cancelButtonColor: "#3085d6",
        confirmButtonText: "Yes, delete it!"
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: "../components/productManagement.cfc?method=deleteProductImage",
                method: "POST",
                data: {
                    productImageId: productImageId,
                    productId: productId
                },
                success: function () {
                    $('#' + productImageId).remove();
                    Swal.fire({
                        title: "Deleted!",
                        text: "The image has been removed.",
                        icon: "success",
                        timer: 2000,
                        showConfirmButton: false
                    });
                }
            });
        }
    });
}

if($('#errorProductResult').length){
    const msg = $('#errorProductResult').attr("data-errorMsg")
    console.log(this)
    Swal.fire({
        title: "Warning!",
        text: msg,
        icon: "warning"
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = document.URL;
        }
    })
}