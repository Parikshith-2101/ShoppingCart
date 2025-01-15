<cfcomponent>
    <!---Category--->
    <cffunction name = "qryCategoryData" access = "public" returnType = "query">
        <cfargument name = "categoryId" required = "no" type = "integer">
        <cfargument name = "categoryName" required = "no" type = "string">
        <cfquery name = "local.fetchCategoryData">
            SELECT 
                fldCategory_Id,
                fldCategoryName
            FROM
                tblcategory
            WHERE           
                fldActive = 1
                <cfif structKeyExists(arguments, "categoryId") AND len(trim(arguments.categoryId))>
                    AND fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                </cfif>
                <cfif structKeyExists(arguments, "categoryName") AND len(trim(arguments.categoryName))>
                    AND fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "varchar">
                </cfif>;
        </cfquery>
        <cfreturn local.fetchCategoryData>
    </cffunction>

    <cffunction name = "addCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "categoryName" required = "yes" type = "string">
        <cftry>                
            <cfset local.fetchCategoryData = qryCategoryData(
                categoryName = arguments.categoryName
            )>
            <cfif local.fetchCategoryData.RecordCount>
                <cfset local.result['resultMsg'] = "Catergory Already Exists">
                <cfset local.result['errorStatus'] = "false">
            <cfelse>
                <cfquery result = "local.categoryId">
                    INSERT INTO tblcategory(
                        fldCategoryName,
                        fldCreatedBy
                    ) 
                    VALUES(
                        <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#session.adminUserId#" cfsqltype = "varchar">
                    );
                </cfquery>
                <cfset local.result['resultMsg'] = "Catergory Created">
                <cfset local.result['errorStatus'] = "true">
            </cfif>
            <cfcatch type = "exception">
                <cfset local.result['resultMsg'] = "Error: #cfcatch.message#">
                <cfset local.result['errorStatus'] = "false">
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "viewCategory" access = "remote" returnType = "Struct" returnFormat = "JSON">
        <cfargument name = "categoryId" required = "yes" type = "integer">
        <cfset local.categoryData = qryCategoryData(arguments.categoryId)>
        <cfset local.category['categoryName'] = local.categoryData.fldCategoryName>
        <cfset local.category['categoryId'] = local.categoryData.fldCategory_Id>
        <cfreturn local.category>
    </cffunction>

    <cffunction name = "editCategory" access = "remote" returnType = "Struct" returnFormat = "JSON">
        <cfargument name = "categoryId" required = "yes" type = "integer"> 
        <cfargument name = "categoryName" required = "yes" type = "string"> 
        <cftry>  
            <cfset local.categoryNameCheck = qryCategoryData(
                categoryId = arguments.categoryId,
                categoryName = arguments.categoryName
            )>
            <cfset local.categoryData = qryCategoryData(
                categoryName = arguments.categoryName
            )>
            <cfif local.categoryNameCheck.RecordCount>
                <cfset local.output['resultMsg'] = "">
                <cfset local.output['errorStatus'] = "nill">
            <cfelseif local.categoryData.RecordCount>
                <cfset local.output['resultMsg'] = "Category Already Exists">
                <cfset local.output['errorStatus'] = "false">
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
                <cfset local.output['resultMsg'] = "Category Edited SuccessFully">
                <cfset local.output['errorStatus'] = "true">
            </cfif>
            <cfcatch type = "exception">
                <cfset local.output['resultMsg'] = "Error: #cfcatch.message#">
                <cfset local.output['errorStatus'] = "false">
            </cfcatch>
        </cftry>
        <cfreturn local.output>
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
        <cfquery name = "local.qrySubCategoryData">
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

    <cffunction name = "addSubCategory" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "subCategoryName" required = "yes" type = "string">
        <cfargument name = "categoryId" required = "yes" type = "integer">
        <cftry>
            <cfset local.fetchSubCategoryData = qrySubCategoryData(
                subCategoryId = arguments.subCategoryId,
                categoryId = arguments.categoryId
            )>
            <cfif local.fetchSubCategoryData.RecordCount>
                <cfset local.result['resultMsg'] = "SubCatergory Already Exists">
                <cfset local.result['errorStatus'] = "false">
            <cfelse>
                <cfquery result = "local.subCategoryId">
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
                <cfset local.result['resultMsg'] = "SubCatergory Created">
                <cfset local.result['errorStatus'] = "true">
            </cfif>
            <cfcatch type = "exception">
                <cfset local.result['resultMsg'] = "Error: #cfcatch.message#">
                <cfset local.result['errorStatus'] = "false">
            </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "viewSubCategory" access = "remote" returnType = "Struct" returnFormat = "JSON">
        <cfargument name = "subCategoryId" required = "yes" type = "integer">
        <cfargument name = "categoryId" required = "yes" type = "integer">
        <cfset local.subCategoryData = qrySubCategoryData(
            subCategoryId = arguments.subCategoryId,
            categoryId = arguments.categoryId
        )>
        <cfset local.subCategory['subCategoryName'] = local.subCategoryData.fldSubCategoryName>
        <cfset local.subCategory['subCategoryId'] = local.subCategoryData.fldSubCategory_Id>
        <cfset local.subCategory['categoryId'] = local.subCategoryData.fldcategoryId>
        <cfreturn local.subCategory>
    </cffunction> 

    <cffunction name = "editSubCategory" access = "remote" returnType = "Struct" returnFormat = "JSON">
        <cfargument name = "subCategoryId" required = "yes" type = "integer"> 
        <cfargument name = "subCategoryName" required = "yes" type = "string">
        <cfargument name = "categoryId" required = "yes" type = "integer">
        <cfargument name = "newCategoryId" required = "yes" type = "integer">
        <cftry>
            <cfset local.subCategoryNameCheck = qrySubCategoryData(
                subCategoryName = arguments.subCategoryName,
                subCategoryId = arguments.subCategoryId,
                categoryId = arguments.newCategoryId
            )>
            <cfset local.subCategoryData = qrySubCategoryData(
                subCategoryName = arguments.subCategoryName,
                categoryId = arguments.newCategoryId
            )>

            <cfif local.subCategoryNameCheck.RecordCount>
                <cfset local.output['resultMsg'] = "">
                <cfset local.output['errorStatus'] = "nill">
            <cfelseif local.subCategoryData.RecordCount>
                <cfset local.output['resultMsg'] = "Category Already Exists">
                <cfset local.output['errorStatus'] = "false">
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
                <cfset local.output['resultMsg'] = "Category Edited SuccessFully">
                <cfset local.output['errorStatus'] = "true">
            </cfif>
            <cfcatch type="exception">
                <cfset local.output['resultMsg'] = "Error: #cfcatch.message#">
                <cfset local.output['errorStatus'] = "false">
            </cfcatch>
        </cftry>
        <cfreturn local.output>
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
        <cfquery name = "local.qryBrand">
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
        <cfquery name = "local.qryProduct">
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
                tblproduct p
            LEFT JOIN
                tblproductimages pi ON P.fldProduct_Id = PI.fldProductId
            LEFT JOIN
                tblbrand b ON P.fldBrandId = B.fldBrand_Id 
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
            GROUP BY
                P.fldProduct_Id,
                P.fldProductName,
                P.fldSubcategoryId,
                P.fldBrandId,
                B.fldBrandName,
                P.fldDescription,
                P.fldUnitPrice,
                P.fldUnitTax,
                PI.fldImageFilePath,
                PI.fldDefaultImage;             
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
        <cfargument name = "productImage" required = "yes" type = "array">
        <cfargument name = "productId" required = "no" type = "integer">
       
        <cfif len(trim(arguments.productId))>
            <cfset local.qryFetchProduct = qryProductData(
                productName = arguments.productName,
                subCategoryId = arguments.subCategoryId
            )>
            <cftry>
                <cfif local.qryFetchProduct.RecordCount AND (local.qryFetchProduct.fldProduct_Id NEQ arguments.productId)>
                    <cfset local.result['errorStatus'] = "false">
                    <cfset local.result['resultMsg'] = "ProductName Already Exists">
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
                            destination = "#expandpath("../assets/images/productImages")#"
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
                    <cfset local.result['errorStatus'] = "true">
                    <cfset local.result['resultMsg'] = "ProductName Edited Succesfully">
                </cfif>
                <cfcatch type="exception">
                    <cfset local.result['errorStatus'] = "false">
                    <cfset local.result['resultMsg'] = "Error updating product: #cfcatch.message#">
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
                    <cfset local.result['errorStatus'] = "false">
                    <cfset local.result['resultMsg'] = "ProductName Already Exists">
                <cfelse>
                    <cffile
                        action = "uploadall"
                        destination = "#expandpath("../assets/images/productImages")#"
                        nameconflict = "MakeUnique"
                        strict = "true"
                        result = "local.imageUploadedResult"
                    >
                    <cfquery result = "local.resultProductId">
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
                    <cfset local.result['errorStatus'] = "true">
                    <cfset local.result['resultMsg'] = "ProductName Added Succesfully">
                </cfif>
                <cfcatch type = "exception">
                    <cfset local.result['errorStatus'] = "false">
                    <cfset local.result['resultMsg'] = "Error adding images: #cfcatch.message#">
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
        <cfquery>
            UPDATE 
                tblproductimages
            SET
                fldActive = 0,
                fldDeactivatedBy = <cfqueryparam value = "#session.adminUserId#" cfsqltype = "integer">,
                fldDeactivatedDate = <cfqueryparam value = "#now()#" cfsqltype = "timestamp">
            WHERE
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                AND fldActive = 1;
        </cfquery>
    </cffunction>

    <cffunction name = "qryProductImage" access = "remote" returnFormat = "JSON" returnType = "query">
        <cfargument name = "productId" required = "yes" type = "integer">
        <cfquery name = "local.qryProductImage">
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