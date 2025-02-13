CREATE DEFINER=`parikshith`@`%` PROCEDURE `sp_placeOrder`(	
	IN userId INT,
	IN addressId INT,
	IN cardNumber VARCHAR(16), 
	IN totalPrice DECIMAL(10,2),   
	IN totalTax DECIMAL(10,2),
    IN orderId varchar(64),
	IN productId INT
)
BEGIN
	INSERT INTO tblorder(fldOrder_Id,fldUserId,fldAddressId,fldCardNumber,fldTotalPrice,fldTotalTax)
    VALUES(orderId,userId,addressId,cardNumber,totalPrice,totalTax);
    
    IF productId = 0 THEN	
        INSERT INTO tblorderitems(fldOrderId, fldProductId, fldQuantity, fldUnitPrice, fldUnitTax)
        SELECT orderId, c.fldProductId, c.fldQuantity, p.fldUnitPrice, p.fldUnitTax 
        FROM tblcart c 
        INNER JOIN tblproduct p ON p.fldProduct_Id = c.fldProductId
        WHERE c.fldUserId = userId;
        
        DELETE FROM tblcart WHERE fldUserId = userId;
    ELSE
        INSERT INTO tblorderitems(fldOrderId, fldProductId, fldQuantity, fldUnitPrice, fldUnitTax)
        SELECT orderId, c.fldProductId, c.fldQuantity, p.fldUnitPrice, p.fldUnitTax 
        FROM tblcart c
        INNER JOIN tblproduct p ON p.fldProduct_Id = c.fldProductId
        WHERE c.fldProductId = productId
        AND c.fldUserId = userId;
        
        DELETE FROM tblcart WHERE fldUserId = userId AND fldProductId = productId;
    END IF;
END