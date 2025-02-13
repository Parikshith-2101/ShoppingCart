<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile</title>
    <link rel="stylesheet" href="../assets/style/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/style/home.css">    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
        integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
        crossorigin="anonymous" referrerpolicy="no-referrer">
</head>
<body>
    <header>
        <cfinclude template="userHeader.cfm">
    </header>
    <cfoutput>     
        <main class="container products-container">
            <form method="post">
                <div class="row">
                    <div class="col-md-4">
                        <div class="card p-4 text-center">
                            <cfif structKeyExists(form, "saveProfileBtn")>
                                <cfset editUserResult = application.productManagementObj.editUser(
                                    firstName = form.userFirstName,
                                    lastName = form.userLastName,
                                    email = form.userEmail
                                )>
                                <div class="errorServerSide">
                                    <cfif editUserResult.error EQ true>
                                        <span class="text-danger fw-bold">#editUserResult.message#</span>
                                    <cfelse>
                                        <span class="text-success fw-bold">#editUserResult.message#</span>
                                    </cfif>
                                </div>
                            </cfif>
                            <img src="../assets/images/designImages/default profile.jpg" class="rounded-circle mb-3 mx-auto" width="120" alt="Profile Picture">
                            <h5 class="card-title">#session.firstName# #session.lastName#</h5>
                            <p class="text-muted">#session.email#</p>
                            <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="##editProfileModal">
                                <i class="fa fa-edit"></i> Edit Profile
                            </button><br>
                        </div>
                        <div class="card mt-3 p-4 text-center">
                            <a href="userOrderDetails.cfm" class="btn btn-primary">My Order History</a>
                        </div>
                    </div>
                    <cfif structKeyExists(form, "saveAddressBtn")>
                        <cfset addressResult = application.productManagementObj.addAddress(
                            firstName = form.firstName,
                            lastName = form.lastName,
                            addressLine1 = form.addressLine1,
                            addressLine2 = form.addressLine2,
                            city = form.city,
                            state = form.state,
                            pincode = form.pincode,
                            phone = form.phone
                        )>
                        <cfif addressResult.error EQ true>
                            <div id="addressResult" data-errorMsg="#addressResult.message#"></div>
                        </cfif>
                    </cfif>
                    <div class="col-md-8">
                        <div class="card p-4">
                            <div class="d-flex justify-content-between">
                                <h5>Saved Addresses</h5>
                                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="##addAddressModal">
                                    <i class="fa fa-plus"></i> Add Address
                                </button>
                            </div>
        
                            <ul class="p-0 m-0 mt-3">
                                <cfset getAddressArray = application.productManagementObj.getAddress()>
                                <cfif arrayLen(getAddressArray.address)>
                                    <cfloop array="#getAddressArray.address#" item="addressItem">
                                    <li class="card flex-row justify-content-between align-items-center p-3 my-3 shadow-sm" id="#addressItem.addressId#">
                                            <div class="d-flex flex-column">
                                                <h6 class="font-weight-bold mb-1">
                                                    #addressItem.firstName# #addressItem.lastName#
                                                </h6>
                                                <p class="mb-1">
                                                    #addressItem.addressLine1# #addressItem.addressLine2#, 
                                                    #addressItem.city#, #addressItem.state# - #addressItem.pincode#
                                                </p>
                                                <p class="mb-2 text-muted">
                                                    <strong>Phone:</strong> #addressItem.phone#
                                                </p>
                                            </div>
                                            <button type="button" class="btn btn-danger p-2" onclick="deleteAddress('#addressItem.addressId#')">
                                                <i class="fa fa-trash"></i> Delete
                                            </button>
                                        </li>
                                    </cfloop>
                                <cfelse>    
                                    <div class="text-center">
                                        <h4 class="text-muted">Add Address Here!</h4>
                                    </div>
                                </cfif>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editProfileModalLabel">Edit Profile</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <input type="text" name="userFirstName" class="form-control mb-2" placeholder="Enter firstName" value="#session.firstName#" required>
                                <input type="text" name="userLastName" class="form-control mb-2" placeholder="Enter lastName" value="#session.lastName#" required>
                                <input type="email" name="userEmail" class="form-control mb-2" placeholder="Enter email" value="#session.email#" required>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-success" name="saveProfileBtn">Save Changes</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="addAddressModal" tabindex="-1" aria-labelledby="addAddressModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addAddressModalLabel">Add New Address</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-2">
                                    <input type="text" class="form-control address-input" id="adFirstName" name="firstName" placeholder="Enter Firstname">
                                    <div class="text-danger" id="errorFirstName"></div>
                                </div>

                                <div class="mb-2">
                                    <input type="text" class="form-control address-input" id="adLastName" name="lastName" placeholder="Enter Lastname">
                                    <div class="text-danger" id="errorLastName"></div>
                                </div>

                                <div class="mb-2">
                                    <input type="text" class="form-control address-input" id="adAddressLine1" name="addressLine1" placeholder="Enter AddressLine1">
                                    <div class="text-danger" id="errorAddressLine1"></div>
                                </div>

                                <div class="mb-2">
                                    <input type="text" class="form-control address-input" id="adAddressLine2" name="addressLine2" placeholder="Enter AddressLine2">
                                    <div class="text-danger" id="errorAddressLine2"></div>
                                </div>

                                <div class="mb-2">
                                    <input type="text" class="form-control address-input" id="adCity" name="city" placeholder="Enter City">
                                    <div class="text-danger" id="errorCity"></div>
                                </div>

                                <div class="mb-2">
                                    <input type="text" class="form-control address-input" id="adState" name="state" placeholder="Enter State">
                                    <div class="text-danger" id="errorState"></div>
                                </div>

                                <div class="mb-2">
                                    <input type="tel" class="form-control address-input" id="adPincode" name="pincode" maxlength="6" placeholder="Enter Pincode">
                                    <div class="text-danger" id="errorPincode"></div>
                                </div>

                                <div class="mb-2">
                                    <input type="tel" class="form-control address-input" id="adPhone" name="phone" placeholder="Enter Phone">
                                    <div class="text-danger" id="errorPhone"></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" id="saveAddressBtn" name="saveAddressBtn" onclick="addressValidate()" class="btn btn-success">Save Address</button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </main>
    </cfoutput>

    <footer class="mt-5 w-100 bg-dark text-white py-4">
        <cfinclude template="/views/userFooter.cfm">
    </footer>

    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/user.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>
