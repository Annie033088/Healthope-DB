CREATE PROCEDURE [dbo].[pro_healthope_editSingleEntryPassStatusEntry]
	@singleEntryPassId INT,
	@errorCode INT OUTPUT
AS
BEGIN
	--錯誤碼
	DECLARE @success INT = 1, @alreadyEntry INT = 2, @ticketInvalid INT = 3

	--票劵狀態
	DECLARE @ticketStatus TINYINT, @statusInvalid INT = 1, @statusEntry INT = 2, @statusExit INT = 3, @statusValid INT = 4
	
	-- 時間
	DECLARE @timeExpiry DATETIME2(3)

	SELECT @ticketStatus = f_status, @timeExpiry = f_expiry FROM t_singleEntryPass WHERE f_singleEntryPassId = @singleEntryPassId
	
	IF @ticketStatus = @statusInvalid
	BEGIN
		SET @errorCode = @ticketInvalid
		RETURN
	END
	
	IF CONVERT(date, @timeExpiry) < CONVERT(date, SYSUTCDATETIME())
	BEGIN
		SET @errorCode = @ticketInvalid
		RETURN
	END

	IF @ticketStatus = @statusEntry
	BEGIN
		SET	@errorCode = @alreadyEntry
		RETURN
	END

	UPDATE t_singleEntryPass WITH(ROWLOCK)
	SET f_status = @statusEntry, f_updateTime = SYSUTCDATETIME()
	WHERE f_singleEntryPassId = @singleEntryPassId

	SET @errorCode = @success
END