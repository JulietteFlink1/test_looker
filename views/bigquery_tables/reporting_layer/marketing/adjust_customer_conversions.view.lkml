view: adjust_customer_conversions {

  sql_table_name: `flink-data-prod.reporting.adjust_customer_conversion`
  ;;

  dimension: adjust_customer_conversion_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.adjust_customer_conversion_uuid ;;
  }

  dimension_group: installed_at_timestamp {
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
    datatype: timestamp
    sql: ${TABLE}.installed_at_timestamp ;;
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension: tracker {
    type: string
    sql: ${TABLE}.tracker ;;
  }

  dimension: network_name {
    type: string
    sql: ${TABLE}.network_name ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: adgroup_name {
    type: string
    sql: ${TABLE}.adgroup_name ;;
  }

  dimension: creative_name {
    type: string
    sql: ${TABLE}.creative_name ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: operating_system {
    type: string
    sql: ${TABLE}.operating_system ;;
  }

  ######## Measures

  measure: number_of_installs {
    type: sum
    sql: ${TABLE}.number_of_install;;
  }

  measure: count_address_selected {
    type: sum
    sql: ${TABLE}.number_of_address_selected;;
  }

  measure: count_add_to_cart {
    type: sum
    sql: ${TABLE}.number_of_add_to_cart;;
  }

  measure: count_checkout_started {
    type: sum
    sql: ${TABLE}.number_of_checkout_started;;
  }

  measure: count_purchase_confirmed {
    type: sum
    sql: ${TABLE}.number_of_purchase_confirmed;;
  }

  measure: count_purchase {
    type: sum
    sql: ${TABLE}.number_of_purchase;;
  }

  measure:  conversion_rate{
    type: number
    sql: (${count_purchase}/${number_of_installs})*100 ;;
    value_format: "0.0\%"
  }

  measure:  mcvr1{
    type: number
    sql: (${count_address_selected}/${number_of_installs})*100 ;;
    value_format: "0.0\%"
  }

  measure:  mcvr2{
    type: number
    sql: (${count_add_to_cart}/${count_address_selected})*100 ;;
    value_format: "0.0\%"
  }

  measure:  mcvr3{
    type: number
    sql: (${count_checkout_started}/${count_add_to_cart})*100 ;;
    value_format: "0.0\%"
  }

  measure:  mcvr4{
    type: number
    sql: (${count_purchase_confirmed}/${count_checkout_started})*100 ;;
    value_format: "0.0\%"
  }

  measure:  mcvr5{
    type: number
    sql: (${count_purchase}/${count_purchase_confirmed})*100 ;;
    value_format: "0.0\%"
  }


  set: detail {

  }
}
