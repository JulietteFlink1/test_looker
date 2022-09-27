view: user_attributes_lifecycle_first28days {
  sql_table_name: `flink-data-prod.reporting.user_attributes_lifecycle_first28days`
    ;;

  dimension: customer_uuid {
    primary_key: yes
    type: string
    sql: ${TABLE}.customer_uuid ;;
  }

  # -------- measures --------- #
  measure: cnt_customers {
    label: "# Customers"
    type: count_distinct
    sql: ${customer_uuid} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: total_gmv_min {
    type: min
    sql: ${avg_gmv_gross}*${number_of_days_ordering} ;;
    value_format_name: eur
  }
  measure: total_gmv_percentile_25 {
    type: percentile
    percentile: 25
    sql: ${avg_gmv_gross}*${number_of_days_ordering} ;;
    value_format_name: eur
  }
  measure: total_gmv_percentile_50 {
    type: median
    sql: ${avg_gmv_gross}*${number_of_days_ordering} ;;
    value_format_name: eur
  }
  measure: total_gmv_percentile_75 {
    type: percentile
    percentile: 75
    sql: ${avg_gmv_gross}*${number_of_days_ordering} ;;
    value_format_name: eur
  }
  measure: total_gmv_percentile_95 {
    type: percentile
    percentile: 95
    sql: ${avg_gmv_gross}*${number_of_days_ordering} ;;
    value_format_name: eur
  }
  measure: total_gmv_max {
    type: max
    sql: ${avg_gmv_gross}*${number_of_days_ordering} ;;
    value_format_name: eur
  }

  measure: avg_number_of_days_ordering {
    type: average
    sql: ${number_of_days_ordering};;
  }

  measure: avg_number_of_days_visiting {
    type: average
    sql: ${number_of_days_visited};;
  }

  measure: number_of_days_visiting_min {
    type: min
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_25 {
    type: percentile
    percentile: 25
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_50 {
    type: median
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_75 {
    type: percentile
    percentile: 75
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_95 {
    type: percentile
    percentile: 95
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_max {
    type: max
    sql: ${number_of_days_visited} ;;
  }

  measure: avg_gmv_min {
    type: min
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_25 {
    type: percentile
    percentile: 25
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_50 {
    type: median
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_75 {
    type: percentile
    percentile: 75
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_95 {
    type: percentile
    percentile: 95
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_max {
    type: max
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }

  measure: number_of_days_ordering_min {
    type: min
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_25 {
    type: percentile
    percentile: 25
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_50 {
    type: median
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_75 {
    type: percentile
    percentile: 75
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_95 {
    type: percentile
    percentile: 95
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_max {
    type: max
    sql: ${number_of_days_ordering} ;;
  }

  #========= Dimension Selector =========#

  parameter: comparison_selector {
    label: "Comparison Selector"
    description: "Controls which dimension X-axis uses"
    type: unquoted
    allowed_value: {
      label: "Platform"
      value: "platform"
    }
    allowed_value: {
      label: "Country"
      value: "country"
    }
    allowed_value: {
      label: "Cohort"
      value: "cohort"
    }
    default_value: "cohort"
  }

  dimension: plotby {
    hidden: yes
    label: "Comparison Field (Dynamic)"
    label_from_parameter: comparison_selector
    description: "Date OR Full App Version Dynamic Dimension - select using Date or Version Dynamic Selector"
    type: string
    sql:
    {% if comparison_selector._parameter_value == 'platform' %}
      ${first_order_platform}
    {% elsif comparison_selector._parameter_value == 'country' %}
      ${first_country_iso}
    {% elsif comparison_selector._parameter_value == 'cohort' %}
      ${first_visit_granularity}
    {% else %}
      ${first_visit_granularity}
    {% endif %};;
  }


#========= User Attributes =========#

  dimension: first_country_iso {
    group_label: "* User Attributes *"
    type: string
    sql: ${TABLE}.first_country_iso ;;
  }

  dimension_group: first_order {
    group_label: "* User Attributes *"
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
    sql: ${TABLE}.first_order_date ;;
  }

  dimension: first_order_platform {
    group_label: "* User Attributes *"
    type: string
    sql: ${TABLE}.first_order_platform ;;
  }

  dimension_group: first_visit {
    group_label: "* User Attributes *"
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
    sql: ${TABLE}.first_visit_date ;;
  }

  dimension: first_visit_granularity {
    group_label: "* User Attributes *"
    label: "First Visit Cohort (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    hidden:  no
    sql:
      {% if timeframe_picker._parameter_value == 'Week' %}
        ${first_visit_week}
      {% elsif timeframe_picker._parameter_value == 'Month' %}
        ${first_visit_month}
      {% elsif timeframe_picker._parameter_value == 'Year' %}
        ${first_visit_year}
      {% endif %};;
  }

  parameter: timeframe_picker {
    label: "First Visit Date Granularity"
    type: unquoted
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    allowed_value: { value: "Year" }
    default_value: "Year"
  }

  dimension: first_visit_platform {
    group_label: "* User Attributes *"
    type: string
    sql: ${TABLE}.first_visit_platform ;;
  }

  dimension: is_xdevice_conversion {
    group_label: "* User Attributes *"
    type: yesno
    sql: ${TABLE}.is_xdevice_conversion ;;
  }

  dimension: number_of_days_to_first_order {
    group_label: "* User Attributes *"
    type: number
    sql: ${TABLE}.number_of_days_to_first_order ;;
  }

  dimension: number_of_visits_to_first_order {
    group_label: "* User Attributes *"
    type: number
    sql: ${TABLE}.number_of_visits_to_first_order ;;
  }

  #----------------------------


  #========= Visit Dimensions =========#

  dimension: avg_days_between_visits {
    group_label: "* Visit Dimensions *"
    type: number
    sql: ${TABLE}.avg_days_between_visits ;;
  }

  dimension_group: last_visit {
    group_label: "* Visit Dimensions *"
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
    sql: ${TABLE}.last_visit_date ;;
  }

  dimension: number_of_days_visited {
    group_label: "* Visit Dimensions *"
    type: number
    sql: ${TABLE}.number_of_days_visited ;;
  }

  #========= Order Dimensions =========#

  dimension: amt_discount_gross {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.amt_discount_gross ;;
  }

  dimension: amt_discount_net {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.amt_discount_net ;;
  }

  dimension: amt_gmv_gross {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: amt_gmv_net {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.amt_gmv_net ;;
  }

  dimension: amt_revenue_gross {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: amt_revenue_net {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.amt_revenue_net ;;
  }

  dimension: avg_days_between_orders {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.avg_days_between_orders ;;
  }

  dimension: avg_discount_gross {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.avg_discount_gross ;;
  }

  dimension: avg_discount_net {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.avg_discount_net ;;
  }

  dimension: avg_gmv_gross {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.avg_gmv_gross ;;
  }

  dimension: avg_gmv_net {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.avg_gmv_net ;;
  }

  dimension: avg_revenue_gross {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.avg_revenue_gross ;;
  }

  dimension: avg_revenue_net {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.avg_revenue_net ;;
  }

  dimension_group: last_order {
    group_label: "* Order Dimensions *"
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
    sql: ${TABLE}.last_order_date ;;
  }

  dimension: number_of_days_ordering {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.number_of_days_ordering ;;
  }

  dimension: number_of_discounted_orders {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.number_of_discounted_orders ;;
  }

  dimension: number_of_orders {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }
}
