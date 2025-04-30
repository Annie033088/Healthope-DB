CREATE PROCEDURE [dbo].[pro_healthope_getAdmin]
	@searchAccount VARCHAR(20),
	@status BIT,
	@sortOrder VARCHAR(10),
	@sortOption VARCHAR(7),
	@recordPerPage TINYINT,
	@page INT,
	@totalPage INT OUTPUT
AS
BEGIN
    -- 計算分頁起始筆數
    DECLARE @offset INT = (@page - 1) * @recordPerPage;
    DECLARE @totalRecord INT;

	SELECT f_adminId, f_account, f_status, f_identity, f_updateTime
	INTO #tempAdminTable
    FROM t_admin WITH(NOLOCK)
    WHERE (@searchAccount IS NULL OR f_account LIKE '%' + @searchAccount + '%')
      AND (@status IS NULL OR f_status = @status)

	SELECT @totalRecord = COUNT(*) FROM #tempAdminTable WITH(NOLOCK); 
	SET @totalPage = CEILING(@totalRecord * 1.0 / @recordPerPage);

	SELECT f_adminId, f_account, f_status, f_identity, f_updateTime
    FROM #tempAdminTable WITH(NOLOCK)
    ORDER BY
       CASE WHEN @sortOption IS NULL AND  @sortOrder = 'ascending' THEN CAST(f_adminId AS sql_variant) END ASC,
	   CASE	WHEN @sortOption IS NULL AND  @sortOrder = 'descending' THEN CAST(f_adminId AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'account' AND @sortOrder = 'ascending' THEN CAST(f_account AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'account' AND @sortOrder = 'descending' THEN CAST(f_account AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'status' AND @sortOrder = 'ascending' THEN CAST(f_status AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'status' AND @sortOrder = 'descending' THEN CAST(f_status AS sql_variant) END DESC,
       CAST(f_adminId AS sql_variant)  ASC --預設排序欄位
    OFFSET @offset ROWS FETCH NEXT @recordPerPage ROWS ONLY;
END