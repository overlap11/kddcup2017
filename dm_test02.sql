CREATE TEMP TABLE tmp_dm_train_base AS (
SELECT
	*
FROM work_travel_time
WHERE
	hour BETWEEN 8 AND 9
	OR hour BETWEEN 17 AND 18
);

SELECT * FROM tmp_dm_train_base;

SELECT
	*
FROM work_travel_time
limit 100;

SELECT
	A.time_window_start
	,B.time_window_start
	,C.time_window_start
	,D.time_window_start
	,E.time_window_start
	,F.time_window_start
	,G.time_window_start
	,*
FROM work_travel_time AS A
LEFT JOIN work_travel_time AS B ON A.intersection_id = B.intersection_id AND A.tollgate_id = B.tollgate_id
	AND A.time_window_start = B.time_window_start + interval '2 hour'
LEFT JOIN work_travel_time AS C ON A.intersection_id = C.intersection_id AND A.tollgate_id = C.tollgate_id
	AND A.time_window_start = C.time_window_start + interval '1 hour' + interval '40 minute'
LEFT JOIN work_travel_time AS D ON A.intersection_id = D.intersection_id AND A.tollgate_id = D.tollgate_id
	AND A.time_window_start = D.time_window_start + interval '1 hour' + interval '20 minute'
LEFT JOIN work_travel_time AS E ON A.intersection_id = E.intersection_id AND A.tollgate_id = E.tollgate_id
	AND A.time_window_start = E.time_window_start + interval '1 hour' + interval '0 minute'
LEFT JOIN work_travel_time AS F ON A.intersection_id = F.intersection_id AND A.tollgate_id = F.tollgate_id
	AND A.time_window_start = F.time_window_start + interval '40 minute'
LEFT JOIN work_travel_time AS G ON A.intersection_id = G.intersection_id AND A.tollgate_id = G.tollgate_id
	AND A.time_window_start = G.time_window_start + interval '20 minute'
limit 100;


CREATE TEMP TABLE tmp_dm_target_window1 AS (
SELECT
	A.intersection_id
	,A.tollgate_id
	,A.intersection_id || '-' || A.tollgate_id AS route
	,A.time_window_start
	,A.date
	,A.time
	,A.month
	,A.hour
	,A.minute
	,A.week
	,A.dow
	,A.avg_travel_time AS target_window1
	,B.avg_travel_time AS expval_bf02h00m
	,C.avg_travel_time AS expval_bf01h40m
	,D.avg_travel_time AS expval_bf01h20m
	,E.avg_travel_time AS expval_bf01h00m
	,F.avg_travel_time AS expval_bf00h40m
	,G.avg_travel_time AS expval_bf00h20m
FROM work_travel_time AS A
LEFT JOIN work_travel_time AS B ON A.intersection_id = B.intersection_id AND A.tollgate_id = B.tollgate_id
	AND A.time_window_start = B.time_window_start + interval '2 hour'
LEFT JOIN work_travel_time AS C ON A.intersection_id = C.intersection_id AND A.tollgate_id = C.tollgate_id
	AND A.time_window_start = C.time_window_start + interval '1 hour' + interval '40 minute'
LEFT JOIN work_travel_time AS D ON A.intersection_id = D.intersection_id AND A.tollgate_id = D.tollgate_id
	AND A.time_window_start = D.time_window_start + interval '1 hour' + interval '20 minute'
LEFT JOIN work_travel_time AS E ON A.intersection_id = E.intersection_id AND A.tollgate_id = E.tollgate_id
	AND A.time_window_start = E.time_window_start + interval '1 hour' + interval '0 minute'
LEFT JOIN work_travel_time AS F ON A.intersection_id = F.intersection_id AND A.tollgate_id = F.tollgate_id
	AND A.time_window_start = F.time_window_start + interval '40 minute'
LEFT JOIN work_travel_time AS G ON A.intersection_id = G.intersection_id AND A.tollgate_id = G.tollgate_id
	AND A.time_window_start = G.time_window_start + interval '20 minute'
);

-- DROP TABLE work_dm_travel_time_01;
CREATE TABLE work_dm_travel_time_01 AS (
SELECT
	A.intersection_id
	,A.tollgate_id
	,A.intersection_id || '-' || A.tollgate_id AS route
	,A.time_window_start
	,A.date
	,A.time
	,A.month
	,A.hour
	,A.minute
	,A.week
	,A.dow
	,COALESCE(expval_bf02h00m,0) AS expval_bf02h00m
	,COALESCE(expval_bf01h40m,0) AS expval_bf01h40m
	,COALESCE(expval_bf01h20m,0) AS expval_bf01h20m
	,COALESCE(expval_bf01h00m,0) AS expval_bf01h00m
	,COALESCE(expval_bf00h40m,0) AS expval_bf00h40m
	,COALESCE(expval_bf00h20m,0) AS expval_bf00h20m
	,target_window1
	,B.avg_travel_time AS target_window2
	,C.avg_travel_time AS target_window3
	,D.avg_travel_time AS target_window4
	,E.avg_travel_time AS target_window5
	,F.avg_travel_time AS target_window6
FROM tmp_dm_target_window1 AS A
LEFT JOIN work_travel_time AS B ON A.intersection_id = B.intersection_id AND A.tollgate_id = B.tollgate_id
	AND A.time_window_start = B.time_window_start - interval '20 minute'
LEFT JOIN work_travel_time AS C ON A.intersection_id = C.intersection_id AND A.tollgate_id = C.tollgate_id
	AND A.time_window_start = C.time_window_start - interval '40 minute'
LEFT JOIN work_travel_time AS D ON A.intersection_id = D.intersection_id AND A.tollgate_id = D.tollgate_id
	AND A.time_window_start = D.time_window_start - interval '60 minute'
LEFT JOIN work_travel_time AS E ON A.intersection_id = E.intersection_id AND A.tollgate_id = E.tollgate_id
	AND A.time_window_start = E.time_window_start - interval '80 minute'
LEFT JOIN work_travel_time AS F ON A.intersection_id = F.intersection_id AND A.tollgate_id = F.tollgate_id
	AND A.time_window_start = F.time_window_start - interval '100 minute'
);

SELECT
	*
FROM work_dm_travel_time_01;

SELECT *
FROM work_dm_travel_time_01





