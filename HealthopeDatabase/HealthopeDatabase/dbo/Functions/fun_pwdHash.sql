CREATE FUNCTION fun_pwdHash(
@salt  NVARCHAR(36),
@inputPwd VARCHAR(20)
)
RETURNS VARCHAR(100)
AS
BEGIN
-- ⚠️ 模擬 UTF-8 編碼 (使用 VARCHAR)
DECLARE @combinedString VARCHAR(100) = CAST(@salt AS VARCHAR(36)) + CAST(@inputPwd AS VARCHAR(64));

-- 進行 SHA256 雜湊（UTF-8 對應的 binary）
DECLARE @hashBytes VARBINARY(32) = HASHBYTES('SHA2_256', @combinedString);

-- 轉 hex 並轉小寫
DECLARE @hashHex NVARCHAR(64) = LOWER(CONVERT(VARCHAR(64), @hashBytes, 2));

RETURN @salt + @hashHex
END