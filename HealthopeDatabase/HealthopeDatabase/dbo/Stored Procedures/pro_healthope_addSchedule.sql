CREATE PROCEDURE pro_healthope_addSchedule
	@className NVARCHAR(20), 
	@category INT,
	@icon INT,
	@time DATETIME2(0), 
	@place NVARCHAR(10), 
	@maximumParticipant TINYINT, 
	@coachId INT, 
	@coachUpdateTime DATETIME2(3), 
	@errorCode INT OUTPUT
AS
BEGIN
	DECLARE @hasBeenModified INT = 14 -- (教練)資料已被異動
	DECLARE @duplicatePlaceAndTime INT = 22 -- 時間及地點重複
	DECLARE @duplicateCoachAndTime INT = 23 -- 時間及教練重複
	DECLARE @invalidFormatOrEntry INT = 5 -- 無效輸入
	DECLARE @success INT = 1

	DECLARE @coachName NVARCHAR(15);
	DECLARE @coachNewUpdateTime DATETIME2(3);
	SELECT @coachName = f_name, @coachNewUpdateTime = f_updateTime FROM t_coach WITH(NOLOCK) WHERE f_coachId = @coachId

	DECLARE @status INT
	SET @status =
		CASE
			WHEN @time BETWEEN GETUTCDATE() AND DATEADD(DAY, 7, GETUTCDATE()) THEN 2
			WHEN @time > DATEADD(DAY, 7, GETUTCDATE()) THEN 1
			ELSE 0  -- 錯誤的時間
		END;
	
	IF  @coachUpdateTime != @coachNewUpdateTime
	BEGIN
		SET @errorCode = @hasBeenModified
		RETURN
	END
	ELSE IF @status = 0
	BEGIN
		SET @errorCode = @invalidFormatOrEntry
		RETURN
	END
	ELSE IF EXISTS (SELECT 1 FROM t_groupClassSchedule WHERE f_time = @time AND f_place = @place) -- 時間及地點不可同時一樣
	BEGIN
		SET @errorCode = @duplicatePlaceAndTime
		RETURN
	END
	ELSE IF EXISTS (SELECT 1 FROM t_groupClassSchedule WHERE f_time = @time AND f_coachId = @coachId) -- 時間及教練不可同時一樣
	BEGIN
		SET @errorCode = @duplicateCoachAndTime
		RETURN
	END
	ELSE
	BEGIN
		INSERT INTO t_groupClassSchedule(f_coachId, f_className, f_category, f_icon, f_coachName, f_time, f_place, f_maximumParticipant, f_status) 
		VALUES(@coachId, @className, @category, @icon, @coachName, @time, @place, @maximumParticipant, @status)
		SET @errorCode = @success
	END
END