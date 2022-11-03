view: user_attributes_lifecycle_first28days {
  derived_table: {
    persist_for: "24 hours"
    sql:
      -- changing 0 to null because percentile_cont ignores nulls but not zeros. This gives the wrong values for amt_gmv_gross (if no order, =0) while correct for avg_gmv_gross (if no order, =null)
      with clean_tb as (
        select
          * except(amt_gmv_gross)
          , NULLIF(amt_gmv_gross,0) as amt_gmv_gross
        from `flink-data-prod.reporting.user_attributes_lifecycle_first28days`
        where {% condition first_visit_date %} first_visit_date {% endcondition %}
      )

      -- using derived table necessary to provide quartiles as dimensions
      select
      *
      , PERCENTILE_CONT(avg_gmv_gross, 0.25) OVER() AS aov_25
      , PERCENTILE_CONT(avg_gmv_gross, 0.5) OVER() AS aov_50
      , PERCENTILE_CONT(avg_gmv_gross, 0.75) OVER() AS aov_75

      , PERCENTILE_CONT(amt_gmv_gross, 0.25) OVER() AS gmv_25
      , PERCENTILE_CONT(amt_gmv_gross, 0.5) OVER() AS gmv_50
      , PERCENTILE_CONT(amt_gmv_gross, 0.75) OVER() AS gmv_75

      , PERCENTILE_CONT(number_of_days_ordering, 0.25) OVER() AS days_ordering_25
      , PERCENTILE_CONT(number_of_days_ordering, 0.5) OVER() AS days_ordering_50
      , PERCENTILE_CONT(number_of_days_ordering, 0.75) OVER() AS days_ordering_75

      , PERCENTILE_CONT(number_of_days_visited, 0.25) OVER() AS days_visiting_25
      , PERCENTILE_CONT(number_of_days_visited, 0.5) OVER() AS days_visiting_50
      , PERCENTILE_CONT(number_of_days_visited, 0.75) OVER() AS days_visiting_75

      from clean_tb
      ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Sets    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  set: user_attributes {
    fields: [
      first_country_iso,
      first_order_date,
      first_order_week,
      first_order_month,
      first_order_year,
      first_order_platform,
      first_visit_date,
      first_visit_granularity,
      first_visit_month,
      first_visit_week,
      first_visit_year,
      first_visit_platform,
      is_xdevice_conversion,
      number_of_days_to_first_order
    ]
  }

  dimension: customer_uuid {
    primary_key: yes
    type: string
    sql: ${TABLE}.customer_uuid ;;
  }

  #=============================================================================================#
  #==================================== Dimension Selection ====================================#
  #=============================================================================================#

  parameter: comparison_selector {
    label: "Comparison Selector"
    description: "Controls which dimension X-axis uses: cohort, country or platform"
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

  #=========================================================================================#
  #==================================== User Attributes ====================================#
  #=========================================================================================#

  dimension: first_country_iso {
    group_label: "* User Attributes *"
    description: "First country customer ordered to"
    type: string
    sql: ${TABLE}.first_country_iso ;;
  }

  dimension_group: first_order {
    group_label: "* User Attributes *"
    description: "First order datetime"
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
    description: "First platform customer ordered from us on"
    type: string
    sql: ${TABLE}.first_order_platform ;;
  }

  dimension_group: first_visit {
    group_label: "* User Attributes *"
    description: "First visit datetime"
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
    description: "Use to set granuality of first visit date field to week, month or year"
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
    description: "Use to set granularity of first visit date field to week, month or year"
    type: unquoted
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    allowed_value: { value: "Year" }
    default_value: "Year"
  }

  dimension: first_visit_platform {
    group_label: "* User Attributes *"
    description: "First platform customer visited on"
    type: string
    sql: ${TABLE}.first_visit_platform ;;
  }

  dimension: is_xdevice_conversion {
    group_label: "* User Attributes *"
    description: "Whether customer used a different device on first visit vs. first order"
    type: yesno
    sql: ${TABLE}.is_xdevice_conversion ;;
  }

  dimension: number_of_days_to_first_order {
    group_label: "* User Attributes *"
    label: "# Days To First Order"
    description: "How many days there were between the customer's first visit and their first order"
    type: number
    sql: ${TABLE}.number_of_days_to_first_order ;;
  }

  #=================================================================================================#
  #==================================== RFM Category Dimensions ====================================#
  #=================================================================================================#

  dimension: aov_25 {
    group_label: " * AOV Percentiles *"
    label: "AOV 25th Percentile"
    group_item_label: "25th Percentile"
    hidden: yes
    type: number
    sql: ${TABLE}.aov_25 ;;
  }

  dimension: aov_50 {
    group_label: " * AOV Percentiles *"
    label: "AOV Median"
    group_item_label: "Median"
    hidden: yes
    type: number
    sql: ${TABLE}.aov_50 ;;
  }

  dimension: aov_75 {
    group_label: " * AOV Percentiles *"
    label: "AOV 75th Percentile"
    group_item_label: "75th Percentile"
    hidden: yes
    type: number
    sql: ${TABLE}.aov_75 ;;
  }

  dimension: aov_category {
    group_label: "* RFM Quartile Categories *"
    label: "AOV (Gross) Per Customer Category"
    description: "Dimension that splits customers into quartiles according to their AOV (Gross) value"
    case: {
      when: {
        sql: ${avg_gmv_gross} < ${aov_25};;
        label: "AOV (Gross) 0-25th percentile"
      }
      when: {
        sql: ${avg_gmv_gross} < ${aov_50} ;;
        label: "AOV (Gross) 25-50th percentile"
      }
      when: {
        sql: ${avg_gmv_gross} < ${aov_75} ;;
        label: "AOV (Gross) 50-75th percentile"
      }
      when: {
        sql: ${avg_gmv_gross} >=${aov_75} ;;
        label: "AOV (Gross) 75-100th percentile"
      }
      else: "No order within first 28 days"
    }
  }

  dimension: gmv_25 {
    group_label: " * Total GMV Percentiles *"
    label: "GMV 25th Percentile"
    group_item_label: "25th Percentile"
    hidden: yes
    type: number
    sql: ${TABLE}.gmv_25 ;;
  }

  dimension: gmv_50 {
    group_label: " * Total GMV Percentiles *"
    label: "GMV Median"
    group_item_label: "Median"
    hidden: yes
    type: number
    sql: ${TABLE}.gmv_50 ;;
  }

  dimension: gmv_75 {
    group_label: " * Total GMV Percentiles *"
    label: "GMV 75th Percentile"
    group_item_label: "75th Percentile"
    hidden: yes
    type: number
    sql: ${TABLE}.gmv_75 ;;
  }

  dimension: gmv_category {
    group_label: "* RFM Quartile Categories *"
    label: "Sum GMV (Gross) Per Customer Category"
    description: "Dimension that splits customers into quartiles according to their total orders value"
    case: {
      when: {
        sql: ${amt_gmv_gross} < ${gmv_25};;
        label: "Sum GMV 0-25th percentile"
      }
      when: {
        sql: ${amt_gmv_gross} < ${gmv_50} ;;
        label: "Sum GMV 25-50th percentile"
      }
      when: {
        sql: ${amt_gmv_gross} < ${gmv_75} ;;
        label: "Sum GMV 50-75th percentile"
      }
      when: {
        sql: ${amt_gmv_gross} >=${gmv_75} ;;
        label: "Sum GMV 75-100th percentile"
      }
      else: "No order within first 28 days"
    }
  }

  dimension: days_ordering_25 {
    group_label: " * # Days Ordering Percentiles *"
    label: "# Days Ordering 25th"
    hidden: yes
    type: number
    sql: ${TABLE}.days_ordering_25 ;;
  }

  dimension: days_ordering_50 {
    group_label: " * # Days Ordering Percentiles *"
    label: "# Days Ordering Median"
    hidden: yes
    type: number
    sql: ${TABLE}.days_ordering_50 ;;
  }

  dimension: days_ordering_75 {
    group_label: " * # Days Ordering Percentiles *"
    label: "# Days Ordering 75th"
    hidden: yes
    type: number
    sql: ${TABLE}.days_ordering_75 ;;
  }

  dimension: days_ordering_category {
    group_label: "* RFM Quartile Categories *"
    label: "# Days Ordering Category"
    description: "Dimension that splits customers into quartiles according to on how many days they've ordered in the first 28 days"
    case: {
      when: {
        sql: ${number_of_days_ordering} < ${days_ordering_25} ;;
        label: "# Days Ordering 25th Percentile"
      }
      when: {
        sql: ${number_of_days_ordering} < ${days_ordering_50} ;;
        label: "# Days Ordering 25-50th Percentile"
      }
      when: {
        sql: ${number_of_days_ordering} < ${days_ordering_75} ;;
        label: "# Days Ordering 50-75th Percentile"
      }
      when: {
        sql: ${number_of_days_ordering} >= ${days_ordering_75} ;;
        label: "# Days Ordering 75-100th Percentile"
      }
      else: "No order within first 28 days"
    }
  }

  dimension: days_visiting_25 {
    group_label: " * # Days Visiting Percentiles *"
    label: "# Days Visiting 25th"
    hidden: yes
    type: number
    sql: ${TABLE}.days_visiting_25 ;;
  }

  dimension: days_visiting_50 {
    group_label: " * # Days Visiting Percentiles *"
    label: "# Days Visiting Median"
    hidden: yes
    type: number
    sql: ${TABLE}.days_visiting_50 ;;
  }

  dimension: days_visiting_75 {
    group_label: " * # Days Visiting Percentiles *"
    label: "# Days Visiting 75th"
    hidden: yes
    type: number
    sql: ${TABLE}.days_visiting_75 ;;
  }

  dimension: days_visiting_category {
    group_label: "* RFM Quartile Categories *"
    label: "# Days Visiting Category"
    description: "Dimension that splits customers into quartiles according to on how many days they've visited in the first 28 days"
    case: {
      when: {
        sql: ${number_of_days_visited} < ${days_visiting_25} ;;
        label: "# Days Visiting 25th Percentile"
      }
      when: {
        sql: ${number_of_days_visited} < ${days_visiting_50} ;;
        label: "# Days Visiting 25-50th Percentile"
      }
      when: {
        sql: ${number_of_days_visited} < ${days_visiting_75} ;;
        label: "# Days Visiting 50-75th Percentile"
      }
      when: {
        sql: ${number_of_days_visited} >= ${days_visiting_75} ;;
        label: "# Days Visiting 75-100th Percentile"
      }
      else: "Unavailable"
    }
  }

  #=========================================================================================#
  #==================================== Monetary Values ====================================#
  #=========================================================================================#

  dimension: avg_gmv_gross_tier_2 {
    group_label: "* Monetary Values *"
    label: "AOV Per Customer (tiered, 2 EUR)"
    type: tier
    tiers: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70]
    style: relational
    sql: ${avg_gmv_gross} ;;
  }

  dimension: amt_gmv_gross {
    group_label: "* Monetary Values *"
    label: "GMV (Gross) Per Customer"
    description: "Sum GMV (Gross) per customer"
    type: number
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: amt_gmv_net {
    group_label: "* Monetary Values *"
    label: "GMV (Net) Per Customer"
    description: "GMV (Net) per customer"
    type: number
    sql: ${TABLE}.amt_gmv_net ;;
  }

  dimension: amt_revenue_gross {
    group_label: "* Monetary Values *"
    label: "Revenue (Gross) Per Customer"
    description: "Revebye (Gross) per customer"
    type: number
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: avg_gmv_gross {
    group_label: "* Monetary Values *"
    label: "AOV (Gross) Per Customer"
    description: "AOV (Gross) per customer"
    type: number
    sql: ${TABLE}.avg_gmv_gross ;;
  }

  dimension: avg_gmv_net {
    group_label: "* Monetary Values *"
    label: "AOV (Net) Per Customer"
    description: "AOV (Net) per customer"
    type: number
    sql: ${TABLE}.avg_gmv_net ;;
  }

  dimension: avg_revenue_gross {
    group_label: "* Monetary Values *"
    label: "Average Revenue (Gross) Per Customer"
    description: "Average Revenue (Gross) per customer"
    type: number
    sql: ${TABLE}.avg_revenue_gross ;;
  }

  #==========================================================================================#
  #==================================== Frequency Values ====================================#
  #==========================================================================================#

  dimension: avg_days_between_orders {
    group_label: "* Frequency Values*"
    label: "AVG Days Between Orders"
    description: "Average number of days between orders"
    type: number
    sql: ${TABLE}.avg_days_between_orders ;;
  }

  dimension: avg_days_between_visits {
    group_label: "* Frequency Values*"
    label: "AVG Days Between Visits"
    description: "Average number of days between visits"
    type: number
    sql: ${TABLE}.avg_days_between_visits ;;
  }

  dimension: number_of_days_ordering {
    group_label: "* Frequency Values*"
    label: "# Days Ordering"
    description: "Number of days the customer has ordered with us"
    type: number
    sql: ${TABLE}.number_of_days_ordering ;;
  }

  dimension: number_of_days_visited {
    group_label: "* Frequency Values*"
    label: "# Days Visited"
    description: "Number of days the customer has visited us"
    type: number
    sql: ${TABLE}.number_of_days_visited ;;
  }

  dimension: number_of_orders {
    group_label: "* Frequency Values*"
    label: "# Orders"
    description: "Number of orders"
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: order_to_visit_ratio_tier {
    hidden: yes
    group_label: "* Frequency Values*"
    label: "Order To Visit Ratio (tiered, 0.05)"
    type: tier
    tiers: [0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1]
    style: relational
    sql: ${order_to_visit_ratio} ;;
  }

  dimension: order_to_visit_ratio_tier3 {
    group_label: "* Frequency Values*"
    label: "Order To Visit Ratio (tiered, 0.33)"
    description: "Tiers for ratio of how many orders occur per visit"
    type: tier
    tiers: [0, 0.33, 0.66, 1]
    style: relational
    sql: ${order_to_visit_ratio} ;;
  }

  dimension: order_to_visit_ratio {
    group_label: "* Frequency Values*"
    description: "Ratio of how many orders occur per visit"
    type: number
    sql: 1.0* ${number_of_days_ordering}/${number_of_days_visited} ;;
    value_format_name: decimal_2
  }

  #========================================================================================#
  #==================================== Recency Values ====================================#
  #========================================================================================#

  dimension_group: last_visit {
    group_label: "* Recency Dates *"
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

  dimension_group: last_order {
    group_label: "* Recency Dates *"
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

  #=============================================================================================#
  #==================================== Discount Dimensions ====================================#
  #=============================================================================================#

  dimension: amt_discount_gross {
    group_label: "* Discount Dimensions *"
    type: number
    sql: ${TABLE}.amt_discount_gross ;;
  }

  dimension: amt_discount_net {
    group_label: "* Discount Dimensions *"
    type: number
    sql: ${TABLE}.amt_discount_net ;;
  }

  dimension: avg_discount_gross {
    group_label: "* Discount Dimensions *"
    type: number
    sql: ${TABLE}.avg_discount_gross ;;
  }

  dimension: avg_discount_net {
    group_label: "* Discount Dimensions *"
    type: number
    sql: ${TABLE}.avg_discount_net ;;
  }

  dimension: number_of_discounted_orders {
    group_label: "* Discount Dimensions *"
    type: number
    sql: ${TABLE}.number_of_discounted_orders ;;
  }


  #==================================================================================#
  #==================================== Measures ====================================#
  #==================================================================================#

  measure: cnt_customers {
    label: "# Customers"
    type: count_distinct
    sql: ${customer_uuid} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: avg_total_gmv_gross {
    group_label: "* Sum GMV Per Customer *"
    group_item_label: "AVG"
    label: "Total GMV AVG"
    description: "Average of the total GMV over customers"
    type: average
    sql: ${amt_gmv_gross} ;;
  }

  measure: total_gmv_gross {
    group_label: "* Sum GMV Per Customer *"
    group_item_label: "Sum"
    label: "Total GMV Sum"
    description: "Sum of the total GMV over customers"
    type: sum
    sql: ${amt_gmv_gross} ;;
  }

  measure: total_gmv_min {
    group_label: "* Sum GMV Per Customer *"
    group_item_label: "Minimum"
    label: "Total GMV Min"
    description: "Min of the total GMV over customers"
    type: min
    sql: ${amt_gmv_gross} ;;
    value_format_name: eur
  }

  measure: total_gmv_percentile_25 {
    group_label: "* Sum GMV Per Customer *"
    group_item_label: "25th Percentile"
    label: "Total GMV 25th Perc."
    description: "25th percentile of the total GMV over customers"
    type: percentile
    percentile: 25
    sql: ${amt_gmv_gross} ;;
    value_format_name: eur
  }

  measure: total_gmv_percentile_50 {
    group_label: "* Sum GMV Per Customer *"
    group_item_label: "50th Percentile"
    label: "Total GMV 50th Perc."
    description: "50th percentile of the total GMV over customers"
    type: median
    sql: ${amt_gmv_gross} ;;
    value_format_name: eur
  }

  measure: total_gmv_percentile_75 {
    group_label: "* Sum GMV Per Customer *"
    group_item_label: "75th Percentile"
    label: "Total GMV 75th Perc."
    description: "75th percentile of the total GMV over customers"
    type: percentile
    percentile: 75
    sql: ${amt_gmv_gross} ;;
    value_format_name: eur
  }

  # measure: total_gmv_percentile_25 {
  #   group_label: "* Sum GMV Per Customer *"
  #   group_item_label: "25th Percentile"
  #   label: "Total GMV 25th Perc."
  #   type: percentile
  #   percentile: 25
  #   sql: ${avg_gmv_gross}*${number_of_days_ordering} ;;
  #   value_format_name: eur
  # }

  measure: total_gmv_percentile_95 {
    group_label: "* Sum GMV Per Customer *"
    group_item_label: "95th Percentile"
    label: "Total GMV 95th Perc."
    description: "95th percentile of the total GMV over customers"
    type: percentile
    percentile: 95
    sql: ${amt_gmv_gross} ;;
    value_format_name: eur
  }
  measure: total_gmv_max {
    group_label: "* Sum GMV Per Customer *"
    group_item_label: "Maximum"
    label: "Total GMV Max"
    description: "Max of the total GMV over customers"
    type: max
    sql: ${amt_gmv_gross} ;;
    # filters: [amt_gmv_gross: ">0"]
    value_format_name: eur
  }

  measure: avg_number_of_days_visiting {
    group_label: "* # Days Visiting *"
    group_item_label: "AVG"
    label: "# Days Visiting AVG"
    description: "Average number of days visited"
    type: average
    sql: ${number_of_days_visited};;
    value_format_name: decimal_1
  }

  measure: number_of_days_visiting_min {
    group_label: "* # Days Visiting *"
    group_item_label: "Minimum"
    label: "# Days Visiting Min"
    description: "Minimum number of days visited"
    type: min
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_25 {
    group_label: "* # Days Visiting *"
    group_item_label: "25th Percentile"
    label: "# Days Visiting 25th Perc."
    description: "25th percentile of number of days visited"
    type: percentile
    percentile: 25
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_50 {
    group_label: "* # Days Visiting *"
    group_item_label: "50th Percentile"
    label: "# Days Visiting 50th Perc."
    description: "50th percentile of number of days visited"
    type: median
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_75 {
    group_label: "* # Days Visiting *"
    group_item_label: "75th Percentile"
    label: "# Days Visiting 75th Perc."
    description: "75th percentile of number of days visited"
    type: percentile
    percentile: 75
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_95 {
    group_label: "* # Days Visiting *"
    group_item_label: "95th Percentile"
    label: "# Days Visiting 95th Perc."
    description: "95th percentile of number of days visited"
    type: percentile
    percentile: 95
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_max {
    group_label: "* # Days Visiting *"
    group_item_label: "Maximum"
    label: "# Days Visiting Max"
    description: "Maximum number of days visited"
    type: max
    sql: ${number_of_days_visited} ;;
  }

  measure: avg_gmv_avg {
    group_label: "* AOV Per Customer *"
    group_item_label: "AVG"
    label: "AOV (Gross) - AVG"
    description: "The average AOV across customers"
    type: average
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }

  measure: avg_gmv_min {
    group_label: "* AOV Per Customer *"
    label: "AOV (Gross) - Min"
    group_item_label: "Minimum"
    description: "The minimum AOV Per Customer across customers"
    type: min
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_25 {
    group_label: "* AOV Per Customer *"
    label: "AOV (Gross) - 25th Percentile"
    group_item_label: "25th Percentile"
    description: "The 25th percentile AOV Per Customer across customers"
    type: percentile
    percentile: 25
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_50 {
    group_label: "* AOV Per Customer *"
    label: "AOV (Gross) - 50th Percentile"
    group_item_label: "50th Percentile"
    description: "The 50th percentile AOV Per Customer across customers"
    type: median
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_75 {
    group_label: "* AOV Per Customer *"
    label: "AOV (Gross) - 75th Percentile"
    group_item_label: "75th Percentile"
    description: "The 75th percentile AOV Per Customer across customers"
    type: percentile
    percentile: 75
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_95 {
    group_label: "* AOV Per Customer *"
    label: "AOV (Gross) - 95th Percentile"
    group_item_label: "95th Percentile"
    description: "The 95th percentile AOV Per Customer across customers"
    type: percentile
    percentile: 95
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_max {
    group_label: "* AOV Per Customer *"
    label: "AOV (Gross) - Max"
    group_item_label: "Maximum"
    description: "The MAX AOV Per Customer across customers"
    type: max
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }

  measure: avg_number_of_days_ordering {
    group_label: "* # Days Ordering *"
    label: "# Days Ordering AVG"
    group_item_label: "AVG"
    description: "Average number of days ordered"
    type: average
    sql: ${number_of_days_ordering};;
    value_format_name: decimal_1
  }

  measure: number_of_days_ordering_min {
    group_label: "* # Days Ordering *"
    label: "# Days Ordering Min"
    group_item_label: "Minimum"
    description: "Minimum number of days ordered"
    type: min
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_25 {
    group_label: "* # Days Ordering *"
    label: "# Days Ordering 25th Perc."
    group_item_label: "25th Percentile"
    description: "25th percentile of number of days ordered"
    type: percentile
    percentile: 25
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_50 {
    group_label: "* # Days Ordering *"
    label: "# Days Ordering 50th Perc."
    group_item_label: "50th Percentile"
    description: "50th percentile of number of days ordered"
    type: median
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_75 {
    group_label: "* # Days Ordering *"
    label: "# Days Ordering 75th Perc."
    group_item_label: "75th Percentile"
    description: "75th percentile of number of days ordered"
    type: percentile
    percentile: 75
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_95 {
    group_label: "* # Days Ordering *"
    label: "# Days Ordering 95th Perc."
    group_item_label: "95th Percentile"
    description: "95th percentile of number of days ordered"
    type: percentile
    percentile: 95
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_max {
    group_label: "* # Days Ordering *"
    label: "# Days Ordering Max"
    group_item_label: "Maximum"
    description: "Max number of days ordered"
    type: max
    sql: ${number_of_days_ordering} ;;
  }
}
