view: inventory_changes {

  view_label: "* Inventory Changes *"

  sql_table_name: `flink-data-prod.curated.inventory_changes`
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

  dimension_group: inventory_change_timestamp {
    label: "Inventory Change"
    description: "The time, when a inventory change was recorded"
    type: time
    timeframes: [
      time,
      hour,
      hour2,
      hour4,
      hour_of_day,
      date
    ]
    sql: ${TABLE}.inventory_change_timestamp ;;
  }

  dimension: quantity_change {
    label: "# Inventory Change"
    type: number
    sql: ${TABLE}.quantity_change ;;
    value_format_name: decimal_0
  }

  dimension: quantity_from {
    label: "# Inventory Changed From"
    type: number
    sql: ${TABLE}.quantity_from ;;
    value_format_name: decimal_0
  }

  dimension: quantity_to {
    label: "# Inventory Changed To"
    type: number
    sql: ${TABLE}.quantity_to ;;
    value_format_name: decimal_0
  }



  # =========  hidden   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

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

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
    hidden: yes
  }

  dimension: order_uuid {
    type: string
    sql: ${TABLE}.order_uuid ;;
    hidden: yes
  }
  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    hidden: yes
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
    hidden: yes
  }

  dimension: message {
    type: string
    sql: ${TABLE}.message ;;
    hidden: yes
  }

  dimension:is_outbound_waste {
    label: "Is Outbound (Waste)"
    description: "Boolean - indicates, if a inventory change is based on waste - determined by the reasons 'product-damaged', 'product-expired' or 'too-good-to-go'"
    type: yesno
    sql: ${TABLE}.is_outbound_waste ;;

  }

  dimension: is_inbound {
    type: yesno
    # sql: case when ${change_type} in ('inbound', 'inbound-bulk') then true else false end ;;
    sql: ${TABLE}.is_inbound ;;
    hidden: no
  }

  dimension: price_gross {
    type: number
    sql: ${products.amt_product_price_gross} ;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: avg_quantity_change {
    label: "AVG Inventory Change"
    description: "Shows on average, how much the inventory changed"

    sql: ${quantity_change} ;;
    type: average
    value_format_name: decimal_1
  }

  measure: sum_quantity_change {
    label: "SUM Inventory Change"
    description: "Shows the sum of how much the inventory changed"

    sql: ${quantity_change} ;;
    type: sum
    value_format_name: decimal_1
  }

  measure: sum_outbound_waste_eur {
    label: "€ Outbound (Waste)"
    description: "The quantity '# Outbound (Waste)' multiplied by the latest product price (gross)"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: abs(${quantity_change}) * ${price_gross};;
    filters: [is_outbound_waste: "Yes"]
    value_format_name: eur
  }

}
