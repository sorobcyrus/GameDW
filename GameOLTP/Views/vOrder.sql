Create OR ALTER View Game.vOrder
/***************************************************************************************************
File: vRetailer.sql
----------------------------------------------------------------------------------------------------
View:           Game.vRetailer
Create Date:    2021-03-01 
Author:         Sorob Cyrus
Description:    Creates the view for Order' Information For seperation of concerns 
Call by:        OLAP
Steps:          NA
Parameter(s):   None
****************************************************************************************************
SUMMARY OF CHANGES
Date			Author				Comments 
------------------- ------------------- ------------------------------------------------------------
****************************************************************************************************/
AS
SELECT 
	O.OrderID,
	O.GameID,
	O.RetailerID,
	O.OrderDate,
	O.Quantity,
	O.TotalAmount
FROM Game.[Order] O
;
GO