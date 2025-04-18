/*
Healthope 的部署指令碼

這段程式碼由工具產生。
變更這個檔案可能導致不正確的行為，而且如果重新產生程式碼，
變更將會遺失。
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;

USE [Healthope];


GO
/*
必須加入資料表 [dbo].[t_admin] 的資料行 [dbo].[t_admin].[f_identity]，但該資料行沒有預設值而且不允許 NULL 值。如果資料表包含資料，則 ALTER 指令碼將無法運作。若要避免這個問題，您必須: 在資料行加入預設值、將它標示為允許 NULL 值，或啟用產生智慧型預設值做為部署選項。
*/

IF EXISTS (select top 1 1 from [dbo].[t_admin])
    RAISERROR (N'偵測到資料列。結構描述更新即將終止，因為可能造成資料遺失。', 16, 127) WITH NOWAIT

GO
PRINT N'正在置放 預設條件約束 [dbo].[t_admin] 上的未命名條件約束...';


GO
ALTER TABLE [dbo].[t_admin] DROP CONSTRAINT [DF__tmp_ms_xx__f_sta__440B1D61];


GO
PRINT N'正在置放 預設條件約束 [dbo].[t_admin] 上的未命名條件約束...';


GO
ALTER TABLE [dbo].[t_admin] DROP CONSTRAINT [DF__tmp_ms_xx__f_upd__44FF419A];


GO
PRINT N'開始重建資料表 [dbo].[t_admin]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_t_admin] (
    [f_adminId]             INT           IDENTITY (1, 1) NOT NULL,
    [f_account]             VARCHAR (20)  NOT NULL,
    [f_hash]                VARCHAR (100) NOT NULL,
    [f_status]              BIT           DEFAULT ((1)) NOT NULL,
    [f_positionDescription] NVARCHAR (20) NOT NULL,
    [f_identity]            TINYINT       NOT NULL,
    [f_updateTime]          DATETIME      DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([f_adminId] ASC),
    UNIQUE NONCLUSTERED ([f_account] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[t_admin])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_t_admin] ON;
        INSERT INTO [dbo].[tmp_ms_xx_t_admin] ([f_adminId], [f_account], [f_hash], [f_status], [f_positionDescription], [f_updateTime])
        SELECT   [f_adminId],
                 [f_account],
                 [f_hash],
                 [f_status],
                 [f_positionDescription],
                 [f_updateTime]
        FROM     [dbo].[t_admin]
        ORDER BY [f_adminId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_t_admin] OFF;
    END

DROP TABLE [dbo].[t_admin];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_t_admin]', N't_admin';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'更新完成。';


GO
