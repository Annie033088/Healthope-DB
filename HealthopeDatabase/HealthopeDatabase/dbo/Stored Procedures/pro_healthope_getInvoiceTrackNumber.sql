CREATE PROCEDURE [dbo].[pro_healthope_getInvoiceTrackNumber]
	@status TINYINT, 
	@time BIT,
	@recordPerPage TINYINT,
	@page INT,
	@totalPage INT OUTPUT
AS
BEGIN
    -- 計算分頁起始筆數
    DECLARE @offset INT = (@page - 1) * @recordPerPage;
    DECLARE @totalRecord INT;

	SELECT f_invoiceTrackNumberId, f_currentNumber, f_endNumber, f_invoicePeriod, f_startNumber, f_trackPrefix, f_updateTime, f_status
	INTO #tempInvoiceTrackNumberTable
    FROM t_invoiceTrackNumber WITH(NOLOCK)
    WHERE (@status IS NULL OR f_status = @status)
      AND (@time IS NULL OR -- time: 0 代表過去期數, 1 代表未來期數, 時間以西元計算
	(
	  @time = 1 AND GETDATE() < EOMONTH(DATEFROMPARTS((f_invoicePeriod / 10) + 1911, ((f_invoicePeriod % 10) * 2), 1))
	) OR
	(
	  @time = 0 AND GETDATE() >= EOMONTH(DATEFROMPARTS((f_invoicePeriod / 10) + 1911, ((f_invoicePeriod % 10) * 2), 1))
	))

	SELECT @totalRecord = COUNT(*) FROM #tempInvoiceTrackNumberTable WITH(NOLOCK); 
	SET @totalPage = CEILING(@totalRecord * 1.0 / @recordPerPage);

	SELECT f_invoiceTrackNumberId, f_currentNumber, f_endNumber, f_invoicePeriod, f_startNumber, f_trackPrefix, f_updateTime, f_status
    FROM #tempInvoiceTrackNumberTable WITH(NOLOCK)
    ORDER BY f_invoiceTrackNumberId
    OFFSET @offset ROWS FETCH NEXT @recordPerPage ROWS ONLY;
END