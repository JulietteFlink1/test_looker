view: user_attributes_lifecycle_last28days {
  sql_table_name: `flink-data-prod.reporting.user_attributes_lifecycle_last28days`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Sets    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  set: user_attributes {
    fields: [
      first_country_iso,
      first_order_date,
      first_order_week,
      first_order_month,
      first_order_quarter,
      first_order_year,
      first_order_platform,
      first_visit_date,
      first_visit_granularity,
      first_visit_month,
      first_visit_week,
      first_visit_quarter,
      first_visit_year,
      first_visit_platform,
      is_xdevice_conversion,
      number_of_days_to_first_order,
      number_of_visits_to_first_order
    ]
  }

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${customer_uuid}, ${execution_date}) ;;
  }

  dimension: customer_uuid {
    type: string
    sql: ${TABLE}.customer_uuid ;;
  }

  #=========== Measures ===========#

  measure: cnt_customers {
    label: "# Customers"
    type: count_distinct
    sql: ${customer_uuid} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: total_gmv_gross {
    type: sum
    sql: ${amt_gmv_gross} ;;
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

  measure: days_since_last_order_min {
    type: min
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_percentile_25 {
    type: percentile
    percentile: 25
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_percentile_50 {
    type: median
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_percentile_75 {
    type: percentile
    percentile: 75
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_percentile_95 {
    type: percentile
    percentile: 95
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_max {
    type: max
    sql: ${days_since_last_order} ;;
  }

  measure: days_since_last_visit_min {
    type: min
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_percentile_25 {
    type: percentile
    percentile: 25
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_percentile_50 {
    type: median
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_percentile_75 {
    type: percentile
    percentile: 75
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_percentile_95 {
    type: percentile
    percentile: 95
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_max {
    type: max
    sql: ${days_since_last_order} ;;
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

  #========= RFM categories =========#
  dimension: aov_category {
    case: {
      when: {
        sql: ${avg_gmv_gross} <17 ;;
        label: "Less than 17EUR AVG GMV"
      }
      when: {
        sql: ${avg_gmv_gross} <23 ;;
        label: "17-23EUR AVG GMV"
      }
      when: {
        sql: ${avg_gmv_gross} <31 ;;
        label: "23- 31EUR AVG GMV"
      }
      when: {
        sql: ${avg_gmv_gross} >=31 ;;
        label: "More than 31 EUR AVG GMV"
      }
      else: "unknown"
    }
  }

  dimension: days_ordering_category {
    case: {
      when: {
        sql: ${number_of_days_ordering} <1 ;;
        label: "No days ordering"
      }
      when: {
        sql: ${number_of_days_ordering} <2 ;;
        label: "1 day ordering"
      }
      when: {
        sql: ${number_of_days_ordering} <3 ;;
        label: "2 days ordering"
      }
      when: {
        sql: ${number_of_days_ordering} >=3 ;;
        label: "3 or more days ordering"
      }
      else: "unknown"
    }
  }

  dimension: aov_split {
    case: {
      when: {
        sql: ${avg_gmv_gross} <17 ;;
        label: "Low"
      }
      when: {
        sql: ${avg_gmv_gross} >=31 ;;
        label: "High"
      }
      else: "Middle"
    }
  }


  dimension: days_since_last_order_category {
    case: {
      when: {
        sql: ${days_since_last_order} < 4 ;;
        label: "Ordered less than 4 days ago"
      }
      when: {
        sql: ${days_since_last_order} < 9 ;;
        label: "Ordered 4-9 days ago"
      }
      when: {
        sql: ${days_since_last_order} < 18 ;;
        label: "Ordered 9-18 days ago "
      }
      when: {
        sql: ${days_since_last_order} >= 18 ;;
        label: "Ordered 18 or more days ago"
      }
      else: "unknown"
    }
  }

  dimension: rf_categories {
    case: {
      when: {
        sql: (${days_since_last_order} < 4) and (${number_of_days_ordering} >=3);;
        label: "Recent, frequent customers"
      }
      when: {
        sql: (${days_since_last_order} < 4) and (${number_of_days_ordering} = 1);;
        label: "Recent, infrequent customers"
      }
      when: {
        sql: (${days_since_last_order} >= 18) and (${number_of_days_ordering} >=3);;
        label: "Not recent, frequent customers"
      }
      when: {
        sql: (${days_since_last_order} >= 18) and (${number_of_days_ordering} = 1);;
        label: "Not recent, infrequent customers"
      }
      else: "other"
    }
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

  #========= Monetary =========#

  dimension: avg_gmv_gross_tier_2 {
    group_label: "* Monetary Values *"
    label: "Average GMV (tiered, 2 EUR)"
    type: tier
    tiers: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70]
    style: relational
    sql: ${avg_gmv_gross} ;;
  }

  dimension: amt_gmv_gross {
    group_label: "* Monetary Values *"
    label: "GMV Gross"
    type: number
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: amt_gmv_net {
    group_label: "* Monetary Values *"
    label: "GMV Net"
    type: number
    sql: ${TABLE}.amt_gmv_net ;;
  }

  dimension: amt_revenue_gross {
    group_label: "* Monetary Values *"
    label: "Revenue Gross"
    type: number
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: amt_revenue_net {
    group_label: "* Monetary Values *"
    label: "Revenue Net"
    type: number
    sql: ${TABLE}.amt_revenue_net ;;
  }

  dimension: avg_gmv_gross {
    group_label: "* Monetary Values *"
    label: "Average GMV Gross"
    type: number
    sql: ${TABLE}.avg_gmv_gross ;;
  }

  dimension: avg_gmv_net {
    group_label: "* Monetary Values *"
    label: "Average GMV Net"
    type: number
    sql: ${TABLE}.avg_gmv_net ;;
  }

  dimension: avg_revenue_gross {
    group_label: "* Monetary Values *"
    label: "Average Revenue Gross"
    type: number
    sql: ${TABLE}.avg_revenue_gross ;;
  }

  dimension: avg_revenue_net {
    group_label: "* Monetary Values *"
    label: "Average Revenue Net"
    type: number
    sql: ${TABLE}.avg_revenue_net ;;
  }


  dimension_group: execution {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week_index,
      day_of_week,
      day_of_month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.execution_date ;;
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


  #========= Recency Values =========#

  dimension: days_since_last_visit {
    group_label: "* Recency Values *"
    type: number
    sql: date_diff(${execution_date}, ${last_visit_date}, day) ;;
  }

  dimension: days_since_last_order {
    group_label: "* Recency Values *"
    type: number
    sql: date_diff(${execution_date}, ${last_order_date}, day) ;;
  }

  dimension_group: last_order {
    group_label: "* Recency Values *"
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

  dimension_group: last_visit {
    group_label: "* Recency Values *"
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


  #========= Frequency Values =========#

  dimension: avg_days_between_orders {
    group_label: "* Frequency Values*"
    type: number
    sql: ${TABLE}.avg_days_between_orders ;;
  }

  dimension: avg_days_between_visits {
    group_label: "* Frequency Values*"
    type: number
    sql: ${TABLE}.avg_days_between_visits ;;
  }

  dimension: number_of_days_ordering {
    group_label: "* Frequency Values*"
    type: number
    sql: ${TABLE}.number_of_days_ordering ;;
  }

  dimension: number_of_days_visited {
    group_label: "* Frequency Values*"
    type: number
    sql: ${TABLE}.number_of_days_visited ;;
  }

  dimension: number_of_orders {
    group_label: "* Frequency Values*"
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: order_to_visit_ratio_tier {
    group_label: "* Frequency Values*"
    label: "Order To Visit Ratio (tiered, 0.05)"
    type: tier
    tiers: [0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1]
    style: relational
    sql: ${order_to_visit_ratio} ;;
  }

  dimension: order_to_visit_ratio_tier3 {
    group_label: "* Frequency Values*"
    label: "Order To Visit Ratio (tiered, 3)"
    type: tier
    tiers: [0, 0.33, 0.66, 1]
    style: relational
    sql: ${order_to_visit_ratio} ;;
  }

  dimension: order_to_visit_ratio {
    group_label: "* Frequency Values*"
    type: number
    sql: 1.0* ${number_of_days_ordering}/${number_of_days_visited} ;;
    value_format_name: decimal_2
  }


  #========= Hidden =========#

  dimension_group: oldest_order {
    hidden: yes
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
    sql: ${TABLE}.oldest_order_date ;;
  }

  dimension_group: oldest_visit {
    hidden: yes
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
    sql: ${TABLE}.oldest_visit_date ;;
  }
}
