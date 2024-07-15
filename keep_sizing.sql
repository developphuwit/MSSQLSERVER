--Keeping database states and sizing.
	with fs
	as
	(select database_id, type, [size] = CAST( (((Size)* 8) / 1024.0) AS DECIMAL(18,2) ) 
	from sys.master_files)
	select
		name AS "Database_Name",
		state_desc AS "Status",
		recovery_model_desc AS "Recovery model",
		compatibility_level AS "Compatibility Level",
		collation_name AS "Collation name",
		log_reuse_wait_desc AS 'Log_waiting_task',
		(select sum(size) from fs where type = 0 and fs.database_id = db.database_id) as DataFileMB,
		(select sum(size) from fs where type = 1 and fs.database_id = db.database_id) as LogFileMB, 
		((select sum(size) from fs where type = 0 and fs.database_id = db.database_id)+
		(select sum(size) from fs where type = 1 and fs.database_id = db.database_id)) as TotalMB
	from sys.databases db 

--By Tube