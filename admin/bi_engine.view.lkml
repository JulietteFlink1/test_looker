explore: bi_engine {
  from: base_table
  label: "BI Engine"
}

datagroup: bi_engine {
  max_cache_age: "24 hours"
  sql_trigger: SELECT TIMESTAMP_TRUNC(creation_time, DAY, "UTC") FROM `region-eu`.INFORMATION_SCHEMA.JOBS;;
}

view: base_table {

  derived_table: {
    sql: SELECT
           TIMESTAMP_TRUNC(creation_time, DAY, "UTC") AS date
          , project_id
          , bi_engine_statistics.bi_engine_mode bi_engine_mode
          , bi_engine_reason.code bi_engine_code
          , bi_engine_reason.message bi_engine_message_raw
          , CASE
            WHEN bi_engine_reason.message LIKE "%Reservation size is 25.00G, usage should be below 50.00G to admit new queries%" THEN "Reservation too small in peak-hours (>25G)"
            WHEN bi_engine_reason.message LIKE "%Reservation size is 1.00G, usage should be below 2.00G to admit new queries." THEN "Reservation too small in off-hours (>1G)"
            WHEN bi_engine_reason.message LIKE "Joining with a partitioned (dimension)%" THEN " Joining with a partitioned (dimension) table is not supported."
            WHEN bi_engine_reason.message LIKE "%nested joins, BI Engine supports up to 5." THEN "More than 5 nested joins"
            WHEN bi_engine_reason.message LIKE "%which exceeds the limit of 5000 files." THEN "Exceeds internal BI Engine limit of 5000 files"
            WHEN bi_engine_reason.message LIKE "%which exceeds the limit of 7000000000 rows."  THEN "Exceeds internal BI Engine limit of 7000000000 rows"
            WHEN bi_engine_reason.message LIKE "%INFORMATION_SCHEMA%" THEN "Unsupported table type like Information Schema Tables "
            ELSE bi_engine_reason.message
            END         AS bi_engine_message
          , cache_hit
          , query
          , job_id
          , total_slot_ms / TIMESTAMP_DIFF(end_time, start_time, MILLISECOND)
          , total_bytes_processed/1000000000000 tb_processed
          , total_bytes_billed/1000000000000 tb_billed
          , total_bytes_billed/102400000000*5 query_cost
          , (total_bytes_processed/102400000000*5)-(total_bytes_billed/102400000000*5) on_demand_savings
          , TIMESTAMP_DIFF(end_time, start_time, MILLISECOND)/1000 duration
          , (SELECT SUM(end_ms - start_ms) FROM UNNEST(job_stages))/1000 stage_duration
          , CASE WHEN query LIKE "%global_filters_and_parameters%" THEN true ELSE false END contains_global_filters_and_parameter
          , CASE WHEN query LIKE "%FULL OUTER JOIN%" THEN true ELSE false END contains_full_outer_join
          FROM `region-eu`.INFORMATION_SCHEMA.JOBS
          LEFT JOIN  UNNEST(bi_engine_statistics.bi_engine_reasons) as bi_engine_reason
          WHERE job_type = "QUERY"
          AND destination_table.table_id LIKE "anon%" -- only queries with anoumous destination tables
          AND creation_time BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 8 DAY) AND CURRENT_TIMESTAMP()
          GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
       ;;
    datagroup_trigger: bi_engine

  }

  drill_fields: [bi_engine*]

  dimension_group: date {
    type: time
    sql: ${TABLE}.date ;;
  }

  dimension: project_id {
    type: string
    sql: ${TABLE}.project_id ;;
  }

  dimension: mode {
    group_label: "BI Engine"
    type: string
    sql: ${TABLE}.bi_engine_mode ;;
  }

  dimension: code {
    group_label: "BI Engine"
    type: string
    sql: ${TABLE}.bi_engine_code ;;
  }

  dimension: message_raw {
    group_label: "BI Engine"
    type: string
    sql: ${TABLE}.bi_engine_message_raw ;;
  }

  dimension: message {
    group_label: "BI Engine"
    type: string
    sql: ${TABLE}.bi_engine_message ;;
    drill_fields: [query, project_id, query_cost, tb_billed]
  }

  dimension: cache_hit {
    type: yesno
    sql: ${TABLE}.cache_hit ;;
  }


  dimension: contains_global_filters_and_parameter {
    type: yesno
    sql: ${TABLE}.contains_global_filters_and_parameter ;;
  }

  dimension: contains_full_outer_join {
    type: yesno
    sql: ${TABLE}.contains_full_outer_join ;;
  }

  dimension: query {
    type: string
    sql: ${TABLE}.query ;;
  }

  dimension: job_id {
    type: string
    sql: ${TABLE}.job_id ;;
  }


  measure:  Jobs{
    type: count
    group_label: "Count"
  }



  measure:  total_jobs{
    label: "Job ids"
    description: "Sum over all job_ids"
    type: number
    group_label: "Total"
    sql: sum(count(job_id)) OVER()  ;;
  }

  measure:  tb_billed{
    type: sum
    group_label: "Total"
    sql: ${TABLE}.tb_billed;;
  }

  measure:  tb_processed{
    type: sum
    group_label: "Total"
    sql: ${TABLE}.tb_processed;;
  }

  measure:  query_cost{
    type: sum
    group_label: "Total"
    sql: ${TABLE}.query_cost;;
  }

  measure:  avg_tb_billed{
    label: "Tb Billed"
    type: average
    group_label: "Average"
    sql: ${TABLE}.tb_billed;;
  }

  measure:  avg_tb_processed{
    label: "Tb proccessed"
    type: average
    group_label: "Average"
    sql: ${TABLE}.tb_processed;;
  }

  measure:  avg_query_cost{
    label: "Query cost"
    type: average
    group_label: "Average"
    sql: ${TABLE}.query_cost;;
  }

  set: bi_engine {
    fields: [mode, code, message]
  }

}
