view: inventory_stock_count_daily {
  sql_table_name: `flink-data-prod.reporting.inventory_stock_count_daily`
    ;;


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

  set: filter_dims {
    fields: [show_category ,show_city, show_country, show_hub_code, show_sku, show_sub_category,
      category_dynamic, city_dynamic, country_dynamic, hub_code_dynamic, sku_name_dynamic, sub_category_dynamic
    ]
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
    sql: UPPER(LEFT(${hub_code},2)) ;;
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
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.partition_timestamp ;;
  }

  dimension: primary_key {
    type: string
    primary_key: yes
    hidden: yes
    sql: concat( ${hub_code}, ${sku}, CAST( ${tracking_date} AS STRING ) ) ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures       ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: avg_stock_count {
    label: "ø Stock"
    type: average
    sql: ${TABLE}.avg_stock_count ;;
    value_format_name: decimal_1
  }

  measure: avg_stock_count_per_substitute_group {
    label: "ø Stock Substitue Group"
    type: average
    sql: ${TABLE}.avg_stock_count_per_substitute_group ;;
    value_format_name: decimal_1
  }


  measure: hours_oos {
    label: "Hours Out-Of-Stock"
    type: sum
    sql: ${TABLE}.hours_oos ;;
    value_format_name: decimal_0
  }

  measure: open_hours_total {
    label: "Opening Hours"
    type: sum
    sql: ${TABLE}.open_hours_total ;;
    value_format_name: decimal_0
  }

  measure: sum_count_purchased {
    label: "# Items Reduced"
    description: "The difference of the previous and current hourly stock level per Product and Hub. This number includes orders, book-outs etc."
    type: sum
    sql: ${TABLE}.sum_count_purchased ;;
    value_format_name: decimal_0
    hidden: yes

  }

  measure: sum_count_restocked {
    label: "# Items Re-Stocked"
    type: sum
    sql: ${TABLE}.sum_count_restocked ;;
    value_format_name: decimal_0
  }
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Calculations     ~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: pct_oos {
    label: "% Out Of Stock"
    type: number
    sql: ${hours_oos} / nullif( ${open_hours_total},0) ;;
    value_format_name: percent_0
    # html:
    # {% if value > 0.1 %}
    # <p style="color: #ffffff; background-color: #B03A2E ;font-size: 100%; text-align:center">{{ rendered_value }}</p>
    # {% elsif value > 0.05 %}
    # <p style="color: #AF601A; background-color: #FAD7A0 ; font-size:100%; text-align:center">{{ rendered_value }}</p>
    # {% elsif value > 0 %}
    # <p style="color: #F1C40F; background-color: #FEF9E7 ; font-size:100%; text-align:center">{{ rendered_value }}</p>
    # {% else %}
    # <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
    # {% endif %};;
  }

  measure: turnover_rate {
    label: "Product Turnover Rate"
    description: "Defined as the quantity sold per SKU divided by the Average Inventory over the observed period of time"
    value_format_name: decimal_2
    sql: ${skus_fulfilled_per_hub_and_date.sum_item_quantity} / nullif(${avg_stock_count},0) ;;
    type: number

  }

  set: _measures {
    fields: [avg_stock_count, avg_stock_count_per_substitute_group, hours_oos, open_hours_total, sum_count_purchased, sum_count_restocked, pct_oos]
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
