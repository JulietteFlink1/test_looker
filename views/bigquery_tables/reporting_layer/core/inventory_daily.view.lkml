view: inventory_daily {
  sql_table_name: `flink-data-prod.reporting.inventory_daily`
    ;;


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension_group: report {
    label: "Inventory Report"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.report_date ;;
  }


  # =========  hidden   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }


  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    hidden: yes
  }


  # =========  IDs   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  # =========  Measures - Dims per Day/Hub/SKU   =========
  dimension: number_of_correction_product_damaged {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_correction_product_damaged ;;
  }

  dimension: number_of_correction_product_expired {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_correction_product_expired ;;
  }

  dimension: number_of_correction_stock_taking_increased {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_correction_stock_taking_increased ;;
  }

  dimension: number_of_correction_stock_taking_reduced {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_correction_stock_taking_reduced ;;
  }

  dimension: number_of_hours_oos {
    type: number
    sql: ${TABLE}.number_of_hours_oos ;;
  }

  dimension: number_of_hours_open {
    type: number
    sql: ${TABLE}.number_of_hours_open ;;
  }

  dimension: number_of_outbound_orders {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_outbound_orders ;;
  }

  dimension: number_of_outbound_others {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_outbound_others ;;
  }

  dimension: number_of_total_correction {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_total_correction ;;
  }

  dimension: number_of_total_inbound {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_total_inbound ;;
  }

  dimension: number_of_total_outbound {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_total_outbound ;;
  }

  dimension: number_of_unspecified {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_unspecified ;;
  }

  dimension: quantity_from {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.quantity_from ;;
  }

  dimension: quantity_to {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.quantity_to ;;
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~








}
