CREATE PROCEDURE pro_healthope_addMembershipPlan
	@name NVARCHAR(20), 
	@price INT,
	@duration TINYINT, 
	@introduction NVARCHAR(200), 
	@imageUrl NVARCHAR(100), 
	@display BIT,
	@status BIT
AS
BEGIN
	INSERT INTO t_membershipPlan(f_name, f_price, f_duration, f_introduction, f_imageUrl, f_display, f_status) 
	VALUES(@name, @price, @duration, @introduction, @imageUrl, @display, @status)
END