
SELECT
	*
FROM tb3_trajectories
limit 100;



SELECT * FROM tb3_trajectories_train;


SELECT * FROM tb8_weather_test1;

SELECT
	*
FROM tb3_trajectories_train
limit 100;

SELECT
	*
FROM tb3_trajectories_train
limit 100;

SELECT
	CAST(starting_time AS DATE) AS date
	,extract(hour from starting_time) AS hour
	,intersection_id
	,tollgate_id
	,COUNT(*) AS cnt
	,SUM(travel_time) AS travel_time
FROM tb3_trajectories_train
GROUP BY
	CAST(starting_time AS DATE)
	,extract(hour from starting_time)
	,intersection_id
	,tollgate_id
;

SELECT
	*
FROM tb6_trajectories_test1
limit 100;

SELECT
	CAST(starting_time AS DATE) AS date
	,extract(hour from starting_time) AS hour
	,intersection_id
	,tollgate_id
	,COUNT(*) AS cnt
	,SUM(travel_time) AS travel_time
FROM tb6_trajectories_test1
GROUP BY
	CAST(starting_time AS DATE)
	,extract(hour from starting_time)
	,intersection_id
	,tollgate_id
;

SELECT
	*
	,CAST(date AS varchar) || CAST(hour AS varchar) || ':'
	,CAST(make_timestamp(CAST(year AS INT), CAST(month AS INT), CAST(day AS INT), CAST(hour AS INT), CAST(minute AS INT), 0.0) AS VARCHAR)
FROM (
	SELECT
		starting_time
		,CAST(starting_time AS DATE) AS date
		,extract(year from starting_time) AS year
		,extract(month from starting_time) AS month
		,extract(day from starting_time) AS day
		,extract(hour from starting_time) AS hour
		,floor(extract(minute from starting_time) / 20) * 20 AS minute
	FROM tb3_trajectories_train
) AS A
limit 100;

SELECT
	*
FROM tb3_trajectories_train
;

-- DROP TABLE tmp_travel_time;
CREATE TEMP TABLE tmp_travel_time AS (
SELECT
	intersection_id
	,tollgate_id
	,time_window AS time_window_start
	,time_window + interval '20 minute' AS time_window_end 
	,'[' || time_window || ',' || time_window + interval '20 minute' || ')' AS time_window
	,AVG(travel_time) AS avg_travel_time
FROM (
	SELECT
		intersection_id
		,tollgate_id
		,make_timestamp(CAST(year AS INT), CAST(month AS INT), CAST(day AS INT), CAST(hour AS INT), CAST(minute AS INT), 0.0) AS time_window
		,travel_time
	FROM (
		SELECT
			intersection_id
			,tollgate_id
			,vehicle_id
			,CAST(extract(year from starting_time) AS INT) AS year
			,CAST(extract(month from starting_time) AS INT) AS month
			,CAST(extract(day from starting_time) AS INT) AS day
			,CAST(extract(hour from starting_time) AS INT) AS hour
			,CAST(floor(extract(minute from starting_time) / 20) * 20 AS INT) AS minute
			,travel_time
		FROM tb3_trajectories_train
	) AS A
) AS AA
GROUP BY
	intersection_id
	,tollgate_id
	,time_window
	,time_window + interval '20 minute'
	,'[' || time_window || ',' || time_window + interval '20 minute' || ')'
);

CREATE TABLE work_travel_time AS (
SELECT
	intersection_id
	,tollgate_id
	,time_window_start
	,time_window_end
	,time_window
	,CAST(time_window_start AS DATE) AS date
	,CAST(time_window_start AS time) AS time
	,extract(month from time_window_start) AS month
	,extract(day from time_window_start) AS day
	,extract(hour from time_window_start) AS hour
	,extract(minute from time_window_start) AS minute
	,extract(week from time_window_start) AS week
	,extract(dow from time_window_start) AS dow
	,avg_travel_time
FROM tmp_travel_time
);

CREATE TEMP TABLE tmp_dm_train_base AS (
SELECT
	*
FROM work_travel_time
WHERE
	hour BETWEEN 8 AND 9
	OR hour BETWEEN 17 AND 18
);

