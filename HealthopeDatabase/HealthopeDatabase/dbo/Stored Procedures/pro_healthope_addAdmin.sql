
CREATE PROCEDURE [dbo].[pro_healthope_addAdmin]
	@account VARCHAR(20),
	@hash VARCHAR(100),
	@identity TINYINT
AS
BEGIN
IF NOT EXISTS (SELECT 1 FROM t_admin WHERE @account = f_account)
	BEGIN
		INSERT INTO t_admin (f_account, f_hash, f_identity) VALUES(@account, @hash, @identity)
	END
END