CREATE PROCEDURE pro_healthope_getAdmin
	@searchAccount VARCHAR(20),
	@status BIT,
	@sortOrder VARCHAR(10),
	@sortOption VARCHAR(7),
	@recordPerPage TINYINT,
	@page INT
AS
BEGIN
    -- 計算分頁起始筆數
    DECLARE @offset INT = (@page - 1) * @recordPerPage;

  SELECT f_adminId, f_account, f_status, f_identity, f_updateTime
    FROM t_admin
    WHERE (@searchAccount IS NULL OR f_account LIKE '%' + @searchAccount + '%')
      AND (@status IS NULL OR f_status = @status)
    ORDER BY
       CASE
            WHEN @sortOption = 'account' THEN f_account
            WHEN @sortOption = 'status' THEN f_status
            ELSE f_adminId -- 預設排序欄位
        END
		, 
		CASE 
            WHEN @sortOrder = 'descending' THEN 1
            ELSE 0
        END DESC
    OFFSET @offset ROWS FETCH NEXT @recordPerPage ROWS ONLY;
END