SELECT * FROM tmp_dm_train_base
limit 100;

CREATE TEMP TABLE tmp_trajectories_train AS (
SELECT
	intersection_id
	,tollgate_id
	,vehicle_id
	,make_timestamp(year,month,day,hour,minute, 0) AS time_window_start
	,CAST(starting_time AS DATE) AS date
	,CAST(make_timestamp(year,month,day,hour,minute, 0) AS time) AS time
	,year
	,month
	,day
	,hour
	,minute
	,week
	,dow
	,travel_time
FROM (
	SELECT
		intersection_id
		,tollgate_id
		,vehicle_id
		,starting_time
		,CAST(extract(year from starting_time) AS INT) AS year
		,CAST(extract(month from starting_time) AS INT) AS month
		,CAST(extract(day from starting_time) AS INT) AS day
		,CAST(extract(hour from starting_time) AS INT) AS hour
		,CAST(floor(extract(minute from starting_time) / 20) * 20 AS INT) AS minute
		,CAST(extract(week from starting_time) AS INT) AS week
		,CAST(extract(dow from starting_time) AS INT) AS dow
		,travel_time
	FROM tb3_trajectories_train
) AS A
);

SELECT
	intersection_id
	,tollgate_id
	,date
	,hour
	,minute
	,COUNT(*)
FROM tmp_trajectories_train
GROUP BY
	intersection_id
	,tollgate_id
	,date
	,hour
	,minute
ORDER BY
	1,2,3,4,5;

SELECT
	intersection_id
	,tollgate_id
	,date
	,hour
	,minute
	,COUNT(*) OVER (PARTITION BY intersection_id, tollgate_id, date, hour, minute)
	,SUM(travel_time) OVER (PARTITION BY intersection_id, tollgate_id, date, hour, minute)
FROM tmp_trajectories_train
ORDER BY
	1,2,3,4,5
limit 100;

SELECT
	intersection_id
	,tollgate_id
	,vehicle_id
	,date
	,hour
	,minute
	,travel_time
	,AVG(travel_time) OVER (ORDER BY time_window_start)
FROM tmp_trajectories_train
WHERE hour = 7 AND minute = 0
	AND intersection_id = 'A'
	AND tollgate_id = '2'

SELECT
	*
	,AVG(avg_travel_time) OVER (ORDER BY date ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) as moving_average
	,AVG(avg_travel_time) OVER (ORDER BY date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) as moving_average2
	,AVG(avg_travel_time) OVER (PARTITION BY dow ORDER BY date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) as moving_average2
FROM (
	SELECT
		date
		,dow
		,AVG(travel_time) avg_travel_time
	FROM tmp_trajectories_train
	GROUP BY
		date
		,dow
) AS A
ORDER BY
	date
;


CREATE TEMP TABLE tmp_travel_time_day AS (
SELECT
	date
	,COUNT(*) AS cnt
	,SUM(travel_time) AS sum_travel_time
	,AVG(travel_time) AS avg_travel_time
FROM tmp_trajectories_train
GROUP BY
	date
);

-- DROP TABLE tmp_travel_time_hour; 
CREATE TEMP TABLE tmp_travel_time_hour AS (
SELECT
	date
	,hour
	,COUNT(*) AS cnt
	,SUM(travel_time) AS sum_travel_time
	,AVG(travel_time) AS avg_travel_time
FROM tmp_trajectories_train
GROUP BY
	date
	,hour
);

CREATE TEMP TABLE tmp_travel_time_minute AS (
SELECT
	date
	,hour
	,minute
	,COUNT(*) AS cnt
	,SUM(travel_time) AS sum_travel_time
	,AVG(travel_time) AS avg_travel_time
FROM tmp_trajectories_train
GROUP BY
	date
	,hour
	,minute
);

SELECT
	*
FROM tmp_dm_train_base AS A
LEFT JOIN 
limit 100;

