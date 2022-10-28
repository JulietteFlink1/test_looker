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
    group_label: "* Dates *"
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
    group_label: "* Dates *"
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
    sql: ${TABLE}.load_method ;;
  }

  measure: number_of_rows{
    type: sum
    label: "# Rows"
    sql: ${TABLE}.number_of_rows ;;
  }

}
