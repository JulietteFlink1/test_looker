view: inventory_stock_count_hourly {
  sql_table_name: `flink-data-prod.reporting.inventory_stock_count_hourly`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: is_relevant_update{
    description: "If set to Yes, filters for only hours that are either out-of-stock or have a change in the quantity compared to the last hour"
    type: yesno
    sql: case when ${current_quantity} = 0 or ${current_quantity} != ${previous_quantity} THEN TRUE ELSE FALSE END ;;
  }

  dimension: stock_level_update_type {
    type: string
    sql:
        CASE WHEN ${current_quantity} = 0  THEN 'Out Of Stock'
             WHEN ${current_quantity} > ${previous_quantity} THEN 'Re-Stocking'
             WHEN ${current_quantity} < ${previous_quantity} THEN 'Orders & Book-Outs'
             WHEN ${current_quantity} = ${previous_quantity} THEN 'No Stock Level Change'
             ELSE 'undefined'
        END
    ;;
  }

  parameter: select_oos_calculation {
    hidden: no
    label: "Select Out-Of-Stock Calculation Type"
    group_label: "* Parameters & Dynamic Fields *"
    description: "Chose, if you want to calculate the oos-rate for every SKU or treat SKUs in the replenishment group just as one product"
    type: unquoted
    allowed_value: {
      label: "SKU-Level"
      value: "sku"
    }
    allowed_value: {
      label: "SKU-Level (Adjusted for Replenishment Groups)"
      value: "repl_group"
    }

    default_value: "repl_group"
  }

  measure: hours_oos {
    label: "Hours Out-Of-Stock"
    description: "The number of business hours, a specific SKU was not available in a hub (corrected by: having also no sales in spec. time)"
    type: sum
    sql:
        case when {% condition select_oos_calculation %} 'sku' {% endcondition %}        THEN ${TABLE}.is_oos
             when {% condition select_oos_calculation %} 'repl_group' {% endcondition %} THEN ${TABLE}.is_oos_repl_group_adjusted
        else null end
        ;;
    value_format_name: decimal_0
  }

  measure: open_hours_total {
    label: "Opening Hours"
    description: "The number of hours, a hub was open (hours were customers could buy)"
    type: sum
    sql:
       case when {% condition select_oos_calculation %} 'sku' {% endcondition %}        THEN ${TABLE}.is_hub_open
            when {% condition select_oos_calculation %} 'repl_group' {% endcondition %} THEN ${TABLE}.is_hub_open_repl_group_adjusted
       else null end
      ;;
    value_format_name: decimal_0
  }


  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  # dimension: hub_opening_hours_day { ==> outdated, not provided anymore
  #   type: number
  #   sql: ${TABLE}.hub_opening_hours_day ;;
  # }

  dimension: is_hup_opening_timestamp {
    label: "Is Hub-Opening Time"
    type: yesno
    sql: CASE WHEN ${TABLE}.is_hub_open = 1 THEN TRUE
              WHEN ${TABLE}.is_hub_open = 0 THEN FALSE
         END
    ;;
  }

  dimension: is_oos {
    label: "Is Out-Of-Stock"
    type: yesno
    sql: CASE WHEN ${TABLE}.is_oos = 1 THEN TRUE
              WHEN ${TABLE}.is_oos = 0 THEN FALSE
         END
    ;;
  }

  dimension: is_leading_product {
    description: "If a product is part of a substitute_group, this boolean (if set to Yes) indicates if the product is shown, when more products of the group are available"
    type: string
    sql: ${TABLE}.is_leading_product ;;
  }

  dimension: is_noos_product {
    label: "Is Never-Out-Of-Stock product"
    description: "This boolean indicates (if set to Yes), that a product is very imoprtant to Flink and should never be out of stock"
    type: string
    sql: ${TABLE}.is_noos_product ;;
  }

  dimension_group: inventory_tracking_timestamp {
    label: "Stock Level"
    type: time
    datatype: timestamp
    timeframes: [
      raw,
      time,
      minute,
      hour,
      hour_of_day,
      day_of_week,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.inventory_tracking_timestamp ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }


  # =========  hidden   =========

  dimension: current_quantity {
    label: "# Current Quantity"
    description: "The currently available number of items of a product in a specific hub"
    hidden: yes
    type: number
    sql: ${TABLE}.current_quantity ;;
  }

  dimension: previous_quantity {
    label: "# Quantity On Stock - Previous Hour"
    description: "The available number of items of a product in a specific hub in the previous hour"
    type: number
    hidden: yes
    sql: ${TABLE}.previous_quantity ;;
  }


  # =========  IDs   =========

  dimension: stock_inventory_uuid {
    type: string
    sql: ${TABLE}.stock_inventory_uuid ;;
    hidden: yes
    primary_key: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




  measure: avg_previous_quantity {
    label: "AVG Quantity On Stock - Previous Hour"
    description: "Sum of Available items in stock"
    type: average
    sql: ${TABLE}.previous_quantity ;;
    value_format_name: decimal_1
  }


  measure: sum_previous_quantity {
    label: "# Quantity On Stock - Previous Hour"
    description: "Sum of Available items in stock"
    type: sum
    sql: ${TABLE}.previous_quantity ;;
    value_format_name: decimal_1
  }


  measure: sum_current_quantity {
    label: "# Quantity On Stock"
    description: "The sum of available items in stock"
    hidden:  no
    type: sum
    sql: ${TABLE}.current_quantity;;
    value_format_name: decimal_1
  }

  measure: avg_current_quantity {
    label: "AVG Quantity On Stock"
    description: "The average number of available items in stock for a given SKU in a specific hub"
    hidden:  no
    type: average
    sql: ${TABLE}.current_quantity;;
    value_format_name: decimal_1
  }

  measure: num_distinct_sku {
    label: "# SKUs"
    description: "The number of unique SKUs in stock"
    type: count_distinct
    sql:  CASE WHEN ${TABLE}.current_quantity > 0 THEN ${sku} END ;;
    value_format_name: decimal_1
  }


  measure: avg_quantity_restocked {
    label: "AVG Quantity Re-Stocked"
    description: "The average number of items, that have been re-stocked for a given SKU in a specific hub"
    hidden:  no
    type: average
    sql: ${TABLE}.current_quantity;;
    filters: [stock_level_update_type: "Re-Stocking"]
    value_format_name: decimal_1
  }

  measure: avg_quantity_sold_booked_out {
    label: "AVG Quantity Sold or Booked Out"
    description: "Sum of Available items in stock"
    hidden:  no
    type: average
    sql: ${TABLE}.current_quantity;;
    filters: [stock_level_update_type: "Orders & Book-Outs"]
    value_format_name: decimal_1
  }

  measure: pct_oos {
    label: "% Out Of Stock"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders"
    type: number
    sql: ${hours_oos} / nullif( ${open_hours_total},0) ;;
    value_format_name: percent_0
    # palette: https://coolors.co/0c0f0a-ff206e-fbff12
    html:
    {% if value >= 0.9 %}
      <p style="color: white; background-color: #FF206E;font-size: 100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value >= 0.8 %}
      <p style="color: white; background-color: #FF5C95; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value >= 0.6 %}
      <p style="color: white; background-color: #FF99BD; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value >= 0.4 %}
      <p style="color: black; background-color: #FFD6E4; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value >= 0.2 %}
      <p style="color: black; background-color: #FEFFC2; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value > 0 %}
      <p style="color: black; background-color: #FFFFEB; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% else %}
      <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %};;
  }

  measure: pct_in_stock {
    label: "% In Stock"
    description: "This rate gives the sum of all hours, an SKU was in stock compared to all hours, the hub was open for orders"
    type: number
    sql: 1 - ${pct_oos} ;;
    value_format_name: percent_0
    # palette: https://coolors.co/0c0f0a-ff206e-fbff12
    html:
    {% if value <= 0.1 %}
    <p style="color: white; background-color: #FF206E;font-size: 100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value <= 0.2 %}
    <p style="color: white; background-color: #FF5C95; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value <= 0.4 %}
    <p style="color: white; background-color: #FF99BD; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value <= 0.6 %}
      <p style="color: black; background-color: #FFD6E4; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value <= 0.8 %}
      <p style="color: black; background-color: #FEFFC2; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value <= 1 %}
      <p style="color: black; background-color: #FFFFEB; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% else %}
      <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %};;
  }




  parameter: select_metric_param {
    group_label: "* Parameters & Dynamic Fields *"
    label: "Select Metric Shown"
    type: unquoted
    allowed_value: { value: "avg_quantity" label: "AVG Quantity On Stock"}
    allowed_value: { value: "re_stocked" label: "AVG Quantity Re-Stocked" }
    allowed_value: { value: "ordered_booked_out" label: "AVG Quantity Sold or Booked Out"}
    default_value: "avg_quantity"
  }

  measure: select_metric_measure {
    group_label: "* Parameters & Dynamic Fields *"
    label: "Measure (Dynamic)"
    label_from_parameter: select_metric_param
    type: number

    sql:
    {% if select_metric_param._parameter_value == 'avg_quantity' %}
      ${avg_current_quantity}
    {% elsif select_metric_param._parameter_value == 're_stocked' %}
      ${avg_quantity_restocked}
    {% elsif select_metric_param._parameter_value == 'ordered_booked_out' %}
      ${avg_quantity_sold_booked_out}
    {% endif %};;
  }
}
