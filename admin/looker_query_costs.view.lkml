view: looker_query_costs {
  derived_table: {
    sql: select *

          from flink-data-dev.dbt_astueber.looker_query_cost_exports as looker

      left join flink-data-dev.dbt_astueber.gcp_logs_parsed_for_looker as gcp
      on
      gcp.looker_history_slug = History_Slug
      ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
      partition_timestamp_time,
      log_name,
      ressource_name,
      service_account,
      query,
      project_id,
      dataset_id,
      total_results,
      job_id,
      location,
      query_priority,
      statement_type,
      job_state,
      job_created_timestamp_time,
      job_started_timestamp_time,
      job_ended_timestamp_time,
      total_bytes_processed,
      total_bytes_billed,
      billing_tier,
      total_tables_processed,
      request_permission,
      looker_history_id,
      looker_history_slug,
      looker_instance_slug,
      looker_user_id,
      referenced_tables,

    ]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Looker Generic
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: query_model {
    label: "Model"
    description: "The Looker model, that is related to the query"
    group_label: "Looker"
    type: string
    sql: ${TABLE}.Query_Model ;;
  }

  dimension: query_explore {

    label: "Explore"
    group_label: "Looker"
    description: "The Looker Explore, that triggered BigQuery jobs"

    type: string
    sql: ${TABLE}.Query_Explore ;;
  }

  dimension_group: history_created_time {
    label: "Query Time (Looker)"
    group_label: "Dates & Timestamps"
    type: time
    timeframes: [date, time]
    sql: ${TABLE}.History_Created_Time ;;
  }

  dimension: looker_user_id {
    label: "User ID (Looker)"
    group_label: "Looker"
    type: string
    sql: ${TABLE}.looker_user_id ;;
  }

  dimension: history_connection_name {
    group_label: "Looker"
    type: string
    sql: ${TABLE}.History_Connection_Name ;;
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Looker Dashboard
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: history_dashboard_id__inclusive_ {
    label: "ID (Dashboard)"
    group_label: "Looker"
    type: number
    sql: ${TABLE}.History_Dashboard_ID__Inclusive_ ;;
  }

  dimension: dashboard_link {
    label: "Link (Dashboard)"
    group_label: "Looker"
    type: number
    sql: ${TABLE}.Dashboard_Link ;;
  }

  dimension: dashboard_lookml_link_id {
    label: "LookML Link (Dashboard)"
    group_label: "Looker"
    type: string
    sql: ${TABLE}.Dashboard_Lookml_Link_ID ;;
  }

  dimension: dashboard_description {
    label: "Description (Dashboard)"
    group_label: "Looker"
    type: string
    sql: ${TABLE}.Dashboard_Description ;;
  }

  dimension: dashboard_title {
    label: "Title (Dashboard)"
    group_label: "Looker"
    type: string
    sql: ${TABLE}.Dashboard_Title ;;
  }




  dimension: look_title {
    label: "Title (Look)"
    group_label: "Looker"
    description: "The title of the Look (given there was a title set). This field only refers to separately saved Looks, not Looks within dashboards"
    type: string
    sql: ${TABLE}.Look_Title ;;
  }

  dimension: look_id {
    label: "ID (Looks)"
    group_label: "Looker"
    type: string
    sql: ${TABLE}.Look_ID ;;
  }

  dimension: look_link {
    label: "Link (Look)"
    group_label: "Looker"
    type: string
    sql: ${TABLE}.Look_Link ;;
  }




  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    GCP Data
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: source {
    label: "GCP Logs Source"
    group_label: "GCP Logs"
    type: string
    sql: ${TABLE}.source__ ;;
  }

  dimension: query {
    label: "Query"
    group_label: "GCP Logs"
    type: string
    sql: ${TABLE}.query ;;
    html: <code>{{ rendered_value }}</code> ;;
  }

  dimension_group: job_created_timestamp {
    label: "BigQuery Job Created"
    group_label: "Dates & Timestamps"
    type: time
    timeframes: [time, date]
    sql: ${TABLE}.job_created_timestamp ;;
  }

  dimension_group: job_started_timestamp {
    label: "BigQuery Job Started"
    group_label: "Dates & Timestamps"
    type: time
    timeframes: [time, date]
    sql: ${TABLE}.job_started_timestamp ;;
  }

  dimension_group: job_ended_timestamp {
    label: "BigQuery Job Ended"
    group_label: "Dates & Timestamps"
    type: time
    timeframes: [time, date]
    sql: ${TABLE}.job_ended_timestamp ;;
  }

  dimension: billing_tier {
    group_label: "GCP Logs"
    type: number
    sql: ${TABLE}.billing_tier ;;
  }

  dimension: referenced_tables {
    label: "Referenced Tables in Query"
    group_label: "GCP Logs"
    type: string
    sql: ${TABLE}.referenced_tables ;;
  }

  dimension: query_link {
    group_label: "GCP Logs"
    type: number
    sql: ${TABLE}.Query_Link ;;
  }

  dimension: query_priority {
    group_label: "GCP Logs"
    type: string
    sql: ${TABLE}.query_priority ;;
  }

  dimension: statement_type {
    group_label: "GCP Logs"

    type: string
    sql: ${TABLE}.statement_type ;;
  }

  dimension: job_state {
    group_label: "GCP Logs"
    type: string
    sql: ${TABLE}.job_state ;;
  }

  dimension: request_permission {
    group_label: "GCP Logs"
    type: string
    sql: ${TABLE}.request_permission ;;
  }

  dimension_group: partition_timestamp {
    group_label: "Dates & Timestamps"
    type: time
    timeframes: [time, date]
    sql: ${TABLE}.partition_timestamp ;;
  }

  dimension: log_name {
    group_label: "GCP Logs"
    type: string
    sql: ${TABLE}.log_name ;;
  }

  dimension: ressource_name {
    group_label: "GCP Logs"
    type: string
    sql: ${TABLE}.ressource_name ;;
  }

  dimension: service_account {
    group_label: "GCP Logs"
    type: string
    sql: ${TABLE}.service_account ;;
  }

  dimension: project_id {
    group_label: "GCP Logs"
    type: string
    sql: ${TABLE}.project_id ;;
  }

  dimension: dataset_id {
    group_label: "GCP Logs"
    type: string
    sql: ${TABLE}.dataset_id ;;
  }



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    IDs
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: job_id {
    type: string
    sql: ${TABLE}.job_id ;;
    hidden: yes
    primary_key: yes
  }

  dimension: history_id {
    type: number
    sql: ${TABLE}.History_ID ;;
    hidden: yes
  }

  dimension: history_slug {
    type: string
    sql: ${TABLE}.History_Slug ;;
    hidden: yes
  }

  dimension: query_id {
    type: number
    sql: ${TABLE}.Query_ID ;;
    hidden: yes
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Hidden Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: query_hash {
    type: string
    sql: ${TABLE}.Query_Hash ;;
    hidden: yes
  }

  dimension: query_count {
    type: number
    sql: ${TABLE}.Query_Count ;;
    hidden: yes
  }

  dimension: total_bytes_processed {
    type: number
    sql: ${TABLE}.total_bytes_processed ;;
    hidden: yes
  }

  dimension: total_bytes_billed {
    type: number
    sql: ${TABLE}.total_bytes_billed ;;
    hidden: yes
  }

  dimension: looker_history_id {
    type: string
    sql: ${TABLE}.looker_history_id ;;
    hidden: yes
  }

  dimension: looker_history_slug {
    type: string
    sql: ${TABLE}.looker_history_slug ;;
    hidden: yes
  }

  dimension: looker_instance_slug {
    type: string
    sql: ${TABLE}.looker_instance_slug ;;
    hidden: yes
  }

  dimension: total_tables_processed {
    type: number
    sql: ${TABLE}.total_tables_processed ;;
    hidden: yes
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
    hidden: yes
  }

  dimension: total_results {
    type: number
    sql: ${TABLE}.total_results ;;
    hidden: yes
  }

  dimension: history_query_run_count {
    group_label: "Looker"
    type: number
    sql: ${TABLE}.History_Query_Run_Count ;;
    hidden: yes
  }

  dimension: history_average_runtime_in_seconds {
    group_label: "Looker"
    type: number
    sql: ${TABLE}.History_Average_Runtime_in_Seconds ;;
    hidden: yes
  }

  dimension: total_gigabytes_billed {
    type: number
    sql: ${total_bytes_billed} /1073741824 ;;
    drill_fields: [detail*]
    hidden: yes
  }

  dimension: total_gigabytes_processed {
    type: number
    sql: ${TABLE}.total_bytes_processed /1073741824 ;;
    drill_fields: [detail*]
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: avg_query_results {
    label: "AVG Rows Returned"
    description: "The GCP-Logs-based information, how many rows have been returned by a query"

    type: average
    sql: ${total_results} ;;
    drill_fields: [detail*]
    value_format_name: decimal_1
  }

  measure: avg_tables_processed {
    label: "AVG Tables Processed"
    description: "The average number of tables, that are used in queries"

    type: average
    sql: ${total_tables_processed} ;;
    drill_fields: [detail*]
    value_format_name: decimal_1
  }

  measure: sum_query_count {
    label: "# Query Counts (GCP)"
    description: "The total number of queries, that have been run"

    type: sum
    sql:  ${query_count};;
    drill_fields: [detail*]
    value_format_name: decimal_0
  }

  measure: avg_gigabytes_billed {
    label: "AVG Gigabytes Billed"
    description: "The average number of gigabytes that have been billed by BigQuery"

    type: average
    sql: ${total_gigabytes_billed}  ;;
    drill_fields: [detail*]
    value_format_name: decimal_2
  }

  measure: avg_gigabytes_processed {
    label: "AVG Gigabytes Processed"
    description: "The average number of gigabytes that have been processed by BigQuery"

    type: average
    sql: ${total_gigabytes_processed}  ;;
    drill_fields: [detail*]
    value_format_name: decimal_2
  }

  measure: sum_gigabytes_processed {
    label: "# Gigabytes Processed"
    description: "The total sum of gigabytes that have been processed by BigQuery"

    type: sum
    sql: ${total_gigabytes_processed}  ;;
    drill_fields: [detail*]
    value_format_name: decimal_0
  }

  measure: total_query_costs {
    label: "# Query Cost"
    description: "The total sum of terrabytes billed multiplied by 5.00€ (staticly defined)"

    type: sum
    sql: 5.0 * (coalesce(${total_gigabytes_billed}, 0) / 1000) ;;
    drill_fields: [detail*]
    value_format_name: eur
  }

  measure: sum_history_query_run_count {
    label: "# Query Counts (Looker)"
    description: "The total number of queries, that have been run"

    type: sum
    sql: ${history_query_run_count} ;;
    drill_fields: [detail*]
    value_format_name: decimal_0
  }

  measure: avg_runtime_seconds {
    label: "AVG Query Runtime"
    description: "The average amount of seconds it took to execute a query"

    type: average
    sql: ${history_average_runtime_in_seconds} ;;
    drill_fields: [detail*]
    value_format_name: decimal_1
  }

}
