CREATE PROCEDURE pro_healthope_editOrderStateRemark
	@orderStateId INT,
	@remark NVARCHAR(50),
	@updateTime DATETIME2(3)
AS
BEGIN
	IF @updateTime = (SELECT f_updateTime FROM t_orderState WHERE f_orderStateId = @orderStateId)
	BEGIN
		UPDATE t_orderState
		SET f_remark = @remark, f_updateTime = SYSUTCDATETIME()
		WHERE f_orderStateId = @orderStateId
	END
END