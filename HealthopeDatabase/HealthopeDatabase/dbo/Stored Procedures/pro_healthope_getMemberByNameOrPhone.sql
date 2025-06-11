CREATE PROCEDURE pro_healthope_getMemberByNameOrPhone
	@name VARCHAR(50),
	@phone INT
AS
BEGIN
	SELECT f_memberId, f_phone, f_phoneVerified, f_name, f_updateTime
    FROM t_member WITH(NOLOCK)
    WHERE (@name IS NULL OR f_name LIKE '%' + @name + '%')
      AND (@phone IS NULL OR f_phone = @phone)
END