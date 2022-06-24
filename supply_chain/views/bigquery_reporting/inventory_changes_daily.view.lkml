view: inventory_changes_daily {

  view_label: "* Inventory Changes Daily *"

  sql_table_name: `flink-data-prod.reporting.inventory_changes_daily`
    ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: dynamic_inventory_change_date {

    label:       "Dynamic Inventory Change Date"
    group_label: ">> Dates & Timestamps"

    label_from_parameter: global_filters_and_parameters.timeframe_picker
    sql:
    {% if    global_filters_and_parameters.timeframe_picker._parameter_value == 'Date' %}
        ${inventory_change_date}

      {% elsif global_filters_and_parameters.timeframe_picker._parameter_value == 'Week' %}
      ${inventory_change_week}

      {% elsif global_filters_and_parameters.timeframe_picker._parameter_value == 'Month' %}
      ${inventory_change_month}

      {% else %}
      ${inventory_change_month}

      {% endif %};;
  }


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
    hidden: no
  }

  dimension: quantity_change_inbounded {
    type: number
    sql: case when ${is_inbound} then ${quantity_change} else 0 end ;;
    hidden: yes
  }

  dimension:is_outbound_waste {
    label: "Is Outbound (Waste)"
    description: "Boolean - indicates, if a inventory chqnge is based on waste - determined by the reasons 'product-damaged' ('delivery damaged'), 'product-expired' ('delivery-expired') or 'too-good-to-go'"
    type: yesno
    # sql: case when ${change_reason} in ('product-damaged', 'product-expired', 'too-good-to-go') then true else false end ;;
    sql: ${TABLE}.is_outbound_waste ;;

  }

  dimension: is_inbound {
    type: yesno
    # sql: case when ${change_type} in ('inbound', 'inbound-bulk') then true else false end ;;
    sql: ${TABLE}.is_inbound ;;
    hidden: no
  }

  dimension: is_drug_waste {
    label:       "Is Drug Waste"
    description: "This flag is true for all direct or indirect waste reasons including inventory corrections (incl. e.g. product-damaged etc,) and too-good-to-go for parent categories that
                  relate to wine, hard alcohol and tabac"
    type: yesno
    sql:

    case
      when

      (    lower(${products.category}) like 'spirit%'
        or lower(${products.category}) like 'tabak%'
        or lower(${products.category}) like 'rauchen%'
        or lower(${products.category}) like '%champagnes'
        or lower(${products.category}) like 'wein%'
        or lower(${products.category}) like 'wijn%'
        )

      and (${change_type} = 'correction' or ${change_reason} = 'too-good-to-go' )
      then true
      else false end ;;
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

  dimension: parent_sku {
    type: string
    sql: ${TABLE}.parent_sku ;;
  }

  dimension: price_gross {
    label: "Product Price Gross (Used for Waste)"
    type: number
    sql: ${products.amt_product_price_gross} ;;
    hidden: no
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

    type: sum
    sql: ${quantity_change} ;;
    value_format_name: decimal_0
  }

  measure: sum_outbound_waste {
    label: "# Outbounded Items (Waste)"
    description: "The sum of all inventory changes, that ar related to waste"
    group_label: ">> Waste Metrics"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_outbound_waste: "Yes"]
    value_format_name: decimal_0
  }

  measure: sum_outbound_waste_eur {
    label: "€ Outbounded Items (Waste)"
    description: "The quantity '# Outbound (Waste)' multiplied by the latest product price (gross)"
    group_label: ">> Waste Metrics"
    type: sum
    sql: abs(${quantity_change}) * ${price_gross};;
    filters: [is_outbound_waste: "Yes"]
    value_format_name: eur
  }

  measure: sum_drug_waste_eur {
    label:       "€ Drug Waste"
    description: "This metric reflects the number of drug waste valued with the most recent product price as defined as: \n
                  all direct or indirect waste reasons including inventory corrections (incl. e.g. product-damaged etc,) and too-good-to-go for parent categories that
                  relate to wine, hard alcohol and tabac"
    group_label: ">> Waste Metrics"
    type: sum
    sql: ${quantity_change} * ${price_gross};;
    filters: [is_drug_waste: "Yes"]
    value_format_name: eur
  }

  # ------- Sums of granular inventory movement metrics

  measure: sum_outbound_orders {
    label: "# Outbounded Items (Orders)"
    description: "The number of inventory changes, that are based on customer orders"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_reason: "order-created"]
    value_format_name: decimal_0
  }

  measure: sum_outbound_too_good_to_go {
    label: "# Outbounded Items (Too-Good-To-Go)"
    description: "The number of outbounded items, that are due to donations to the app too-good-to-go."
    group_label: ">> Waste Metrics"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_reason: "too-good-to-go"]
    value_format_name: decimal_0
  }

  measure: sum_correction_product_expired {
    label: "# Corrected Items (Product Expired)"
    description: "The number of corrected items, that are due to expiration (too close to best-before-date) while storing them in our hubs."
    group_label: ">> Waste Metrics"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_reason: "product-expired"]
    value_format_name: decimal_0
  }

  measure: sum_correction_product_delivery_expired {
    label: "# Corrected Items (Product Delivery Expired)"
    description: "The number of corrected items, that are due to expiration (too close to best-before-date) when being delivered to our hubs."
    group_label: ">> Waste Metrics"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_reason: "product-delivery-expired"]
    value_format_name: decimal_0
  }

  measure: sum_correction_product_delivery_damaged {
    label: "# Corrected Items (Product Delivery Damaged)"
    description: "The number of corrected items, that are due to being damaged (too close to best-before-date) when being delivered to our hubs."
    group_label: ">> Waste Metrics"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_reason: "product-delivery-damaged"]
    value_format_name: decimal_0
  }

  measure: pct_product_delivery_damaged_to_inbounds {
    label:       "% Delivery Damage Rate"
    description: "The percentage of items delivered by a supplier, that needed to be booked-out (corrected) due to items being damaged when being delivered to a hub"
    group_label: ">> Waste Metrics"

    type: number
    sql: safe_divide(${sum_correction_product_delivery_damaged},${sum_inbound_inventory}) ;;
    value_format_name: percent_2
  }

  measure: sum_correction_product_damaged {
    label: "# Corrected Items (Product Damaged)"
    description: "The number of corrected items, that are due to being damaged (too close to best-before-date) while storing them in our hubs."
    group_label: ">> Waste Metrics"

    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_reason: "product-damaged"]
    value_format_name: decimal_0
  }

  measure: sum_correction_order_cancelled {
    label: "# Corrected Items (Order Cancelled)"
    description: "The number of corrected items, that are due to being part of customers orders, that have been cancelled."
    group_label: ">> Waste Metrics"

    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_reason: "order-aborted, order-cancelled"]
    value_format_name: decimal_0
  }




  # TODO: deprecate
  measure: sum_outbound_wrong_delivery {
    label: "# Outbounded Items (Wrong Delivery)"
    description: "The number of inventory changes, that are based on wrong deliveries"
    group_label: "* Inventory Changes Daily *"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [change_reason: "wrong-delivery"]
    value_format_name: decimal_0
    hidden: yes
  }

  # TODO: deprecate
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
    label: "# Inbounded Items (Delivery)"
    description: "The sum of inventory changes based on restockings caused by vendor deliveries (excluding inbounds due to cancelled orders)"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_inbound: "Yes"]
    value_format_name: decimal_0
  }

  measure: pct_waste_quote_items {
    label: "% Waste Quote (# Items)"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled items in the same hub-sku-date combination"
    group_label: ">> Waste Metrics"

    type: number
    sql: ${sum_outbound_waste} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled} , 0 ) ;;
    value_format_name: percent_1
  }

  measure: pct_waste_quote_gmv {
    label: "% Waste Ratio (Item-Revenue)"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price) divided by the item revenue of sold products in the same hub-sku-date combination"
    group_label: ">> Waste Metrics"

    type: number
    sql: ${sum_outbound_waste_eur} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross} , 0 ) ;;
    value_format_name: percent_1
  }





  # -- CORRECTIONS ------------------------------------------------------------------------------------------------------------------

  measure: sum_inventory_correction_increased {
    label: "# Corrected Items (Generic - Increased)"
    description: "The sum of inventory changes related to unspecified inventory corrections that increased the inventory"
    group_label: ">> Waste Metrics"

    type: sum
    sql: case when ${inventory_correction_increased} between 0 and 100 then ${inventory_correction_increased} end ;;
    value_format_name: decimal_0
  }

  measure: sum_inventory_correction_reduced {
    label: "# Corrected Items (Generic - Reduced)"
    description: "The sum of inventory changes related to unspecified inventory corrections that reduced the inventory"
    group_label: ">> Waste Metrics"

    type: sum
    sql: case when ${inventory_correction_reduced} between -100 and 0 then abs(${inventory_correction_reduced}) end ;;
    value_format_name: decimal_0
  }

  measure: sum_inventory_correction_increased_gmv {
    label: "€ Corrected Items (Generic - Increased)"
    description: "The sum of inventory changes related to unspecified inventory corrections that increased the inventory multiplied by the price of the item"
    group_label: ">> Waste Metrics"

    type: sum
    sql: case when ${inventory_correction_increased} between 0 and 100 then ${inventory_correction_increased} * ${price_gross} end ;;
    value_format_name: eur
  }

  measure: sum_inventory_correction_reduced_gmv {
    label: "€ Corrected Items (Generic - Reduced)"
    description: "The sum of inventory changes related to unspecified inventory corrections that reduced the inventory multiplied by the price of the item"
    group_label: ">> Waste Metrics"

    type: sum
    sql: case when ${inventory_correction_reduced} between -100 and 0 then abs(${inventory_correction_reduced} * ${price_gross}) end ;;
    value_format_name: eur
  }

  measure: pct_reduced_correction_quote_items {
    label: "% Negative Correction Quote (# Items)"
    description: "The sum of corrected (reduced) inventory divided by the number of fulfilled items in the same hub-sku-date combination"
    group_label: ">> Waste Metrics"

    type: number
    sql: ${sum_inventory_correction_reduced} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled} , 0 ) ;;
    value_format_name: percent_1
  }

  measure: pct_reduced_correction_quote_gmv {
    label: "% Negative Correction Ratio (Item Revenue)"
    description: "The value of corrected (reduced) inventory (defined by the number * item price) divided by the GMV of sold products in the same hub-sku-date combination"
    group_label: ">> Waste Metrics"

    type: number
    sql: ${sum_inventory_correction_reduced_gmv} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross} , 0 ) ;;
    value_format_name: percent_1
  }

  measure: pct_increased_correction_quote_items {
    label: "% Positive Correction Quote (# Items)"
    description: "The sum of corrected (increased) inventory divided by the number of fulfilled items in the same hub-sku-date combination"
    group_label: ">> Waste Metrics"

    type: number
    sql: ${sum_inventory_correction_increased} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled} , 0 ) ;;
    value_format_name: percent_1
  }

  measure: pct_increased_correction_quote_gmv {
    label: "% Positive Correction Ratio (Item Revenue)"
    description: "The value of corrected (increased) inventory (defined by the number * item price) divided by the item revenue of sold products in the same hub-sku-date combination"
    group_label: ">> Waste Metrics"

    type: number
    sql: ${sum_inventory_correction_increased_gmv} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross} , 0 ) ;;
    value_format_name: percent_1
  }

  set: fields_for_utr_calculation {
    fields: [
      sum_quantity_change,
      sum_outbound_orders,
      sum_inbound_inventory,
      sum_outbound_waste,
      sum_outbound_orders,
      sum_outbound_wrong_delivery,
      sum_outbound_too_good_to_go,
      is_inbound,
      is_outbound_waste,
      change_reason
    ]
  }

}
