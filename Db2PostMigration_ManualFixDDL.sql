USE [deepazr05-db]
GO
create view DSODB.JobRunParamsView as
            select RUNID
                 , param.ref.value('@name',  'NVARCHAR(225)') as [ParamName]
                 , param.ref.value('@value', 'NVARCHAR(225)') as [ParamValue]
            from DSODB.JobRunParams c     cross apply c.ParamList.nodes('/params/param') param(ref);
GO
create view DSODB.JobRunTotalRowsUsage as
            select RUNID
                 , StartTimestamp
                 , EndTimestamp
                 , param.ref.value('@e', 'INT')    as [RunElapsedSecs]
                 , param.ref.value('@c', 'BIGINT') as [TotalRowsConsumed]
                 , param.ref.value('@p', 'BIGINT') as [TotalRowsProduced]
           from DSODB.JobRunUsage c       cross apply c.ResourceInfo.nodes('/rows/snap') param(ref);
GO
create view DSODB.ParallelConfigNodes as
            select CONFIGID
                 , HOSTID
                 , param.ref.value('@pname', 'NVARCHAR(255)')  as [PhysicalName]
                 , param.ref.value('@lnum',  'INT')            as [NumLogicalNodes]
            from DSODB.ParallelConfig c   cross apply c.NodeList.nodes('/nodes/node') param(ref);
GO
CREATE VIEW DSODB.ResourceSnapDisks AS
            select HOSTID
                 , HEAD_HOSTID
                 , LastUpdateTimestamp
                 , param.ref.value('@p', 'NVARCHAR(255)') as [DiskPathMonitored]
                 , param.ref.value('@t', 'BIGINT')        as [DiskTotalKB]
                 , param.ref.value('@f', 'BIGINT')        as [DiskFreeKB]
            from DSODB.ResourceSnap c     cross apply c.DiskSnap.nodes('/dsn/dsk') param(ref);
GO
CREATE VIEW DSODB.ResourceUsageDisks AS
            select StartTimestamp
                 , HOSTID
                 , HEAD_HOSTID
                 , EndTimestamp
                 , NumSamples
                 , param.ref.value('@p',  'NVARCHAR(255)') as [DiskPathMonitored]
                 , param.ref.value('@t',  'BIGINT')        as [DiskTotalKB]
                 , param.ref.value('@af', 'BIGINT')        as [DiskFreeKBAvg]
                 , param.ref.value('@xf', 'BIGINT')        as [DiskFreeKBMax]
                 , param.ref.value('@nf', 'BIGINT')        as [DiskFreeKBMin]
            from DSODB.ResourceUsage c    cross apply c.DiskUsage.nodes('/dus/dsk') param(ref);
GO