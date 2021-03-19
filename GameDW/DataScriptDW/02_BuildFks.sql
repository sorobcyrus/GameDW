/***************************************************************************************************
File: 03_BuildFKs.sql
----------------------------------------------------------------------------------------------------
Create Date:    2021-03-01 
Author:         Sorob Cyrus
Description:    Creates all needed GameDW FKs  
Call by:        TBD, UI, Add hoc
Steps:          NA
****************************************************************************************************
SUMMARY OF CHANGES
Date			Author				Comments 
------------------- ------------------- ------------------------------------------------------------
****************************************************************************************************/
SET NOCOUNT ON;

DECLARE @ErrorText VARCHAR(MAX),      
        @Message   VARCHAR(255),   
        @StartTime DATETIME

BEGIN TRY;   
SET @ErrorText = 'Unexpected ERROR in setting the variables!';  

SET @StartTime = GETDATE();    

SET @Message = 'Started SP ' + FORMAT(@StartTime , 'MM/dd/yyyy HH:mm:ss');  
RAISERROR (@Message, 0,1) WITH NOWAIT;
-------------------------------------------------------------------------------

SET @ErrorText = 'Failed Calling SP CreateFKs!.';


EXEC GameDW.CreateFKs;

SET @Message = 'Completed SP CreateFKs';   
RAISERROR(@Message, 0,1) WITH NOWAIT;


-------------------------------------------------------------------------------

SET @Message = 'Completed, Duration in minutes:  '   
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
