CREATE PROCEDURE pro_healthope_getOldTerm
@type TINYINT,
@applicableTarget TINYINT
AS
BEGIN
	SELECT f_termId, f_version, f_name, f_detailContent
    FROM t_term WITH(NOLOCK)
	WHERE f_type = @type AND f_applicableTarget = @applicableTarget AND f_status != 1
END