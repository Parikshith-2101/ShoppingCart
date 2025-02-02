function handleAjaxError(xhr, status, error) {
    console.error('AJAX error:', status, error);
    alert('Something went wrong. Please try again.');
}

$(document).ready(function () {
    // Logout
    $('#logoutCategory').on('click', function () {
        if (confirm("Logout! Are you sure?")) {
            $.ajax({
                url: "../components/userLogin.cfc?method=logout",
                method: "POST",
                success: function () {
                    window.location.href = "adminLogin.cfm";
                },
                error: handleAjaxError
            });
        }
    });

    //CategoryModal
    $('#addCategoryBtn').on('click', function () {
        $('#categoryValue').val('');
        $('#categoryModal').modal('show');
        $('#category-error').text('');
        $('#saveCategory').val('');
    });

    //saveCategory
    $('#saveCategory').on('click', function () {
        const categoryName = $('#categoryValue').val();
        const categoryId = $('#saveCategory').val();
        $('#category-error').addClass('text-danger').removeClass('text-success');
        $('#category-error').text('');
        if(!categoryName){
            $('#category-error').text('Enter Catergory Name');
            return;
        }
        if(categoryId.trim()){
            //edit
            $.ajax({
                url: "../components/productManagement.cfc?method=editCategory",
                method: "POST",
                data: {
                    categoryId : categoryId,
                    categoryName : categoryName
                },
                success: function(editCategoryData){
                    const data = JSON.parse(editCategoryData);
                    console.log(data);
                    if (data.errorStatus === "true") {
                        $('#category-error').text(data.resultMsg);
                        $('#category-error').addClass('text-success').removeClass('text-danger');
                        setTimeout(function() {
                            window.location.href = "categories.cfm";
                        }, 900);
                    }                     
                    else if(data.errorStatus === "nill") {
                        $('#categoryModal').modal('hide');
                    }
                    else {
                        $('#category-error').text(data.resultMsg);
                    }
                },
                error: handleAjaxError
            });
        }
        else{
            //create
            $.ajax({
                url: "../components/productManagement.cfc?method=addCategory",
                method: "POST",
                data:{
                    categoryName : categoryName
                },
                success: function (categoryServerResponse) {
                    const data = JSON.parse(categoryServerResponse);
                    if (data.errorStatus === "true") {
                        $('#category-error').text(data.resultMsg);
                        $('#category-error').addClass('text-success').removeClass('text-danger');
                        setTimeout(function() {
                            window.location.href = "categories.cfm";
                        }, 900);
                    } 
                    else{
                        $('#category-error').text(data.resultMsg);
                    }
                },
                error: handleAjaxError
            });
        }
    });

    //SubCategoryModal
    $('#addSubCategoryBtn').on('click', function () {
        $('#subCategoryValue').val('');
        $('#subCategoryModal').modal('show');
        $('#subCategory-error').text('');
        $('#saveSubCategory').val('');
        const searchParams = new URLSearchParams(window.location.search);
        const categoryId = searchParams.get('categoryId');
        $('#categoryDropdown').val(categoryId);
    });

    //saveSubCategory
    $('#saveSubCategory').on('click', function () {
        const subCategoryName = $('#subCategoryValue').val();
        const newCategoryId = $('#categoryDropdown').val();

        const searchParams = new URLSearchParams(window.location.search);
        const oldCategoryId = searchParams.get('categoryId')

        const subCategoryId = $('#saveSubCategory').val();
        $('#subCategory-error').addClass('text-danger').removeClass('text-success');
        if(!newCategoryId){
            $('#subCategory-error').text('Select Category');
            return;
        }
        if(!subCategoryName){
            $('#subCategory-error').text('Enter SubCatergory Name');
            return;
        }
        if(!subCategoryId){
            //create
            $.ajax({
                url: "../components/productManagement.cfc?method=addSubCategory",
                method: "POST",
                data: {
                    subCategoryName : subCategoryName,
                    categoryId : newCategoryId
                },
                success: function(response){
                    const data = JSON.parse(response);
                    console.log(data);
                    if(data.errorStatus == "true"){
                        $('#subCategory-error').text(data.resultMsg);
                        $('#subCategory-error').addClass('text-success').removeClass('text-danger');
                        setTimeout(function() {
                            window.location.reload();
                        }, 900);
                    }
                    else{
                        $('#subCategory-error').text(data.resultMsg);                       
                    }
                },
                error: handleAjaxError
            });
        }
        else{
            //edit
            $.ajax({
                url: "../components/productManagement.cfc?method=editSubCategory",
                method: "POST",
                data: {
                    subCategoryId : subCategoryId,
                    subCategoryName : subCategoryName,
                    categoryId : oldCategoryId,
                    newCategoryId : newCategoryId
                },
                success : function(response){
                    const data = JSON.parse(response);
                    console.log(data);
                    if(data.errorStatus === "true"){
                        $('#subCategory-error').text(data.resultMsg);
                        $('#subCategory-error').addClass('text-success').removeClass('text-danger');
                        setTimeout(function() {
                            window.location.reload();
                        }, 900);
                    }
                    else if(data.errorStatus === "nill"){
                        $('#subCategoryModal').modal('hide');
                    }
                    else{
                        $('#subCategory-error').text(data.resultMsg);                       
                    }
                },
                error: handleAjaxError
            });
        }
    });
});

//view on edit Category
function editCategory(categoryId){
    $('#category-error').text('');
    $.ajax({
        url: "../components/productManagement.cfc?method=viewCategory",
        method: "POST",
        data:{
            categoryId : categoryId
        },
        success: function(viewCategoryData){
            const data = JSON.parse(viewCategoryData);
            console.log(data);
            $('#categoryValue').val(data.categoryName);
            $('#categoryModal').modal('show'); 
            $('#saveCategory').val(data.categoryId);
        }
    });
}

//delete Category
function deleteCategory(categoryId){
    if(confirm("Delete! Are you sure?")){
        $.ajax({
            type: "POST",
            url: "../components/productManagement.cfc?method=deleteCategory",
            data: {
                categoryId : categoryId
            },
            success: function() {
                $('#' + categoryId).remove();
            },
        });
    }     
}

//view on edit subCategory
function editSubCategory(subCategoryId,categoryId){
    $('#subCategory-error').text('');
    $.ajax({
        url: "../components/productManagement.cfc?method=viewSubCategory",
        method: "POST",
        data:{
            subCategoryId : subCategoryId,
            categoryId : categoryId
        },
        success: function(viewSubCategoryData){
            const data = JSON.parse(viewSubCategoryData);
            console.log(data);
            $('#subCategoryValue').val(data.subCategoryName);
            $('#saveSubCategory').val(data.subCategoryId);
            $('#categoryDropdown').val(data.categoryId);
            $('#subCategoryModal').modal('show');
        },
        error: handleAjaxError
    });
}

//delete SubCategory
function deleteSubCategory(subCategoryId,categoryId){
    if(confirm("Delete! Are you sure?")){
        $.ajax({
            type: "POST",
            url: "../components/productManagement.cfc?method=deleteSubCategory",
            data: {
                subCategoryId : subCategoryId,
                categoryId : categoryId
            },
            success: function() {
                $('#' + subCategoryId).remove();
            },
            error: handleAjaxError
        });
    }     
}