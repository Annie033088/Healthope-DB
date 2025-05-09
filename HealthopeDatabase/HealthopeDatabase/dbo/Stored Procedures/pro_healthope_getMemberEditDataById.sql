CREATE PROCEDURE pro_healthope_getMemberEditDataById
@memberId INT
AS
BEGIN
	SELECT f_name, f_phone, f_status, f_updateTime
    FROM t_member WITH(NOLOCK)
	WHERE f_memberId = @memberId
END