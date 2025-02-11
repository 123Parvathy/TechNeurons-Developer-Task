SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SPD_CALCULATEPAYROLL 
	@DepartmentID NUMERIC(10),
	@Return INT OUT
AS
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

BEGIN   TRY

     SELECT SUM(BaseSalary + Bonus -Deductions) AS TOTALPAYROLL
	 FROM Employees E JOIN Salaries S ON E.Employee_ID = S.Employee_ID
	 WHERE Department_ID IS NULL OR E.Department_ID = @DepartmentID;	 
SET @Return = @@IDENTITY;

END TRY

BEGIN CATCH
     IF ERROR_NUMBER() IN (2,3)
	   BEGIN
	   SET @Return = -1;
	   THROW;
	   END
	 ELSE
	   BEGIN
	   SET @Return = 0;
	   THROW;
	   END

END CATCH


