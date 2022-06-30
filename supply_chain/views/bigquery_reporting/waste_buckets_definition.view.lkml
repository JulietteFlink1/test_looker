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


  dimension: waste_buckets {
    label: "Waste Buckets Definition"
    group_label: "Waste Dimensions"
    type: string
    sql: ${TABLE}.waste_buckets ;;
  }


  dimension: amt_waste_gross {
    label: "€ Waste Gross"
    hidden: yes
    type: number
    sql: ${TABLE}.amt_waste_gross ;;
  }

  dimension: number_of_items_waste {
    label: "# Outbound Items (Waste)"
    hidden: yes
    group_label: "Waste Dimensions"
    type: number
    sql: ${TABLE}.number_of_items_waste ;;
  }

  dimension: item_selling_price_daily_gross {
    label: "Item Selling Price Gross"
    group_label: "Waste Dimensions"
    hidden: yes
    type: number
    sql: ${TABLE}.item_selling_price_daily_gross ;;
  }

##################################################################################
############################## Measures ##########################################
##################################################################################


  measure: sum_waste_gross {
    type: sum
    sql: ${amt_waste_gross} ;;
    label: "€ SUM Waste Gross"
    value_format: "0.0,\" K\""
  }

  measure: sum_number_of_items_waste {
    type: sum
    sql: ${number_of_items_waste} ;;
    label: "SUM Outbound Items (Waste)"
  }


  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
