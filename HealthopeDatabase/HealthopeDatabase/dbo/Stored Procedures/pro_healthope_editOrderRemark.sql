CREATE PROCEDURE pro_healthope_editOrderRemark
	@orderId INT,
	@remark NVARCHAR(50),
	@updateTime DATETIME2(3)
AS
BEGIN
	IF @updateTime = (SELECT f_updateTime FROM t_order WHERE f_orderId = @orderId)
	BEGIN
		UPDATE t_order
		SET f_remark = @remark, f_updateTime = SYSUTCDATETIME()
		WHERE f_orderId = @orderId
	END
END