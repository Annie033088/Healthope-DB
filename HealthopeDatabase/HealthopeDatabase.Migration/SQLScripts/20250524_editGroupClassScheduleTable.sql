-- Step 1: 查找並刪除舊的 default constraint（如果存在）
DECLARE @constraintName1 NVARCHAR(255);
DECLARE @constraintName2 NVARCHAR(255);
DECLARE @sql NVARCHAR(MAX);

SELECT @constraintName1 = df.name
FROM sys.default_constraints df
JOIN sys.columns c ON df.parent_object_id = c.object_id AND df.parent_column_id = c.column_id
WHERE OBJECT_NAME(df.parent_object_id) = 't_groupClassSchedule'
  AND c.name = 'f_createTime'

SELECT @constraintName2 = df.name
FROM sys.default_constraints df
JOIN sys.columns c ON df.parent_object_id = c.object_id AND df.parent_column_id = c.column_id
WHERE OBJECT_NAME(df.parent_object_id) = 't_groupClassSchedule'
  AND c.name = 'f_updateTime'

IF @constraintName1 IS NOT NULL
BEGIN
    SET @sql = N'ALTER TABLE t_groupClassSchedule DROP CONSTRAINT ' + QUOTENAME(@constraintName1)
    EXEC sp_executesql @sql
END;

IF @constraintName2 IS NOT NULL
BEGIN
    SET @sql = N'ALTER TABLE t_groupClassSchedule DROP CONSTRAINT ' + QUOTENAME(@constraintName2)
    EXEC sp_executesql @sql
END;

-- Step 2: 修改欄位型別為 datetime2
ALTER TABLE t_groupClassSchedule
ALTER COLUMN f_createTime datetime2(3) NOT NULL 

ALTER TABLE t_groupClassSchedule
ALTER COLUMN f_updateTime datetime2(3) NOT NULL 

-- Step 3: 新增 default constraint 為 SYSUTCDATETIME()
ALTER TABLE t_groupClassSchedule
ADD CONSTRAINT DF_t_groupClassSchedule_f_createTime DEFAULT SYSUTCDATETIME() FOR f_createTime

ALTER TABLE t_groupClassSchedule
ADD CONSTRAINT DF_t_groupClassSchedule_f_updateTime DEFAULT SYSUTCDATETIME() FOR f_updateTime
