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
      year,
      day_of_week_index
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

  dimension: purchase_unit {
    sql: ${TABLE}.purchase_unit ;;
    type: number
    label: "Purchase Unit"
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
                  relate to wine, hard alcohol and tabac."
    group_label: ">> Waste Metrics"
    type: sum
    sql:
    -- if the change reason is inventory-correction, we also remove such corrections >200 here (as we do with the other correction metrics)
    if(
        ${change_reason} =  "inventory-correction",
        if(abs(${quantity_change}) <= 200, ${quantity_change}, 0),
        ${quantity_change}
    ) * ${price_gross};;
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

    html:
    {% if global_filters_and_parameters.show_info._parameter_value == 'yes' %}
    {{ rendered_value }} ({{ sum_inbound_inventory._rendered_value }} inbounded items)
    {% else %}
    {{ rendered_value }}
    {% endif %}
    ;;
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
    sql: case when abs(${quantity_change}) <= 200 then  abs(${quantity_change}) end;; # remove outlier - requested by @Fabian Hardenberg
    filters: [change_reason: "inventory-correction"]
    value_format_name: decimal_0
    hidden: yes
  }




  measure: sum_inbound_inventory {
    label: "# Inbounded Items (Delivery) in Sell. Units"
    description: "The sum of inventory changes based on restockings caused by vendor deliveries in Selling Units (excluding inbounds due to cancelled orders)"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_inbound: "Yes"]
    value_format_name: decimal_0
  }

  measure: sum_inbound_inventory_handling_units {
    label: "# Inbounded Items (Delivery) in Handl. Units"
    description: "The sum of inventory changes based on restockings caused by vendor deliveries in Handling Units (excluding inbounds due to cancelled orders)
                  If this is null is probably because we don't have
                  Purch. Units defined for this SKU so we can't do the conversion from Sell. Units to Handl. Units"
    type: sum
    sql: safe_divide(abs(${quantity_change}),${purchase_unit}) ;;
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
    sql: case when ${inventory_correction_increased} between 0 and 200 then ${inventory_correction_increased} end ;;
    value_format_name: decimal_0
  }

  measure: sum_inventory_correction_reduced {
    label: "# Corrected Items (Generic - Reduced)"
    description: "The sum of inventory changes related to unspecified inventory corrections that reduced the inventory"
    group_label: ">> Waste Metrics"

    type: sum
    sql: case when ${inventory_correction_reduced} between -200 and 0 then abs(${inventory_correction_reduced}) end ;;
    value_format_name: decimal_0
  }

  measure: sum_inventory_correction_increased_gmv {
    label: "€ Corrected Items (Generic - Increased)"
    description: "The sum of inventory changes related to unspecified inventory corrections that increased the inventory multiplied by the price of the item"
    group_label: ">> Waste Metrics"

    type: sum
    sql: case when ${inventory_correction_increased} between 0 and 200 then ${inventory_correction_increased} * ${price_gross} end ;;
    value_format_name: eur
  }

  measure: sum_inventory_correction_reduced_gmv {
    label: "€ Corrected Items (Generic - Reduced)"
    description: "The sum of inventory changes related to unspecified inventory corrections that reduced the inventory multiplied by the price of the item"
    group_label: ">> Waste Metrics"

    type: sum
    sql: case when ${inventory_correction_reduced} between -200 and 0 then abs(${inventory_correction_reduced} * ${price_gross}) end ;;
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
      change_reason,
      sum_inbound_inventory_handling_units
    ]
  }

  ########################################################################################################################
  ########################################################################################################################
  ############################################# Demand Planning ##########################################################
  ########################################################################################################################
  ########################################################################################################################

  dimension_group: current_date_t_1 {
    label: "Current Date - 1"
    type: time
    timeframes: [
      date,
      week,
      month,
      day_of_week_index,
      day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: date_sub(current_date(), interval 1 day) ;;
    hidden: yes
  }

  dimension: until_today {
    type: yesno
    sql: ${inventory_change_day_of_week_index} <= ${current_date_t_1_day_of_week_index} AND
      ${inventory_change_day_of_week_index} >= 0 ;;
    hidden: yes
  }


#Items
#Daily
  measure: sum_outbound_waste_t_1 {
    label: "# Outbounded Items (Waste) t-1"
    description: "The sum of all inventory changes, that ar related to waste t-1"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "yesterday"]
    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_outbound_waste_t_2 {
    label: "# Outbounded Items (Waste) t-2"
    description: "The sum of all inventory changes, that ar related to waste t-2"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "2 days ago"]
    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_outbound_waste_t_3 {
    label: "# Outbounded Items (Waste) t-3"
    description: "The sum of all inventory changes, that ar related to waste t-3"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "3 days ago"]
    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_outbound_waste_t_4 {
    label: "# Outbounded Items (Waste) t-4"
    description: "The sum of all inventory changes, that ar related to waste t-4"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "4 days ago"]
    value_format_name: decimal_0
    hidden: yes
  }

  #Weekly

  measure: sum_outbound_waste_w_1 {
    label: "# Outbounded Items (Waste) w-1"
    description: "The sum of all inventory changes, that ar related to waste w-1"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "1 week ago"]
    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_outbound_waste_w_2 {
    label: "# Outbounded Items (Waste) w-2"
    description: "The sum of all inventory changes, that ar related to waste w-2"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "2 weeks ago"]
    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_outbound_waste_w_3 {
    label: "# Outbounded Items (Waste) w-3"
    description: "The sum of all inventory changes, that ar related to waste w-3"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "3 weeks ago"]
    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_outbound_waste_w_4 {
    label: "# Outbounded Items (Waste) w-4"
    description: "The sum of all inventory changes, that ar related to waste w-4"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "4 week ago"]
    value_format_name: decimal_0
    hidden: yes
  }


  ##In euro
  #Daily

  measure: sum_outbound_waste_eur_t_1 {
    label: "€ Outbounded Items (Waste) t-1"
    description: "The quantity '# Outbound (Waste)' multiplied by the latest product price (gross) t-1"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) * ${price_gross};;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "yesterday"]
    value_format_name: eur
    hidden: yes
  }

  measure: sum_outbound_waste_eur_t_2 {
    label: "€ Outbounded Items (Waste) t-2"
    description: "The quantity '# Outbound (Waste)' multiplied by the latest product price (gross) t-2"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) * ${price_gross};;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "2 days ago"]
    value_format_name: eur
    hidden: yes
  }

  measure: sum_outbound_waste_eur_t_3 {
    label: "€ Outbounded Items (Waste) t-3"
    description: "The quantity '# Outbound (Waste)' multiplied by the latest product price (gross) t-3"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) * ${price_gross};;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "3 days ago"]
    value_format_name: eur
    hidden: yes
  }

  measure: sum_outbound_waste_eur_t_4 {
    label: "€ Outbounded Items (Waste) t-4"
    description: "The quantity '# Outbound (Waste)' multiplied by the latest product price (gross) t-4"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) * ${price_gross};;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "4 days ago"]
    value_format_name: eur
    hidden: yes
  }

