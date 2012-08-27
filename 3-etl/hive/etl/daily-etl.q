ADD JAR s3://psychicbazaar-snowplow-static/snowplow-log-deserializers-0.4.7.jar ;

CREATE EXTERNAL TABLE `cloudfront_log_of_events`
ROW FORMAT SERDE 'com.snowplowanalytics.snowplow.hadoop.hive.SnowPlowEventDeserializer'
LOCATION '${CLOUDFRONTLOGS}' ;

CREATE EXTERNAL TABLE IF NOT EXISTS `events` (
tm STRING,
txn_id STRING,
user_id STRING,
user_ipaddress string,
visit_id INT,
page_url string,
page_title string,
page_referrer string,
mkt_source string,
mkt_medium string,
mkt_term string,
mkt_content string,
mkt_campaign string,
ev_category string,
ev_action string,
ev_label string,
ev_property string,
ev_value string,
br_name string,
br_family string,
br_version string,
br_type string,
br_renderengine string,
br_lang string,
br_features array<string>,
br_cookies boolean,
os_name string,
os_family string,
os_manufacturer string,
dvce_type string,
dvce_ismobile boolean,
dvce_screenwidth int,
dvce_screenheight int)
PARTITIONED BY (dt STRING)
LOCATION 's3://psychicbazaar-snowplow-hive-tables/events/' ;

ALTER TABLE events RECOVER PARTITIONS ;

SET hive.exec.dynamic.partition=true ;
SET hive.exec.dynamic.partition.mode=nonstrict ;

/* Use a query like the one below to ETL more than one days worth of data into the optimised table */

INSERT OVERWRITE TABLE `events`
PARTITION(dt)
SELECT
tm,
txn_id,
user_id,
user_ipaddress,
visit_id,
page_url,
page_title,
page_referrer,
mkt_source,
mkt_medium,
mkt_term,
mkt_content,
mkt_campaign,
ev_category,
ev_action,
ev_label,
ev_property,
ev_value,
br_name,
br_family,
br_version,
br_type,
br_renderengine,
br_lang,
br_features,
br_cookies,
os_name,
os_family,
os_manufacturer,
dvce_type,
dvce_ismobile,
dvce_screenwidth,
dvce_screenheight,
dt
FROM 
`cloudfront_log_of_events`
WHERE dt IS NOT NULL
AND dt>'2012-08-21'
AND dt<'2012-08-27' ;

/* Use a query like the one below to ETL more only one days worth of data into the optimised table */

INSERT OVERWRITE TABLE `events`
PARTITION(dt='2012-05-28')
SELECT
tm,
txn_id,
user_id,
user_ipaddress,
visit_id,
page_url,
page_title,
page_referrer,
mkt_source,
mkt_medium,
mkt_term,
mkt_content,
mkt_campaign,
ev_category,
ev_action,
ev_label,
ev_property,
ev_value,
br_name,
br_family,
br_version,
br_type,
br_renderengine,
br_lang,
br_features,
br_cookies,
os_name,
os_family,
os_manufacturer,
dvce_type,
dvce_ismobile,
dvce_screenwidth,
dvce_screenheight
FROM 
`extracted_logs`
WHERE dt='2012-05-28';