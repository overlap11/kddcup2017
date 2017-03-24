SELECT
	*
FROM tb4_volume_train
limit 100
;

CREATE TEMP TABLE tmp_volume_prediction AS (
SELECT
	tollgate_id
	,time_window_start
	,time_window_start + interval '20 minute' AS time_window_end 
	,'[' || time_window_start || ',' || time_window_start + interval '20 minute' || ')' AS time_window
	,direction
	,COUNT(*) AS volume
FROM (
	SELECT
		tollgate_id
		,make_timestamp(CAST(year AS INT), CAST(month AS INT), CAST(day AS INT), CAST(hour AS INT), CAST(minute AS INT), 0) AS time_window_start
		,direction
	FROM (
		SELECT
			tollgate_id
			,direction
			,CAST(extract(year from time) AS INT) AS year
			,CAST(extract(month from time) AS INT) AS month
			,CAST(extract(day from time) AS INT) AS day
			,CAST(extract(hour from time) AS INT) AS hour
			,CAST(floor(extract(minute from time) / 20) * 20 AS INT) AS minute
		FROM tb4_volume_train
	) AS A
) AS AA
GROUP BY
	tollgate_id
	,time_window_start
	,time_window_start + interval '20 minute'
	,'[' || time_window_start || ',' || time_window_start + interval '20 minute' || ')'
	,direction
);

CREATE TABLE work_volume_prediction AS (
SELECT
	tollgate_id
	,time_window_start
	,time_window_end
	,time_window
	,direction
	,CAST(time_window_start AS DATE) AS date
	,CAST(time_window_start AS time) AS time
	,extract(month from time_window_start) AS month
	,extract(day from time_window_start) AS day
	,extract(hour from time_window_start) AS hour
	,extract(minute from time_window_start) AS minute
	,extract(week from time_window_start) AS week
	,extract(dow from time_window_start) AS dow
	,volume
FROM tmp_volume_prediction
);

SELECT
	CAST(time_window_start AS DATE)
	,tollgate_id
	,direction
	,SUM(volume)
FROM work_volume_prediction
GROUP BY
	CAST(time_window_start AS DATE)
	,tollgate_id
	,direction
;

