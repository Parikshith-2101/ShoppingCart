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
        <div class="row">
            <div class="col-md-4">
                <div class="card p-4 text-center">
                    <img src="../assets/images/designImages/default profile.jpg" class="rounded-circle mb-3 mx-auto" width="120" alt="Profile Picture">
                    <h5 class="card-title">#session.firstName# #session.lastName#</h5>
                    <p class="text-muted">#session.email#</p>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="##editProfileModal">
                        <i class="fa fa-edit"></i> Edit Profile
                    </button>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card p-4">
                    <div class="d-flex justify-content-between">
                        <h5>Saved Addresses</h5>
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="##addAddressModal">
                            <i class="fa fa-plus"></i> Add Address
                        </button>
                    </div>
  
                    <ul class="p-0 m-0 mt-3">
                        <li class="card flex-row justify-content-between align-items-center p-2 my-2">
                            123, Street Name, City, Country
                            <button class="btn btn-danger p-1 px-2">
                                <i class="fa fa-trash"></i> Delete
                            </button>
                        </li>
                        <li class="card flex-row justify-content-between align-items-center p-2 my-2">
                            456, Another Street, City, Country
                            <button class="btn btn-danger p-1 px-2">
                                <i class="fa fa-trash"></i> Delete
                            </button>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </main>

    <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editProfileModalLabel">Edit Profile</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="text" class="form-control mb-2" id="editName" value="John Doe">
                    <input type="email" class="form-control mb-2" id="editEmail" value="johndoe@example.com">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-success" id="saveProfileBtn"><i class="fa fa-save"></i> Save Changes</button>
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
                    <input type="text" class="form-control mb-2" placeholder="Enter Address">
                    <input type="text" class="form-control mb-2" placeholder="Enter Address">
                    <input type="text" class="form-control mb-2" placeholder="Enter Address">
                    <input type="text" class="form-control mb-2" placeholder="Enter Address">
                    <input type="text" class="form-control mb-2" placeholder="Enter Address">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-success">Save Address</button>
                </div>
            </div>
        </div>
    </div>
    </cfoutput>

    <footer>

    </footer>

    <script src="../assets/script/bootstrap.min.js"></script>
    <script src="../assets/script/jquery-3.7.1.min.js"></script>
    <script src="../assets/script/user.js"></script>

</body>
</html>
