view: inbounding_times_per_vendor {
  sql_table_name: `flink-data-prod.reporting.inbounding_times_per_vendor`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension_group: report {
    label: "Inbound"
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
    sql: ${TABLE}.report_date ;;
  }



  # =========  hidden   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: erp_vendor_id {
    type: string
    sql: ${TABLE}.erp_vendor_id ;;
    hidden: yes
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }

  dimension: sku_list {
    type: string
    sql: ${TABLE}.sku_list ;;
    hidden: yes
  }

  dimension: inbounding_time_hours {
    type: number
    sql: ${TABLE}.inbounding_time_hours ;;
    hidden: yes
  }


  dimension: number_of_unique_skus_inbounded {
    type: number
    sql: ${TABLE}.number_of_unique_skus_inbounded ;;
    hidden: yes
  }

  dimension_group: first_item_booked_in_timestamp {

    label: "Time Inbound Started"
    description: "The start time of the inbounding process per vendor"

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
    sql: ${TABLE}.first_item_booked_in_timestamp ;;
    hidden: yes
  }


  dimension_group: last_item_booked_in_timestamp {

    label: "Time Inbound Ended"
    description: "The end time of the inbounding process per vendor"

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
    sql: ${TABLE}.last_item_booked_in_timestamp ;;
    hidden: yes
  }



  # =========  IDs   =========

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: avg_inbounding_time_hours  {

    label: "AVG Inbounding Time per Supplier (Hours)"
    description: "The average time it took to inbound the SKUs of a vendor"

    sql: ${inbounding_time_hours} ;;
    type: average

    value_format_name: decimal_2
  }

  measure: avg_number_of_unique_skus_inbounded {

    label: "AVG Inbounded SKUs per Supplier"
    description: "The average number of SKUs, that are inbounded per vendor"

    sql: ${number_of_unique_skus_inbounded} ;;
    type: average

    value_format_name: decimal_1
  }



}
