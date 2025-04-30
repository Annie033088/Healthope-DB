CREATE PROCEDURE pro_healthope_getAdminById
@adminId INT
AS
BEGIN
	SELECT f_adminId, f_account, f_status, f_identity, f_updateTime
    FROM t_admin WITH(NOLOCK)
	WHERE f_adminId = @adminId
END