Create OR ALTER View Game.vPartner
/***************************************************************************************************
File: vPartner.sql
----------------------------------------------------------------------------------------------------
View:           Game.vPartner
Create Date:    2021-03-01 
Author:         Sorob Cyrus
Description:    Creates the view for Partners' Information 
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
	P1.PartnerID,
	P1.[Name] As [Name],
	P2.Website,
	P2.City,
	P2.[State],
	P2.Country,
	P2.Note
FROM Game.[Partner] P1
	INNER JOIN Game.PartnerInfo P2
	ON P1.PartnerID = P2.PartnerID
;
GO