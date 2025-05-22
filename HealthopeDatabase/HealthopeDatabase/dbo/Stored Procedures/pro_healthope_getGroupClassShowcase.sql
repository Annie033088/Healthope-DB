CREATE PROCEDURE [dbo].[pro_healthope_getGroupClassShowcase]
	@searchName VARCHAR(20),
	@category INT,
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

	SELECT f_groupClassShowcaseId, f_name, f_category, f_icon, f_sort
	INTO #tempGroupClassShowcaseTable
    FROM t_groupClassShowcase WITH(NOLOCK)
    WHERE (@searchName IS NULL OR f_name LIKE '%' + @searchName + '%')
      AND (@category IS NULL OR f_category = @category)

	SELECT @totalRecord = COUNT(*) FROM #tempGroupClassShowcaseTable WITH(NOLOCK); 
	SET @totalPage = CEILING(@totalRecord * 1.0 / @recordPerPage); --總頁數

	SELECT  f_groupClassShowcaseId, f_name, f_category, f_icon, f_sort
    FROM #tempGroupClassShowcaseTable WITH(NOLOCK)
    ORDER BY
       CASE WHEN @sortOption IS NULL AND  @sortOrder = 'ascending' THEN CAST(f_groupClassShowcaseId AS sql_variant) END ASC,
	   CASE	WHEN @sortOption IS NULL AND  @sortOrder = 'descending' THEN CAST(f_groupClassShowcaseId AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'name' AND @sortOrder = 'ascending' THEN CAST(f_name AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'name' AND @sortOrder = 'descending' THEN CAST(f_name AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'sort' AND @sortOrder = 'ascending' THEN CAST(f_sort AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'sort' AND @sortOrder = 'descending' THEN CAST(f_sort AS sql_variant) END DESC,
       CAST(f_groupClassShowcaseId AS SQL_VARIANT)  ASC --預設排序欄位
    OFFSET @offset ROWS FETCH NEXT @recordPerPage ROWS ONLY;
END