function handleAjaxError(xhr, status, error){
    console.error('AJAX error:', status, error);
    Swal.fire({
        title: "Error!", 
        text: "Something went wrong. Please try again.", 
        icon: "error"
    });
}

$(document).ready(function (){
    $('#saveCategory').prop("disabled", true);
    $('#saveSubCategory').prop("disabled", true);
    // Logout
    $('#logoutCategory').on('click', function (){
        Swal.fire({
            title: "Are you sure?", 
            text: "You will be logged out.", 
            icon: "warning", 
            showCancelButton: true, 
            confirmButtonColor: "#d33", 
            cancelButtonColor: "#3085d6", 
            confirmButtonText: "Yes, logout!"
        }).then((result) => {
            if (result.isConfirmed){
                $.ajax({
                    url: "/admin/model/adminLogin.cfc?method=logout", 
                    method: "POST", 
                    success: function (){
                        Swal.fire({
                            title: "Logged Out!", 
                            text: "You have been logged out successfully", 
                            icon: "success", 
                            timer: 1500, 
                            showConfirmButton: false
                        }).then(() => {
                            window.location.reload();
                        });
                    }, 
                    error:handleAjaxError
                });
            }
        });
    });
    
    $('#categoryValue').on('input', function (){
        if($('#categoryValue').val() == "" || $('#categoryValue').val() == $('#categoryValue').attr("defaultValue")){
            $('#saveCategory').prop("disabled", true);
        }
        else if($('#categoryValue').val().length > 32){
            $('#category-error').addClass('text-danger').removeClass('text-success');
            $('#category-error').text("Maximum length should be 32");
            $('#saveCategory').prop("disabled", true);
            $('#categoryValue').prop("maxlength", 33);
        } 
        else{
            $('#category-error').text('');
            $('#saveCategory').prop("disabled", false);
        }
    });

    //CategoryModal
    $('#addCategoryBtn').on('click', function (){
        $('#categoryValue').val('');
        $('#categoryModal').modal('show');
        $('#category-error').text('');
        $('#saveCategory').val('');
        $('#categoryValue').attr("defaultValue", "");
    });

    //saveCategory
    $('#saveCategory').on('click', function (){
        const categoryName = $('#categoryValue').val();
        const categoryId = $('#saveCategory').val();
        $('#category-error').text('');

        if (!categoryName){
            $('#category-error').text('Enter Category Name');
            return;
        }
        const ajaxData = {};  
        ajaxData.categoryName =  categoryName ;
        let ajaxUrl = "/admin/model/adminSpecific.cfc?method=addCategory";
        if (categoryId.trim()){
            ajaxData.categoryId = categoryId;
            ajaxUrl = "/admin/model/adminSpecific.cfc?method=editCategory";
        }
        $.ajax({
            url: ajaxUrl, 
            method: "POST", 
            data: ajaxData, 
            success: function (response){
                const data = JSON.parse(response);
                if (data.error === false){
                    $('#category-error').addClass('text-success').removeClass('text-danger');
                    $('#category-error').text(data.message);
                    setTimeout(()=>{
                        window.location.href = "categories.cfm";
                    }, 1000);
                }                     
                else {
                    $('#category-error').addClass('text-danger').removeClass('text-success');
                    $('#category-error').text(data.message);
                }
            }, 
            error: handleAjaxError
        });
    });

    $('#subCategoryValue').on('input', function (){
        if($('#subCategoryValue').val() == "" || $('#subCategoryValue').val() == $('#subCategoryValue').attr("defaultValue")){
            $('#saveSubCategory').prop("disabled", true);
        }
        else if($('#subCategoryValue').val().length > 32){
            $('#subCategory-error').addClass('text-danger').removeClass('text-success'); 
            $('#subCategory-error').text("Maxlength should be 32");
            $('#saveSubCategory').prop("disabled", true);
            $('#subCategoryValue').prop("maxlength", 33);
        }
        else{
            $('#subCategory-error').text("");
            $('#saveSubCategory').prop("disabled", false);
        }
    });
    $('#categoryDropdown').on('input', function (){
        if($('#categoryDropdown').val() == "" || $('#categoryDropdown').val() == $('#categoryDropdown').attr("defaultValue")){
            $('#saveSubCategory').prop("disabled", true);
        }
        else{
            $('#saveSubCategory').prop("disabled", false);
        }
    });
    //SubCategoryModal
    $('#addSubCategoryBtn').on('click', function (){
        $('#subCategoryValue').val('');
        $('#subCategoryModal').modal('show');
        $('#subCategory-error').text('');
        $('#saveSubCategory').val('');
        const searchParams = new URLSearchParams(window.location.search);
        const categoryId = searchParams.get('categoryId');
        $('#categoryDropdown').val(categoryId);
        $('#subCategoryValue').attr("defaultValue", "");
    });

    //saveSubCategory
    $('#saveSubCategory').on('click', function (){
        const subCategoryName = $('#subCategoryValue').val();
        const newCategoryId = $('#categoryDropdown').val();
        const searchParams = new URLSearchParams(window.location.search);
        const oldCategoryId = searchParams.get('categoryId')
        const subCategoryId = $('#saveSubCategory').val();   
        if(!newCategoryId){
            $('#subCategory-error').text('Select Category').addClass('text-danger');
            return;
        }
        if(!subCategoryName){
            $('#subCategory-error').text('Enter SubCatergory Name').addClass('text-danger');
            return;
        }
        let ajaxUrl = "/admin/model/adminSpecific.cfc?method=addSubCategory";
        const ajaxData = { subCategoryName, categoryId: newCategoryId };
        if (subCategoryId){
            ajaxUrl = "/admin/model/adminSpecific.cfc?method=editSubCategory";
            ajaxData.subCategoryId = subCategoryId;
            ajaxData.oldCategoryId = oldCategoryId;
            ajaxData.newCategoryId = newCategoryId;
        }
        console.log(ajaxData);
        $.ajax({
            url: ajaxUrl, 
            method: "POST", 
            data: ajaxData, 
            success: function (response){
                const data = JSON.parse(response);
                if(data.error == false){
                    $('#subCategory-error').addClass('text-success').removeClass('text-danger');
                    $('#subCategory-error').text(data.message);
                    setTimeout(function(){
                        window.location.reload();
                    }, 900);
                }
                else{
                    $('#subCategory-error').addClass('text-danger').removeClass('text-success'); 
                    $('#subCategory-error').text(data.message);                       
                }
            }, 
            error: handleAjaxError
        });
    });
});

