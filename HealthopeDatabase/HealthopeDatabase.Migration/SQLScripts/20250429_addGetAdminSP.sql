CREATE PROCEDURE pro_healthope_getAdmin
	@searchAccount VARCHAR(20),
	@status BIT,
	@sortOrder VARCHAR(10),
	@sortOption VARCHAR(7),
	@recordPerPage TINYINT
AS
BEGIN
  SELECT TOP (@recordPerPage)
        f_adminId, f_account, f_status, f_identity, f_updateTime
    FROM t_admin
    WHERE (@searchAccount IS NULL OR f_account LIKE '%' + @searchAccount + '%')
      AND (@status IS NULL OR f_status = @status)
    ORDER BY
        CASE 
            WHEN @sortOption = 'account' AND @sortOrder = 'ascending' THEN 'f_account' 
        END ASC,
        CASE 
            WHEN @sortOption = 'account' AND @sortOrder = 'descending' THEN 'f_account'  
        END DESC,
        CASE 
            WHEN @sortOption = 'status' AND @sortOrder = 'ascending' THEN 'f_status' 
        END ASC,
        CASE 
            WHEN @sortOption = 'status' AND @sortOrder = 'descending' THEN 'f_status'  
        END DESC
END
GO