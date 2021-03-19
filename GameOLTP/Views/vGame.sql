Create OR ALTER View Game.vGame
/***************************************************************************************************
File: vGame.sql
----------------------------------------------------------------------------------------------------
View:           Game.vGame
Create Date:    2021-03-01 
Author:         Sorob Cyrus
Description:    Creates the view for Partners and their Games  
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
	G.GameID,
	G.[Name],
	T.[Name] AS GameType,
	P.PartnerID,
	P.[Name] As [Partner]
FROM Game.Game G
	JOIN Game.[Partner] P
	ON G.PartnerID = P.PartnerID
	JOIN Game.[Type] T
	ON G.TypeID = T.TypeID
;
GO