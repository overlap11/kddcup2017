CREATE TABLE test (id integer, name varchar);

SELECT * FROM test;

COPY test FROM 'D:/home/work/kddcup2017/import/test.csv' WITH CSV;

SELECT * FROM test;

-- DROP TABLE tb1_links;
CREATE TABLE tb1_links (
    link_id varchar(100)
    ,length FLOAT
    ,width FLOAT
    ,lanes INTEGER
    ,in_top VARCHAR(100)
    ,out_top VARCHAR(100)
    ,lane_width FLOAT
);

COPY tb1_links FROM 'D:/home/work/kddcup2017/import/tb1_links.csv' WITH CSV QUOTE '"';

CREATE TABLE tb2_routes (
    intersection_id VARCHAR(100)
    ,tollgate_id VARCHAR(100)
    ,link_seq VARCHAR(100)
);

COPY tb2_routes FROM 'D:/home/work/kddcup2017/import/tb2_routes.csv' WITH CSV QUOTE '"';

CREATE TABLE tb3_trajectories (
    intersection_id VARCHAR(100)
    ,tollgate_id VARCHAR(100)
    ,vehicle_id VARCHAR(100)
    ,starting_time TIMESTAMP
    ,travel_seq TEXT
    ,travel_time FLOAT
);

COPY tb3_trajectories FROM 'D:/home/work/kddcup2017/import/tb3_trajectories_train.csv' WITH CSV QUOTE '"';
ALTER TABLE tb3_trajectories RENAME TO tb3_trajectories_train;
ALTER TABLE tb3_trajectories RENAME TO tb3_trajectories_train;

CREATE TABLE tb4_volume_train (
    time TIMESTAMP
    ,tollgate_id VARCHAR(100)
    ,direction VARCHAR(100)
    ,vehicle_model INTEGER
    ,has_etc VARCHAR(100)
    ,vehicle_type VARCHAR(100)
);

COPY tb4_volume_train FROM 'D:/home/work/kddcup2017/import/tb4_volume_train.csv' WITH CSV QUOTE '"';

CREATE TABLE tb5_weather_train (
    date DATE
    ,hour INTEGER
    ,pressure FLOAT
    ,sea_pressure FLOAT
    ,wind_direction FLOAT
    ,wind_speed FLOAT
    ,temperature FLOAT
    ,rel_humidity FLOAT
    ,precipitation FLOAT
);

COPY tb5_weather_train FROM 'D:/home/work/kddcup2017/import/tb5_weather_train.csv' WITH CSV QUOTE '"';

CREATE TABLE tb6_trajectories_test (
    intersection_id VARCHAR(100)
    ,tollgate_id VARCHAR(100)
    ,vehicle_id VARCHAR(100)
    ,starting_time TIMESTAMP
    ,travel_seq TEXT
    ,travel_time FLOAT
);

COPY tb6_trajectories_test FROM 'D:/home/work/kddcup2017/import/tb6_trajectories_test.csv' WITH CSV QUOTE '"';
ALTER TABLE tb6_trajectories_test RENAME TO tb6_trajectories_test1;

CREATE TABLE tb7_volume_test (
    time TIMESTAMP
    ,tollgate_id VARCHAR(100)
    ,direction VARCHAR(100)
    ,vehicle_model INTEGER
    ,has_etc VARCHAR(100)
    ,vehicle_type VARCHAR(100)
);

COPY tb7_volume_test FROM 'D:/home/work/kddcup2017/import/tb7_volume_test.csv' WITH CSV QUOTE '"';
ALTER TABLE tb7_volume_test RENAME TO tb7_volume_test1;

DROP TABLE test;

CREATE TABLE tb8_weather_test1 (
    date DATE
    ,hour INTEGER
    ,pressure FLOAT
    ,sea_pressure FLOAT
    ,wind_direction FLOAT
    ,wind_speed FLOAT
    ,temperature FLOAT
    ,rel_humidity FLOAT
    ,precipitation FLOAT
);

COPY tb8_weather_test1 FROM 'D:/home/work/kddcup2017/import/tb8_weather_test1.csv' WITH CSV QUOTE '"';

