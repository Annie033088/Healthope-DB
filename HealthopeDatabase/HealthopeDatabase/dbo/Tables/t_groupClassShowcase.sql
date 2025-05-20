CREATE TABLE [dbo].[t_groupClassShowcase] (
    [f_groupClassShowcaseId] INT            IDENTITY (1, 1) NOT NULL,
    [f_name]                 NVARCHAR (20)  NOT NULL,
    [f_summary]              NVARCHAR (80)  NOT NULL,
    [f_detailContent]        NVARCHAR (500) NOT NULL,
    [f_imageUrl]             NVARCHAR (100) NOT NULL,
    [f_category]             INT            NOT NULL,
    [f_icon]                 INT            NOT NULL,
    [f_sort]                 INT            NOT NULL,
    [f_updateTime]           DATETIME       DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([f_groupClassShowcaseId] ASC)
);

