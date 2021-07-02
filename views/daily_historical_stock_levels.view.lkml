view: daily_historical_stock_levels {
  sql_table_name: `flink-data-dev.sandbox.daily_historical_stock_levels`
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
    sql: if({% parameter show_sku %}, concat(${sku}, ' - ', ${product_product.name}), null) ;;
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
    sql: if({% parameter show_category %}, ${parent_category.name}, null) ;;
  }

  parameter: show_sub_category {
    group_label: "* Parameters & Dynamic Fields *"
    type: yesno
    default_value: "yes"
  }
  dimension: sub_category_dynamic {
    group_label: "* Parameters & Dynamic Fields *"
    type: string
    sql: if({% parameter show_sub_category %}, ${product_category.name}, null) ;;
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

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
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
    sql: ${TABLE}.tracking_date ;;
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
    label: "# Items Sold"
    type: sum
    sql: ${TABLE}.sum_count_purchased ;;
    value_format_name: decimal_0
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
