-- Step 1: 查找並刪除舊的 default constraint（如果存在）
DECLARE @constraintName NVARCHAR(255);
DECLARE @sql NVARCHAR(MAX);

SELECT @constraintName = df.name
FROM sys.default_constraints df
JOIN sys.columns c ON df.parent_object_id = c.object_id AND df.parent_column_id = c.column_id
WHERE OBJECT_NAME(df.parent_object_id) = 't_groupClassShowcase'
  AND c.name = 'f_updateTime'

IF @constraintName IS NOT NULL
BEGIN
    SET @sql = N'ALTER TABLE t_groupClassShowcase DROP CONSTRAINT ' + QUOTENAME(@constraintName)
    EXEC sp_executesql @sql
END;

-- Step 2: 修改欄位型別為 datetime2
ALTER TABLE t_groupClassShowcase
ALTER COLUMN f_updateTime datetime2 NOT NULL 

-- Step 3: 新增 default constraint 為 SYSUTCDATETIME()
ALTER TABLE t_groupClassShowcase
ADD CONSTRAINT DF_t_groupClassShowcase_f_updateTime DEFAULT SYSUTCDATETIME() FOR f_updateTime
