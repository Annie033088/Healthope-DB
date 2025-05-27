CREATE PROCEDURE [pro_healthope_getGroupClassSchedule]
	@status TINYINT,
	@dateRangeFilter VARCHAR(10),
	@specificDate DATETIME2(0),
	@sortOrder VARCHAR(10),
	@sortOption VARCHAR(20),
	@recordPerPage TINYINT,
	@page INT,
	@totalPage INT OUTPUT
AS
BEGIN
    -- 計算分頁起始筆數
    DECLARE @offset INT = (@page - 1) * @recordPerPage;
    DECLARE @totalRecord INT;

	SELECT f_groupClassScheduleId, f_time, f_className, f_category, f_coachName, f_place, f_reserveParticipant, f_maximumParticipant, f_checkInParticipant, f_status, f_tag
	INTO #tempGroupClassScheduleTable
    FROM t_groupClassSchedule WITH(NOLOCK)
    WHERE (@status IS NULL OR f_status = @status)
		AND (@dateRangeFilter IS NULL OR @dateRangeFilter = 'all'
			OR (@dateRangeFilter = 'past' AND f_time < GETUTCDATE())
			OR (@dateRangeFilter = 'future' AND f_time >= GETUTCDATE()))
		AND (@specificDate IS NULL OR (f_time >= @specificDate AND f_time < DATEADD(DAY, 1, @specificDate)))

	SELECT @totalRecord = COUNT(*) FROM #tempGroupClassScheduleTable WITH(NOLOCK); 
	SET @totalPage = CEILING(@totalRecord * 1.0 / @recordPerPage); --總頁數

	SELECT f_groupClassScheduleId, f_time, f_className, f_category, f_coachName, f_place, f_reserveParticipant, f_maximumParticipant, f_checkInParticipant, f_status, f_tag
    FROM #tempGroupClassScheduleTable WITH(NOLOCK)
    ORDER BY
       CASE WHEN @sortOption IS NULL AND  @sortOrder = 'ascending' THEN CAST(f_groupClassScheduleId AS sql_variant) END ASC,
	   CASE	WHEN @sortOption IS NULL AND  @sortOrder = 'descending' THEN CAST(f_groupClassScheduleId AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'time' AND @sortOrder = 'ascending' THEN CAST(f_time AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'time' AND @sortOrder = 'descending' THEN CAST(f_time AS sql_variant) END DESC,
       CASE WHEN @sortOption = 'reserveParticipant' AND @sortOrder = 'ascending' THEN CAST(f_reserveParticipant AS sql_variant) END ASC,
       CASE WHEN @sortOption = 'reserveParticipant' AND @sortOrder = 'descending' THEN CAST(f_reserveParticipant AS sql_variant) END DESC,
       CAST(f_groupClassScheduleId AS SQL_VARIANT)  ASC --預設排序欄位
    OFFSET @offset ROWS FETCH NEXT @recordPerPage ROWS ONLY;
END