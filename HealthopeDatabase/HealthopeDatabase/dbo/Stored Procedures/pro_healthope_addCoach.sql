CREATE PROCEDURE pro_healthope_addCoach
	@name NVARCHAR(15), 
	@phone INT,
	@email VARCHAR(254),
	@type TINYINT, 
    @contractStartTime DATE,
	@contractEndTime DATE,
	@account VARCHAR(20),
	@hash VARCHAR(100), 
	@introduction NVARCHAR(50),
	@specialty NVARCHAR(200),
	@certification NVARCHAR(200), 
	@photoUrl NVARCHAR(100),
	@errorCode INT OUTPUT
AS
BEGIN
	DECLARE @duplicateAccount INT = 17 --帳號重複
	DECLARE @duplicatePhone INT = 16 --手機號碼重複
	DECLARE @success INT = 1

	IF  EXISTS (SELECT 1 FROM t_coach WHERE f_account = @account)
	BEGIN
		SET @errorCode = @duplicateAccount
		RETURN
	END
	ELSE IF EXISTS (SELECT 1 FROM t_coach WHERE f_phone = @phone)
	BEGIN
		SET @errorCode = @duplicatePhone
		RETURN
	END
	ELSE
	BEGIN
		INSERT INTO t_coach (f_name, f_phone, f_email, f_type, f_contractStartTime, f_contractEndTime, f_account, f_hash, f_introduction, f_specialty, f_certification, f_photoUrl) 
		VALUES(@name, @phone, @email, @type, @contractStartTime, @contractEndTime, @account, @hash, @introduction, @specialty, @certification, @photoUrl)
		SET @errorCode = @success
	END
END