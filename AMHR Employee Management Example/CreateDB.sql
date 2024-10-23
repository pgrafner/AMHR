Use AMHR


CREATE TABLE [dbo].[Employees](
	[ID] [uniqueidentifier] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Position] [nvarchar](50) NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Employees_Email] ON [dbo].[Employees]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Employees] ADD  CONSTRAINT [DF_Employees_ID]  DEFAULT (newid()) FOR [ID]
GO


BEGIN TRANSACTION
GO

CREATE PROCEDURE sp_AddEmployee 
	@ID UniqueIdentifier, 
	@FirstName nvarchar(50), 
	@LastName nvarchar(50), 
	@Email nvarchar(50), 
	@Position nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[Employees]
           ([ID], [FirstName], [LastName], [Email], [Position])
    VALUES
           (@ID, @FirstName, @LastName, @Email, @Position);

END
GO
COMMIT

GRANT EXECUTE ON dbo.sp_AddEmployee TO Public;
GO

BEGIN TRANSACTION
GO

CREATE PROCEDURE sp_GetAllEmployees 

AS
BEGIN
	SET NOCOUNT ON;

	SELECT [ID]
		  ,[FirstName]
		  ,[LastName]
		  ,[Email]
		  ,[Position]
	  FROM [dbo].[Employees]
END
GO
COMMIT

GRANT EXECUTE ON dbo.sp_GetAllEmployees TO Public;
GO

BEGIN TRANSACTION
GO

CREATE PROCEDURE sp_GetEmployeeByEmail
	@Email nvarchar(50) 
AS
BEGIN

	SET NOCOUNT ON;
	SELECT ID, FirstName, LastName, Email, Position
		From [dbo].[Employees]
		Where [Email] = @Email
END
GO

GRANT EXECUTE ON dbo.sp_GetEmployeeByEmail TO Public;
GO
