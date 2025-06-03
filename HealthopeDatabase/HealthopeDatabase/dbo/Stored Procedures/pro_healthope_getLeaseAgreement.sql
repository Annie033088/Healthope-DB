CREATE PROCEDURE pro_healthope_getLeaseAgreement
	@status TINYINT, 
	@recordPerPage INT,
	@page INT,
	@totalPage INT OUTPUT
AS
BEGIN
    -- 計算分頁起始筆數
    DECLARE @offset INT = (@page - 1) * @recordPerPage;
    DECLARE @totalRecord INT;

	SELECT f_leaseAgreementId, f_startTime, f_endTime, f_reminderLeadTime, f_status, f_remind, f_remark, f_updateTime
	INTO #tempLeaseAgreementTable
    FROM t_leaseAgreement WITH(NOLOCK)
    WHERE  (@status IS NULL OR f_status = @status)

	SELECT @totalRecord = COUNT(*) FROM #tempLeaseAgreementTable WITH(NOLOCK); 
	SET @totalPage = CEILING(@totalRecord * 1.0 / @recordPerPage);

	SELECT f_leaseAgreementId, f_startTime, f_endTime, f_reminderLeadTime, f_status, f_remind, f_remark, f_updateTime
    FROM #tempLeaseAgreementTable WITH(NOLOCK)
    ORDER BY f_leaseAgreementId
    OFFSET @offset ROWS FETCH NEXT @recordPerPage ROWS ONLY;
END