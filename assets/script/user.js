function userLogin () {
    const userName = $('#userName').val();
    const password = $('#password').val();
    let isValid = true;
    $('#userName-error').text('');
    $('#password-error').text('');
    $('.resultMsg').text('');

    if (!userName) {
        $('#userName-error').text('Username is required.');
        isValid =  false;
    }
    if (!password) {
        $('#password-error').text('Password is required.');
        isValid = false;
    }
    return isValid;
}

function userSignUpValidation(){
    const firstName = $('#firstName').val();
    const lastName = $('#lastName').val();
    const email = $('#email').val();
    const phoneNumber = $('#phoneNumber').val();
    const password = $('#password').val();
    const confirmPassword = $('#confirmPassword').val();
    let isValid = true;
    $('#firstName-error').text('');
    $('#lastName-error').text('');
    $('#email-error').text('');
    $('#phoneNumber-error').text('');
    $('#password-error').text('');
    $('#confirmPassword-error').text('');

    const nameRegex = /^[A-Za-z]+$/;
    if(!firstName){
        $('#firstName-error').text('Please Enter FirstName');
        isValid = false;
    }
    else if (!nameRegex.test(firstName)){
        $('#firstName-error').text('First Name should only contain alphabets');
        isValid = false;
    }

    if(!lastName){
        $('#lastName-error').text('Please Enter LastName');
        isValid = false;
    }
    else if (!nameRegex.test(lastName)){
        $('#lastName-error').text('First Name should only contain alphabets');
        isValid = false;
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!email || !emailRegex.test(email)) {
        $('#email-error').text('Please Enter a Valid Email');
        isValid = false;
    }

    const phoneRegex = /^[0-9]{10}$/;
    if (!phoneNumber || !phoneRegex.test(phoneNumber)) {
        $('#phoneNumber-error').text('Please Enter a Valid Phone Number (10 digits)');
        isValid = false;
    }

    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
    if (!password || password.trim() === '') {
        $('#password-error').text('Please Enter Password');
        isValid = false;
    } else if (!passwordRegex.test(password)) {
        $('#password-error').text('Password must be at least 8 characters long, include an uppercase letter, a number, and a special character');
        isValid = false;
    }
    if(!confirmPassword || confirmPassword !== password){
        $('#confirmPassword-error').text('Password Doesnt Match');
        isValid = false;
    }
    return isValid;
}

if ($('#signUpSuccess').length) {
    Swal.fire({
        title: "Success!",
        text: "Sign-up successful. Redirecting to login page...",
        icon: "success",
        timer: 1500,
        showConfirmButton: false
    }).then(() => {
        window.location.href = "userLogin.cfm";
    });
}

$('#logoutBtn').click(function(){
    Swal.fire({
        title: "Logout!",
        text: "Are you sure you want to logout?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, Logout!"
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
                        window.location.href = "userHome.cfm";
                    });
                }
            });
        }
    });
});

$('#eyeIcon').click(function () {
    let passfield = $('#password');
    if (passfield.attr("type") === "password") {
        passfield.attr("type","text");
        $('#eyeIcon').html(`<i class="fa-solid fa-eye-slash"></i>`);
    } 
    else {
        passfield.attr("type","password");
        $('#eyeIcon').html(`<i class="fa-solid fa-eye"></i>`);
    }
});

function toggleCustomInput(selectElement, inputId) {
    let inputElement = $("#" + inputId);
    
    if ($(selectElement).val() === "custom") {
        inputElement.removeClass("d-none").focus();
    } else {
        inputElement.addClass("d-none");
    }
}

$('#filterBtn').on('click', function() {
    $('#minPrice').val();
    $('#maxPrice').val();
    $('#minPriceCustom').val();
    $('#maxPriceCustom').val();
});

$(document).on("click", function(){
    $(".errorServerSide").hide();
});

function deleteAddress(addressId) {
    Swal.fire({
        title: "Are you sure?",
        text: "You won't be able to revert this!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, delete it!"
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: "../components/productManagement.cfc?method=deleteAddress",
                method: "POST",
                data: { addressId: addressId},
                success: function() {
                    Swal.fire({
                        title: "Deleted!",
                        text: "Your address has been deleted.",
                        icon: "success"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            document.getElementById(addressId).remove();
                            let parentDiv = $('#addressParentDiv');
                            if(parentDiv.children().length == 0){
                                window.location.reload();
                            } 
                        }
                    });
                },
            });
        }
    });
}

$('#noOrdersFound').hide();
$('#searchOrder').on('input', function () {
    let searchValue = $(this).val().toLowerCase();
    let anyVisible = false;
    $('#search-for').text(`Search results for "${searchValue}"`).show();
    $('.orderDetailsDiv').each(function () {
        let orderId = $(this).attr('id').toLowerCase();
        if(orderId.includes(searchValue)) {
            $(this).show();
            anyVisible = true;
        }else {
            $(this).hide();
        }
    });
    if(anyVisible) {
        $('#noOrdersFound').hide();
    } else {
        $('#noOrdersFound').show();
    }
});

function toggleView() {
    let container = $("#product-container");
    if (container.css("max-height") === "360px") {
        container.css("max-height", "none");
        $(this).text("View Less");
    } else {
        container.css("max-height", "360px");
        $(this).text("View More");
    }
}

function addressValidate() {
    let isValid = true;
    $('#errorFirstName').text('');
    $('#errorLastName').text('');
    $('#errorAddressLine1').text('');
    $('#errorAddressLine2').text('');
    $('#errorCity').text('');
    $('#errorState').text('');
    $('#errorPincode').text('');
    $('#errorPhone').text('');

    if (!$('#adFirstName').val().trim()) {
        $('#errorFirstName').text('First Name is required.');
        isValid = false;
    }
    if (!$('#adLastName').val().trim()) {
        $('#errorLastName').text('Last Name is required.');
        isValid = false;
    } 
    if (!$('#adAddressLine1').val().trim()) {
        $('#errorAddressLine1').text('Address Line 1 is required.');
        isValid = false;
    }
    if (!$('#adAddressLine2').val().trim()) {
        $('#errorAddressLine2').text('Address Line 2 is required.');
        isValid = false;
    }
    if (!$('#adCity').val().trim()) {
        $('#errorCity').text('City is required.');
        isValid = false;
    }

    if (!$('#adState').val().trim()) {
        $('#errorState').text('State is required.');
        isValid = false;
    } 
    if (!($('#adPincode').val()) || $('#adPincode').val() < 6) {
        $('#errorPincode').text('Pincode is required. Pincode must be 5 or 6 digits.');
        isValid = false;
    } 
    if (!($('#adPhone').val()) || $('#adPhone').val() < 10) {
        $('#errorPhone').text('Phone is required. Phone must be 10 digits.');
        isValid = false;
    }
    $('#saveAddressBtn').prop('disabled', !isValid);
}
$('.address-input').on('input', addressValidate);

if($('#addressResult').length){
    Swal.fire({
        icon: "error",
        title: "Oops...",
        text: `${$('#addressResult').attr("data-errorMsg")}!`
    });
}

if ($('#activateSweetAlert').length) {
    Swal.fire({
        title: "Address Details Not Provided!",
        text: "Please add your address to place the order.",
        icon: "warning"
    }).then((result) => {
        if (result.isConfirmed) {
            $('#addAddressModal').modal('show');
        }
    });
}
