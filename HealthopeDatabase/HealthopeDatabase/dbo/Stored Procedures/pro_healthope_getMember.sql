CREATE PROCEDURE pro_healthope_getMember
	@searchName VARCHAR(50),
	@searchPhone INT,
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

	SELECT f_memberId, f_name, f_phone, f_phoneVerified, f_email, f_membershipExpiry, f_status, f_absenceTime, f_allowGroupClass
	INTO #tempMemberTable
    FROM t_member WITH(NOLOCK)
    WHERE (@searchName IS NULL OR f_name LIKE '%' + @searchName + '%')
      AND (@status IS NULL OR f_status = @status)
      AND (@searchPhone IS NULL OR f_phone LIKE '%' + CAST(@searchPhone AS VARCHAR))

	SELECT @totalRecord = COUNT(*) FROM #tempMemberTable WITH(NOLOCK); 
	SET @totalPage = CEILING(@totalRecord * 1.0 / @recordPerPage); --總頁數

	SELECT f_memberId, f_name, f_phone, f_phoneVerified, f_email, f_membershipExpiry, f_status, f_absenceTime, f_allowGroupClass
    FROM #tempMemberTable WITH(NOLOCK)
    ORDER BY
       CASE WHEN @sortOption IS NULL AND  @sortOrder = 'ascending' THEN CAST(f_memberId AS sql_variant) END ASC,
	   CASE	WHEN @sortOption IS NULL AND  @sortOrder = 'descending' THEN CAST(f_memberId AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'name' AND @sortOrder = 'ascending' THEN CAST(f_name AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'name' AND @sortOrder = 'descending' THEN CAST(f_name AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'status' AND @sortOrder = 'ascending' THEN CAST(f_status AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'status' AND @sortOrder = 'descending' THEN CAST(f_status AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'membershipExpiry' AND @sortOrder = 'ascending' THEN CAST(f_membershipExpiry AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'membershipExpiry' AND @sortOrder = 'descending' THEN CAST(f_membershipExpiry AS sql_variant) END DESC,
       CAST(f_memberId AS SQL_VARIANT)  ASC --預設排序欄位
    OFFSET @offset ROWS FETCH NEXT @recordPerPage ROWS ONLY;
END