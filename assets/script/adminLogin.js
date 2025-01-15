function handleAjaxError(xhr, status, error) {
    console.error('AJAX error:', status, error);
    alert('Something went wrong. Please try again.');
}
 function adminLogin () {
    const userName = $('#userName').val();
    const password = $('#password').val();

    $('#userName-error').text('');
    $('#password-error').text('');
    $('#resultMsg').text('');

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
}
