CREATE OR ALTER PROCEDURE GameDW.CreateTables
AS
/***************************************************************************************************
File: CreateTables.sql
----------------------------------------------------------------------------------------------------
Procedure:      GameDW.CreateTables
Create Date:    2021-03-01 (yyyy-mm-dd)
Author:         Sorob Cyrus
Description:    Creates all needed GameDW tables  
Call by:        TBD, UI, Add hoc
Steps:          NA
Parameter(s):   None
Usage:          EXEC GameDW.CreateTables
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

SET @SP = OBJECT_NAME(@@PROCID)
SET @StartTime = GETDATE();    
SET @Message = 'Started SP ' + @SP + ' at ' + FORMAT(@StartTime , 'MM/dd/yyyy HH:mm:ss');  


-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table GameDW.DimTime.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'GameDW.DimTime') AND type in (N'U'))
BEGIN
    SET @Message = 'Table GameDW.DimTime already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE GameDW.DimTime
    (
        TimeKey int IDENTITY (1, 1) NOT NULL ,
        ActualDate DATE NOT NULL ,
        Year int NOT NULL ,
        Quarter int NOT NULL ,
        Month int NOT NULL ,
        Week int NOT NULL ,
        DayofYear int NOT NULL ,
        DayofMonth int NOT NULL ,
        DayofWeek int NOT NULL ,
        IsWeekend bit NOT NULL ,
        Comments varchar(20) NULL ,
        CalendarWeek int NOT NULL ,
        BusinessYearWeek int NOT NULL ,
        LeapYear tinyint NOT NULL,
        CONSTRAINT PK_DimTime_TimeKey PRIMARY KEY CLUSTERED (TimeKey)
    );
    SET @Message = 'Completed CREATE TABLE GameDW.DimTime.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

SET @ErrorText = 'Failed CREATE Table GameDW.DimRetailer.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'GameDW.DimRetailer') AND type in (N'U'))
BEGIN
    SET @Message = 'Table GameDW.DimRetailer already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE GameDW.DimRetailer
    (
        RetailerID TINYINT	NOT NULL,
        [Name] NVARCHAR(50) NOT NULL,
        CONSTRAINT PK_DimRetailer_RetailerID PRIMARY KEY CLUSTERED (RetailerID),
        CONSTRAINT UK_DimRetailer_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE GameDW.DimRetailer.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table GameDW.DimGame.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'GameDW.DimGame') AND type in (N'U'))
BEGIN
    SET @Message = 'Table GameDW.DimGame already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE GameDW.DimGame
    (
        GameID		TINYINT			NOT NULL,
        [Name]		NVARCHAR(50)	NOT NULL,
		GameType	VARCHAR(50)		NOT NULL,
		[Partner]	NVARCHAR(50)	NOT NULL
        CONSTRAINT PK_DimGame_GameID PRIMARY KEY CLUSTERED (GameID),
        CONSTRAINT UK_DimGame_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE GameDW.DimGame.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table GameDW.DimPartner.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'GameDW.DimPartner') AND type in (N'U'))
BEGIN
    SET @Message = 'Table GameDW.DimPartner already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE GameDW.DimPartner
    (
        PartnerID		TINYINT			NOT NULL,
        [Name]			NVARCHAR(50)	NOT NULL,
		Website			NVARCHAR(250)	NULL,
		City			VARCHAR(50)		NOT NULL,
		[State]			VARCHAR(2)		NOT NULL,
		Country			VARCHAR(50)		NOT NULL,
		[Note]			NVARCHAR(250)	NULL
        CONSTRAINT PK_DimPartner_PartnerID PRIMARY KEY CLUSTERED (PartnerID),
        CONSTRAINT UK_DimPartner_Name UNIQUE ([Name])
    );

    SET @Message = 'Completed CREATE TABLE GameDW.DimPartner.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table GameDW.FactSales.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'GameDW.FactSales') AND type in (N'U'))
BEGIN
    SET @Message = 'Table GameDW.FactSales already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE GameDW.FactSales
    (
        OrderID			INT			NOT NULL,
        GameID			TINYINT		NOT NULL,
        RetailerID		TINYINT		NOT NULL,
        TimeKey			INT			NOT NULL,
        TotalAmount		MONEY		NOT NULL,
        CONSTRAINT PK_FactSales_OrderID_CustomerID_ProductID_TimeKey PRIMARY KEY CLUSTERED (OrderID, GameID, RetailerID, TimeKey)
    );

    SET @Message = 'Completed CREATE TABLE GameDW.FactSales.';
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

