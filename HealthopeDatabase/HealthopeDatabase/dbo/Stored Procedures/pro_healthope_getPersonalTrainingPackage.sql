CREATE PROCEDURE pro_healthope_getPersonalTrainingPackage
	@status BIT,
	@sortOrder VARCHAR(10),
	@sortOption VARCHAR(15),
	@recordPerPage TINYINT,
	@page INT,
	@totalPage INT OUTPUT
AS
BEGIN
    -- 計算分頁起始筆數
    DECLARE @offset INT = (@page - 1) * @recordPerPage;
    DECLARE @totalRecord INT;

	SELECT f_personalTrainingPackageId, f_name, f_price, f_display, f_introduction, f_status, f_sessionCount, f_updateTime
	INTO #tempPersonalTrainingPackageTable
    FROM t_personalTrainingPackage WITH(NOLOCK)
    WHERE  (@status IS NULL OR f_status = @status)

	SELECT @totalRecord = COUNT(*) FROM #tempPersonalTrainingPackageTable WITH(NOLOCK); 
	SET @totalPage = CEILING(@totalRecord * 1.0 / @recordPerPage); --總頁數

	SELECT  f_personalTrainingPackageId, f_name, f_price, f_display, f_introduction, f_status, f_sessionCount, f_updateTime
    FROM #tempPersonalTrainingPackageTable WITH(NOLOCK)
    ORDER BY
       CASE WHEN @sortOption IS NULL AND  @sortOrder = 'ascending' THEN CAST(f_personalTrainingPackageId AS sql_variant) END ASC,
	   CASE	WHEN @sortOption IS NULL AND  @sortOrder = 'descending' THEN CAST(f_personalTrainingPackageId AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'status' AND @sortOrder = 'ascending' THEN CAST(f_status AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'status' AND @sortOrder = 'descending' THEN CAST(f_status AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'price' AND @sortOrder = 'ascending' THEN CAST(f_price AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'price' AND @sortOrder = 'descending' THEN CAST(f_price AS sql_variant) END DESC,
       CAST(f_personalTrainingPackageId AS SQL_VARIANT)  ASC --預設排序欄位
    OFFSET @offset ROWS FETCH NEXT @recordPerPage ROWS ONLY;
END