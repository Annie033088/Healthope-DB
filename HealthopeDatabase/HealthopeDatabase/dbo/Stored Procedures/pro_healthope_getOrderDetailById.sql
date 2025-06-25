CREATE PROCEDURE pro_healthope_getOrderDetailById
	@orderId INT
AS
BEGIN
	SELECT f_state, f_createTime, f_amount, f_method, f_orderNumber, f_planName, f_remark 
	FROM t_order WHERE f_orderId = @orderId
	
	SELECT f_createTime, f_orderStateId, f_remark, f_state, f_updateTime
	FROM t_orderState WHERE f_orderId = @orderId
END