#Weekly

  measure: sum_outbound_waste_eur_w_1 {
    label: "€ Outbounded Items (Waste) w-1"
    description: "The quantity '# Outbound (Waste)' multiplied by the latest product price (gross) w-1"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) * ${price_gross};;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "1 week ago"]
    value_format_name: eur
    hidden: yes
  }

  measure: sum_outbound_waste_eur_w_2 {
    label: "€ Outbounded Items (Waste) w-2"
    description: "The quantity '# Outbound (Waste)' multiplied by the latest product price (gross) w-2"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) * ${price_gross};;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "2 weeks ago"]
    value_format_name: eur
    hidden: yes
  }

  measure: sum_outbound_waste_eur_w_3 {
    label: "€ Outbounded Items (Waste) w-3"
    description: "The quantity '# Outbound (Waste)' multiplied by the latest product price (gross) w-3"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) * ${price_gross};;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "3 weeks ago"]
    value_format_name: eur
    hidden: yes
  }

  measure: sum_outbound_waste_eur_w_4 {
    label: "€ Outbounded Items (Waste) w-4"
    description: "The quantity '# Outbound (Waste)' multiplied by the latest product price (gross) w-4"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) * ${price_gross};;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "4 weeks ago"]
    value_format_name: eur
    hidden: yes
  }

