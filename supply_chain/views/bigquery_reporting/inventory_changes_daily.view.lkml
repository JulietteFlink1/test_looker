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
    description: "The reason of the inventory change"
    type: string
    sql: ${TABLE}.change_reason ;;
  }

  dimension: change_service {
    label: "Inventory Change Service"
    description: "The entity/service, that caused the inventory change"
    type: string
    sql: ${TABLE}.change_service ;;
  }

  dimension: change_type {
    label: "Inventory Change Type"
    description: "The overall category of the inventory change - inbount, outbound, correction"
    type: string
    sql: ${TABLE}.change_type ;;
  }

  dimension_group: inventory_change {
    label: "Inventory Change"
    description: "The date, when the inventory change was recorded"
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
    description: "Boolean - indicates, if a inventory chqnge is based on waste - determined by the reasons 'product-damaged'm 'product-expired' or 'too-good-to-go'"
    type: yesno
    sql: case when ${change_reason} in ('product-damaged', 'product-expired', 'too-good-to-go') then true else false end ;;

  }

  dimension: is_inbound {
    type: yesno
    sql: case when ${change_type} in ('inbound', 'inbound-bulk') then true else false end ;;
    hidden: yes
  }


  # =========  hidden   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: no
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: no
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    hidden: no
  }

  dimension: price_gross {
    type: number
    sql: ${products.amt_product_price_gross} ;;
    hidden: yes
  }

  dimension: inventory_correction_increased {
    sql: ${TABLE}.inventory_correction_increased ;;
    type: number
    hidden: yes
  }

  dimension: inventory_correction_reduced {
    sql: ${TABLE}.inventory_correction_reduced ;;
    type: number
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
    description: "The sum of all inventory changes"
    group_label: "* Inventory Changes Daily *"

    type: sum
    sql: ${quantity_change} ;;
    value_format_name: decimal_0
  }

  measure: sum_outbound_waste {
    label: "# Outbound (Waste)"
    description: "The sum of all inventory changes, that ar related to waste"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_outbound_waste: "Yes"]
    value_format_name: decimal_0
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

  measure: sum_outbound_orders {
    label: "# Outbound (Orders)"
    description: "The number of inventory changes, that are based on customer orders"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_reason: "order-created"]
    value_format_name: decimal_0
  }

  measure: sum_outbound_wrong_delivery {
    label: "# Outbound (Wrong Delivery)"
    description: "The number of inventory changes, that are based on wrong deliveries"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_reason: "wrong-delivery"]
    value_format_name: decimal_0
  }

  measure: sum_inventory_correction {
    label: "# Inventory Correction"
    description: "The sum of inventory changes related to inventory corrections"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: case when abs(${quantity_change}) <= 100 then  abs(${quantity_change}) end;; # remove outlier - requested by @Fabian Hardenberg
    filters: [change_reason: "inventory-correction"]
    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_inbound_inventory {
    label: "# Inbound Inventory"
    description: "The sum of inventory changes based on restockings"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_inbound: "Yes"]
    value_format_name: decimal_0
  }

  measure: pct_waste_quote_items {
    label: "% Waste Quote (# Items)"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled items in the same hub-sku-date combination"
    group_label: "* Inventory Changes Daily *"

    type: number
    sql: ${sum_outbound_waste} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled} , 0 ) ;;
    value_format_name: percent_1
  }

  measure: pct_waste_quote_gmv {
    label: "% Waste Ratio (Item-Revenue)"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price) divided by the item revenue of sold products in the same hub-sku-date combination"
    group_label: "* Inventory Changes Daily *"

    type: number
    sql: ${sum_outbound_waste_eur} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross} , 0 ) ;;
    value_format_name: percent_1
  }





  # -- CORRECTIONS ------------------------------------------------------------------------------------------------------------------

  measure: sum_inventory_correction_increased {
    label: "# Inventory Correction (Increased)"
    description: "The sum of inventory changes related to inventory corrections that increased the inventory"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: case when ${inventory_correction_increased} between 0 and 100 then ${inventory_correction_increased} end ;;
    value_format_name: decimal_0
  }

  measure: sum_inventory_correction_reduced {
    label: "# Inventory Correction (Reduced)"
    description: "The sum of inventory changes related to inventory corrections that reduced the inventory"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: case when ${inventory_correction_reduced} between -100 and 0 then abs(${inventory_correction_reduced}) end ;;
    value_format_name: decimal_0
  }

  measure: sum_inventory_correction_increased_gmv {
    label: "€ Inventory Correction (Increased)"
    description: "The sum of inventory changes related to inventory corrections that increased the inventory multiplied by the price of the item"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: case when ${inventory_correction_increased} between 0 and 100 then ${inventory_correction_increased} * ${price_gross} end ;;
    value_format_name: eur
  }

  measure: sum_inventory_correction_reduced_gmv {
    label: "€ Inventory Correction (Reduced)"
    description: "The sum of inventory changes related to inventory corrections that reduced the inventory multiplied by the price of the item"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: case when ${inventory_correction_reduced} between -100 and 0 then abs(${inventory_correction_reduced} * ${price_gross}) end ;;
    value_format_name: eur
  }

  measure: pct_reduced_correction_quote_items {
    label: "% Negative Correction Quote (# Items)"
    description: "The sum of corrected (reduced) inventory divided by the number of fulfilled items in the same hub-sku-date combination"
    group_label: "* Inventory Changes Daily *"

    type: number
    sql: ${sum_inventory_correction_reduced} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled} , 0 ) ;;
    value_format_name: percent_1
  }

  measure: pct_reduced_correction_quote_gmv {
    label: "% Negative Correction Ratio (Item Revenue)"
    description: "The value of corrected (reduced) inventory (defined by the number * item price) divided by the GMV of sold products in the same hub-sku-date combination"
    group_label: "* Inventory Changes Daily *"

    type: number
    sql: ${sum_inventory_correction_reduced_gmv} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross} , 0 ) ;;
    value_format_name: percent_1
  }

  measure: pct_increased_correction_quote_items {
    label: "% Positive Correction Quote (# Items)"
    description: "The sum of corrected (increased) inventory divided by the number of fulfilled items in the same hub-sku-date combination"
    group_label: "* Inventory Changes Daily *"

    type: number
    sql: ${sum_inventory_correction_increased} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled} , 0 ) ;;
    value_format_name: percent_1
  }

  measure: pct_increased_correction_quote_gmv {
    label: "% Positive Correction Ratio (Item Revenue)"
    description: "The value of corrected (increased) inventory (defined by the number * item price) divided by the item revenue of sold products in the same hub-sku-date combination"
    group_label: "* Inventory Changes Daily *"

    type: number
    sql: ${sum_inventory_correction_increased_gmv} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross} , 0 ) ;;
    value_format_name: percent_1
  }





}
