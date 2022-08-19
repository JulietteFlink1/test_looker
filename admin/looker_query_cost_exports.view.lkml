view: looker_query_cost_exports {
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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: query_explore {
    type: string
    sql: ${TABLE}.Query_Explore ;;
    drill_fields: [detail*]
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

  dimension: history_id {
    type: number
    sql: ${TABLE}.History_ID ;;
  }

  dimension: history_slug {
    type: string
    sql: ${TABLE}.History_Slug ;;
  }

  dimension: history_dashboard_id__inclusive_ {
    type: number
    sql: ${TABLE}.History_Dashboard_ID__Inclusive_ ;;
  }

  dimension: history_connection_name {
    type: string
    sql: ${TABLE}.History_Connection_Name ;;
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

  dimension: dashboard_link {
    type: number
    sql: ${TABLE}.Dashboard_Link ;;
  }

  dimension: dashboard_lookml_link_id {
    type: string
    sql: ${TABLE}.Dashboard_Lookml_Link_ID ;;
  }

  dimension: dashboard_description {
    type: string
    sql: ${TABLE}.Dashboard_Description ;;
  }

  dimension: dashboard_title {
    type: string
    sql: ${TABLE}.Dashboard_Title ;;
  }

  dimension: query_hash {
    type: string
    sql: ${TABLE}.Query_Hash ;;
  }

  dimension_group: history_created_time {
    type: time
    sql: ${TABLE}.History_Created_Time ;;
  }

  dimension: query_count {
    type: number
    sql: ${TABLE}.Query_Count ;;
  }

  dimension: history_query_run_count {
    type: number
    sql: ${TABLE}.History_Query_Run_Count ;;
  }

  dimension: history_average_runtime_in_seconds {
    type: number
    sql: ${TABLE}.History_Average_Runtime_in_Seconds ;;
  }

  dimension: meta_json {
    type: string
    sql: ${TABLE}.meta_json ;;
  }

  dimension: user_email {
    type: string
    sql: ${TABLE}.user_email ;;
  }

  dimension_group: report_timestamp {
    type: time
    sql: ${TABLE}.report_timestamp ;;
  }

  dimension: job_type {
    type: string
    sql: ${TABLE}.job_type ;;
  }

  dimension: looker_context_history_id {
    type: string
    sql: ${TABLE}.looker_context_history_id ;;
  }

  dimension: looker_context_history_slug {
    type: string
    sql: ${TABLE}.looker_context_history_slug ;;
  }

  dimension: looker_context_instance_slug {
    type: string
    sql: ${TABLE}.looker_context_instance_slug ;;
  }

  dimension: looker_context_user_id {
    type: string
    sql: ${TABLE}.looker_context_user_id ;;
  }

  dimension: looker_query {
    type: string
    sql: ${TABLE}.looker_query ;;
  }

  dimension: statement_type {
    type: string
    sql: ${TABLE}.statement_type ;;
  }

  dimension: job_name {
    type: string
    sql: ${TABLE}.job_name ;;
  }

  dimension: query_start_time {
    type: string
    sql: ${TABLE}.query_start_time ;;
  }

  dimension: query_end_time {
    type: string
    sql: ${TABLE}.query_end_time ;;
  }

  dimension: billing_tier {
    type: string
    sql: ${TABLE}.billing_tier ;;
  }

  dimension: number_of_output_rows {
    type: string
    sql: ${TABLE}.number_of_output_rows ;;
  }

  dimension: referenced_tables {
    type: string
    sql: ${TABLE}.referenced_tables ;;
  }

  dimension: total_billed_bytes {
    type: number
    sql: cast(${TABLE}.total_billed_bytes as int64) ;;
  }

  dimension: total_billed_gigabytes {
    type: number
    sql: ${total_billed_bytes} /1000000000000 ;;
  }

  measure: avg_billed_gigabytes {
    type: average
    sql: ${total_billed_gigabytes}  ;;
    value_format_name: decimal_2
  }

  measure: total_query_costs {
    type: sum
    sql: 5.0 * coalesce(${total_billed_gigabytes}, 0) ;;
    value_format_name: eur
  }

  set: detail {
    fields: [
      query_explore,
      query_id,
      query_link,
      query_model,
      history_id,
      history_slug,
      history_dashboard_id__inclusive_,
      history_connection_name,
      look_id,
      look_link,
      look_title,
      dashboard_link,
      dashboard_lookml_link_id,
      dashboard_description,
      dashboard_title,
      query_hash,
      history_created_time_time,
      query_count,
      history_query_run_count,
      history_average_runtime_in_seconds,
      meta_json,
      user_email,
      report_timestamp_time,
      job_type,
      looker_context_history_id,
      looker_context_history_slug,
      looker_context_instance_slug,
      looker_context_user_id,
      looker_query,
      statement_type,
      job_name,
      query_start_time,
      query_end_time,
      billing_tier,
      number_of_output_rows,
      referenced_tables,
      total_billed_bytes
    ]
  }
}