##w2d
#Items
  measure: sum_outbound_waste_wtd {
    label: "# Outbounded Items (Waste) WtD"
    description: "The sum of all inventory changes, that ar related to waste - WtD"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "this week", until_today: "yes"]
    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_outbound_waste_wtd_w_1 {
    label: "# Outbounded Items (Waste) WtD w-1"
    description: "The sum of all inventory changes, that ar related to waste - Previous week WtD"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) ;;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "1 week ago", until_today: "yes"]
    value_format_name: decimal_0
    hidden: yes
  }

#Euro

  measure: sum_outbound_waste_eur_wtd {
    label: "€ Outbounded Items (Waste) WtD"
    description: "The quantity '# Outbound (Waste)' multiplied by the latest product price (gross) - WtD"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) * ${price_gross};;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "this week", until_today: "yes"]
    value_format_name: eur
    hidden: yes
  }


  measure: sum_outbound_waste_eur_wtd_w_1 {
    label: "€ Outbounded Items (Waste) WtD w-1"
    description: "The quantity '# Outbound (Waste)' multiplied by the latest product price (gross) - Previous week WtD"
    group_label: "Demand Planning"
    type: sum
    sql: abs(${quantity_change}) * ${price_gross};;
    filters: [is_outbound_waste: "Yes", inventory_change_date: "1 week ago", until_today: "yes"]
    value_format_name: eur
    hidden: yes
  }

  ## Calculations

  ## Waste Quote Items

  ##daily

  measure: pct_waste_quote_items_t_1 {
    label: "% Waste Quote (# Items) t-1"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled items in the same hub-sku-date combination t-1"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_t_1} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled_t_1} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_items_t_2 {
    label: "% Waste Quote (# Items) t-2"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled items in the same hub-sku-date combination t-2"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_t_2} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled_t_2} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_items_t_3 {
    label: "% Waste Quote (# Items) t-3"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled items in the same hub-sku-date combination t-3"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_t_3} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled_t_3} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_items_t_4 {
    label: "% Waste Quote (# Items) t-4"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled items in the same hub-sku-date combination t-4"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_t_4} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled_t_4} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  #weekly

  measure: pct_waste_quote_items_w_1 {
    label: "% Waste Quote (# Items) w-1"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled items in the same hub-sku-date combination w-1"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_w_1} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled_w_1} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_items_w_2 {
    label: "% Waste Quote (# Items) w-2"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled items in the same hub-sku-date combination w-2"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_w_2} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled_w_2} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_items_w_3 {
    label: "% Waste Quote (# Items) w-3"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled items in the same hub-sku-date combination w-3"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_w_3} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled_w_3} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_items_w_4 {
    label: "% Waste Quote (# Items) w-4"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled items in the same hub-sku-date combination w-2=4"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_w_4} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled_w_4} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_items_wow_w_1_vs_w_2 {
    label: "% Waste Quote (# Items) WOW Growth (w-1 vs w-2)"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled
                  items in the same hub-sku-date combination - WoW Growth (w-1 vs w-2)"
    group_label: "Demand Planning"

    type: number
    sql: (${pct_waste_quote_items_w_1} - ${pct_waste_quote_items_w_2}) / nullif( ${pct_waste_quote_items_w_2} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }


    ## Waste Quote Euro

  ##daily

  measure: pct_waste_quote_gmv_t_1 {
    label: "% Waste Ratio (Item-Revenue) t-1"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price)
                  divided by the item revenue of sold products in the same hub-sku-date combination t-1"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_eur_t_1} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross_t_1} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_gmv_t_2 {
    label: "% Waste Ratio (Item-Revenue) t-2"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price)
                  divided by the item revenue of sold products in the same hub-sku-date combination  t-2"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_eur_t_2} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross_t_2} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_gmv_t_3 {
    label: "% Waste Ratio (Item-Revenue) t-3"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price)
                  divided by the item revenue of sold products in the same hub-sku-date combination  t-3"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_eur_t_3} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross_t_3} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_gmv_t_4 {
    label: "% Waste Ratio (Item-Revenue) t-4"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price)
                  divided by the item revenue of sold products in the same hub-sku-date combination  t-4"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_eur_t_4} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross_t_4} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

