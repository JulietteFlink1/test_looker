view: gcp_logs_parsed_for_looker {
  sql_table_name: `flink-data-prod.reporting.gcp_logs_parsed_for_looker`
    ;;



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Main
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: dataset_id {
    type: string
    sql: ${TABLE}.dataset_id ;;
  }

  dimension: job_state {
    type: string
    sql: ${TABLE}.job_state ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: project_id {
    type: string
    sql: ${TABLE}.project_id ;;
  }

  dimension: query {
    label: "Query"
    type: string
    sql: ${TABLE}.query ;;
    html: <code>{{ rendered_value }}</code> ;;
  }

  dimension: service_account {
    type: string
    sql: ${TABLE}.service_account ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Dates & Timestamps
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dimension_group: job_started_timestamp {
    label: "BigQuery Job Started"
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
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    IDs
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

  dimension: looker_user_id {
    type: string
    sql: ${TABLE}.looker_user_id ;;
    hidden: yes
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Hidden Measure Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: amt_billed_potentially {
    type: number
    sql: ${TABLE}.amt_billed_potentially ;;
    hidden: yes
  }

  dimension: amt_billed_total {
    type: number
    sql: ${TABLE}.amt_billed_total ;;
    hidden: yes
  }

  dimension: number_of_queries {
    type: number
    sql: ${TABLE}.number_of_queries ;;
    hidden: yes
  }

  dimension: query_duration_in_seconds {
    type: number
    sql: ${TABLE}.query_duration_in_seconds ;;
    hidden: yes
  }

  dimension: total_bytes_billed {
    type: number
    sql: ${TABLE}.total_bytes_billed ;;
    hidden: yes
  }

  dimension: total_bytes_processed {
    type: number
    sql: ${TABLE}.total_bytes_processed ;;
    hidden: yes
  }

  dimension: total_gigabytes_billed {
    type: number
    sql: ${TABLE}.total_gigabytes_billed ;;
    hidden: yes
  }

  dimension: total_gigabytes_processed {
    type: number
    sql: ${TABLE}.total_gigabytes_processed ;;
    hidden: yes
  }

  dimension: total_results {
    type: number
    sql: ${TABLE}.total_results ;;
    hidden: yes
  }

  dimension: total_tables_processed {
    type: number
    sql: ${TABLE}.total_tables_processed ;;
    hidden: yes
  }

  dimension: total_terabytes_billed {
    type: number
    sql: ${TABLE}.total_terabytes_billed ;;
    hidden: yes
  }

  dimension: total_terabytes_processed {
    type: number
    sql: ${TABLE}.total_terabytes_processed ;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: avg_query_results {
    label: "AVG Rows Returned"
    description: "The GCP-Logs-based information, how many rows have been returned by a query"

    type: average
    sql: ${total_results} ;;
    value_format_name: decimal_1
  }

  measure: avg_tables_processed {
    label: "AVG Tables Processed"
    description: "The average number of tables, that are used in queries"

    type: average
    sql: ${total_tables_processed} ;;
    value_format_name: decimal_1
  }

  measure: sum_query_count {
    label: "# Queries"
    description: "The total number of queries, that have been run"

    type: sum
    sql:  ${number_of_queries};;
    value_format_name: decimal_0
  }

  measure: avg_gigabytes_billed {
    label: "AVG Gigabytes Billed"
    description: "The average number of gigabytes that have been billed by BigQuery"

    type: average
    sql: ${total_gigabytes_billed}  ;;
    value_format_name: decimal_2
  }

  measure: sum_gigabytes_billed {
    label: "# Gigabytes Billed"
    description: "The sum of gigabytes that have been billed by BigQuery"

    type: sum
    sql: ${total_gigabytes_billed}  ;;
    value_format_name: decimal_2
  }

  measure: avg_gigabytes_processed {
    label: "AVG Gigabytes Processed"
    description: "The average number of gigabytes that have been processed by BigQuery"

    type: average
    sql: ${total_gigabytes_processed}  ;;
    value_format_name: decimal_2
  }

  measure: sum_gigabytes_processed {
    label: "# Gigabytes Processed"
    description: "The total sum of gigabytes that have been processed by BigQuery"

    type: sum
    sql: ${total_gigabytes_processed}  ;;
    value_format_name: decimal_0
  }

  measure: total_query_costs {
    label: "€ Query Cost (based on billed bytes)"
    description: "The total sum of terrabytes billed multiplied by 5.00€ (staticly defined)"

    type: sum
    sql: ${amt_billed_total} ;;
    value_format_name: eur
  }

  measure: total_potential_query_costs {
    label: "€ Hypothetical Query Cost (based on processed bytes)"
    description: "The total sum of terrabytes processed multiplied by 5.00€ (staticly defined). This serves as the hypothetical number: what would we have payed, if we did not enable slot-based-billing"

    type: sum
    sql: ${amt_billed_potentially} ;;
    value_format_name: eur
  }

  measure: avg_runtime_seconds {
    label: "AVG Query Runtime"
    description: "The average amount of seconds it took to execute a query"

    type: average
    sql: ${query_duration_in_seconds} ;;
    value_format_name: decimal_1
  }

  measure: avg_cost_per_query {
    label: "AVG Cost per Qeury"
    description: "The average cost per qeury (€ Total Query Cost / # Queries)"
    type: number
    sql: ${total_query_costs}/nullif(${sum_query_count},0) ;;
    value_format_name: eur
  }



  measure: count {
    type: count
    drill_fields: []
  }
}