CREATE TEMP TABLE tmp_travel_time_cols AS (
SELECT DISTINCT
	intersection_id
	,tollgate_id
	,time_window_start
	,date
	,time
	,year
	,month
	,day
	,hour
	,minute
	,week
	,dow
	,cnt_day
	,cnt_hour
	,cnt_min
	,sum_travel_time_day
	,sum_travel_time_hour
	,sum_travel_time_min
	,avg_travel_time_day
	,avg_travel_time_hour
	,avg_travel_time_min
	,cnt_day_i
	,cnt_hour_i
	,cnt_min_i
	,sum_travel_time_day_i
	,sum_travel_time_hour_i
	,sum_travel_time_min_i
	,avg_travel_time_day_i
	,avg_travel_time_hour_i
	,avg_travel_time_min_i
	,cnt_day_t
	,cnt_hour_t
	,cnt_min_t
	,sum_travel_time_day_t
	,sum_travel_time_hour_t
	,sum_travel_time_min_t
	,avg_travel_time_day_t
	,avg_travel_time_hour_t
	,avg_travel_time_min_t
	,cnt_day_it
	,cnt_hour_it
	,cnt_min_it
	,sum_travel_time_day_it
	,sum_travel_time_hour_it
	,sum_travel_time_min_it
	,avg_travel_time_day_it
	,avg_travel_time_hour_it
	,avg_travel_time_min_it
FROM (
	SELECT
		*
		,COUNT(*) OVER (PARTITION BY date) AS cnt_day
		,COUNT(*) OVER (PARTITION BY date, hour) AS cnt_hour
		,COUNT(*) OVER (PARTITION BY date, hour, minute) AS cnt_min
		,SUM(travel_time) OVER (PARTITION BY date) AS sum_travel_time_day
		,SUM(travel_time) OVER (PARTITION BY date, hour) AS sum_travel_time_hour
		,SUM(travel_time) OVER (PARTITION BY date, hour, minute) AS sum_travel_time_min
		,AVG(travel_time) OVER (PARTITION BY date) AS avg_travel_time_day
		,AVG(travel_time) OVER (PARTITION BY date, hour) AS avg_travel_time_hour
		,AVG(travel_time) OVER (PARTITION BY date, hour, minute) AS avg_travel_time_min
		,COUNT(*) OVER (PARTITION BY intersection_id, date) AS cnt_day_i
		,COUNT(*) OVER (PARTITION BY intersection_id, date, hour) AS cnt_hour_i
		,COUNT(*) OVER (PARTITION BY intersection_id, date, hour, minute) AS cnt_min_i
		,SUM(travel_time) OVER (PARTITION BY intersection_id, date) AS sum_travel_time_day_i
		,SUM(travel_time) OVER (PARTITION BY intersection_id, date, hour) AS sum_travel_time_hour_i
		,SUM(travel_time) OVER (PARTITION BY intersection_id, date, hour, minute) AS sum_travel_time_min_i
		,AVG(travel_time) OVER (PARTITION BY intersection_id, date) AS avg_travel_time_day_i
		,AVG(travel_time) OVER (PARTITION BY intersection_id, date, hour) AS avg_travel_time_hour_i
		,AVG(travel_time) OVER (PARTITION BY intersection_id, date, hour, minute) AS avg_travel_time_min_i
		,COUNT(*) OVER (PARTITION BY tollgate_id, date) AS cnt_day_t
		,COUNT(*) OVER (PARTITION BY tollgate_id, date, hour) AS cnt_hour_t
		,COUNT(*) OVER (PARTITION BY tollgate_id, date, hour, minute) AS cnt_min_t
		,SUM(travel_time) OVER (PARTITION BY tollgate_id, date) AS sum_travel_time_day_t
		,SUM(travel_time) OVER (PARTITION BY tollgate_id, date, hour) AS sum_travel_time_hour_t
		,SUM(travel_time) OVER (PARTITION BY tollgate_id, date, hour, minute) AS sum_travel_time_min_t
		,AVG(travel_time) OVER (PARTITION BY tollgate_id, date) AS avg_travel_time_day_t
		,AVG(travel_time) OVER (PARTITION BY tollgate_id, date, hour) AS avg_travel_time_hour_t
		,AVG(travel_time) OVER (PARTITION BY tollgate_id, date, hour, minute) AS avg_travel_time_min_t
		,COUNT(*) OVER (PARTITION BY intersection_id, tollgate_id, date) AS cnt_day_it
		,COUNT(*) OVER (PARTITION BY intersection_id, tollgate_id, date, hour) AS cnt_hour_it
		,COUNT(*) OVER (PARTITION BY intersection_id, tollgate_id, date, hour, minute) AS cnt_min_it
		,SUM(travel_time) OVER (PARTITION BY intersection_id, tollgate_id, date) AS sum_travel_time_day_it
		,SUM(travel_time) OVER (PARTITION BY intersection_id, tollgate_id, date, hour) AS sum_travel_time_hour_it
		,SUM(travel_time) OVER (PARTITION BY intersection_id, tollgate_id, date, hour, minute) AS sum_travel_time_min_it
		,AVG(travel_time) OVER (PARTITION BY intersection_id, tollgate_id, date) AS avg_travel_time_day_it
		,AVG(travel_time) OVER (PARTITION BY intersection_id, tollgate_id, date, hour) AS avg_travel_time_hour_it
		,AVG(travel_time) OVER (PARTITION BY intersection_id, tollgate_id, date, hour, minute) AS avg_travel_time_min_it
	FROM tmp_trajectories_train
) AS A
);