#Weekly

  measure: pct_waste_quote_gmv_w_1 {
    label: "% Waste Ratio (Item-Revenue) w-1"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price)
                  divided by the item revenue of sold products in the same hub-sku-date combination w-1"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_eur_w_1} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross_w_1} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_gmv_w_2 {
    label: "% Waste Ratio (Item-Revenue) w-2"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price)
                  divided by the item revenue of sold products in the same hub-sku-date combination w-2"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_eur_w_2} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross_w_2} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_gmv_w_3 {
    label: "% Waste Ratio (Item-Revenue) w-3"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price)
                  divided by the item revenue of sold products in the same hub-sku-date combination w-3"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_eur_w_3} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross_w_3} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_gmv_w_4 {
    label: "% Waste Ratio (Item-Revenue) w-4"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price)
                  divided by the item revenue of sold products in the same hub-sku-date combination w-4"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_eur_w_4} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross_w_4} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }


  measure: pct_waste_quote_gmv_wow_w_1_vs_w_2 {
    label: "% Waste Ratio (Item-Revenue) WOW Growth (w-1 vs w-2)"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price)
                  divided by the item revenue of sold products in the same hub-sku-date combination - WOW Growth (w-1 vs w-2)"
    group_label: "Demand Planning"

    type: number
    sql: (${pct_waste_quote_gmv_w_1} - ${pct_waste_quote_gmv_w_2}) / nullif( ${pct_waste_quote_gmv_w_2} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }



  #w2d
  #Items
  measure: pct_waste_quote_items_wtd {
    label: "% Waste Quote (# Items) WtD"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled items in the same hub-sku-date combination - WtD"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_wtd} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled_wtd} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_items_wtd_w_1 {
    label: "% Waste Quote (# Items) WtD w-1"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled
                  items in the same hub-sku-date combination - Previous week WtD"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_wtd_w_1} / nullif( ${sku_hub_day_level_orders.sum_item_quantity_fulfilled_wtd_w_1} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }


  measure: pct_waste_quote_items_wow_wtd {
    label: "% Waste Quote (# Items) WOW Growth - WtD"
    description: "The sum of out bounded inventory as waste divided by the number of fulfilled
                  items in the same hub-sku-date combination - WOW Growth - WtD"
    group_label: "Demand Planning"

    type: number
    sql: (${pct_waste_quote_items_wtd} - ${pct_waste_quote_items_wtd_w_1})/nullif(${pct_waste_quote_items_wtd_w_1}, 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }


  #Euro
  measure: pct_waste_quote_gmv_wtd {
    label: "% Waste Ratio (Item-Revenue) WtD"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price)
                  divided by the item revenue of sold products in the same hub-sku-date combination - WtD"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_eur_wtd} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross_wtd} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_gmv_wtd_t_1 {
    label: "% Waste Ratio (Item-Revenue) WtD w-1"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price)
                  divided by the item revenue of sold products in the same hub-sku-date combination - Previous week WtD"
    group_label: "Demand Planning"

    type: number
    sql: ${sum_outbound_waste_eur_wtd_w_1} / nullif( ${sku_hub_day_level_orders.sum_item_price_fulfilled_gross_wtd_w_1} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_waste_quote_gmv_wow_wtd {
    label: "% Waste Ratio (Item-Revenue) WOW Growth - WtD"
    description: "The value of out bounded products as waste (defined by the number out bounded * item price)
                  divided by the item revenue of sold products in the same hub-sku-date combination - WOW Growth - WtD"
    group_label: "Demand Planning"

    type: number
    sql: (${pct_waste_quote_gmv_wtd}-${pct_waste_quote_gmv_wtd_t_1})/nullif( ${pct_waste_quote_gmv_wtd_t_1} , 0 ) ;;
    value_format_name: percent_1
    hidden: yes
  }

}
