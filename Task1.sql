USE Company
CREATE VIEW getCustomerById 
AS
SELECT *  FROM Customers WHERE Age > 20

--FUNCTION
CREATE FUNCTION dbo.sayHelloWorld()
RETURNS NVARCHAR(50)
AS
BEGIN 
	RETURN 'Hello World'
END

SELECT dbo.sayHelloWorld() AS Text

CREATE FUNCTION dbo.say(@str NVARCHAR(20))
RETURNS NVARCHAR(50)
AS
BEGIN
	RETURN @str
END	

SELECT dbo.say('Chinara') AS Word

CREATE FUNCTION dbo.sumOfNums(@num1 INT,@num2 INT)
RETURNS INT
AS
BEGIN
	RETURN @num1 + @num2
END

DECLARE @firstNum int = 20
DECLARE @secondNum int = 30

SELECT dbo.sumOfNums(@firstNum, @secondNum) AS Sum

CREATE FUNCTION dbo.getCustomerCount()
RETURNS INT
AS
BEGIN
	DECLARE @count INT = (SELECT COUNT(*) FROM Customers WHERE Age > 25)
	RETURN @COUNT
END	

SELECT dbo.getCustomerCount() AS 'Count of Customers'

CREATE FUNCTION dbo.getCustomerAvgAgeById(@id int)
RETURNS INT
AS
BEGIN
	DECLARE @avgAge INT = (SELECT AVG(Age) FROM Customers WHERE Id > @id)
	RETURN @avgAge
END

SELECT  dbo.getCustomerAvgAgeById(3) AS 'Average age of customers'


--PROCEDURE
CREATE PROCEDURE usp_sayHelloWorld
AS
BEGIN
	PRINT 'Hello world'
END

EXEC usp_sayHelloWorld

CREATE PROCEDURE usp_sumOfNums
@num1 INT,
@num2 INT
AS
BEGIN
	PRINT @num1 + @num2
END

EXEC usp_sumOfNums 20,40

CREATE PROCEDURE usp_addCustomer 
@name NVARCHAR(50),
@surname NVARCHAR(50),
@age NVARCHAR(50),
@email NVARCHAR(50)
AS
BEGIN
	INSERT INTO Customers(Name,Surname,Age,Email)
	VALUES (@name,@surname,@age,@email)
END

EXEC usp_addCustomer 'Konul','Ibrahimova',27,'konulsi@code.edu.az'
EXEC usp_addCustomer 'ALi','Talibov',21,'ali@code.edu.az'

CREATE PROCEDURE usp_deleteCustomer
@id INT
AS
BEGIN
	DELETE FROM Customers WHERE Id = @id
	SELECT * FROM Customers
END	

EXEC usp_deleteCustomer 7

CREATE PROCEDURE usp_updateCustomer
@id INT
AS
BEGIN
	UPDATE Customers SET Age = 26 WHERE Id = @id
	SELECT * FROM Customers
END	

EXEC usp_updateCustomer 3



CREATE PROCEDURE usp_deleteCustomerById
@id INT
AS
BEGIN
	UPDATE Customers SET IsDeleted  = '1' WHERE Id = @id
	SELECT * FROM Customers WHERE IsDeleted = '0'
END

EXEC usp_deleteCustomerById 2



CREATE PROCEDURE usp_checkText 
@text NVARCHAR(50),
@searchText NVARCHAR(10)
AS
BEGIN
	DECLARE @select int = CHARINDEX(@searchText, @text)
	 IF @select = 0
		PRINT 'No'
	 ELSE 
		PRINT 'Yes'
END

EXEC usp_checkText 'Chinara','c'


--TRIGGER
CREATE TABLE CustomersLog(
	Id INT PRIMARY KEY IDENTITY,
	CustomerId INT,
	Operation NVARCHAR(10),
	Date DATETIME
)

CREATE TRIGGER trg_addCustomer ON Customers
AFTER INSERT 
AS
BEGIN
	INSERT INTO CustomersLog(CustomerId,Operation,Date)
	SELECT Id,'Insert',GETDATE() FROM inserted
END

EXEC usp_addCustomer 'ALi','Talibov',21,'ali@code.edu.az'


CREATE TRIGGER trg_deleteCustomer ON Customers
AFTER DELETE
AS
BEGIN
	INSERT INTO CustomersLog(CustomerId,Operation,Date)
	SELECT Id,'Delete',GETDATE() FROM deleted
END

EXEC usp_deleteCustomer 8


CREATE TRIGGER trg_updateCustomer ON Customers
AFTER UPDATE
AS
BEGIN
	INSERT INTO CustomersLog(CustomerId,Operation,Date)
	SELECT Id,'Update',GETDATE() FROM deleted
END


EXEC usp_updateCustomer 3


SELECT * FROM CustomersLog WHERE CustomerId = 8