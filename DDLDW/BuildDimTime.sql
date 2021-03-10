CREATE OR ALTER PROCEDURE GameDW.BuildDimTime
    @MinDate DATE,
    @MaxDate DATE
AS
/***************************************************************************************************
File: BuildDimTime.sql
----------------------------------------------------------------------------------------------------
Procedure:      GameDW.BuildDimTime
Create Date:    2021-03-01 (yyyy-mm-dd)
Author:         Sorob Cyrus
Description:    Build table GameDW.DimTime  
Call by:        TBD, UI, Add hoc
Steps:          NA
Parameter(s):   None
Usage:          EXEC GameDW.BuildDimTime @MinDate = '1/1/2020',
                                        @MaxDate = '1/31/2022';
****************************************************************************************************
SUMMARY OF CHANGES
Date(yyyy-mm-dd)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
****************************************************************************************************/
SET NOCOUNT ON;

DECLARE @ErrorText VARCHAR(MAX),      
        @Message   VARCHAR(255),   
        @StartTime DATETIME,
        @SP        VARCHAR(50);

BEGIN TRY;   
SET @ErrorText = 'Unexpected ERROR in setting the variables!';  

SET @SP = OBJECT_NAME(@@PROCID)
SET @StartTime = GETDATE();    
SET @Message = 'Started SP ' + @SP + ' at ' + FORMAT(@StartTime , 'MM/dd/yyyy HH:mm:ss');  
 
-------------------------------------------------------------------------------
SET @ErrorText = 'Failed Build Table GameDW.DimTime.';

-- Delete contents of Date Dimension Table
TRUNCATE TABLE GameDW.DimTime;

-- Declare variables
-- DECLARE @DT DATETIME
DECLARE @DT DATE;
DECLARE @YEAR INT;
DECLARE @QUARTER INT;
DECLARE @MONTH  INT;
DECLARE @WEEK  INT;
DECLARE @DayofYear INT;
DECLARE @DayofMonth INT;
DECLARE @DayofWeek INT;
DECLARE @IsWeekend  BIT;
-- DECLARE @IsHoliday  BIT
DECLARE @CalendarWeek INT;
DECLARE @DayName VARCHAR(20);
DECLARE @MonthName VARCHAR(20);
DECLARE @BusinessYearWeek INT;
DECLARE @LeapYear BIT;

-- Initialize variables
SET @BusinessYearWeek =0;
SET @CalendarWeek = 1;
SET @LeapYear =0;

-- The starting date for the date dimension
-- SET  @DT  = '1/1/2020'
SET  @DT  = @MinDate;

-- Start looping, stop at ending date
-- WHILE (@DT <= '1/31/2022')
WHILE (@DT <= @MaxDate)
BEGIN

    -- Get information about the data
    SET @IsWeekend = 0;
    SET @YEAR = DATEPART (YEAR, @DT);
    SET @QUARTER = DATEPART (QUARTER, @DT);
    SET @MONTH = DATEPART (MONTH , @DT);
    SET @WEEK  = DATEPART (WEEK , @DT);
    SET @DayofYear = DATEPART (DY , @DT);
    SET @DayofMonth = DATEPART (DAY , @DT);
    SET @DayofWeek = DATEPART (DW , @DT);

    -- Note if weekend or not
    IF ( @DayofWeek = 1 OR @DayofWeek = 7 )  
    BEGIN
        SET @IsWeekend   = 1;
    END;

    -- Add 1 every time we start a new week
    IF ( @DayofWeek = 1)
    BEGIN
        SET @CalendarWeek = @CalendarWeek +1;
    END;

    -- Add business rule (need to know complete weeks in a year, so a partial week in new year set to 0)
    IF ( @DayofWeek != 1 AND @DayofYear = 1)
    BEGIN
        SET @BusinessYearWeek = 0;
    END;


    IF ( @DayofWeek = 1)
    BEGIN
        SET @BusinessYearWeek = @BusinessYearWeek +1;
    END;

    -- Add business rule (start counting business weeks with first complete week)
    IF (@BusinessYearWeek =53)
    BEGIN
        SET @BusinessYearWeek = 1;
    END;

    -- Check for leap year
    IF ((@YEAR % 4 = 0) AND (@YEAR % 100 != 0 OR @YEAR % 400 = 0))
	    SET @LeapYear =1;
	ELSE
        SET @LeapYear =0;

    -- Insert values into Date Dimension table
    INSERT GameDW.DimTime
        (ActualDate, Year, Quarter, Month, Week, DayofYear, DayofMonth, DayofWeek, IsWeekend, CalendarWeek, BusinessYearWeek, LeapYear)
    VALUES
        (@DT, @YEAR, @QUARTER, @MONTH, @WEEK, @DayofYear, @DayofMonth, @DayofWeek, @IsWeekend, @CalendarWeek, @BusinessYearWeek, @LeapYear);

    -- Increment the date one day
    SET @DT  = DATEADD(DAY, 1, @DT);

END;


SET @Message = 'Completed Build Table GameDW.DimTime.';
RAISERROR(@Message, 0,1) WITH NOWAIT;
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

