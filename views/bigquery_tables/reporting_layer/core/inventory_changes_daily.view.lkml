view: inventory_changes_daily {

  view_label: "* Inventory Changes Daily*"

  sql_table_name: `flink-data-prod.reporting.inventory_changes_daily`
    ;;


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: change_reason {
    label: "Inventory Change Reason"
    type: string
    sql: ${TABLE}.change_reason ;;
  }

  dimension: change_service {
    label: "Inventory Change Service"
    type: string
    sql: ${TABLE}.change_service ;;
  }

  dimension: change_type {
    label: "Inventory Change Type"
    type: string
    sql: ${TABLE}.change_type ;;
  }

  dimension_group: inventory_change {
    label: "Inventory Change"
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
    sql: ${TABLE}.inventory_change_date ;;
  }

  dimension: quantity_change {
    label: "Inventory Change Quantity"
    type: number
    sql: ${TABLE}.quantity_change ;;
    value_format_name: decimal_0
    hidden: yes
  }

  dimension:is_outbound_waste {
    label: "Is Outbound (Waste)"
    type: yesno
    sql: case when ${change_reason} in ('product-damaged', 'product-expired') then true else false end ;;

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



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: sum_quantity_change {
    label: "# Inventory Change Quantity"
    group_label: "* Inventory Changes Daily *"

    type: sum
    sql: ${quantity_change} ;;
    value_format_name: decimal_0
  }

  measure: sum_outbound_waste {
    label: "# Outbound (Waste)"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_outbound_waste: "Yes"]
    value_format_name: decimal_0
  }

  measure: sum_outbound_waste_eur {
    label: "€ Outbound (Waste)"
    group_label: "* Inventory Changes Daily *"
    type: number
    sql: ((${sum_outbound_waste})  * ${sku_hub_day_level_orders.unit_price_gross_amount});;
    value_format_name: eur
  }

  measure: sum_outbound_orders {
    label: "# Outbound (Orders)"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_reason: "order-created"]
    value_format_name: decimal_0
  }

  measure: sum_outbound_wrong_delivery {
    label: "# Outbound (Wrong Delivery)"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_reason: "wrong-delivery"]
    value_format_name: decimal_0
  }

  measure: sum_inventory_correction {
    label: "# Inventory Correction"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_reason: "inventory-correction"]
    value_format_name: decimal_0
  }

  measure: sum_inbound_inventory {
    label: "# Inbound Inventory"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_type: "inbound"]
    value_format_name: decimal_0
  }

  measure: pct_waste_quote_items {
    label: "% Waste Quote (# Items)"
    group_label: "* Inventory Changes Daily *"

    type: number
    sql: ${sum_outbound_waste} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled} , 0 ) ;;
    value_format_name: percent_1
  }

  measure: pct_waste_quote_gmv {
    label: "% Waste Ratio (GMV)"
    group_label: "* Inventory Changes Daily *"

    type: number
    sql: ${sum_outbound_waste_eur} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross} , 0 ) ;;
    value_format_name: percent_1
  }





}
