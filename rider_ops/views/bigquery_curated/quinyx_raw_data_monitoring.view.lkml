# Owner:   Omar Alshobaki
# Created: 2022-10-27
# This view contains Daily Aggregation of number of row based on extaction timestamp and loading mothod, this explore will be used in monitor Quinyx missing data over time, which will allow us to better understand why we are missing data and how we can reduce it by exploring using different parameters if needed.

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
    sql: ${TABLE}.endpoint ;;
  }

  dimension_group: extraction {
    type: time
    timeframes: [
      raw,
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
    type: time
    timeframes: [
      raw,
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
    sql: ${TABLE}.load_method ;;
  }

  measure: number_of_rows{
    type: sum
    label: "# Rows"
    sql: ${TABLE}.number_of_rows ;;
  }

}
