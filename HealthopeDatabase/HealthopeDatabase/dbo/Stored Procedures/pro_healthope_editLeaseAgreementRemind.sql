CREATE PROCEDURE pro_healthope_editLeaseAgreementRemind
 @leaseAgreementId INT, 
 @remind BIT,
 @updateTime DATETIME2,
 @errorCode INT OUTPUT
 AS
 BEGIN
	DECLARE @hasBeenModified INT = 14 --資料已被變動
	DECLARE @success INT = 1 --成功

	DECLARE @statusDraft INT = 1 --草稿狀態碼

	IF @updateTime != (SELECT f_updateTime FROM t_leaseAgreement WITH(NOLOCK) WHERE f_leaseAgreementId = @leaseAgreementId)
		SET @errorCode = @hasBeenModified
	ELSE
	BEGIN
		UPDATE t_leaseAgreement WITH(ROWLOCK)
		SET
			f_remind = @remind,
			f_updateTime = GETUTCDATE()
		WHERE f_leaseAgreementId = @leaseAgreementId

		SET @errorCode = @success
	END
 END