/***************************************************************************************************
File: 02_InstertTables.sql
----------------------------------------------------------------------------------------------------
Create Date:    2021-03-01 
Author:         Sorob Cyrus
Description:    Inserts needed parameters to table Game.Game, Game.Team and Game.GameTeam (Many to Many) 
Call by:        TBD, Add hoc
****************************************************************************************************
SUMMARY OF CHANGES
Date(yyyy-mm-dd)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
****************************************************************************************************/
SET NOCOUNT ON;

DECLARE @ErrorText VARCHAR(MAX),      
        @Message   VARCHAR(255),   
        @StartTime DATETIME,
        @SP        VARCHAR(50)

BEGIN TRY;   
SET @ErrorText = 'Unexpected ERROR in setting the variables!';

SET @SP = 'Script-1_InsertDataPartner';
SET @StartTime = GETDATE();

SET @Message = 'Started SP ' + @SP + ' at ' + FORMAT(@StartTime , 'MM/dd/yyyy HH:mm:ss');   
RAISERROR (@Message, 0,1) WITH NOWAIT;

-------------------------------------------------------------------------------

SET @ErrorText = 'Failed INSERT to table Game!';
INSERT INTO Game.Game
   (GameID, PartnerID, TypeID, [Name])
VALUES
   (101, 102, 1, 'Stratigists Concur'),
   (102, 101, 2, 'Chess match ultimate'),
   (103, 104, 3, 'Band of firends'),
   (104, 103, 4, 'Red-White rose')

SET @Message = CONVERT(VARCHAR(10), @@ROWCOUNT) + ' rows effected. Completed INSERT to table Game';   
RAISERROR (@Message, 0,1) WITH NOWAIT;
-------------------------------------------------------------------------------

SET @ErrorText = 'Failed INSERT to table Type!';
INSERT INTO Game.Type
   (TypeID, [Name], Note)
VALUES
   (1, 'Strategy', 'Games based on strategy'),
   (2, 'Brain Games', 'Games to improve cognitive behaviour'),
   (3, 'War Games', 'Games based on killing nature'),
   (4, 'Politics', 'Games based on politics'),
   (5, 'Romantic', 'Games nobody wants to play')

SET @Message = CONVERT(VARCHAR(10), @@ROWCOUNT) + ' rows effected. Completed INSERT to table Game';   
RAISERROR (@Message, 0,1) WITH NOWAIT;
-------------------------------------------------------------------------------

SET @ErrorText = 'Failed INSERT to table Partner!';
INSERT INTO Game.Partner
   (PartnerID, [Name])
VALUES
   (101, 'Accentuarist'),
   (102, 'Macrosoft'),
   (103, 'Avanator'),
   (104, 'Dotnetters')

SET @Message = CONVERT(VARCHAR(10), @@ROWCOUNT) + ' rows effected. Completed INSERT to table Game';   
RAISERROR (@Message, 0,1) WITH NOWAIT;
-------------------------------------------------------------------------------

SET @ErrorText = 'Failed INSERT to table PartnerInfo!';
INSERT INTO Game.PartnerInfo
   (PartnerID, Website, City, [State], Country, Note)
VALUES
   (101, 'Accentuarist.GOM', 'Redmond', 'WA', 'United States', NULL),
   (102, 'Macrosoft.GOM', 'Denver', 'CO', 'United States', NULL),
   (103, 'Avanator.GOM', 'Seattle', 'WA', 'United States', NULL),
   (104, 'Dotnetters.GOM', 'Tuscon', 'AZ', 'United States', NULL)

SET @Message = CONVERT(VARCHAR(10), @@ROWCOUNT) + ' rows effected. Completed INSERT to table PartnerInfo';   
RAISERROR (@Message, 0,1) WITH NOWAIT;
-------------------------------------------------------------------------------

SET @ErrorText = 'Failed INSERT to table Retailer!';
INSERT INTO Game.Retailer
   (RetailerID, [Name])
VALUES
   (101, 'Amazian'),
   (102, 'Googoolie'),
   (103, 'Costonco')

SET @Message = CONVERT(VARCHAR(10), @@ROWCOUNT) + ' rows effected. Completed INSERT to table Retailer';   
RAISERROR (@Message, 0,1) WITH NOWAIT;
-------------------------------------------------------------------------------

SET @ErrorText = 'Failed INSERT to table Order!';
INSERT INTO Game.[Order]
   (OrderID, GameID, RetailerID, OrderDate, Quantity, TotalAmount)
VALUES
   (01, 101, 101, '01/01/2021', 1, 10),
   (02, 101, 102, '01/02/2021', 2, 20),
   (03, 101, 102, '01/03/2021', 3, 30),
   (04, 101, 101, '01/03/2021', 4, 40),
   (05, 102, 101, '01/01/2021', 1, 10),
   (06, 102, 102, '01/02/2021', 2, 20),
   (07, 102, 103, '01/03/2021', 3, 30),
   (08, 102, 102, '01/03/2021', 4, 40),
   (09, 103, 103, '01/01/2021', 1, 10),
   (10, 103, 102, '01/02/2021', 2, 20),
   (11, 103, 101, '01/03/2021', 3, 30),
   (12, 103, 101, '01/03/2021', 4, 40)

SET @Message = CONVERT(VARCHAR(10), @@ROWCOUNT) + ' rows effected. Completed INSERT to table Customer';   
RAISERROR (@Message, 0,1) WITH NOWAIT;
-------------------------------------------------------------------------------

SET @Message = 'Completed SP ' + @SP + '. Duration in minutes:  '   
   + CONVERT(VARCHAR(12), CONVERT(DECIMAL(6,2),datediff(mi, @StartTime, getdate())));    
RAISERROR(@Message, 0,1) WITH NOWAIT;

END TRY

BEGIN CATCH;
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

SET @ErrorText = 'Error: '+CONVERT(VARCHAR,ISNULL(ERROR_NUMBER(),'NULL'))      
                  +', Severity = '+CONVERT(VARCHAR,ISNULL(ERROR_SEVERITY(),'NULL'))      
                  +', State = '+CONVERT(VARCHAR,ISNULL(ERROR_STATE(),'NULL'))      
                  +', Line = '+CONVERT(VARCHAR,ISNULL(ERROR_LINE(),'NULL'))      
                  +', Procedure = '+CONVERT(VARCHAR,ISNULL(ERROR_PROCEDURE(),'NULL'))      
                  +', Server Error Message = '+CONVERT(VARCHAR(100),ISNULL(ERROR_MESSAGE(),'NULL'))      
                  +', SP Defined Error Text = '+@ErrorText;

RAISERROR(@ErrorText,18,127) WITH NOWAIT;
END CATCH;      
