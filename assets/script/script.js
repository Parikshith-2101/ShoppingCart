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
                    window.location.reload();
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
                    if(data.sameId === true){
                        $('#categoryModal').modal('hide');
                    }
                    else if (data.error === "true") {
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
                    if(data.error == "true"){
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
                    if(data.sameId === true){
                        $('#subCategoryModal').modal('hide');
                    }                   
                    else if(data.error === "true"){
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
    $.ajax({
        url: "../components/productManagement.cfc?method=getCategory",
        method: "POST",
        data:{
            categoryId : categoryId
        },
        success: function(getCategoryData){
            const data = JSON.parse(getCategoryData);
            console.log(data[0]);
            $('#categoryValue').val(data[0].categoryName);
            $('#categoryModal').modal('show'); 
            $('#saveCategory').val(data[0].categoryId);
        },
        error: handleAjaxError
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
        url: "../components/productManagement.cfc?method=getSubCategory",
        method: "POST",
        data:{
            subCategoryId : subCategoryId,
            categoryId : categoryId
        },
        success: function(getSubCategoryData){
            const data = JSON.parse(getSubCategoryData);
            console.log(data[0]);
            $('#categoryDropdown').val(data[0].categoryId);
            $('#subCategoryValue').val(data[0].subCategoryName);
            $('#saveSubCategory').val(data[0].subCategoryId);
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