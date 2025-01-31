function handleAjaxError(xhr, status, error) {
    console.error('AJAX error:', status, error);
    alert('Something went wrong. Please try again.');
}

$(document).ready(function () {
    $('#saveCategory').prop("disabled", true);
    $('#saveSubCategory').prop("disabled", true);
    // Logout
    $('#logoutCategory').on('click', function () {
        if (confirm("Logout! Are you sure?")) {
            $.ajax({
                url: "../components/userLogin.cfc?method=logout",
                method: "POST",
                success: function () {
                    window.location.reload();
                },
                error: handleAjaxError
            });
        }
    });
    $('#categoryValue').on('keyup',function () {
        if($('#categoryValue').val() == "" || $('#categoryValue').val() == $('#categoryValue').attr("defaultValue")){
            $('#saveCategory').prop("disabled", true);
        }
        else{
            $('#saveCategory').prop("disabled", false);
        }
    });

    //CategoryModal
    $('#addCategoryBtn').on('click', function () {
        $('#categoryValue').val('');
        $('#categoryModal').modal('show');
        $('#category-error').text('');
        $('#saveCategory').val('');
        $('#categoryValue').attr("defaultValue","");
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
            console.log("name : "+categoryName)
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
                    if (data.error === false) {
                        $('#category-error').text(data.message);
                        $('#category-error').addClass('text-success').removeClass('text-danger');
                        setTimeout(function() {
                            window.location.href = "categories.cfm";
                        }, 900);
                    }                     
                    else {
                        $('#category-error').text(data.message);
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
                    console.log(data)
                    if (data.error === "true") {
                        $('#category-error').text(data.message);
                        $('#category-error').addClass('text-success').removeClass('text-danger');
                        setTimeout(function() {
                            window.location.href = "categories.cfm";
                        }, 900);
                    } 
                    else{
                        $('#category-error').text(data.message);
                    }
                },
                error: handleAjaxError
            });
        }
    });

    $('#subCategoryValue').on('keyup',function () {
        if($('#subCategoryValue').val() == "" || $('#subCategoryValue').val() == $('#subCategoryValue').attr("defaultValue")){
            $('#saveSubCategory').prop("disabled", true);
        }
        else{
            $('#saveSubCategory').prop("disabled", false);
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
        $('#subCategoryValue').attr("defaultValue","");
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
                    if(data.error == false){
                        $('#subCategory-error').text(data.message);
                        $('#subCategory-error').addClass('text-success').removeClass('text-danger');
                        setTimeout(function() {
                            window.location.reload();
                        }, 900);
                    }
                    else{
                        $('#subCategory-error').text(data.message);                       
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
                    if(data.error === false){
                        $('#subCategory-error').text(data.message);
                        $('#subCategory-error').addClass('text-success').removeClass('text-danger');
                        setTimeout(function() {
                            window.location.reload();
                        }, 900);
                    }
                    else{
                        $('#subCategory-error').text(data.message);                       
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
    $('#categoryValue').val('').change();
    $.ajax({
        url: "../components/productManagement.cfc?method=getCategory",
        method: "POST",
        data:{
            categoryId : categoryId
        },
        success: function(getCategoryData){
            const data = JSON.parse(getCategoryData);
            console.log(data);
            if(data.error == true){
                $('#category-error').text(data.message);
            }
            else{
                $('#categoryValue').val(data.category[0].categoryName);
                $('#categoryValue').attr("defaultValue",data.category[0].categoryName);
                $('#categoryModal').modal('show'); 
                $('#saveCategory').val(data.category[0].categoryId);
            }
        },
        error: handleAjaxError
    });
}

//delete Category
function deleteCategory(categoryId,divId){
    console.log(categoryId)
    if(confirm("Delete! Are you sure?")){
        $.ajax({
            type: "POST",
            url: "../components/productManagement.cfc?method=deleteCategory",
            data: {
                categoryId : categoryId
            },
            success: function() {
                $(`#${divId}`).remove();
            }
        });
    }     
}

//view on edit subCategory
function editSubCategory(subCategoryId,categoryId){
    $('#subCategory-error').text('');
    $.ajax({
        url: "../components/productManagement.cfc?method=getSubCategory",
        method: "POST",
        data:{
            subCategoryId : subCategoryId,
            categoryId : categoryId
        },
        success: function(getSubCategoryData){
            const data = JSON.parse(getSubCategoryData);
            console.log(data.subCategory[0]);
            $('#categoryDropdown').val(data.subCategory[0].categoryId);
            $('#subCategoryValue').val(data.subCategory[0].subCategoryName);
            $('#saveSubCategory').val(data.subCategory[0].subCategoryId);
            $('#subCategoryValue').attr("defaultValue",data.subCategory[0].subCategoryName);
            $('#subCategoryModal').modal('show');
        },
        error: handleAjaxError
    });
}

//delete SubCategory
function deleteSubCategory(subCategoryId,categoryId,divId){
    if(confirm("Delete! Are you sure?")){
        $.ajax({
            type: "POST",
            url: "../components/productManagement.cfc?method=deleteSubCategory",
            data: {
                subCategoryId : subCategoryId,
                categoryId : categoryId
            },
            success: function() {
                $(`#${divId}`).remove();
            },
            error: handleAjaxError
        });
    }     
}