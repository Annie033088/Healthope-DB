-- Step 1: 查找並刪除舊的 default constraint（如果存在）
DECLARE @constraintName NVARCHAR(255);
DECLARE @sql NVARCHAR(MAX);

SELECT @constraintName = df.name
FROM sys.default_constraints df
JOIN sys.columns c ON df.parent_object_id = c.object_id AND df.parent_column_id = c.column_id
WHERE OBJECT_NAME(df.parent_object_id) = 't_memberAccessRecord'
  AND c.name = 'f_exitTime'

IF @constraintName IS NOT NULL
BEGIN
    SET @sql = N'ALTER TABLE t_memberAccessRecord DROP CONSTRAINT ' + QUOTENAME(@constraintName)
    EXEC sp_executesql @sql
END;

-- Step 2: 修改欄位型別為 datetime2
ALTER TABLE t_memberAccessRecord
ALTER COLUMN f_entryTime datetime2 NOT NULL 

ALTER TABLE t_memberAccessRecord
ALTER COLUMN f_exitTime datetime2 NOT NULL 

-- Step 3: 新增 default constraint 為 SYSUTCDATETIME()
ALTER TABLE t_memberAccessRecord
ADD CONSTRAINT DF_t_memberAccessRecord_f_updateTime DEFAULT '1900-01-01 00:00:00' FOR f_exitTime
