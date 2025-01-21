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
    if(!firstName){
        $('#firstName-error').text('Please Enter FirstName');
        isValid = false;
    }
    if(!lastName){
        $('#lastName-error').text('Please Enter LastName');
        isValid = false;
    }
    if(!email){
        $('#email-error').text('Please Enter Valid Email');
        isValid = false;
    }
    if(!phoneNumber){
        $('#phoneNumber-error').text('Please Enter Valid Number');
        isValid = false;
    }
    if(!password){
        $('#password-error').text('Please Enter Password');
        isValid = false;
    }
    if(!confirmPassword || confirmPassword !== password){
        $('#confirmPassword-error').text('Password Doesnt Match');
        isValid = false;
    }
    return isValid;
}