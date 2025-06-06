﻿CREATE TABLE [dbo].[t_memberAccessRecord] (
    [f_memberAccessRecordId] INT           IDENTITY (1, 1) NOT NULL,
    [f_memberId]             INT           NOT NULL,
    [f_entryTime]            DATETIME2 (3) NOT NULL,
    [f_exitTime]             DATETIME2 (3) CONSTRAINT [DF_t_memberAccessRecord_f_updateTime] DEFAULT ('1900-01-01 00:00:00') NOT NULL,
    PRIMARY KEY CLUSTERED ([f_memberAccessRecordId] ASC),
    CONSTRAINT [fk_memberAccessRecordMemberId] FOREIGN KEY ([f_memberId]) REFERENCES [dbo].[t_member] ([f_memberId])
);

