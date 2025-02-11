SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE SPD_ADDEMPLOYEE 
    @EmployeeID NUMERIC(10),
    @EmployeeName VARCHAR(100),
    @DepartmentID NUMERIC(10),
    @HireDate DATE,
	@Return INT OUT
AS
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	INSERT INTO Employees (Employee_ID, Employee_NAME, Department_ID, Hire_DATE, IS_ACTIVE, CREATED_BY, CREATED_ON)
	VALUES (@EmployeeID, @EmployeeName, @DepartmentID ,@HireDate, 1, 1, GETDATE());

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

