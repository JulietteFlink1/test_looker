view: waste_waterfall_definition {
  sql_table_name: `flink-data-dev.reporting.waste_buckets`
    ;;



##################################################################################
############################## ID Dimension ######################################
##################################################################################

  dimension: table_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: sku {
    type: string
    group_label: "ID Dimensions"
    sql: ${TABLE}.sku ;;
  }

  dimension: hub_code {
    type: string
    group_label: "ID Dimensions"
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    type: string
    group_label: "ID Dimensions"
    sql: ${TABLE}.country_iso ;;
  }


##################################################################################
############################## Time Dimension ####################################
##################################################################################

  dimension_group: inventory_change {
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
    sql: ${TABLE}.inventory_change_date ;;
  }

  dimension_group: inventory_change_timestamp {
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
    hidden: yes
    sql: ${TABLE}.inventory_change_timestamp ;;
  }



##################################################################################
############################## Buckets Dimension #################################
##################################################################################


  dimension: waste_reason_clasification {
    label: "Waste Definition"
    type: string
    sql: ${TABLE}.waste_reason_clasification ;;
  }


  dimension: euro_waste {
    label: "€ Euro Waste"
    hidden: yes
    type: number
    sql: ${TABLE}.euro_waste ;;
  }

  dimension: quantity_change {
    label: "Outbound Quantity"
    type: number
    sql: ${TABLE}.quantity_change ;;
  }


##################################################################################
############################## Measures ##########################################
##################################################################################


  measure: sum_bucket_a_damaged {
    type: sum
    sql: ${euro_waste} ;;
    label: "€ Euro Waste"
    value_format: "0.0,\" K\""
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
