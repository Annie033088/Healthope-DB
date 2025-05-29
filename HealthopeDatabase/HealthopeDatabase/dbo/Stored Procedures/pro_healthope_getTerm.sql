CREATE PROCEDURE pro_healthope_getTerm
	@type TINYINT, 
	@status TINYINT, 
	@applicableTarget TINYINT,
	@recordPerPage TINYINT,
	@page INT,
	@totalPage INT OUTPUT
AS
BEGIN
    -- 計算分頁起始筆數
    DECLARE @offset INT = (@page - 1) * @recordPerPage;
    DECLARE @totalRecord INT;

	SELECT f_termId, f_name, f_version, f_type, f_applicableTarget, f_status, f_effectiveTime
	INTO #tempTermTable
    FROM t_term WITH(NOLOCK)
    WHERE (@type IS NULL OR f_type = @type)
      AND (@status IS NULL OR f_status = @status)
      AND (@applicableTarget IS NULL OR f_applicableTarget = @applicableTarget)

	SELECT @totalRecord = COUNT(*) FROM #tempTermTable WITH(NOLOCK); 
	SET @totalPage = CEILING(@totalRecord * 1.0 / @recordPerPage);

	SELECT f_termId, f_name, f_version, f_type, f_applicableTarget, f_status, f_effectiveTime
    FROM #tempTermTable WITH(NOLOCK)
    ORDER BY f_termId
    OFFSET @offset ROWS FETCH NEXT @recordPerPage ROWS ONLY;
END