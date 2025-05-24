CREATE TABLE [dbo].[t_groupClassSchedule] (
    [f_groupClassScheduleId] INT           IDENTITY (1, 1) NOT NULL,
    [f_coachId]              INT           NOT NULL,
    [f_className]            VARCHAR (20)  NOT NULL,
    [f_category]             INT           NOT NULL,
    [f_icon]                 INT           NOT NULL,
    [f_coachName]            NVARCHAR (15) NOT NULL,
    [f_time]                 DATETIME2 (0) NOT NULL,
    [f_place]                NVARCHAR (10) NOT NULL,
    [f_maximumParticipant]   TINYINT       NOT NULL,
    [f_reserveParticipant]   TINYINT       DEFAULT ((0)) NOT NULL,
    [f_checkInParticipant]   TINYINT       DEFAULT ((0)) NOT NULL,
    [f_tag]                  TINYINT       DEFAULT ((1)) NOT NULL,
    [f_status]               TINYINT       NOT NULL,
    [f_createTime]           DATETIME2 (3) CONSTRAINT [DF_t_groupClassSchedule_f_createTime] DEFAULT (sysutcdatetime()) NOT NULL,
    [f_updateTime]           DATETIME2 (3) CONSTRAINT [DF_t_groupClassSchedule_f_updateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    PRIMARY KEY CLUSTERED ([f_groupClassScheduleId] ASC),
    CONSTRAINT [FK_GroupClassSchedule_CoachId] FOREIGN KEY ([f_coachId]) REFERENCES [dbo].[t_coach] ([f_coachId])
);

