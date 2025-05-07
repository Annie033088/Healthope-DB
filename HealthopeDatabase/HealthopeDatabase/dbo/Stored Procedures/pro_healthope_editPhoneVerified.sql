
CREATE PROCEDURE [dbo].pro_healthope_editPhoneVerified
@memberId INT
AS
BEGIN
	UPDATE t_member WITH(ROWLOCK) SET f_phoneVerified = 1 WHERE f_memberId = @memberId
END