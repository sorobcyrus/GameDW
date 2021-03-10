CREATE OR ALTER PROCEDURE Game.CreateFKs
AS
/***************************************************************************************************
File: CreateTables.sql
----------------------------------------------------------------------------------------------------
Procedure:      Game.CreateFKs
Create Date:    2021-03-01 
Author:         Sorob Cyrus
Description:    Creates all needed Game FKs  
Call by:        TBD, UI, Add hoc
Steps:          NA
Parameter(s):   None
Usage:          EXEC Game.CreateFKs
****************************************************************************************************
SUMMARY OF CHANGES
Date			Author				Comments 
------------------- ------------------- ------------------------------------------------------------
****************************************************************************************************/
SET NOCOUNT ON;

DECLARE @ErrorText VARCHAR(MAX),      
        @Message   VARCHAR(255),   
        @StartTime DATETIME,
        @SP        VARCHAR(50)

BEGIN TRY;   
SET @ErrorText = 'Unexpected ERROR in setting the variables!';  

SET @SP = OBJECT_NAME(@@PROCID)
SET @StartTime = GETDATE();    

SET @Message = 'Started SP ' + @SP + ' at ' + FORMAT(@StartTime , 'MM/dd/yyyy HH:mm:ss');  
RAISERROR (@Message, 0,1) WITH NOWAIT;
-------------------------------------------------------------------------------

SET @ErrorText = 'Failed adding FOREIGN KEY for Table Game.Order.';

IF EXISTS (SELECT *
	FROM sys.foreign_keys
	WHERE object_id = OBJECT_ID(N'Game.FK_Order_Game_GameID')
	AND parent_object_id = OBJECT_ID(N'Game.Order')
)
BEGIN
  SET @Message = 'FOREIGN KEY for Table Game.Order already exist, skipping....';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
  ALTER TABLE Game.[Order]
   ADD CONSTRAINT FK_Order_Game_GameID FOREIGN KEY (GameID)
      REFERENCES Game.Game (GameID),
   CONSTRAINT FK_Order_Retailer_RetailerID FOREIGN KEY (RetailerID)
      REFERENCES Game.Retailer (RetailerID);
      
  SET @Message = 'Completed adding FOREIGN KEY for TABLE Game.Order.';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
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

