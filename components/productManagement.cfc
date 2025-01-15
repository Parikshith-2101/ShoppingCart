<cfcomponent>
    <!---Category--->
    <cffunction name = "qryCategoryData" access = "public" returnType = "query">
        <cfargument name = "categoryId" required = "no">
        <cfargument name = "categoryName" required = "no">
        <cfquery name = "local.fetchCategoryData">
            SELECT 
                fldCategory_Id,
                fldCategoryName
            FROM
                tblcategory
            WHERE           
                fldActive = <cfqueryparam value = "1" cfsqltype = "integer">
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
        <cfargument name = "categoryName">
        <cftry>                
            <cfset local.fetchCategoryData = qryCategoryData(categoryName = arguments.categoryName)>
            <cfif local.fetchCategoryData.RecordCount>
                <cfset local.result['resultMsg'] = "Catergory Already Exists">
                <cfset local.result['errorStatus'] = "false">
            <cfelse>
                <cfquery name = "local.qryAddCategory" result = "local.categoryId">
                    INSERT INTO tblcategory(
                        fldCategoryName,
                        fldCreatedBy
                    ) 
                    VALUES(
                        <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "varchar">,
                        <cfqueryparam value = "#session.userId#" cfsqltype = "varchar">
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
        <cfargument name = "categoryId">
        <cfset local.categoryData = qryCategoryData(arguments.categoryId)>
        <cfset local.category['categoryName'] = local.categoryData.fldCategoryName>
        <cfset local.category['categoryId'] = local.categoryData.fldCategory_Id>
        <cfreturn local.category>
    </cffunction>

    <cffunction name = "editCategory" access = "remote" returnType = "Struct" returnFormat = "JSON">
        <cfargument name = "categoryId"> 
        <cfargument name = "categoryName"> 
        <cftry>  
            <cfset local.categoryNameCheck = qryCategoryData(
                categoryId = arguments.categoryId,
                categoryName = arguments.categoryName
            )>
            <cfset local.categoryData = qryCategoryData(categoryName = arguments.categoryName)>
            <cfif local.categoryNameCheck.RecordCount>
                <cfset local.output['resultMsg'] = "">
                <cfset local.output['errorStatus'] = "nill">
            <cfelseif local.categoryData.RecordCount>
                <cfset local.output['resultMsg'] = "Category Already Exists">
                <cfset local.output['errorStatus'] = "false">
            <cfelse>
                <cfquery name = "local.qryEditCategory">
                    UPDATE 
                        tblcategory
                    SET 
                        fldCategoryName = <cfqueryparam value = "#arguments.categoryName#" cfsqltype = "varchar">,
                        fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                    WHERE
                        fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                        AND fldActive = <cfqueryparam value = "1" cfsqltype = "integer">;
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
        <cfargument name = "categoryId">
        <cfquery name = "local.qryDeleteCategory">
            UPDATE 
                tblcategory
            SET 
                fldActive = <cfqueryparam value = "0" cfsqltype = "integer">,
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
            WHERE
                fldCategory_Id = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">;
        </cfquery>
    </cffunction>

    <!---SubCategory--->
    <cffunction name = "qrySubCategoryData" access = "remote" returnType = "query" returnFormat = "JSON">
        <cfargument name = "subCategoryId" required = "no">
        <cfargument name = "subCategoryName" required = "no">
        <cfargument name = "categoryId" required = "no">
        <cfquery name = "local.qrySubCategoryData">
            SELECT 
                fldSubCategory_Id,
                fldCategoryId,
                fldSubCategoryName
            FROM
                tblsubcategory
            WHERE
                fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                AND fldActive = <cfqueryparam value = "1" cfsqltype = "integer">
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
        <cfargument name = "subCategoryName">
        <cfargument name = "categoryId">
        <cftry>
            <cfset local.fetchSubCategoryData = qrySubCategoryData(
                subCategoryId = arguments.subCategoryId,
                categoryId = arguments.categoryId
            )>
            <cfif local.fetchSubCategoryData.RecordCount>
                <cfset local.result['resultMsg'] = "SubCatergory Already Exists">
                <cfset local.result['errorStatus'] = "false">
            <cfelse>
                <cfquery name = "local.qryAddSubCategory" result = "local.subCategoryId">
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
        <cfargument name = "subCategoryId">
        <cfargument name = "categoryId">
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
        <cfargument name = "subCategoryId"> 
        <cfargument name = "subCategoryName">
        <cfargument name = "categoryId">
        <cfargument name = "newCategoryId">
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
                <cfquery name = "local.qryEditSubCategory">
                    UPDATE 
                        tblsubcategory
                    SET 
                        fldSubCategoryName = <cfqueryparam value = "#arguments.subCategoryName#" cfsqltype = "varchar">,
                        fldCategoryId = <cfqueryparam value = "#arguments.newCategoryId#" cfsqltype = "integer">,
                        fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                    WHERE
                        fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                        AND fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">
                        AND fldActive = <cfqueryparam value = "1" cfsqltype = "integer">;
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
        <cfargument name = "subCategoryId">
        <cfargument  name = "categoryId">
        <cfquery name = "local.qryDeleteCategory">
            UPDATE 
                tblsubcategory
            SET 
                fldActive = <cfqueryparam value = "0" cfsqltype = "integer">,
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
            WHERE
                fldSubCategory_Id = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                AND fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "integer">;
        </cfquery>
    </cffunction>

    <cffunction name = "qryBrandData" returnType = "query">
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

    <cffunction name = "qryProductData" returnType = "query">
        <cfargument name = "productName" required = "no">
        <cfargument name = "subCategoryId" required = "no">     
        <cfargument name = "productId" required = "no">     
        <cfquery name = "local.qryProduct">
            SELECT 
                p.fldProduct_Id,
                p.fldProductName,
                p.fldSubcategoryId,
                p.fldBrandId,
                b.fldBrandName,
                p.fldDescription,
                p.fldUnitPrice,
                p.fldUnitTax,
                pi.fldImageFilePath,
                pi.fldDefaultImage
            FROM
                tblproduct p
            LEFT JOIN
                tblproductimages pi ON p.fldProduct_Id = pi.fldProductId
            LEFT JOIN
                tblbrand b ON p.fldBrandId = b.fldBrand_Id 
            WHERE
                p.fldActive = <cfqueryparam value = "1" cfsqltype = "integer">
                AND pi.fldDefaultImage = <cfqueryparam value = "1" cfsqltype = "integer">
                <cfif structKeyExists(arguments, "subCategoryId") AND len(trim(arguments.subCategoryId))>
                    AND p.fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">
                </cfif>
                <cfif structKeyExists(arguments, "productName") AND len(trim(arguments.productName))>
                    AND p.fldProductName = <cfqueryparam value = "#arguments.productName#" cfsqltype = "varchar">
                </cfif>
                <cfif structKeyExists(arguments, "productId") AND len(trim(arguments.productId))>
                    AND p.fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                </cfif>
            GROUP BY
                p.fldProduct_Id,
                p.fldProductName,
                p.fldSubcategoryId,
                p.fldBrandId,
                b.fldBrandName,
                p.fldDescription,
                p.fldUnitPrice,
                p.fldUnitTax,
                pi.fldImageFilePath,
                pi.fldDefaultImage;             
        </cfquery>
        <cfreturn local.qryProduct>
    </cffunction>

    <cffunction name = "addProduct" access = "public" returnType = "struct">
        <cfargument name = "categoryId">
        <cfargument name = "subCategoryId">
        <cfargument name = "productName">
        <cfargument name = "productBrandId">
        <cfargument name = "productDesc">
        <cfargument name = "productPrice">
        <cfargument name = "productTax">
        <cfargument name = "productImage">
        <cfargument name = "productId">
       
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
                    <cftry>
                    <cfquery name = "qryEditProduct">  
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
                    </cfquery>
                    <cfif len(trim(arguments.productImage))>
                        <cffile
                            action = "uploadall"
                            destination = "#expandpath("../assets/images/productImages")#"
                            nameconflict = "MakeUnique"
                            strict = "true"
                            result = "local.imageUploadedResult"
                        >
                        <cfquery name = "qryAddImages">
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
                    <cfquery name = "local.qryInsertProduct" result = "local.resultProductId">
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
                    <cfquery name = "insertProductImages">
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
                    <cfset local.result['errorStatus'] = "true">
                    <cfset local.result['resultMsg'] = "ProductName Added Succesfully">
                    <cfcatch type="exception">
                        <cfset local.result['errorStatus'] = "false">
                        <cfset local.result['resultMsg'] = "Error adding images: #cfcatch.message#">
                    </cfcatch>
                </cftry>        
            </cfif>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "viewProduct" access = "remote" returnType = "struct" returnFormat = "JSON">
        <cfargument name = "productId">
        <cfargument name = "subCategoryId">
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
        <cfargument name = "productId">
        <cfargument name = "subCategoryId">
        <cfquery name = "local.qryDeactivateProduct"> 
            UPDATE  
                tblproduct
            SET
                fldActive = <cfqueryparam value = "0" cfsqltype = "integer">,
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
            WHERE
                fldProduct_Id = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                AND fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfsqltype = "integer">;
        </cfquery>
        <cfquery name = "local.qryDeactivateProductImages">
            UPDATE 
                tblproductimages
            SET
                fldActive = <cfqueryparam value = "0" cfsqltype = "integer">,
                fldDeactivatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                fldDeactivatedDate = <cfqueryparam value = "#now()#" cfsqltype = "timestamp">
            WHERE
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">;
        </cfquery>
    </cffunction>

    <cffunction name = "qryProductImage" access = "remote" returnFormat = "JSON" returnType = "query">
        <cfargument name = "productId">
        <cfquery name = "local.qryProductImage">
            SELECT
                fldProductImage_Id,
                fldProductId,
                fldImageFilePath,
                fldDefaultImage
            FROM
                tblproductimages
            WHERE
                fldActive = <cfqueryparam value = "1" cfsqltype = "integer">
                AND fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
        </cfquery>
        <cfreturn local.qryProductImage>
    </cffunction>

    <cffunction name = "setDefaultProductImage" access = "remote">
        <cfargument name = "productImageId">
        <cfargument name = "productId">
        <cfquery name = "local.removeDefault">
            UPDATE
                tblproductimages
            SET
                fldDefaultImage = <cfqueryparam value = "0" cfsqltype = "integer">
            WHERE
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
        </cfquery>
        <cfquery name = "local.setDefault">
            UPDATE
                tblproductimages
            SET
                fldDefaultImage = <cfqueryparam value = "1" cfsqltype = "integer">
            WHERE
                fldProductImage_Id = <cfqueryparam value = "#arguments.productImageId#" cfsqltype = "integer">
                AND fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">;
        </cfquery>
    </cffunction>

    <cffunction name = "deleteProductImage" access = "remote">
        <cfargument name = "productImageId">
        <cfquery name = "local.deleteProductImage">
            UPDATE
                tblproductimages
            SET
                fldActive = <cfqueryparam value = "0" cfsqltype = "integer">,
                fldDeactivatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                fldDeactivatedDate = <cfqueryparam value = "#now()#" cfsqltype = "timestamp">
            WHERE
                fldProductImage_Id = <cfqueryparam value = "#arguments.productImageId#" cfsqltype = "integer">;
        </cfquery>
    </cffunction>
</cfcomponent>