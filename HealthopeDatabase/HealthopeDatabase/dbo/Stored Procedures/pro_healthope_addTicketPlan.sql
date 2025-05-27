CREATE PROCEDURE pro_healthope_addTicketPlan
	@price INT, 
	@status BIT
AS
BEGIN
	INSERT INTO t_tickctPlan(f_price, f_status) 
	VALUES(@price, @status)
END