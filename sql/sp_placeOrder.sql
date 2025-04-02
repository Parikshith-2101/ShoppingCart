CREATE DEFINER=`parikshith`@`%` PROCEDURE `sp_placeOrder`(	
	IN userId INT,
	IN addressId INT,
	IN cardNumber VARCHAR(16), 
	IN productId INT,
	OUT totalPrice DECIMAL(10,2),   
	OUT totalTax DECIMAL(10,2),
    OUT orderId varchar(64)
)
BEGIN
    SET totalPrice = 0;
    SET totalTax = 0;
    SET orderId = uuid();

    SELECT 
        SUM(P.fldUnitPrice * C.fldQuantity), SUM(P.fldUnitTax * C.fldQuantity)
    INTO 
        totalPrice,totalTax    
    FROM 
        tblcart C INNER JOIN tblproduct P ON P.fldProduct_Id = C.fldProductId
    WHERE 
        C.fldUserId = userId AND (productId = 0 OR C.fldProductId = productId);

	INSERT INTO tblorder(
        fldOrder_Id,
        fldUserId,
        fldAddressId,
        fldCardNumber,
        fldTotalPrice,
        fldTotalTax
        ) VALUES(
        orderId,
        userId,
        addressId,
        cardNumber,
        totalPrice,
        totalTax
    );
    
    INSERT INTO tblorderitems(
        fldOrderId,
        fldProductId,
        fldQuantity,
        fldUnitPrice,
        fldUnitTax
    )
    SELECT 
        orderId,
        C.fldProductId,
        C.fldQuantity,
        p.fldUnitPrice,
        p.fldUnitTax 
    FROM 
        tblcart C
    INNER JOIN tblproduct p ON p.fldProduct_Id = C.fldProductId
    WHERE C.fldUserId = userId AND (productId = 0 OR C.fldProductId = productId);

    DELETE FROM tblcart 
    WHERE fldUserId = userId AND (productId = 0 OR fldProductId = productId);
END