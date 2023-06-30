# Owner:   Omar Alshobaki
# Created: 2022-10-27
# Daily Aggregation of number of rows based on extraction timestamps and loading method.
# This explore will be used to monitor Quinyx missing data over time.


view: quinyx_raw_data_monitoring {
  sql_table_name: `flink-data-prod.sandbox.quinyx_raw_data_monitoring`
    ;;


  dimension: table_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.table_uuid ;;
  }


  dimension: endpoint {
    type: string
    label: "Endpoint"
    sql: ${TABLE}.endpoint ;;
  }

  dimension_group: extraction {
    group_label: "> Dates"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.extraction_date ;;
  }

  dimension_group: last_modified {
    group_label: "> Dates"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_modified_date ;;
  }

  dimension: load_method {
    type: string
    label: "Load Method"
    hidden: yes
    sql: ${TABLE}.load_method ;;
  }

  measure: number_of_rows_full{
    type: sum
    label: "# Rows Full Load"
    filters:[load_method: "full"]
    sql: ${TABLE}.number_of_rows ;;
  }

  measure: number_of_rows_Incremental{
    type: sum
    label: "# Rows Incremental Load"
    filters:[load_method: "incremental"]
    sql: ${TABLE}.number_of_rows ;;
  }

  measure: pct_of_rows_full{
    type: number
    label: "% Rows Full Load"
    sql: ${number_of_rows_full}/nullif(${number_of_rows_full}+${number_of_rows_Incremental},0) ;;
    value_format: "0%"
  }

  measure: pct_of_rows_Incremental{
    type: number
    label: "% Rows Incremental Load"
    sql: ${number_of_rows_Incremental}/nullif(${number_of_rows_full}+${number_of_rows_Incremental},0) ;;
    value_format: "0%"
  }

}
