view: looker_query_cost_exports_main {

  derived_table: {
    sql: SELECT *
      FROM       flink-data-dev.dbt_astueber.looker_query_cost_exports  as looker
      left join  flink-data-dev.dbt_astueber.gcp_logs_looker  as gcp
      on
        gcp.looker_context_history_slug = looker.History_Slug

      where
      true
      and date(gcp.report_timestamp) = '2022-08-18'
      and date(looker.History_Created_Time) = '2022-08-18'
      ;;
  }

  dimension: billing_tier {
    type: number
    sql: ${TABLE}.billing_tier ;;
  }

  dimension: dashboard_description {
    type: string
    sql: ${TABLE}.Dashboard_Description ;;
  }

  dimension: dashboard_link {
    type: number
    sql: ${TABLE}.Dashboard_Link ;;
  }

  dimension: dashboard_lookml_link_id {
    type: string
    sql: ${TABLE}.Dashboard_Lookml_Link_ID ;;
  }

  dimension: dashboard_title {
    type: string
    sql: ${TABLE}.Dashboard_Title ;;
  }

  dimension: dataset_id {
    type: string
    sql: ${TABLE}.dataset_id ;;
  }

  dimension: history_average_runtime_in_seconds {
    type: number
    sql: ${TABLE}.History_Average_Runtime_in_Seconds ;;
  }

  dimension: history_connection_name {
    type: string
    sql: ${TABLE}.History_Connection_Name ;;
  }

  dimension_group: history_created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.History_Created_Time ;;
  }

  dimension: history_dashboard_id__inclusive_ {
    type: number
    value_format_name: id
    sql: ${TABLE}.History_Dashboard_ID__Inclusive_ ;;
  }

  dimension: history_id {
    type: number
    sql: ${TABLE}.History_ID ;;
  }

  dimension: history_query_run_count {
    type: number
    sql: ${TABLE}.History_Query_Run_Count ;;
  }

  dimension: history_slug {
    type: string
    sql: ${TABLE}.History_Slug ;;
  }

  dimension_group: job_created_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.job_created_timestamp ;;
  }

  dimension_group: job_ended_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.job_ended_timestamp ;;
  }

  dimension: job_id {
    type: string
    sql: ${TABLE}.job_id ;;
  }

  dimension_group: job_started_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.job_started_timestamp ;;
  }

  dimension: job_state {
    type: string
    sql: ${TABLE}.job_state ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: log_name {
    type: string
    sql: ${TABLE}.log_name ;;
  }

  dimension: look_id {
    type: string
    sql: ${TABLE}.Look_ID ;;
  }

  dimension: look_link {
    type: string
    sql: ${TABLE}.Look_Link ;;
  }

  dimension: look_title {
    type: string
    sql: ${TABLE}.Look_Title ;;
  }

  dimension: looker_history_id {
    type: string
    sql: ${TABLE}.looker_history_id ;;
  }

  dimension: looker_history_slug {
    type: string
    sql: ${TABLE}.looker_history_slug ;;
  }

  dimension: looker_instance_slug {
    type: string
    sql: ${TABLE}.looker_instance_slug ;;
  }

  dimension: looker_user_id {
    type: string
    sql: ${TABLE}.looker_user_id ;;
  }

  dimension_group: partition_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.partition_timestamp ;;
  }

  dimension: project_id {
    type: string
    sql: ${TABLE}.project_id ;;
  }

  dimension: query {
    type: string
    sql: ${TABLE}.query ;;
  }

  dimension: query_count {
    type: number
    sql: ${TABLE}.Query_Count ;;
  }

  dimension: query_explore {
    type: string
    sql: ${TABLE}.Query_Explore ;;
  }

  dimension: query_hash {
    type: string
    sql: ${TABLE}.Query_Hash ;;
  }

  dimension: query_id {
    type: number
    sql: ${TABLE}.Query_ID ;;
  }

  dimension: query_link {
    type: number
    sql: ${TABLE}.Query_Link ;;
  }

  dimension: query_model {
    type: string
    sql: ${TABLE}.Query_Model ;;
  }

  dimension: query_priority {
    type: string
    sql: ${TABLE}.query_priority ;;
  }

  dimension: referenced_tables {
    type: string
    sql: ${TABLE}.referenced_tables ;;
  }

  dimension: request_permission {
    type: string
    sql: ${TABLE}.request_permission ;;
  }

  dimension: ressource_name {
    type: string
    sql: ${TABLE}.ressource_name ;;
  }

  dimension: service_account {
    type: string
    sql: ${TABLE}.service_account ;;
  }

  dimension: statement_type {
    type: string
    sql: ${TABLE}.statement_type ;;
  }

  dimension: total_bytes_billed {
    type: number
    sql: ${TABLE}.total_bytes_billed ;;
  }

  dimension: total_bytes_processed {
    type: number
    sql: ${TABLE}.total_bytes_processed ;;
  }

  dimension: total_results {
    type: number
    sql: ${TABLE}.total_results ;;
  }

  dimension: total_tables_processed {
    type: number
    sql: ${TABLE}.total_tables_processed ;;
  }

  measure: count {
    type: count
    drill_fields: [history_created_time, log_name, history_connection_name, ressource_name]
  }

  dimension: total_gigabytes_billed {
    type: number
    sql: ${total_bytes_billed} /1073741824 ;;
  }

  dimension: total_gigabytes_processed {
    type: number
    sql: ${TABLE}.total_bytes_processed /1073741824 ;;
  }

  measure: avg_gigabytes_billed {
    type: average
    sql: ${total_gigabytes_billed}  ;;
    value_format_name: decimal_2
  }

  measure: avg_gigabytes_processed {
    type: average
    sql: ${total_gigabytes_processed}  ;;
    value_format_name: decimal_2
  }

  measure: sum_gigabytes_processed {
    type: sum
    sql: ${total_gigabytes_processed}  ;;
    value_format_name: decimal_0
  }

  measure: total_query_costs {
    type: sum
    sql: 5.0 * (coalesce(${total_gigabytes_billed}, 0) / 1000) ;;
    value_format_name: eur
  }
}
