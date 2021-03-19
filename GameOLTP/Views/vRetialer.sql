Create OR ALTER View Game.vRetailer
/***************************************************************************************************
File: vRetailer.sql
----------------------------------------------------------------------------------------------------
View:           Game.vRetailer
Create Date:    2021-03-01 
Author:         Sorob Cyrus
Description:    Creates the view for Retailers' Information 
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
	R.RetailerID,
	R.[Name]
FROM Game.Retailer R
;
GO