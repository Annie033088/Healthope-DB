
CREATE PROCEDURE [dbo].[pro_healthope_getLoggingInAdmin]
	@account VARCHAR(20)
AS
BEGIN
	SELECT f_adminId, f_hash, f_status, f_identity FROM t_admin WHERE @account = f_account
END