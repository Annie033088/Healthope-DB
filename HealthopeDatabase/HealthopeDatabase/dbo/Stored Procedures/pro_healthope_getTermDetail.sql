CREATE PROCEDURE pro_healthope_getTermDetail
@termId INT
AS
BEGIN
	SELECT f_version, f_name, f_versionDescription, f_detailContent
    FROM t_term WITH(NOLOCK)
	WHERE f_termId = @termId
END