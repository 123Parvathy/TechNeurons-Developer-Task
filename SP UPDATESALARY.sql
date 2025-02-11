SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SPD_UPDATED_SALARIEES 
    @HistoryID NUMERIC(10),
    @EmployeeID NUMERIC(10),
    @NewBaseSalary NUMERIC(10, 2),
    @NewBonus NUMERIC(10, 2),
    @NewDeductions NUMERIC(10, 2),
    @UpdatedBy VARCHAR(50),
    @Return INT OUT
AS
BEGIN TRY
-- Check if Employee exists in Salaries table
        IF NOT EXISTS (SELECT 1 FROM Salaries WHERE Employee_ID = @EmployeeID)
        BEGIN
            SET @Return = -1;  
            THROW 50000, 'Error: Employee not found in the Salaries table.', 1;
        END
		-- Declare variables to store the old salary details
        DECLARE @OldBaseSalary NUMERIC(10, 2);
        DECLARE @OldBonus NUMERIC(10, 2);
        DECLARE @OldDeductions NUMERIC(10, 2);

        -- Get the current salary details for the employee
        SELECT 
            @OldBaseSalary = BaseSalary,
            @OldBonus = Bonus,
            @OldDeductions = Deductions
        FROM Salaries
        WHERE Employee_ID = @EmployeeID;

		 -- Insert a record into SalaryHistory to log the changes
        INSERT INTO SalaryHistory (History_ID, Employee_ID, Old_BaseSalary, New_BaseSalary, Old_Bonus, New_Bonus, Old_Deduction, New_Deduction ,IS_ACTIVE,CREATED_BY,CREATED_ON,UPDATED_BY,UPDATED_ON, Changed_Date)
        VALUES (@HistoryID, @EmployeeID, @OldBaseSalary, @NewBaseSalary, @OldBonus, @NewBonus, @OldDeductions, @NewDeductions,1,1,GETDATE(), 1, GETDATE(), GETDATE());

		 -- Update the employee's salary details in the Salaries table
        UPDATE Salaries
        SET 
            BaseSalary = @NewBaseSalary,
            Bonus = @NewBonus,
            Deductions = @NewDeductions
        WHERE Employee_ID = @EmployeeID;

        
        SET @Return = 1;

    END TRY
 BEGIN CATCH
        
        IF ERROR_NUMBER() IN (2, 3)
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

GO
