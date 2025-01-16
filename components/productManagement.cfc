<cfcomponent>
    <!---Category--->
    <cffunction name = "getCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "categoryId" required = "no" type = "integer">
        <cfargument name = "categoryName" required = "no" type = "string">
        <cfset local.categoryResult = {
            'categoryId' : [],
            'categoryName' : []
        }>
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
        <cfloop query = "local.qryCategoryData">
            <cfset arrayAppend(local.categoryResult['categoryId'], local.qryCategoryData.fldCategory_Id)>
            <cfset arrayAppend(local.categoryResult['categoryName'], local.qryCategoryData.fldCategoryName)>
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
            <cfif arrayLen(local.fetchCategoryData.categoryId)>
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
                        <cfqueryparam value = "#session.adminUserId#" cfsqltype = "varchar">
                    );
                </cfquery>
                <cfset local.result['message'] = "Catergory Created">
                <cfset local.result['error'] = "true">
            </cfif>
            <cfcatch type = "exception">
                <cfset local.result['message'] = "Error: #cfcatch.message#">
                <cfset local.result['error'] = "false">
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
            'sameId' : "false"
        }>
        <cftry>  
            <cfset local.fetchCategoryData = getCategory(
                categoryName = arguments.categoryName
            )>
            <cfif arrayLen(local.fetchCategoryData.categoryId) 
                AND (ArrayContains(local.fetchCategoryData.categoryId, arguments.categoryId) EQ false)>
                <cfset local.result['message'] = "Category Already Exists">
                <cfset local.result['error'] = "false">
            <cfelse>
                <cfquery>
                    UPDATE 
                        tblcategory
                    SET 
                        fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "varchar">,
                        fldUpdatedBy = <cfqueryparam value = "#session.adminUserId#" cfsqltype = "integer">
                    WHERE
                        fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                        AND fldActive = 1;
                </cfquery>
                <cfset local.result['message'] = "Category Edited SuccessFully">
                <cfset local.result['error'] = "true">
                <cfset local.result['sameId'] = ArrayContains(local.fetchCategoryData.categoryId, arguments.categoryId)>
            </cfif>
            <cfcatch type = "exception">
                <cfset local.result['message'] = "Error: #cfcatch.message#">
                <cfset local.result['error'] = "false">
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "deleteCategory" access = "remote" returnType = "void">
        <cfargument name = "categoryId" required = "yes" type = "integer">
        <cfquery>
            UPDATE 
                tblcategory
            SET 
                fldActive = 0,
                fldUpdatedBy = <cfqueryparam value = "#session.adminUserId#" cfsqltype = "integer">
            WHERE
                fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                AND fldActive = 1;
        </cfquery>
    </cffunction>

    <!---SubCategory--->
    <cffunction name = "qrySubCategoryData" access = "remote" returnType = "query" returnFormat = "JSON">
        <cfargument name = "subCategoryId" required = "no" type = "integer">
        <cfargument name = "subCategoryName" required = "no" type = "string">
        <cfargument name = "categoryId" required = "no" type = "integer">
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
                <cfif structKeyExists(arguments, "subCategoryId") AND len(trim(arguments.subCategoryId))>
                    AND fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                </cfif>
                <cfif structKeyExists(arguments, "subCategoryName") AND len(trim(arguments.subCategoryName))>
                    AND fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "varchar">
                </cfif>;
        </cfquery>
        <cfreturn local.qrySubCategoryData>
    </cffunction>

    <cffunction name = "getSubCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "subCategoryId" required = "no" type = "integer">
        <cfargument name = "subCategoryName" required = "no" type = "string">
        <cfargument name = "categoryId" required = "yes" type = "integer">
        <cfset local.fetchSubCategoryData = {
            'subCategoryId' : [],
            'categoryId' : [],
            'subCategoryName' : []
        }>
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
        <cfloop query = "local.qrySubCategoryData">
            <cfset arrayAppend(local.fetchSubCategoryData['subCategoryId'], local.qrySubCategoryData.fldSubCategory_Id)>
            <cfset arrayAppend(local.fetchSubCategoryData['categoryId'], local.qrySubCategoryData.fldCategoryId)>
            <cfset arrayAppend(local.fetchSubCategoryData['subCategoryName'], local.qrySubCategoryData.fldSubCategoryName)>
        </cfloop>
        <cfreturn local.fetchSubCategoryData>
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
                subCategoryId = arguments.subCategoryId,
                categoryId = arguments.categoryId
            )>
            <cfif arrayLen(local.fetchSubCategoryData.subCategoryId)>
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
                        <cfqueryparam value = "#session.adminUserId#" cfsqltype = "integer">
                    );
                </cfquery>
                <cfset local.result['message'] = "SubCatergory Created">
                <cfset local.result['error'] = "true">
            </cfif>
            <cfcatch type = "exception">
                <cfset local.result['message'] = "Error: #cfcatch.message#">
                <cfset local.result['error'] = "false">
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
            <cfif arrayLen(local.fetchSubCategoryData.subCategoryId)
                AND (ArrayContains(local.fetchSubCategoryData.subCategoryId, arguments.subCategoryId) EQ false)>
                <cfset local.result['message'] = "Category Already Exists">
                <cfset local.result['error'] = "false">
            <cfelse>
                <cfquery>
                    UPDATE 
                        tblsubcategory
                    SET 
                        fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "varchar">,
                        fldCategoryId = <cfqueryparam value = "#arguments.newCategoryId#" cfsqltype = "integer">,
                        fldUpdatedBy = <cfqueryparam value = "#session.adminUserId#" cfsqltype = "integer">
                    WHERE
                        fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                        AND fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                        AND fldActive = 1;
                </cfquery>
                <cfset local.result['message'] = "Category Edited SuccessFully">
                <cfset local.result['error'] = "true">
                <cfset local.result['sameId'] = ArrayContains(local.fetchSubCategoryData.subCategoryId, arguments.subCategoryId)>
            </cfif>
            <cfcatch type="exception">
                <cfset local.result['message'] = "Error: #cfcatch.message#">
                <cfset local.result['error'] = "false">
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "deleteSubCategory" access = "remote" returnType = "void">
        <cfargument name = "subCategoryId" required = "yes" type = "integer">
        <cfargument name = "categoryId" required = "yes" type = "integer">
        <cfquery>
            UPDATE 
                tblsubcategory
            SET 
                fldActive = 0,
                fldUpdatedBy = <cfqueryparam value = "#session.adminUserId#" cfsqltype = "integer">
            WHERE
                fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                AND fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                AND fldActive = 1;
        </cfquery>
    </cffunction>

    <cffunction name = "qryBrandData" access = "public" returnType = "query">
        <cfquery name = "local.qryBrand" dataSource = "shoppingCart">
            SELECT 
                fldBrand_Id,
                fldBrandName
            FROM 
                tblbrand
            WHERE
                fldActive = <cfqueryparam value = "1" cfsqltype = "integer">;
        </cfquery>
        <cfreturn local.qryBrand>
    </cffunction>

    <cffunction name = "qryProductData" access = "public" returnType = "query">
        <cfargument name = "productName" required = "no" type = "string">
        <cfargument name = "subCategoryId" required = "no" type = "integer">     
        <cfargument name = "productId" required = "no" type = "integer">     
        <cfquery name = "local.qryProduct" dataSource = "shoppingCart">
            SELECT 
                P.fldProduct_Id,
                P.fldProductName,
                P.fldSubcategoryId,
                P.fldBrandId,
                B.fldBrandName,
                P.fldDescription,
                P.fldUnitPrice,
                P.fldUnitTax,
                PI.fldImageFilePath,
                PI.fldDefaultImage
            FROM
                tblproduct P
            LEFT JOIN
                tblproductimages PI ON P.fldProduct_Id = PI.fldProductId
            LEFT JOIN
                tblbrand B ON P.fldBrandId = B.fldBrand_Id 
            WHERE
                PI.fldDefaultImage = 1
                AND P.fldActive = 1
                <cfif structKeyExists(arguments, "subCategoryId") AND len(trim(arguments.subCategoryId))>
                    AND P.fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                </cfif>
                <cfif structKeyExists(arguments, "productName") AND len(trim(arguments.productName))>
                    AND P.fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype = "varchar">
                </cfif>
                <cfif structKeyExists(arguments, "productId") AND len(trim(arguments.productId))>
                    AND P.fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                </cfif>            
        </cfquery>
        <cfreturn local.qryProduct>
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
            <cfset local.qryFetchProduct = qryProductData(
                productName = arguments.productName,
                subCategoryId = arguments.subCategoryId
            )>
            <cftry>
                <cfif local.qryFetchProduct.RecordCount AND (local.qryFetchProduct.fldProduct_Id NEQ arguments.productId)>
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
                            fldUnitTax = <cfqueryparam value = "#arguments.productTax#" cfsqltype = "integer">
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
                                    <cfqueryparam value = "#session.adminUserId#" cfsqltype = "integer">
                                )
                                <cfif imageIndex LT arrayLen(local.imageUploadedResult)>,</cfif>
                            </cfloop>;
                        </cfquery>
                    </cfif>
                    <cfset local.result['error'] = "true">
                    <cfset local.result['message'] = "ProductName Edited Succesfully">
                </cfif>
                <cfcatch type="exception">
                    <cfset local.result['error'] = "false">
                    <cfset local.result['message'] = "Error updating product: #cfcatch.message#">
                </cfcatch>
            </cftry>
        <cfelse>
            <!---create--->
            <cftry>           
                <cfset local.qryFetchProduct = qryProductData(
                    productName = arguments.productName,
                    subCategoryId = arguments.subCategoryId
                )>
                <cfif local.qryFetchProduct.RecordCount>
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
                            <cfqueryparam value = "#session.adminUserId#" cfsqltype = "integer">
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
                                <cfqueryparam value = "#session.adminUserId#" cfsqltype = "integer">
                            )
                            <cfif imageIndex LT arrayLen(local.imageUploadedResult)>,</cfif>
                        </cfloop>;
                    </cfquery>
                    <cfset local.result['error'] = "true">
                    <cfset local.result['message'] = "ProductName Added Succesfully">
                </cfif>
                <cfcatch type = "exception">
                    <cfset local.result['error'] = "false">
                    <cfset local.result['message'] = "Error adding images: #cfcatch.message#">
                </cfcatch>
            </cftry>        
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "viewProduct" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "productId" required = "yes" type = "integer">
        <cfargument name = "subCategoryId" required = "yes" type = "integer">
        <cfset local.productData = qryProductData(
            productId = productId,
            subCategoryId = subCategoryId
        )>
        <cfset local.product['productId'] = local.productData.fldproduct_Id>
        <cfset local.product['productName'] = local.productData.fldProductName>
        <cfset local.product['brandId'] = local.productData.fldBrandId>
        <cfset local.product['productDesc'] = local.productData.fldDescription>
        <cfset local.product['unitPrice'] = local.productData.fldUnitPrice>
        <cfset local.product['unitTax'] = local.productData.fldUnitTax>
        <cfreturn local.product>
    </cffunction>

    <cffunction name = "deleteProduct" access = "remote" returnType = "void">
        <cfargument name = "productId" required = "yes" type = "integer">
        <cfargument name = "subCategoryId" required = "yes" type = "integer">
        <cfquery> 
            UPDATE  
                tblproduct
            SET
                fldActive = 0,
                fldUpdatedBy = <cfqueryparam value = "#session.adminUserId#" cfsqltype = "integer">
            WHERE
                fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                AND fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                AND fldActive = 1;
        </cfquery>
    </cffunction>

    <cffunction name = "qryProductImage" access = "remote" returnFormat = "JSON" returnType = "query">
        <cfargument name = "productId" required = "yes" type = "integer">
        <cfargument name = "productImageId" required = "no" type = "integer">
        <cfquery name = "local.qryProductImage" dataSource = "shoppingCart">
            SELECT
                fldProductImage_Id,
                fldProductId,
                fldImageFilePath,
                fldDefaultImage
            FROM
                tblproductimages
            WHERE
                fldActive = 1
                AND fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                <cfif structKeyExists(arguments, "productImageId")>
                    AND fldProductImage_Id = <cfqueryparam value = "#arguments.productImageId#" cfsqltype = "integer">
                </cfif>;
        </cfquery>
        <cfreturn local.qryProductImage>
    </cffunction>

    <cffunction name = "setDefaultProductImage" access = "remote" returnType = "void">
        <cfargument name = "productImageId" required = "yes" type = "integer">
        <cfargument name = "productId" required = "yes" type = "integer">
        <cfquery>
            UPDATE
                tblproductimages
            SET
                fldDefaultImage = 0
            WHERE
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                AND fldActive = 1;
        </cfquery>
        <cfquery>
            UPDATE
                tblproductimages
            SET
                fldDefaultImage = 1
            WHERE
                fldProductImage_Id = <cfqueryparam value = "#arguments.productImageId#" cfsqltype = "integer">
                AND fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                AND fldActive = 1;
        </cfquery>
    </cffunction>

    <cffunction name = "deleteProductImage" access = "remote">
        <cfargument name = "productImageId" required = "yes" type = "integer">
        <cfargument name = "productId" required = "yes" type = "integer">
        <cfset productImageData = qryProductImage(
            productId = arguments.productId,
            productImageId = arguments.productImageId
        )>
        <cffile action = "delete" file = "#expandPath('../assets/images/product#productImageData.fldProductId#/#productImageData.fldImageFilePath#')#">>
        
        <cfquery>
            UPDATE
                tblproductimages
            SET
                fldActive = 0,
                fldDeactivatedBy = <cfqueryparam value = "#session.adminUserId#" cfsqltype = "integer">,
                fldDeactivatedDate = <cfqueryparam value = "#now()#" cfsqltype = "timestamp">
            WHERE
                fldProductImage_Id = <cfqueryparam value = "#arguments.productImageId#" cfsqltype = "integer">
                AND fldActive = 1;
        </cfquery>
    </cffunction>
</cfcomponent>