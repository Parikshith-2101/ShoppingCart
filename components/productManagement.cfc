<cfcomponent>
    <!---Category--->
    <cffunction name = "getCategory" access = "remote" returnType = "array" returnFormat = "JSON">
        <cfargument name = "categoryId" required = "no" type = "integer">
        <cfargument name = "categoryName" required = "no" type = "string">
        <cfset local.categoryResult = []>
        <cftry>
            <cfquery name = "local.qryCategoryData" dataSource = "shoppingCart">
                SELECT 
                    fldCategory_Id,
                    fldCategoryName
                FROM
                    tblcategory
                WHERE
                    fldActive = 1
                    <cfif structKeyExists(arguments, "categoryId")>
                        AND fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                    </cfif>
                    <cfif structKeyExists(arguments, "categoryName") AND len(trim(arguments.categoryName))>
                        AND fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "varchar">
                    </cfif>;
            </cfquery>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#">
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
        <cfloop query = "local.qryCategoryData">
            <cfset arrayAppend(local.categoryResult, {
                'categoryId' : local.qryCategoryData.fldCategory_Id,
                'categoryName' : local.qryCategoryData.fldCategoryName
            })>
        </cfloop>
        <cfreturn local.categoryResult>
    </cffunction>


    <cffunction name = "addCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "categoryName" required = "yes" type = "string">
        <cfset local.result = {
            'message' : "",
            'error' : "false"
        }>
        <cftry>                
            <cfset local.fetchCategoryData = getCategory(
                categoryName = arguments.categoryName
            )>
            <cfif arrayLen(local.fetchCategoryData)>
                <cfset local.result['message'] = "Catergory Already Exists">
                <cfset local.result['error'] = "false">
            <cfelse>
                <cfquery result = "local.categoryId" dataSource = "shoppingCart">
                    INSERT INTO tblcategory(
                        fldCategoryName,
                        fldCreatedBy
                    ) 
                    VALUES(
                        <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#session.userId#" cfsqltype = "varchar">
                    );
                </cfquery>
                <cfset local.result['message'] = "Catergory Created">
                <cfset local.result['error'] = "true">
            </cfif>
            <cfcatch>
                <cfset local.result['message'] = "Error: #cfcatch.message#">
                <cfset local.result['error'] = "false">
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "editCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "categoryId" required = "yes" type = "integer"> 
        <cfargument name = "categoryName" required = "yes" type = "string"> 
        <cfset local.result = {
            'message' : "",
            'error' : "false",
            'sameId' : "no"
        }>
        <cftry> 
            <cfset local.fetchCategoryData = getCategory(
                categoryName = arguments.categoryName
            )>  
            <cfif arrayLen(local.fetchCategoryData) AND (local.fetchCategoryData[1].categoryId NEQ arguments.categoryId)>
                <cfset local.result['message'] = "Category Already Exists">
                <cfset local.result['error'] = "false">
            <cfelse>
                <cfquery>
                    UPDATE 
                        tblcategory
                    SET 
                        fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "varchar">,
                        fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                        fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "timestamp">
                    WHERE
                        fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                        AND fldActive = 1;
                </cfquery>
                <cfset local.result['message'] = "Category Edited SuccessFully">
                <cfset local.result['error'] = "true">
                <cfif arrayLen(local.fetchCategoryData)>
                    <cfset local.result['sameId'] = local.fetchCategoryData[1].categoryId EQ arguments.categoryId>
                </cfif>
            </cfif>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.result['message'] = "Error in #local.currentFunction#: #cfcatch.message#">
                <cfset local.result['error'] = "false">
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry> 
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "deleteCategory" access = "remote" returnType = "void">
        <cfargument name = "categoryId" required = "yes" type = "integer">
        <cftry>
            <cfquery>
                UPDATE 
                    tblcategory
                SET 
                    fldActive = 0,
                    fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                    fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "timestamp">
                WHERE
                    fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                    AND fldActive = 1;
            </cfquery>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
    </cffunction>

    <!---SubCategory--->
    <cffunction name = "getSubCategory" access = "remote" returnType = "array" returnFormat = "JSON">
        <cfargument name = "subCategoryId" required = "no" type = "integer">
        <cfargument name = "subCategoryName" required = "no" type = "string">
        <cfargument name = "categoryId" required = "yes" type = "integer">
        <cfset local.subCategoryResult = []>
        <cftry>
            <cfquery name = "local.qrySubCategoryData" dataSource = "shoppingCart">
                SELECT 
                    fldSubCategory_Id,
                    fldCategoryId,
                    fldSubCategoryName
                FROM
                    tblsubcategory
                WHERE
                    fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                    AND fldActive = 1
                    <cfif structKeyExists(arguments, "subCategoryId")>
                        AND fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                    </cfif>
                    <cfif structKeyExists(arguments, "subCategoryName") AND len(trim(arguments.subCategoryName))>
                        AND fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "varchar">
                    </cfif>;
            </cfquery>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
        <cfloop query = "local.qrySubCategoryData">
            <cfset arrayAppend(local.subCategoryResult,{
                'subCategoryId' : local.qrySubCategoryData.fldSubCategory_Id,
                'categoryId' : local.qrySubCategoryData.fldCategoryId,
                'subCategoryName' : local.qrySubCategoryData.fldSubCategoryName
            })>
        </cfloop>
        <cfreturn local.subCategoryResult>
    </cffunction>

    <cffunction name = "addSubCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "subCategoryName" required = "yes" type = "string">
        <cfargument name = "categoryId" required = "yes" type = "integer">
        <cfset local.result = {
            'message' : "",
            'error' : "false"
        }>
        <cftry>
            <cfset local.fetchSubCategoryData = getSubCategory(
                subCategoryName = arguments.subCategoryName,
                categoryId = arguments.categoryId
            )>
            <cfif arrayLen(local.fetchSubCategoryData)>
                <cfset local.result['message'] = "SubCatergory Already Exists">
                <cfset local.result['error'] = "false">
            <cfelse>
                <cfquery result = "local.subCategoryId" dataSource = "shoppingCart">
                    INSERT INTO tblsubcategory(
                        fldSubCategoryName,
                        fldCategoryId,
                        fldCreatedBy
                    ) 
                    VALUES(
                        <cfqueryparam value = "#arguments.SubCategoryName#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#arguments.CategoryId#" cfsqltype = "integer">,
                        <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                    );
                </cfquery>
                <cfset local.result['message'] = "SubCatergory Created">
                <cfset local.result['error'] = "true">
            </cfif>
            <cfcatch>
                <cfset local.result['message'] = "Error: #cfcatch.message#">
                <cfset local.result['error'] = "false">
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "editSubCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "subCategoryId" required = "yes" type = "integer"> 
        <cfargument name = "subCategoryName" required = "yes" type = "string">
        <cfargument name = "categoryId" required = "yes" type = "integer">
        <cfargument name = "newCategoryId" required = "yes" type = "integer">
        <cfset local.result = {
            'message' : "",
            'error' : "false",
            'sameId' : "false"
        }>
        <cftry>
            <cfset local.fetchSubCategoryData = getSubCategory(
                subCategoryName = arguments.subCategoryName,
                categoryId = arguments.newCategoryId
            )>
            <cfif arrayLen(local.fetchSubCategoryData) AND (local.fetchSubCategoryData[1].subCategoryId NEQ arguments.subCategoryId)>
                <cfset local.result['message'] = "Category Already Exists">
                <cfset local.result['error'] = "false">
            <cfelse>
                <cfquery>
                    UPDATE 
                        tblsubcategory
                    SET 
                        fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "varchar">,
                        fldCategoryId = <cfqueryparam value = "#arguments.newCategoryId#" cfsqltype = "integer">,
                        fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                        fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "timestamp">
                    WHERE
                        fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                        AND fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                        AND fldActive = 1;
                </cfquery>
                <cfset local.result['message'] = "Category Edited SuccessFully">
                <cfset local.result['error'] = "true">
                <cfif arrayLen(local.fetchSubCategoryData)>
                    <cfset local.result['sameId'] = local.fetchSubCategoryData[1].subCategoryId EQ arguments.subCategoryId>
                </cfif>
            </cfif>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.result['message'] = "Error in #local.currentFunction#: #cfcatch.message#">
                <cfset local.result['error'] = "false">
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "deleteSubCategory" access = "remote" returnType = "void">
        <cfargument name = "subCategoryId" required = "yes" type = "integer">
        <cfargument name = "categoryId" required = "yes" type = "integer">
        <cftry>
            <cfquery>
                UPDATE 
                    tblsubcategory
                SET 
                    fldActive = 0,
                    fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                    fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "timestamp">
                WHERE
                    fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                    AND fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                    AND fldActive = 1;
            </cfquery>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name = "getBrand" access = "public" returnType = "array">
        <cfset local.brandData = []>
        <cftry>
            <cfquery name = "local.qryBrand" dataSource = "shoppingCart">
                SELECT 
                    fldBrand_Id,
                    fldBrandName
                FROM 
                    tblbrand
                WHERE
                    fldActive = <cfqueryparam value = "1" cfsqltype = "integer">;
            </cfquery>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
        <cfloop query = "local.qryBrand">
            <cfset arrayAppend(local.brandData,{
                'brandId' : local.qryBrand.fldBrand_Id,
                'brandName' : local.qryBrand.fldBrandName
            })>
        </cfloop>
        <cfreturn local.brandData>
    </cffunction>

    <cffunction name = "getProduct" access = "remote" returnType = "array" returnFormat = "JSON">
        <cfargument name = "productName" required = "no" type = "string">
        <cfargument name = "subCategoryId" required = "no" type = "integer">     
        <cfargument name = "productId" required = "no" type = "integer"> 
        <cfargument name = "limit" required = "no" type = "integer"> 
        <cfargument name = "sortType" required = "no" type = "string">
        <cfargument name = "minPrice" required = "no" type = "string"> 
        <cfargument name = "maxPrice" required = "no" type = "string"> 
        <cfargument name = "priceRange" required = "no" type = "string"> 
        <cfargument name = "searchForProducts" required = "no" type = "string"> 
        <cfset local.productData = []>    
        <cftry>
            <cfquery name = "local.qryProduct" dataSource = "shoppingCart">
                SELECT 
                    P.fldProduct_Id,
                    P.fldProductName,
                    P.fldSubCategoryId,
                    P.fldBrandId,
                    B.fldBrandName,
                    P.fldDescription,
                    P.fldUnitPrice,
                    P.fldUnitTax,
                    PI.fldImageFilePath,
                    PI.fldDefaultImage,
                    SC.fldSubCategoryName
                FROM
                    tblproduct P
                LEFT JOIN tblproductimages PI ON P.fldProduct_Id = PI.fldProductId AND PI.fldDefaultImage = 1
                LEFT JOIN tblbrand B ON P.fldBrandId = B.fldBrand_Id 
                LEFT JOIN tblsubcategory SC ON P.fldSubCategoryId = SC.fldSubCategory_Id
                WHERE
                    P.fldActive = 1
                    <cfif structKeyExists(arguments, "subCategoryId")>
                        AND P.fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                    </cfif>
                    <cfif structKeyExists(arguments, "productName") AND len(trim(arguments.productName))>
                        AND P.fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype = "varchar">
                    </cfif>
                    <cfif structKeyExists(arguments, "productId")>
                        AND P.fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                    </cfif>
                    <cfif structKeyExists(arguments, "searchForProducts") AND len(trim(arguments.searchForProducts))>
                        AND (
                            P.fldProductName LIKE <cfqueryparam value = "%#arguments.searchForProducts#%" cfsqltype = "varchar">
                            OR P.fldDescription LIKE <cfqueryparam value = "%#arguments.searchForProducts#%" cfsqltype = "varchar">
                            OR B.fldBrandName LIKE <cfqueryparam value = "%#arguments.searchForProducts#%" cfsqltype = "varchar">
                            OR SC.fldSubCategoryName LIKE <cfqueryparam value = "%#arguments.searchForProducts#%" cfsqltype = "varchar">
                            )
                    </cfif>
                    <cfif structKeyExists(arguments, "priceRange") AND len(trim(arguments.priceRange))>
                        AND
                        <cfif arguments.priceRange EQ "low">
                            (P.fldUnitPrice BETWEEN 10000 AND 20000)
                        <cfelseif arguments.priceRange EQ "mid">
                            (P.fldUnitPrice BETWEEN 20000 AND 30000)
                        <cfelseif arguments.priceRange EQ "high"> 
                            (P.fldUnitPrice > 30000)
                        </cfif>
                    <cfelse>
                        <cfif (structKeyExists(arguments, "minPrice") AND len(trim(arguments.minPrice))) 
                            AND (structKeyExists(arguments, "maxPrice") AND len(trim(arguments.maxPrice)))>
                                AND (P.fldUnitPrice BETWEEN <cfqueryparam value = "#arguments.minPrice#"> 
                                    AND <cfqueryparam value = "#arguments.maxPrice#">)
                        </cfif>
                    </cfif>
                <cfif structKeyExists(arguments, "sortType")>   
                    ORDER BY P.fldUnitPrice #arguments.sortType#
                <cfelse>
                    ORDER BY RAND()
                </cfif>
                <cfif structKeyExists(arguments, "limit")>
                    LIMIT <cfqueryparam value = "#arguments.limit#" cfsqltype = "integer">   
                </cfif>
            </cfquery>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
        <cfloop query = "local.qryProduct">
            <cfset arrayAppend(local.productData,{
                'productId' : local.qryProduct.fldProduct_Id,
                'productName' : local.qryProduct.fldProductName,
                'subCategoryId' : local.qryProduct.fldSubCategoryId,
                'brandId' : local.qryProduct.fldBrandId,
                'brandName' : local.qryProduct.fldBrandName,
                'description' : local.qryProduct.fldDescription,
                'unitPrice' : local.qryProduct.fldUnitPrice,
                'unitTax' : local.qryProduct.fldUnitTax,
                'imageFile' : local.qryProduct.fldImageFilePath,
                'defaultImage' : local.qryProduct.fldDefaultImage
            })>
        </cfloop>
        <cfreturn local.productData>
    </cffunction>

    <cffunction name = "addProduct" access = "public" returnType = "struct">
        <cfargument name = "categoryId" required = "yes" type = "integer">
        <cfargument name = "subCategoryId" required = "yes" type = "integer">
        <cfargument name = "productName" required = "yes" type = "string">
        <cfargument name = "productBrandId" required = "yes" type = "integer">
        <cfargument name = "productDesc" required = "yes" type = "string">
        <cfargument name = "productPrice" required = "yes" type = "numeric">
        <cfargument name = "productTax" required = "yes" type = "numeric">
        <cfargument name = "productImage" required = "yes" type = "string">
        <cfargument name = "productId" required = "no">
        <cfif len(trim(arguments.productId))>
            <cfset local.FetchProduct = getProduct(
                productName = arguments.productName,
                subCategoryId = arguments.subCategoryId
            )>
            <cftry>
                <cfif arrayLen(local.FetchProduct) 
                    AND (local.FetchProduct[1].productId NEQ arguments.productId)>
                    <cfset local.result['error'] = "false">
                    <cfset local.result['message'] = "ProductName Already Exists">
                <cfelse>
                    <!---edit--->
                    <cfquery>  
                        UPDATE 
                            tblproduct
                        SET
                            fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">,
                            fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype = "varchar">,
                            fldBrandId = <cfqueryparam value = "#arguments.productBrandId#" cfsqltype = "integer">,
                            fldDescription = <cfqueryparam value = "#arguments.productDesc#" cfsqltype = "varchar">,
                            fldUnitPrice = <cfqueryparam value = "#arguments.productPrice#" cfsqltype = "integer">,
                            fldUnitTax = <cfqueryparam value = "#arguments.productTax#" cfsqltype = "integer">,
                            fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                            fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "timestamp">
                        WHERE
                            fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                            AND fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                            AND fldActive = 1
                    </cfquery>
                    <cfif len(trim(arguments.productImage))>                    
                        <cffile
                            action = "uploadall"
                            destination = "#expandPath('../assets/images/product#arguments.productId#')#"
                            nameconflict = "MakeUnique"
                            strict = "true"
                            result = "local.imageUploadedResult"
                        >
                        <cfquery>
                            INSERT INTO tblproductimages(
                                fldProductId,
                                fldImageFilePath,
                                fldCreatedBy
                            )
                            VALUES
                            <cfloop array = "#local.imageUploadedResult#" item = "imagesArr" index = "imageIndex">               
                                (
                                    <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">,
                                    <cfqueryparam value = "#imagesArr.SERVERFILE#" cfsqltype = "varchar">,
                                    <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                                )
                                <cfif imageIndex LT arrayLen(local.imageUploadedResult)>,</cfif>
                            </cfloop>;
                        </cfquery>
                    </cfif>
                    <cfset local.result['error'] = "true">
                    <cfset local.result['message'] = "ProductName Edited Succesfully">
                </cfif>
                <cfcatch>
                    <cfset local.currentFunction = getFunctionCalledName()>
                    <cfset local.result['error'] = "false">
                    <cfset local.result['message'] = "Error updating product: #cfcatch.message#">
                    <cfmail 
                        from = "parikshith2101@gmail.com" 
                        to = "parikshith2k23@gmail.com" 
                        subject = "Error in Function: #local.currentFunction#"
                    >
                        <h3>An error occurred in function: #local.currentFunction#</h3>
                        <p><strong>Error Message:</strong> #cfcatch.message#</p>
                    </cfmail>
                </cfcatch>
            </cftry>
        <cfelse>
            <!---create--->
            <cftry>           
                <cfset local.FetchProduct = getProduct(
                    productName = arguments.productName,
                    subCategoryId = arguments.subCategoryId
                )>
                <cfif arrayLen(local.FetchProduct)>
                    <cfset local.result['error'] = "false">
                    <cfset local.result['message'] = "ProductName Already Exists">
                <cfelse>
                    <cfquery result = "local.resultProductId" dataSource = "shoppingCart">
                        INSERT INTO tblproduct(
                            fldSubCategoryId,
                            fldProductName,
                            fldBrandId,
                            fldDescription,
                            fldUnitPrice,
                            fldUnitTax,
                            fldCreatedBy
                        )
                        VALUES(
                            <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">,
                            <cfqueryparam value = "#arguments.productName#" cfsqltype = "varchar">,
                            <cfqueryparam value = "#arguments.productBrandId#" cfsqltype = "integer">,
                            <cfqueryparam value = "#arguments.productDesc#" cfsqltype = "varchar">,
                            <cfqueryparam value = "#arguments.productPrice#" cfsqltype = "integer">,
                            <cfqueryparam value = "#arguments.productTax#" cfsqltype = "integer">,
                            <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                        );
                    </cfquery>
                    <cfdirectory action = "create" directory = "#expandPath('../assets/images/product#local.resultProductId.generatedkey#')#">
                    <cffile
                        action = "uploadall"
                        destination = "#expandPath('../assets/images/product#local.resultProductId.generatedkey#')#"
                        nameconflict = "MakeUnique"
                        strict = "true"
                        result = "local.imageUploadedResult"
                    >
                    <cfquery>
                        INSERT INTO tblproductimages(
                            fldProductId,
                            fldImageFilePath,
                            fldDefaultImage,
                            fldCreatedBy
                        )
                        VALUES
                        <cfloop array = "#local.imageUploadedResult#" item = "imagesArr" index = "imageIndex">               
                            (
                                <cfqueryparam value = "#local.resultProductId.generatedkey#" cfsqltype = "integer">,
                                <cfqueryparam value = "#imagesArr.SERVERFILE#" cfsqltype = "varchar">,
                                <cfif imageIndex EQ 1>
                                    <cfqueryparam value = 1 cfsqltype = "integer">
                                <cfelse>
                                    <cfqueryparam value = 0 cfsqltype = "integer">
                                </cfif>,
                                <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                            )
                            <cfif imageIndex LT arrayLen(local.imageUploadedResult)>,</cfif>
                        </cfloop>;
                    </cfquery>
                    <cfset local.result['error'] = "true">
                    <cfset local.result['message'] = "ProductName Added Succesfully">
                </cfif>
                <cfcatch>
                    <cfset local.result['error'] = "false">
                    <cfset local.result['message'] = "Error adding images: #cfcatch.message#">
                    <cfset local.currentFunction = getFunctionCalledName()>
                    <cfmail 
                        from = "parikshith2101@gmail.com" 
                        to = "parikshith2k23@gmail.com" 
                        subject = "Error in Function: #local.currentFunction#"
                    >
                        <h3>An error occurred in function: #local.currentFunction#</h3>
                        <p><strong>Error Message:</strong> #cfcatch.message#</p>
                    </cfmail>
                </cfcatch>
            </cftry>        
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "deleteProduct" access = "remote" returnType = "void">
        <cfargument name = "productId" required = "yes" type = "integer">
        <cfargument name = "subCategoryId" required = "yes" type = "integer">
        <cftry>
            <cfquery> 
                UPDATE  
                    tblproduct
                SET
                    fldActive = 0,
                    fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                    fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "timestamp">
                WHERE
                    fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                    AND fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                    AND fldActive = 1;
            </cfquery>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name = "getProductImage" access = "remote" returnFormat = "JSON" returnType = "array">
        <cfargument name = "productId" required = "yes" type = "integer">
        <cfargument name = "productImageId" required = "no" type = "integer">
        <cfset local.productImages = []>
        <cftry>
            <cfquery name = "local.qryProductImage" dataSource = "shoppingCart">
                SELECT
                    fldProductImage_Id,
                    fldProductId,
                    fldImageFilePath,
                    fldDefaultImage
                FROM
                    tblproductimages
                WHERE
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                    AND fldActive = 1
                    <cfif structKeyExists(arguments, "productImageId")>
                        AND fldProductImage_Id = <cfqueryparam value = "#arguments.productImageId#" cfsqltype = "integer">
                    </cfif>;
            </cfquery>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
        <cfloop query = "local.qryProductImage">
            <cfset arrayAppend(local.productImages,{
                'productImageId' : local.qryProductImage.fldProductImage_Id,
                'productId' : local.qryProductImage.fldProductId,
                'imageFile' : local.qryProductImage.fldImageFilePath,
                'defaultImage' : local.qryProductImage.fldDefaultImage
            })>
        </cfloop>
        <cfreturn local.productImages>
    </cffunction>

    <cffunction name = "setDefaultProductImage" access = "remote" returnType = "void">
        <cfargument name = "productImageId" required = "yes" type = "integer">
        <cfargument name = "productId" required = "yes" type = "integer">
        <cftry>
            <cfquery dataSource = "shoppingCart">
                UPDATE
                    tblproductimages
                SET
                    fldDefaultImage = 0
                WHERE
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                    AND fldActive = 1;
            </cfquery>
            <cfquery dataSource = "shoppingCart">
                UPDATE
                    tblproductimages
                SET
                    fldDefaultImage = 1
                WHERE
                    fldProductImage_Id = <cfqueryparam value = "#arguments.productImageId#" cfsqltype = "integer">
                    AND fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                    AND fldActive = 1;
            </cfquery>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name = "deleteProductImage" access = "remote">
        <cfargument name = "productImageId" required = "yes" type = "integer">
        <cfargument name = "productId" required = "yes" type = "integer">
        <cfset productImageData = getProductImage(
            productId = arguments.productId,
            productImageId = arguments.productImageId
        )>
        <cffile action = "delete" file = "#expandPath('../assets/images/product#productImageData[1].productId#/#productImageData[1].imageFile#')#">>    
        <cftry>
            <cfquery dataSource = "shoppingCart">
                UPDATE
                    tblproductimages
                SET
                    fldActive = 0,
                    fldDeactivatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                    fldDeactivatedDate = <cfqueryparam value = "#now()#" cfsqltype = "timestamp">
                WHERE
                    fldProductImage_Id = <cfqueryparam value = "#arguments.productImageId#" cfsqltype = "integer">
                    AND fldActive = 1;
            </cfquery>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name = "getCart" access = "public" returnType = "array">
        <cfargument name = "productId" required = "no" type = "integer"> 
        <cfset local.getCart = []>
        <cfquery name = "local.qryCart" dataSource = "shoppingCart">
            SELECT 
                C.fldCart_Id,
                C.fldUserId,
                C.fldProductId,
                C.fldQuantity,
                P.fldProductName,
                P.fldUnitPrice,
                P.fldUnitTax,
                P.fldSubCategoryId,
                P.fldDescription,
                PI.fldImageFilePath,
                PI.fldDefaultImage
            FROM 
                tblcart C 
            LEFT JOIN tblproduct P ON P.fldProduct_Id = C.fldProductId
            LEFT JOIN tblproductimages PI ON P.fldProduct_Id = PI.fldProductId AND PI.fldDefaultImage = 1
            WHERE 
                C.fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                <cfif structKeyExists(arguments,"productId")>
                    AND C.fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer"> 
                </cfif>
        </cfquery>
        <cfloop query = "local.qryCart">
        <cfset arrayAppend(local.getCart,{
            'cartId' : local.qryCart.fldCart_Id,
            'userId' : local.qryCart.fldUserId,
            'productId' : local.qryCart.fldProductId,
            'quantity' : local.qryCart.fldQuantity,
            'productName' : local.qryCart.fldProductName,
            'unitPrice' : local.qryCart.fldUnitPrice,
            'unitTax' : local.qryCart.fldUnitTax,
            'subCategoryId' : local.qryCart.fldSubCategoryId,
            'description' : local.qryCart.fldDescription,
            'imageFile' : local.qryCart.fldImageFilePath
        })>
        </cfloop>
        <cfreturn local.getCart>
    </cffunction>

    <cffunction name = "addCart" access = "public" returnType = "struct">
        <cfargument name = "productId" required = "yes" type = "integer">
        <cfset local.result = {
            'error' : "",
            'message' : ""
        }>
        <cfset local.cartData = getCart(productId = arguments.productId)>
        <cftry>  
            <cfif arrayLen(local.cartData)>
                <cfset local.quantityCount = local.cartData[1].quantity + 1>
                <cfquery dataSource = "shoppingCart">
                    UPDATE
                        tblcart
                    SET
                        fldQuantity = #local.quantityCount#  
                    WHERE 
                        fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                        AND fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                </cfquery>
                <cfset local.result['error'] = "true">
                <cfset local.result['message'] = "Edited">
            <cfelse>
                <cfquery dataSource = "shoppingCart">
                    INSERT INTO tblcart(
                        fldUserId,
                        fldProductId,
                        fldQuantity       
                    )
                    VALUES(
                        <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                        <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">,
                        1
                    );
                </cfquery>
                <cfset local.result['error'] = "true">
                <cfset local.result['message'] = "Added">
            </cfif>
            <cfset local.fetchCartQuantity = getCart()>
            <cfset session.cartQuantity = arrayLen(local.fetchCartQuantity)>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfset local.result['error'] = "false">
                <cfset local.result['message'] = "Error in  #local.currentFunction#: #cfcatch.message#">
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "deleteCart" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "cartId" required = "yes" type = "integer">
        <cfset local.result = {
            'cartQuantity' : "",
            'getCartData' : {}
        }>
        <cfquery dataSource = "shoppingCart">
            DELETE FROM tblcart
            WHERE
                fldCart_Id = <cfqueryparam value = "#arguments.cartId#" cfsqltype = "integer">
        </cfquery>
        <cfset local.getCartData = getCart()>
        <cfset session.cartQuantity = arrayLen(local.getCartData)>
        <cfset local.result['cartQuantity'] = session.cartQuantity>
        <cfset local.result['getCartData'] = local.getCartData>        
        <cfreturn local.result>
    </cffunction>

    <cffunction  name = "modifyQuantity" access = "remote" returnType = "any" returnFormat = "JSON">
        <cfargument name = "modifyStatus" required = "yes" type = "string">
        <cfargument name = "productId" required = "yes" type = "integer">
        <cfset local.result = {
            'error' : "true",
            'getCartData' : {}
        }>
        <cfset local.quantityCount = 0>
        <cftry>
            <cfset local.getCartData = getCart(productId = arguments.productId)>
            <cfif arguments.modifyStatus EQ "add">
                <cfset local.quantityCount = local.getCartData[1].quantity + 1>
                <cfquery dataSource = "shoppingCart">
                    UPDATE
                        tblcart
                    SET
                        fldQuantity = <cfqueryparam value = "#local.quantityCount#" cfsqltype = "integer"> 
                    WHERE 
                        fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                        AND fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                </cfquery>
            <cfelseif (arguments.modifyStatus EQ "remove") AND (local.getCartData[1].quantity GT 1)>
                <cfset local.quantityCount = local.getCartData[1].quantity - 1>
                <cfquery dataSource = "shoppingCart">
                    UPDATE
                        tblcart
                    SET
                        fldQuantity = <cfqueryparam value = "#local.quantityCount#" cfsqltype = "integer">
                    WHERE 
                        fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                        AND fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                </cfquery>
            <cfelse>
                <cfset local.result['error'] = "false">
            </cfif>
            <cfcatch>
                <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "parikshith2101@gmail.com" 
                    to = "parikshith2k23@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
            </cfcatch>
        </cftry>
        <cfset local.getCart = getCart()>
        <cfset local.result['getCartData'] = local.getCart>
        <cfreturn local.result>
    </cffunction>
</cfcomponent>