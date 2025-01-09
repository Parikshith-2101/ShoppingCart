$(document).ready(function () {
    $('#loginBtn').on('click', function () {
       
        const userName = $('#userName').val();
        const password = $('#password').val();

        $('#userName-error').text('');
        $('#password-error').text('');

        if (!userName) {
            $('#userName-error').text('Username is required.');
            return;
        }
        if (!password) {
            $('#password-error').text('Password is required.');
            return;
        }
        $.ajax({
            url: '../components/userLogin.cfc?method=adminLogin', 
            type: 'POST',
            data: {
                userName: userName,
                password: password
            },
            success: function (serverResponse) {
                const myData = JSON.parse(serverResponse);
                console.log(myData);
                if (myData.errorStatus == "true") {
                    $('#resultMsg').text(myData.resultMsg);
                    $('#resultMsg').css({
                        color: "green",
                        "margin-bottom": "20px"
                    });
                    setTimeout(function() {
                        window.location.href = "categories.cfm";
                    }, 600);
                }
                
                else{
                    $('#resultMsg').text(myData.resultMsg);
                    $('#resultMsg').css({
                        color: "red",
                        "margin-bottom": "20px"
                    });
                }
            },
            error: function (xhr, status, error) {
                console.error('AJAX error:', status, error);
                alert('Something went wrong. Please try again.');
            }
        });
    });
});

$(document).ready(function () {
    $('#logoutCategory').on('click', function () {
        if(confirm("Logout! Are you sure?")){
            $.ajax({
                url: "../components/userLogin.cfc?method=logout",
                method: "POST",
                success: function(){
                    window.location.href = "adminLogin.cfm";
                }
            });
        }
    });
});

function addCategory() {
    $('#addCategory').modal('show');
}

$(document).ready(function () {
    $('#saveCategory').on('click', function () {
        const categoryName = $('#categoryValue').val();
        $('#category-error').text('');
        if(!categoryName){
            $('#category-error').text('Please Enter Catergory Name');
            return;
        }
        $.ajax({
            url: "../components/userLogin.cfc?method=addCategory",
            method: "POST",
            data:{
                categoryName : categoryName
            },
            success:function(){

            }
        });
    });
});