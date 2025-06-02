CREATE PROCEDURE pro_healthope_getTermEditDataById
@termId INT
AS
BEGIN
	SELECT f_name, f_versionDescription, f_detailContent, f_updateTime
    FROM t_term WITH(NOLOCK)
	WHERE f_termId = @termId
END