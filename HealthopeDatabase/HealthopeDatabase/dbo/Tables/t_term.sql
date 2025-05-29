CREATE TABLE [dbo].[t_term] (
    [f_termId]             INT            IDENTITY (1, 1) NOT NULL,
    [f_version]            INT            DEFAULT ((0)) NOT NULL,
    [f_name]               NVARCHAR (15)  NOT NULL,
    [f_detailContent]      NVARCHAR (MAX) NOT NULL,
    [f_type]               TINYINT        NOT NULL,
    [f_applicableTarget]   TINYINT        NOT NULL,
    [f_versionDescription] NVARCHAR (200) NOT NULL,
    [f_status]             TINYINT        DEFAULT ((1)) NOT NULL,
    [f_effectiveTime]      DATETIME2 (3)  DEFAULT ('1900-01-01 00:00:00') NOT NULL,
    [f_updateTime]         DATETIME2 (3)  DEFAULT (sysutcdatetime()) NOT NULL
);

