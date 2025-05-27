CREATE PROCEDURE pro_healthope_addPersonalTrainingPackage
	@name NVARCHAR(20), 
	@price INT,
	@sessionCount INT, 
	@introduction NVARCHAR(200), 
	@imageUrl NVARCHAR(100), 
	@display BIT,
	@status BIT
AS
BEGIN
	INSERT INTO t_personalTrainingPackage(f_name, f_price, f_sessionCount, f_introduction, f_imageUrl, f_display, f_status) 
	VALUES(@name, @price, @sessionCount, @introduction, @imageUrl, @display, @status)
END