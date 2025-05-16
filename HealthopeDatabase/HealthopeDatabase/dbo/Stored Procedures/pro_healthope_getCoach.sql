CREATE PROCEDURE pro_healthope_getCoach
	@searchName VARCHAR(50),
	@searchPhone VARCHAR(3),
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

	SELECT f_coachId, f_name, f_phone, f_status, f_type, f_contractStartTime, f_contractEndTime
	INTO #tempCoachTable
    FROM t_coach WITH(NOLOCK)
    WHERE (@searchName IS NULL OR f_name LIKE '%' + @searchName + '%')
      AND (@status IS NULL OR f_status = @status)
      AND (@searchPhone IS NULL OR f_phone LIKE '%' + @searchPhone)

	SELECT @totalRecord = COUNT(*) FROM #tempCoachTable WITH(NOLOCK); 
	SET @totalPage = CEILING(@totalRecord * 1.0 / @recordPerPage); --總頁數

	SELECT f_coachId, f_name, f_phone, f_status, f_type, f_contractStartTime, f_contractEndTime
    FROM #tempCoachTable WITH(NOLOCK)
    ORDER BY
       CASE WHEN @sortOption IS NULL AND  @sortOrder = 'ascending' THEN CAST(f_coachId AS sql_variant) END ASC,
	   CASE	WHEN @sortOption IS NULL AND  @sortOrder = 'descending' THEN CAST(f_coachId AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'name' AND @sortOrder = 'ascending' THEN CAST(f_name AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'name' AND @sortOrder = 'descending' THEN CAST(f_name AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'status' AND @sortOrder = 'ascending' THEN CAST(f_status AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'status' AND @sortOrder = 'descending' THEN CAST(f_status AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'contractEndTime' AND @sortOrder = 'ascending' THEN CAST(f_contractEndTime AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'contractEndTime' AND @sortOrder = 'descending' THEN CAST(f_contractEndTime AS sql_variant) END DESC,
       CAST(f_coachId AS SQL_VARIANT)  ASC --預設排序欄位
    OFFSET @offset ROWS FETCH NEXT @recordPerPage ROWS ONLY;
END