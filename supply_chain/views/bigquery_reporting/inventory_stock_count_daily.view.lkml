view: inventory_stock_count_daily {
  sql_table_name: `flink-data-prod.reporting.inventory_stock_count_daily`;;
  view_label: "* Daily Inventory Stock Level *"



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameter     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter: date_granularity {
    group_label: "* Parameters & Dynamic Fields *"
    label: "Select Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }
  dimension: date {
    group_label: "* Parameters & Dynamic Fields *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${tracking_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${tracking_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${tracking_month}
    {% endif %};;
  }


  parameter: show_sku {
    group_label: "* Parameters & Dynamic Fields *"
    type: yesno
    default_value: "yes"
  }
  dimension: sku_name_dynamic {
    group_label: "* Parameters & Dynamic Fields *"
    type: string
    sql: if({% parameter show_sku %}, concat(${sku}, ' - ', ${products.product_name}), null) ;;
  }


  parameter: show_country {
    group_label: "* Parameters & Dynamic Fields *"
    type: yesno
    default_value: "yes"
  }
  dimension: country_dynamic {
    group_label: "* Parameters & Dynamic Fields *"
    type: string
    sql: if({% parameter show_country %}, ${hubs.country_iso}, null) ;;
  }


  parameter: show_city {
    group_label: "* Parameters & Dynamic Fields *"
    type: yesno
    default_value: "yes"
  }
  dimension: city_dynamic {
    group_label: "* Parameters & Dynamic Fields *"
    type: string
    sql: if({% parameter show_city %}, ${hubs.city}, null) ;;
  }

  parameter: show_category {
    group_label: "* Parameters & Dynamic Fields *"
    type: yesno
    default_value: "yes"
  }
  dimension: category_dynamic {
    group_label: "* Parameters & Dynamic Fields *"
    type: string
    sql: if({% parameter show_category %}, ${products.category}, null) ;;
  }

  parameter: show_sub_category {
    group_label: "* Parameters & Dynamic Fields *"
    type: yesno
    default_value: "yes"
  }
  dimension: sub_category_dynamic {
    group_label: "* Parameters & Dynamic Fields *"
    type: string
    sql: if({% parameter show_sub_category %}, ${products.subcategory}, null) ;;
  }

  parameter: show_hub_code {
    group_label: "* Parameters & Dynamic Fields *"
    type: yesno
    default_value: "yes"
  }
  dimension: hub_code_dynamic {
    group_label: "* Parameters & Dynamic Fields *"
    type: string
    sql: if({% parameter show_hub_code %}, ${hub_code}, null) ;;
  }


  dimension: show_dynamic_dims_dense {
    label: "Dimensions Dynamic (merged)"
    group_label: "* Parameters & Dynamic Fields *"
    type: string
    sql: concat(
            ifnull(${country_dynamic}      , '' ) , "  " ,
            ifnull(${city_dynamic}         , '' ) , "  " ,
            ifnull(${hub_code_dynamic}     , '' ) , "  " ,
            ifnull(${category_dynamic}     , '' ) , "  " ,
            ifnull(${sub_category_dynamic} , '' ) , "  " ,
            ifnull(${sku_name_dynamic}     , '' )
            )
    ;;
  }


  set: filter_dims {
    fields: [
      show_country,
      show_city,
      show_hub_code,
      show_category,
      show_sub_category,
      show_sku,

      country_dynamic,
      city_dynamic,
      hub_code_dynamic,
      category_dynamic,
      sub_category_dynamic,
      sku_name_dynamic,
    ]
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

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension_group: tracking {
    type: time
    timeframes: [
      raw,
      date,
      week,
      week_of_year,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.inventory_tracking_date ;;
  }

  dimension: primary_key {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.daily_stock_uuid ;;
  }

  dimension: stock_count {
    sql: ${TABLE}.avg_stock_count ;;
    type: number
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures       ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: avg_stock_count {
    label: "AVG Quantity"
    description: "The average stock count of a SKU"
    type: average
    sql: ${TABLE}.avg_stock_count ;;
    value_format_name: decimal_1
  }

  measure: hours_oos {
    label: "Hours Out-Of-Stock"
    description: "The number of business hours, a specific SKU was not available in a hub (corrected by: having also no sales in spec. time)"
    type: sum
    sql:
        case when {% condition select_oos_calculation %} 'sku' {% endcondition %}        THEN ${TABLE}.hours_oos
             when {% condition select_oos_calculation %} 'repl_group' {% endcondition %} THEN ${TABLE}.hours_oos_repl_group_adjusted
        else null end
        ;;
    value_format_name: decimal_0
  }

  measure: open_hours_total {
    label: "Opening Hours"
    description: "The number of hours, a hub was open (hours were customers could buy)"
    type: sum
    sql:
       case when {% condition select_oos_calculation %} 'sku' {% endcondition %}        THEN ${TABLE}.open_hours_total
            when {% condition select_oos_calculation %} 'repl_group' {% endcondition %} THEN ${TABLE}.open_hours_total_repl_group_adjusted
       else null end
      ;;
    value_format_name: decimal_0
  }

  measure: sum_count_purchased {
    label: "# Items Reduced"
    description: "The difference of the previous and current hourly stock level per Product and Hub. This number includes orders, book-outs etc."
    type: sum
    sql: ${TABLE}.sum_count_stock_decreased ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_items_sold { # TODO tweak inventory query to filter is_successful and is_internal
    label: "# Items Sold"
    description: "The number of items sold"
    type: sum
    sql: ${TABLE}.sum_items_ordered ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_count_restocked {
    label: "# Items Re-Stocked"
    description: "The number of items, that have been re-stocked for a given SKU and hub"
    type: sum
    sql: ${TABLE}.sum_count_restocked ;;
    value_format_name: decimal_0
  }
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Calculations     ~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: pct_oos {
    label: "% Out Of Stock"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders"
    type: number
    sql: ${hours_oos} / nullif( ${open_hours_total},0) ;;
    value_format_name: percent_1
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
    value_format_name: percent_1
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

  measure: turnover_rate {
    label: "Product Turnover Rate"
    description: "Defined as the quantity sold per SKU divided by the Average Inventory over the observed period of time"
    value_format_name: decimal_2
    sql: ${skus_fulfilled_per_hub_and_date.item_quantity} / nullif(${stock_count},0) ;;
    type: average

  }

  set: _measures {
    fields: [avg_stock_count, hours_oos, open_hours_total, sum_count_purchased, sum_count_restocked, pct_oos]
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Hidden     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
