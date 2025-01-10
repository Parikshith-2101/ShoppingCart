$(document).ready(function () {
    function handleAjaxError(xhr, status, error) {
        console.error('AJAX error:', status, error);
        alert('Something went wrong. Please try again.');
    }

    // Login 
    $('#loginBtn').on('click', function () {
        const userName = $('#userName').val();
        const password = $('#password').val();

        $('#userName-error').text('');
        $('#password-error').text('');

        if (!userName) {
            displayMessage('#userName-error', 'Username is required.', false);
            return;
        }
        if (!password) {
            displayMessage('#password-error', 'Password is required.', false);
            return;
        }

        $.ajax({
            url: '../components/shoppingCart.cfc?method=adminLogin',
            type: 'POST',
            data: {
                userName: userName,
                password: password
            },
            success: function (loginServerResponse) {
                const data = JSON.parse(loginServerResponse);
                if (data.errorStatus === "true") {
                    $('#resultMsg').text(data.resultMsg);
                    $('#resultMsg').css({
                        color: "green",
                        "margin-bottom": "20px"
                    });
                    setTimeout(function() {
                        window.location.href = "categories.cfm";
                    }, 600);
                } else {
                    $('#resultMsg').text(data.resultMsg);
                    $('#resultMsg').css({
                        color: "red",
                        "margin-bottom": "20px"
                    });
                }
            },
            error: handleAjaxError
        });
    });

    // Logout
    $('#logoutCategory').on('click', function () {
        if (confirm("Logout! Are you sure?")) {
            $.ajax({
                url: "../components/shoppingCart.cfc?method=logout",
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
        $('#category-error').text('');
        if(!categoryName){
            $('#category-error').text('Enter Catergory Name');
            return;
        }
        if(categoryId.trim()){
            $.ajax({
                url: "../components/shoppingCart.cfc?method=editCategory",
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
                        $('#category-error').css({
                            color: "green",
                            "margin-bottom": "20px"
                        });
                        setTimeout(function() {
                            window.location.href = "categories.cfm";
                        }, 900);
                    } else {
                        $('#category-error').text(data.resultMsg);
                        $('#category-error').css({
                            color: "red",
                            "margin-bottom": "20px"
                        });
                    }
                },
                error: handleAjaxError
            });
        }
        else{
            $.ajax({
                url: "../components/shoppingCart.cfc?method=addCategory",
                method: "POST",
                data:{
                    categoryName : categoryName
                },
                success: function (categoryServerResponse) {
                    const data = JSON.parse(categoryServerResponse);
                    if (data.errorStatus === "true") {
                        $('#category-error').text(data.resultMsg);
                        $('#category-error').css({
                            color: "green",
                            "margin-bottom": "20px"
                        });
                        setTimeout(function() {
                            window.location.href = "categories.cfm";
                        }, 900);
                    } else {
                        $('#category-error').text(data.resultMsg);
                        $('#category-error').css({
                            color: "red",
                            "margin-bottom": "20px"
                        });
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
    });

    //saveSubCategory
    $('#saveSubCategory').on('click', function () {
        const subCategoryName = $('#subCategoryValue').val();
        const categoryId = $('#categoryDropdown').val();
        const subCategoryId = $('#saveSubCategory').val();
        if(!subCategoryId){
            alert('create');
            $.ajax({
                url: "../components/shoppingCart.cfc?method=addSubCategory",
                method: "POST",
                data: {
                    subCategoryName : subCategoryName,
                    categoryId : categoryId
                },
                success: function(response){
                    const data = JSON.parse(response);
                    console.log(data);
                }
            });
        }
        else{alert('edit')}
    });
});

//view on edit Category
function editCategory(categoryId){
    $('#category-error').text('');
    $.ajax({
        url: "../components/shoppingCart.cfc?method=viewCategory",
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
            url: "../components/shoppingCart.cfc?method=deleteCategory",
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
function editSubCategory(subCategoryId){
    $('#subCategory-error').text('');
    $.ajax({
        url: "../components/shoppingCart.cfc?method=viewSubCategory",
        method: "POST",
        data:{
            subCategoryId : subCategoryId
        },
        success: function(viewSubCategoryData){
            const data = JSON.parse(viewSubCategoryData);
            console.log(data);
            $('#subCategoryValue').val(data.subCategoryName);
            $('#subCategoryModal').modal('show'); 
            $('#saveCategory').val(data.subCategoryId);
        }
    });
}

