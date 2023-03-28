
--2) Course databazasi olacaq. Students table (Id, Name,Surname,Age,Email,Address) yaradirsiz, 
--Student table-dan hansisa data silinende  silinmish data  StudentArchives table-na  yazilmalidir.
--Silinme prosesini procedure sekilinde yazmalisiz. Qeyd : Butun her sheyi kodlar  vasitesile yazirsiz,
--butun sorgular faylda olsun. (Databaza yaratmaq daxil olmaq shertile)

CREATE DATABASE Course
USE Course
CREATE TABLE Students(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Age INT,
	Email NVARCHAR(50),
	Address NVARCHAR(100)
)

CREATE TABLE StudentArchives(
	Id INT PRIMARY KEY IDENTITY,
	StuId INT,
	Operation NVARCHAR(10),
	Date DATETIME
)

INSERT INTO Students(FirstName,LastName,Age,Email,Address) VALUES 
('Chinara','Ibadova',22,'chinaraei@code.edu.az','Lokbatan'),
('Konul','Ibrahimova',27,'konulsi@code.edu.az','Neftciler'),
('Roya','Meherremova',27,'roya@code.edu.az','Sumqayit'),
('Elekber','Hesenli',21,'elekber@code.edu.az','Bayil'),
('Cahandar','Velibeyli',26,'cahandar@code.edu.az','Ehmedli'),
('Ibrahim','Eliyev',29,'ibrahim@code.edu.az','Gunesli')

CREATE TRIGGER trg_deleteStudent ON Students 
AFTER DELETE
AS
BEGIN
	INSERT INTO StudentArchives(StuId,Operation,Date)
	SELECT Id,'Delete',GETDATE() FROM DELETED
END

CREATE PROCEDURE usp_deleteStudentById
@id INT
AS
BEGIN
	DELETE FROM Students WHERE Id = @id
END

EXEC usp_deleteStudentById 2