//view on edit Category
function editCategory(categoryId){
    $('#category-error').text('');
    $('#categoryValue').val('').change();
    $.ajax({
        url: "/admin/model/adminSpecific.cfc?method=getCategory", 
        method: "POST", 
        data:{
            categoryId : categoryId
        }, 
        success: function(getCategoryData){
            const data = JSON.parse(getCategoryData);
            if(data.error == true){
                $('#category-error').text(data.message);
            }
            else{
                $('#categoryValue').val(data.category[0].categoryName);
                $('#categoryValue').attr("defaultValue", data.category[0].categoryName);
                $('#categoryModal').modal('show'); 
                $('#saveCategory').val(data.category[0].categoryId);
            }
        }, 
        error: handleAjaxError
    });
}

//delete Category
function deleteCategory(categoryId){
    Swal.fire({
        title: "Are you sure?", 
        text: "This action cannot be undone!", 
        icon: "warning", 
        showCancelButton: true, 
        confirmButtonColor: "#d33", 
        cancelButtonColor: "#3085d6", 
        confirmButtonText: "Yes, delete it!"
    }).then((result) => {
        if (result.isConfirmed){
            $.ajax({
                type: "POST", 
                url: "/admin/model/adminSpecific.cfc?method=deleteCategory", 
                data: { categoryId: categoryId }, 
                success: function (){
                    const parentDiv = $('#categoryParentDiv');
                    Swal.fire({
                        title: "Deleted!", 
                        text: "Category has been deleted.", 
                        icon: "success"
                    }).then((result)=>{
                        if(result.isConfirmed){
                            document.getElementById(categoryId).remove();
                            if(parentDiv.children().length == 0){
                                window.location.reload();
                            }                    
                        }
                    });
                }, 
                error: handleAjaxError
            });
        }
    });
}

//view on edit subCategory
function editSubCategory(subCategoryId, categoryId){
    $('#subCategory-error').text('');
    $.ajax({
        url: "/admin/model/adminSpecific.cfc?method=getSubCategory", 
        method: "POST", 
        data:{
            subCategoryId : subCategoryId, 
            categoryId : categoryId
        }, 
        success: function(getSubCategoryData){
            const data = JSON.parse(getSubCategoryData);           
            $('#categoryDropdown').val(data.subCategory[0].categoryId);
            $('#subCategoryValue').val(data.subCategory[0].subCategoryName);
            $('#saveSubCategory').val(subCategoryId);
            $('#subCategoryValue').attr("defaultValue", data.subCategory[0].subCategoryName);
            $('#categoryDropdown').attr("defaultValue", categoryId);
            $('#subCategoryModal').modal('show');
        }, 
        error: handleAjaxError
    });
}

//delete SubCategory
function deleteSubCategory(subCategoryId, categoryId){
    Swal.fire({
        title: "Are you sure?", 
        text: "This action cannot be undone!", 
        icon: "warning", 
        showCancelButton: true, 
        confirmButtonColor: "#d33", 
        cancelButtonColor: "#3085d6", 
        confirmButtonText: "Yes, delete it!"
    }).then((result) => {
        if (result.isConfirmed){
            $.ajax({
                type: "POST", 
                url: "/admin/model/adminSpecific.cfc?method=deleteSubCategory", 
                data: {
                    subCategoryId : subCategoryId, 
                    categoryId : categoryId
                }, 
                success: function(){
                    const parentDiv = $('#subCategoryParentDiv');
                    Swal.fire({
                        title: "Deleted!", 
                        text: "SubCategory has been deleted.", 
                        icon: "success"
                    }).then((result)=>{
                        if(result.isConfirmed){
                            document.getElementById(subCategoryId).remove();
                            if(parentDiv.children().length == 0){
                                window.location.reload();
                            }                    
                        }
                    });
                }, 
                error: handleAjaxError
            });
        }
    });
}