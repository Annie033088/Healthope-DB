CREATE PROCEDURE pro_healthope_delInoviceTrackNumber
 @invoiceTrackNumberId INT
 AS
 BEGIN
 DECLARE @statusInactive INT = 1 --未啟用狀態
	IF @statusInactive = (SELECT f_status FROM t_invoiceTrackNumber WITH(NOLOCK) WHERE f_invoiceTrackNumberId = @invoiceTrackNumberId) --是草稿狀態才能刪除
		DELETE t_invoiceTrackNumber WHERE f_invoiceTrackNumberId = @invoiceTrackNumberId
 END