SELECT *
FROM tmp_dm_train_base AS A
LEFT JOIN tmp_travel_time_cols AS B 
	ON A.intersection_id = B.intersection_id AND A.tollgate_id = B.tollgate_id
		AND A.date = B.date AND B.hour = 6 


SELECT
	A.intersection_id
	,A.tollgate_id
	,A.time_window_start
	,A.time_window_end
	,A.time_window
	,A.date
	,A.time
	,A.month
	,A.week
	,A.dow
	,A.avg_travel_time
	,B.h06m00
	,B.h06m20
	,B.h06m40
	,B.h07m00
	,B.h07m20
	,B.h07m40
	,B.h15m00
	,B.h15m20
	,B.h15m40
	,B.h16m00
	,B.h16m20
	,B.h16m40
FROM tmp_dm_train_base AS A
LEFT JOIN (
	SELECT
		intersection_id
		,tollgate_id
		,date
		,SUM(CASE WHEN hour = 6 AND minute = 0 THEN avg_travel_time_min_it ELSE 0 END) AS h06m00
		,SUM(CASE WHEN hour = 6 AND minute = 20 THEN avg_travel_time_min_it ELSE 0 END) AS h06m20
		,SUM(CASE WHEN hour = 6 AND minute = 40 THEN avg_travel_time_min_it ELSE 0 END) AS h06m40
		,SUM(CASE WHEN hour = 7 AND minute = 0 THEN avg_travel_time_min_it ELSE 0 END) AS h07m00
		,SUM(CASE WHEN hour = 7 AND minute = 20 THEN avg_travel_time_min_it ELSE 0 END) AS h07m20
		,SUM(CASE WHEN hour = 7 AND minute = 40 THEN avg_travel_time_min_it ELSE 0 END) AS h07m40
		,SUM(CASE WHEN hour = 15 AND minute = 0 THEN avg_travel_time_min_it ELSE 0 END) AS h15m00
		,SUM(CASE WHEN hour = 15 AND minute = 20 THEN avg_travel_time_min_it ELSE 0 END) AS h15m20
		,SUM(CASE WHEN hour = 15 AND minute = 40 THEN avg_travel_time_min_it ELSE 0 END) AS h15m40
		,SUM(CASE WHEN hour = 16 AND minute = 0 THEN avg_travel_time_min_it ELSE 0 END) AS h16m00
		,SUM(CASE WHEN hour = 16 AND minute = 20 THEN avg_travel_time_min_it ELSE 0 END) AS h16m20
		,SUM(CASE WHEN hour = 16 AND minute = 40 THEN avg_travel_time_min_it ELSE 0 END) AS h16m40
	FROM tmp_travel_time_cols
	WHERE hour BETWEEN 6 AND 7
		OR hour BETWEEN 15 AND 16
	GROUP BY
		intersection_id
		,tollgate_id
		,date
) AS B ON A.intersection_id = B.intersection_id AND A.tollgate_id = B.tollgate_id AND A.date = B.date
ORDER BY intersection_id, tollgate_id, time_window_start
;

SELECT
	


