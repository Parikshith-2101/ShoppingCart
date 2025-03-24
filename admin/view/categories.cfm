
<cfset getCategory =  application.productManagementObj.getCategory()> 
<cfinclude template="header.cfm">
<cfoutput>
    <div class="container my-5 d-flex flex-column p-0 w-50 bg-white position-relative">
        <div class="d-flex justify-content-center">
            <div class="border rounded shadow-heavy w-100">
                <div class="py-4 px-3 align-items-center d-flex flex-column" id="categoryDiv">
                    <div class="d-flex w-100 align-items-center">
                        <div class="text-uppercase login-title fs-4 px-2">Categories</div>
                        <div class="border border-2 rounded fw-bold px-2 ms-2 fs-small addPageBtn" id="addCategoryBtn">Add+</div>
                    </div>

                    <div class="modal fade" id="categoryModal" data-bs-backdrop="static" data-bs-keyboard="false"
                        tabindex="-1" aria-labelledby="addCategoryLabel" aria-hidden="true">
                        <div class="modal-dialog w-50">
                            <div class="modal-content">
                                <form method="post" enctype="multipart/form-data" name="addCategoryForm">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="exampleModalLabel">Category</h5>
                                        <button type="button" class="close btn btn-outline-danger px-2 py-0" data-bs-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <label for="categoryName">Category Name*</label>
                                        <input type="text" name="categoryName" id="categoryValue">
                                        <div id="category-error" class = "fw-bold"></div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Close</button>
                                        <button type="button" class="btn btn-primary" id="saveCategory">Save</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex flex-column w-100 mt-3" id="categoryParentDiv">
                        <cfif getCategory.error EQ true>
                            <cfdump var="#getCategory#">
                        </cfif>
                        <cfloop array="#getCategory.category#" item="categoryItem">
                            <div class="card shadow-lg" id = "#categoryItem.categoryId#">
                                <div class="d-flex align-items-center">
                                    <div class="categoryName">
                                        #categoryItem.categoryName#
                                    </div>
                                    <div class="d-flex ms-auto">
                                        <button onclick="editCategory('#categoryItem.categoryId#')" class="btn btn-outline-info mx-1 d-flex align-items-center justify-content-center" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button onclick="deleteCategory('#categoryItem.categoryId#')" class="btn btn-outline-danger mx-1 d-flex align-items-center justify-content-center" title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                        <a href="subCategories.cfm?categoryId=#UrlEncodedFormat(categoryItem.categoryId)#" class="btn btn-outline-success mx-1 d-flex align-items-center justify-content-center" title="Go to Category">
                                            <i class="fas fa-arrow-right"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </cfloop>                                                                                                           
                    </div>                 
                </div>
            </div>
        </div>
    </div>
</cfoutput>
<cfinclude template="footer.cfm">