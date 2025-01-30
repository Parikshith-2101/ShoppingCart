function userLogin () {
    const userName = $('#userName').val();
    const password = $('#password').val();
    let isValid = true;
    $('#userName-error').text('');
    $('#password-error').text('');
    $('#resultMsg').text('');

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
    console.log(firstName,lastName,email,phoneNumber,password);
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
$('#logoutBtn').click(function(){
    if (confirm("Logout! Are you sure?")) {
        $.ajax({
            url: "../components/userLogin?method=logout",
            method: "POST",
            success: function () {
                window.location.reload();
            }
        });
    }
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
    let minPrice = $('#minPrice').val();
    let maxPrice = $('#maxPrice').val();
    let minPriceCustom = $('#minPriceCustom').val();
    let maxPriceCustom = $('#maxPriceCustom').val();
    console.log(`Min Price: ${minPrice === 'custom' ? minPriceCustom : minPrice}`);
    console.log(`Max Price: ${maxPrice === 'custom' ? maxPriceCustom : maxPrice}`);
});
