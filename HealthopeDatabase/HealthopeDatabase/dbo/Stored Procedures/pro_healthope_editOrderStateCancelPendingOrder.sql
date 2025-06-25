CREATE PROCEDURE [dbo].[pro_healthope_editOrderStateCancelPendingOrder]
	@orderId INT,
	@updateTime DATETIME2(3)
AS
BEGIN
	DECLARE @newUpdateTime DATETIME2(3), @state TINYINT, @statePending TINYINT = 1, @stateCancel TINYINT = 3
	
	BEGIN TRY
		BEGIN TRANSACTION;
		SELECT @newUpdateTime = f_updateTime, @state = f_state FROM t_order WITH(UPDLOCK) WHERE f_orderId = @orderId

		IF @updateTime = @newUpdateTime AND @state = @statePending
		BEGIN
			UPDATE t_order
			SET f_state = @stateCancel, f_updateTime = SYSUTCDATETIME()
			WHERE f_orderId = @orderId

			INSERT INTO t_orderState(f_orderId, f_state)
			VALUES (@orderId, @stateCancel)
		END
		COMMIT TRANSACTION;
	-- 返回成功結果
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END