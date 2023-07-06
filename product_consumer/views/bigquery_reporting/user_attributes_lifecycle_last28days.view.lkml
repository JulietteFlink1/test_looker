view: user_attributes_lifecycle_last28days {
  derived_table: {
    sql:
      -- changing 0 to null because percentile_cont ignores nulls but not zeros. This gives the wrong values for amt_gmv_gross (if no order, =0) while correct for avg_gmv_gross (if no order, =null)
      with clean_tb as (
        select
          * except(amt_gmv_gross)
          , NULLIF(amt_gmv_gross,0) as amt_gmv_gross
        from `flink-data-prod.reporting.user_attributes_lifecycle_last28days`
        where {% condition execution_date %} execution_date {% endcondition %}
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

      , PERCENTILE_CONT(date_diff(execution_date, last_order_date, day), 0.25) OVER() AS days_since_last_order_25
      , PERCENTILE_CONT(date_diff(execution_date, last_order_date, day), 0.5) OVER() AS days_since_last_order_50
      , PERCENTILE_CONT(date_diff(execution_date, last_order_date, day), 0.75) OVER() AS days_since_last_order_75

      , PERCENTILE_CONT(date_diff(execution_date, last_visit_date, day), 0.25) OVER() AS days_since_last_visit_25
      , PERCENTILE_CONT(date_diff(execution_date, last_visit_date, day), 0.5) OVER() AS days_since_last_visit_50
      , PERCENTILE_CONT(date_diff(execution_date, last_visit_date, day), 0.75) OVER() AS days_since_last_visit_75

      from clean_tb
      ;;
  }

  # sql_table_name: `flink-data-prod.reporting.user_attributes_lifecycle_last28days`;;

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

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${customer_uuid}, ${execution_date}) ;;
  }

  dimension: customer_uuid {
    type: string
    sql: ${TABLE}.customer_uuid ;;
  }

  #=============================================================================================#
  #==================================== Dimension Selection ====================================#
  #=============================================================================================#

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

  dimension_group: execution {
    label: "Reference"
    description: "Reference date from which last 28 days are considered. Default is to use yesterday as a reference, as this is the latest dataset available"
    hidden: no
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year,
      day_of_week_index,
      day_of_week,
      day_of_month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.execution_date ;;
  }

  dimension: execution_date_dynamic {
    label: "Reference Date (Dynamic)"
    sql:
    {% if global_filters_and_parameters.timeframe_picker._parameter_value == 'Date' %}
      ${execution_date}
    {% elsif global_filters_and_parameters.timeframe_picker._parameter_value == 'Week' %}
      ${execution_week}
    {% elsif global_filters_and_parameters.timeframe_picker._parameter_value == 'Month' %}
      ${execution_month}
    {% endif %};;
  }

  #=========================================================================================#
  #==================================== User Attributes ====================================#
  #=========================================================================================#

  dimension: first_country_iso {
    group_label: "> User Attributes"
    type: string
    sql: ${TABLE}.first_country_iso ;;
  }

  dimension_group: first_order {
    group_label: "> User Attributes"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_order_date ;;
  }

  dimension: first_order_platform {
    group_label: "> User Attributes"
    type: string
    sql: ${TABLE}.first_order_platform ;;
  }

  dimension_group: first_visit {
    group_label: "> User Attributes"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_visit_date ;;
  }

  dimension: first_visit_granularity {
    group_label: "> User Attributes"
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
    group_label: "> User Attributes"
    description: "First platform customer visited on"
    type: string
    sql: ${TABLE}.first_visit_platform ;;
  }

  dimension: is_xdevice_conversion {
    group_label: "> User Attributes"
    description: "Whether customer used a different device on first visit vs. first order"
    type: yesno
    sql: ${TABLE}.is_xdevice_conversion ;;
  }

  dimension: number_of_days_to_first_order {
    group_label: "> User Attributes"
    label: "# Days To First Order"
    description: "How many days there were between the customer's first visit and their first order"
    type: number
    sql: ${TABLE}.number_of_days_to_first_order ;;
  }

  dimension: has_atc_last1day {
    group_label: "> User Attributes"
    description: "Did the user ATC in the last day?"
    type: yesno
    sql: ${number_of_unique_product_skus_atc_last1day} > 0 ;;
  }

  dimension: has_atc_cart_reco_last1day {
    group_label: "> User Attributes"
    description: "Did the user ATC from Cart Recommendations in the last day?"
    type: yesno
    sql: ${number_of_unique_product_skus_atc_last1day_cart_reco} > 0 ;;
  }

  dimension: has_atc_search_reco_last1day {
    group_label: "> User Attributes"
    description: "Did the user ATC from Search Recommendations in the last day?"
    type: yesno
    sql: ${number_of_unique_product_skus_atc_last1day_search_reco} > 0 ;;
  }

  dimension: has_atc_category_reco_last1day {
    group_label: "> User Attributes"
    description: "Did the user ATC from Category Recommendations (Highlights) in the last day?"
    type: yesno
    sql: ${number_of_unique_product_skus_atc_last1day_category_reco} > 0 ;;
  }

  dimension: has_atc_home_toppicks_last1day {
    group_label: "> User Attributes"
    description: "Did the user ATC from Home Top Picks in the last day?"
    type: yesno
    sql: ${number_of_unique_product_skus_atc_last1day_home_toppicks} > 0 ;;
  }

  dimension: has_atc_pdp_reco_last1day {
    group_label: "> User Attributes"
    description: "Did the user ATC from PDP Recommendations in the last day?"
    type: yesno
    sql: ${number_of_unique_product_skus_atc_last1day_pdp_reco} > 0 ;;
  }

  dimension: has_atc_home_lastbought_last1day {
    group_label: "> User Attributes"
    description: "Did the user ATC from Home Last-Bought in the last day?"
    type: yesno
    sql: ${number_of_unique_product_skus_atc_last1day_home_lastbought} > 0 ;;
  }

  dimension: has_atc_lastboughtdetail_last1day {
    group_label: "> User Attributes"
    description: "Did the user ATC from Last Bought Screen in the last day?"
    type: yesno
    sql: ${number_of_unique_product_skus_atc_last1day_lastboughtdetail} > 0 ;;
  }

  dimension: has_atc_any_lastbought_last1day {
    group_label: "> User Attributes"
    description: "Did the user ATC from Last Bought on Home or Last Bought Screen in the last day?"
    type: yesno
    sql: ${number_of_unique_product_skus_atc_last1day_lastboughtdetail} > 0 or ${number_of_unique_product_skus_atc_last1day_home_lastbought} > 0;;
  }

  dimension: has_atc_any_reco_last1day {
    group_label: "> User Attributes"
    description: "Did the user ATC from any recommendation lane in the last day?"
    type: yesno
    sql: ${number_of_unique_product_skus_atc_last1day_any_reco} > 0 ;;
  }

  #=================================================================================================#
  #==================================== Unique Item ATC Dimensions =================================#
  #=================================================================================================#

  dimension: number_of_unique_product_skus_atc {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 28 Days"
    description: "How many unique product SKUs were ATC in the last 28 days?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 1 Day"
    description: "How many unique product SKUs were ATC on the previous day?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_over28days {
    group_label: "> Unique Item ATC"
    label: "# Novel ATC"
    description: "How many unique product SKUs were ATC on the previous day that were not ATC from any other day in the last 28 days?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_over28days ;;
  }

  dimension: number_of_unique_product_skus_atc_cart_reco {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 28 Days Reco on Cart"
    description: "How many unique product SKUs were ATC in the last 28 days from recommendation on cart page?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_cart_reco ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_cart_reco {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 1 Day Cart Reco"
    description: "How many unique product SKUs were ATC on the previous day from recommendation on cart page?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_cart_reco ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_cart_reco_over28days {
    group_label: "> Unique Item ATC"
    label: "# Novel ATC from Cart Reco"
    description: "How many unique product SKUs were ATC from recommendation on cart page on the previous day that were not ATC from anywhere else any other day in the last 28 days?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_cart_reco_over28days ;;
  }

  dimension: number_of_unique_product_skus_atc_search_reco {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 28 Days Search Reco"
    description: "How many unique product SKUs were ATC in the last 28 days from recommendation on search?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_search_reco ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_search_reco {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 1 Day Search Reco"
    description: "How many unique product SKUs were ATC on the previous day from recommendation on search page?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_search_reco ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_search_reco_over28days {
    group_label: "> Unique Item ATC"
    label: "# Novel ATC from Search Reco"
    description: "How many unique product SKUs were ATC from recommendation on search page on the previous day that were not ATC from anywhere else any other day in the last 28 days?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_search_reco_over28days ;;
  }

  dimension: number_of_unique_product_skus_atc_category_reco {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 28 Days Category Reco (Highlights)"
    description: "How many unique product SKUs were ATC in the last 28 days from recommendation on Category (Highlights)?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_category_reco ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_category_reco {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 1 Day Category Reco (Highlights)"
    description: "How many unique product SKUs were ATC on the previous day from recommendation on Category (Highlights)?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_category_reco ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_category_reco_over28days {
    group_label: "> Unique Item ATC"
    label: "# Novel ATC from Category Reco (Highlights)"
    description: "How many unique product SKUs were ATC from recommendation on category page (highlights) on the previous day that were not ATC from anywhere else any other day in the last 28 days?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_category_reco_over28days ;;
  }


  dimension: number_of_unique_product_skus_atc_home_toppicks {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 28 Days Home Top Picks"
    description: "How many unique product SKUs were ATC in the last 28 days from home top picks?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_home_toppicks ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_home_toppicks {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 1 Day Home Top Picks"
    description: "How many unique product SKUs were ATC on the previous day from home top picks?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_home_toppicks ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_home_toppicks_over28days {
    group_label: "> Unique Item ATC"
    label: "# Novel ATC from Home Top Picks"
    description: "How many unique product SKUs were ATC from home top picks on the previous day that were not ATC from anywhere else any other day in the last 28 days?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_home_toppicks_over28days ;;
  }

  dimension: number_of_unique_product_skus_atc_pdp_reco {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 28 Days PDP Reco"
    description: "How many unique product SKUs were ATC in the last 28 days from recommendation on PDP?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_pdp_reco ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_pdp_reco {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 1 Day Reco PDP"
    description: "How many unique product SKUs were ATC on the previous day from recommendation on PDP?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_pdp_reco ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_pdp_reco_over28days {
    group_label: "> Unique Item ATC"
    label: "# Novel ATC from PDP Reco"
    description: "How many unique product SKUs were ATC from recommendation on PDP on the previous day that were not ATC from anywhere else any other day in the last 28 days?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_pdp_reco_over28days ;;
  }

  dimension: number_of_unique_product_skus_atc_home_lastbought {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 28 Days Home Lastbought"
    description: "How many unique product SKUs were ATC in the last 28 days from lastbought on home?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_home_lastbought ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_home_lastbought {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 1 Day Home Lastbought"
    description: "How many unique product SKUs were ATC on the previous day from lastbought lane on home?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_home_lastbought ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_home_lastbought_over28days {
    group_label: "> Unique Item ATC"
    label: "# Novel ATC from Home Lastbought"
    description: "How many unique product SKUs were ATC from lastbought on home on the previous day that were not ATC from anywhere else any other day in the last 28 days?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_home_lastbought_over28days ;;
  }

  dimension: number_of_unique_product_skus_atc_lastboughtdetail {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 28 Days Lastbought Detail"
    description: "How many unique product SKUs were ATC in the last 28 days from lastbought detail page?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_lastboughtdetail ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_lastboughtdetail {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 1 Day Lastbought Detail"
    description: "How many unique product SKUs were ATC on the previous day from lastbought detail page?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_lastboughtdetail ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_lastboughtdetail_over28days {
    group_label: "> Unique Item ATC"
    label: "# Novel ATC from Lastbought Detail"
    description: "How many unique product SKUs were ATC from lastbought detail page on the previous day that were not ATC from anywhere else any other day in the last 28 days?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_lastboughtdetail_over28days ;;
  }

  dimension: number_of_unique_product_skus_atc_any_reco {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 28 Days Any Reco"
    description: "How many unique product SKUs were ATC in the last 28 days from any recommendation lane?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_any_reco ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_any_reco {
    group_label: "> Unique Item ATC"
    label: "# Unique SKU ATC Last 1 Day Any Reco"
    description: "How many unique product SKUs were ATC on the previous day from any recommendation lane?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_any_reco ;;
  }

  dimension: number_of_unique_product_skus_atc_last1day_any_reco_over28days {
    group_label: "> Unique Item ATC"
    label: "# Novel ATC from Any Reco"
    description: "How many unique product SKUs were ATC from any recommendation lane on the previous day that were not ATC from anywhere else any other day in the last 28 days?"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.number_of_unique_product_skus_atc_last1day_any_reco_over28days ;;
  }


  #=================================================================================================#
  #==================================== RFM Category Dimensions ====================================#
  #=================================================================================================#

  dimension: aov_25 {
    group_label: ">  AOV Percentiles"
    label: "AOV 25th Percentile"
    group_item_label: "25th Percentile"
    hidden: yes
    type: number
    sql: ${TABLE}.aov_25 ;;
  }

  dimension: aov_50 {
    group_label: ">  AOV Percentiles"
    label: "AOV Median"
    group_item_label: "Median"
    hidden: yes
    type: number
    sql: ${TABLE}.aov_50 ;;
  }

  dimension: aov_75 {
    group_label: ">  AOV Percentiles"
    label: "AOV 75th Percentile"
    group_item_label: "75th Percentile"
    hidden: yes
    type: number
    sql: ${TABLE}.aov_75 ;;
  }

  dimension: aov_category {
    group_label: "> RFM Quartile Categories"
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
      else: "Unavailable"
    }
  }

  dimension: gmv_25 {
    group_label: ">  Total GMV Percentiles"
    label: "GMV 25th Percentile"
    group_item_label: "25th Percentile"
    hidden: yes
    type: number
    sql: ${TABLE}.gmv_25 ;;
  }

  dimension: gmv_50 {
    group_label: ">  Total GMV Percentiles"
    label: "GMV Median"
    group_item_label: "Median"
    hidden: yes
    type: number
    sql: ${TABLE}.gmv_50 ;;
  }

  dimension: gmv_75 {
    group_label: ">  Total GMV Percentiles"
    label: "GMV 75th Percentile"
    group_item_label: "75th Percentile"
    hidden: yes
    type: number
    sql: ${TABLE}.gmv_75 ;;
  }

  dimension: gmv_category {
    group_label: "> RFM Quartile Categories"
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
      else: "Unavailable"
    }
  }

  dimension: days_ordering_25 {
    group_label: ">  # Days Ordering Percentiles"
    label: "# Days Ordering 25th"
    hidden: yes
    type: number
    sql: ${TABLE}.days_ordering_25 ;;
  }

  dimension: days_ordering_50 {
    group_label: ">  # Days Ordering Percentiles"
    label: "# Days Ordering Median"
    hidden: yes
    type: number
    sql: ${TABLE}.days_ordering_50 ;;
  }

  dimension: days_ordering_75 {
    group_label: ">  # Days Ordering Percentiles"
    label: "# Days Ordering 75th"
    hidden: yes
    type: number
    sql: ${TABLE}.days_ordering_75 ;;
  }

  dimension: days_ordering_category {
    group_label: "> RFM Quartile Categories"
    label: "# Days Ordering Category"
    description: "Dimension that splits customers into quartiles according to on how many days they've ordered in the last 28 days"
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
      else: "Unavailable"
    }
  }

  dimension: days_visiting_25 {
    group_label: ">  # Days Visiting Percentiles"
    label: "# Days Visiting 25th"
    hidden: yes
    type: number
    sql: ${TABLE}.days_visiting_25 ;;
  }

  dimension: days_visiting_50 {
    group_label: ">  # Days Visiting Percentiles"
    label: "# Days Visiting Median"
    hidden: yes
    type: number
    sql: ${TABLE}.days_visiting_50 ;;
  }

  dimension: days_visiting_75 {
    group_label: ">  # Days Visiting Percentiles"
    label: "# Days Visiting 75th"
    hidden: yes
    type: number
    sql: ${TABLE}.days_visiting_75 ;;
  }

  dimension: days_visiting_category {
    group_label: "> RFM Quartile Categories"
    label: "# Days Visiting Category"
    description: "Dimension that splits customers into quartiles according to on how many days they've visited in the last 28 days"
    case: {
      when: {
        sql: ${number_of_days_visited} < ${days_visiting_25} ;;
        label: "# Days Ordering 25th Percentile"
      }
      when: {
        sql: ${number_of_days_visited} < ${days_visiting_50} ;;
        label: "# Days Ordering 25-50th Percentile"
      }
      when: {
        sql: ${number_of_days_visited} < ${days_visiting_75} ;;
        label: "# Days Ordering 50-75th Percentile"
      }
      when: {
        sql: ${number_of_days_visited} >= ${days_visiting_75} ;;
        label: "# Days Ordering 75-100th Percentile"
      }
      else: "Unavailable"
    }
  }

  dimension: days_since_last_order_25 {
    group_label: ">  # Days Since Last Order Percentiles"
    label: "# Days Since Last Order 25th"
    hidden: yes
    type: number
    sql: ${TABLE}.days_since_last_order_25 ;;
  }

  dimension: days_since_last_order_50 {
    group_label: ">  # Days Since Last Order Percentiles"
    label: "# Days Since Last Order Median"
    hidden: yes
    type: number
    sql: ${TABLE}.days_since_last_order_50 ;;
  }

  dimension: days_since_last_order_75 {
    group_label: ">  # Days Since Last Order Percentiles"
    label: "# Days Since Last Order 75th"
    hidden: yes
    type: number
    sql: ${TABLE}.days_since_last_order_75 ;;
  }

  dimension: days_since_last_order_category {
    group_label: "> RFM Quartile Categories"
    label: "# Days Since Last Order Category"
    description: "Dimension that splits customers into quartiles according to how many days it has been from the last order to the reference date. Note maximum is 28 because this model looks at the last 28 days only"
    case: {
      when: {
        sql: ${days_since_last_order} < ${days_since_last_order_25} ;;
        label: "# Days Since Last Order 25th Percentile"
      }
      when: {
        sql: ${days_since_last_order} < ${days_since_last_order_50} ;;
        label: "# Days Since Last Order 25-50th Percentile"
      }
      when: {
        sql: ${days_since_last_order} < ${days_since_last_order_75} ;;
        label: "# Days Since Last Order 50-75th Percentile"
      }
      when: {
        sql: ${days_since_last_order} >= ${days_since_last_order_75} ;;
        label: "# Days Since Last Order 75-100th Percentile"
      }
      else: "Unavailable"
    }
  }

  dimension: days_since_last_visit_25 {
    group_label: ">  # Days Since Last Visit Percentiles"
    label: "# Days Since Last Visit 25th"
    hidden: yes
    type: number
    sql: ${TABLE}.days_since_last_visit_25 ;;
  }

  dimension: days_since_last_visit_50 {
    group_label: ">  # Days Since Last Visit Percentiles"
    label: "# Days Since Last Visit Median"
    hidden: yes
    type: number
    sql: ${TABLE}.days_since_last_visit_50 ;;
  }

  dimension: days_since_last_visit_75 {
    group_label: ">  # Days Since Last Visit Percentiles"
    label: "# Days Since Last Visit 75th"
    hidden: yes
    type: number
    sql: ${TABLE}.days_since_last_visit_75 ;;
  }

  dimension: days_since_last_visit_category {
    group_label: "> RFM Quartile Categories"
    label: "# Days Since Last Visit Category"
    description: "Dimension that splits customers into quartiles according to how many days it has been from the last visit to the reference date. Note maximum is 28 because this model looks at the last 28 days only"
    case: {
      when: {
        sql: ${days_since_last_visit} < ${days_since_last_visit_25} ;;
        label: "# Days Since Last Order 25th Percentile"
      }
      when: {
        sql: ${days_since_last_visit} < ${days_since_last_visit_50} ;;
        label: "# Days Since Last Order 25-50th Percentile"
      }
      when: {
        sql: ${days_since_last_visit} < ${days_since_last_visit_75} ;;
        label: "# Days Since Last Order 50-75th Percentile"
      }
      when: {
        sql: ${days_since_last_visit} >= ${days_since_last_visit_75} ;;
        label: "# Days Since Last Order 75-100th Percentile"
      }
      else: "Unavailable"
    }
  }

  dimension: aov_split {
    hidden: yes
    case: {
      when: {
        sql: ${avg_gmv_gross} < ${aov_25} ;;
        label: "Low"
      }
      when: {
        sql: ${avg_gmv_gross} >= ${aov_75} ;;
        label: "High"
      }
      else: "Middle"
    }
  }

  dimension: rf_categories {
    hidden: yes
    case: {
      when: {
        sql: (${days_since_last_order} < ${days_since_last_order_25}) and (${number_of_days_ordering} >= ${days_ordering_75});;
        label: "Recent, frequent customers"
      }
      when: {
        sql: (${days_since_last_order} < ${days_since_last_order_25}) and (${number_of_days_ordering} <=  ${days_ordering_25});;
        label: "Recent, infrequent customers"
      }
      when: {
        sql: (${days_since_last_order} >= ${days_since_last_order_75}) and (${number_of_days_ordering} >=  ${days_ordering_75});;
        label: "Not recent, frequent customers"
      }
      when: {
        sql: (${days_since_last_order} >= ${days_since_last_order_75}) and (${number_of_days_ordering} <=  ${days_ordering_25});;
        label: "Not recent, infrequent customers"
      }
      else: "other"
    }
  }


  #=========================================================================================#
  #==================================== Monetary Values ====================================#
  #=========================================================================================#

  dimension: avg_gmv_gross_tier_2 {
    group_label: "> Monetary Values"
    label: "AOV Per Customer (tiered, 2 EUR)"
    type: tier
    tiers: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70]
    style: relational
    sql: ${avg_gmv_gross} ;;
  }

  dimension: amt_gmv_gross {
    group_label: "> Monetary Values"
    label: "GMV (Gross) Per Customer"
    description: "Sum GMV (Gross) per customer"
    type: number
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: amt_gmv_net {
    group_label: "> Monetary Values"
    label: "GMV (Net) Per Customer"
    description: "GMV (Net) per customer"
    type: number
    sql: ${TABLE}.amt_gmv_net ;;
  }

  dimension: amt_revenue_gross {
    group_label: "> Monetary Values"
    label: "Revenue (Gross) Per Customer"
    description: "Revebye (Gross) per customer"
    type: number
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: avg_gmv_gross {
    group_label: "> Monetary Values"
    label: "AOV (Gross) Per Customer"
    description: "AOV (Gross) per customer"
    type: number
    sql: ${TABLE}.avg_gmv_gross ;;
  }

  dimension: avg_gmv_net {
    group_label: "> Monetary Values"
    label: "AOV (Net) Per Customer"
    description: "AOV (Net) per customer"
    type: number
    sql: ${TABLE}.avg_gmv_net ;;
  }

  dimension: avg_revenue_gross {
    group_label: "> Monetary Values"
    label: "Average Revenue (Gross) Per Customer"
    description: "Average Revenue (Gross) per customer"
    type: number
    sql: ${TABLE}.avg_revenue_gross ;;
  }


  #==========================================================================================#
  #==================================== Frequency Values ====================================#
  #==========================================================================================#

  dimension: avg_days_between_orders {
    group_label: "> Frequency Values"
    label: "AVG Days Between Orders"
    description: "Average number of days between orders"
    type: number
    sql: ${TABLE}.avg_days_between_orders ;;
  }

  dimension: avg_days_between_visits {
    group_label: "> Frequency Values"
    label: "AVG Days Between Visits"
    description: "Average number of days between visits"
    type: number
    sql: ${TABLE}.avg_days_between_visits ;;
  }

  dimension: number_of_days_ordering {
    group_label: "> Frequency Values"
    label: "# Days Ordering"
    description: "Number of days the customer has ordered with us"
    type: number
    sql: ${TABLE}.number_of_days_ordering ;;
  }

  dimension: number_of_days_visited {
    group_label: "> Frequency Values"
    label: "# Days Visited"
    description: "Number of days the customer has visited us"
    type: number
    sql: ${TABLE}.number_of_days_visited ;;
  }

  dimension: number_of_orders {
    group_label: "> Frequency Values"
    label: "# Orders"
    description: "Number of orders"
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: order_to_visit_ratio_tier {
    hidden: yes
    group_label: "> Frequency Values"
    label: "Order To Visit Ratio (tiered, 0.05)"
    type: tier
    tiers: [0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1]
    style: relational
    sql: ${order_to_visit_ratio} ;;
  }

  dimension: order_to_visit_ratio_tier3 {
    group_label: "> Frequency Values"
    label: "Order To Visit Ratio (tiered, 0.33)"
    description: "Tiers for ratio of how many orders occur per visit"
    type: tier
    tiers: [0, 0.33, 0.66, 1]
    style: relational
    sql: ${order_to_visit_ratio} ;;
  }

  dimension: order_to_visit_ratio {
    group_label: "> Frequency Values"
    description: "Ratio of how many orders occur per visit"
    type: number
    sql: 1.0* ${number_of_days_ordering}/${number_of_days_visited} ;;
    value_format_name: decimal_2
  }


  #========================================================================================#
  #==================================== Recency Values ====================================#
  #========================================================================================#

  dimension: days_since_last_visit {
    group_label: "> Recency Values"
    label: "# Days Since Last Visit"
    type: number
    sql: date_diff(${execution_date}, ${last_visit_date}, day) ;;
  }

  dimension: days_since_last_order {
    group_label: "> Recency Values"
    label: "# Days Since Last Order"
    type: number
    sql: date_diff(${execution_date}, ${last_order_date}, day) ;;
  }

  dimension_group: last_order {
    group_label: "> Recency Values"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_order_date ;;
  }

  dimension_group: last_visit {
    group_label: "> Recency Values"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_visit_date ;;
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
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.oldest_visit_date ;;
  }

  #==================================================================================#
  #==================================== Measures ====================================#
  #==================================================================================#

  measure: cnt_customers {
    group_label: "> Customer Counts"
    label: "# Customers"
    type: count_distinct
    sql: ${customer_uuid} ;;
  }

  measure: cnt_customers_with_orders {
    group_label: "> Customer Counts"
    label: "# Customers With Orders"
    type: count_distinct
    sql: ${customer_uuid} ;;
    filters: [number_of_orders: ">0"]
  }

  measure: cnt_customers_atc_last1day {
    group_label: "> Customer Counts"
    type: count_distinct
    sql: ${customer_uuid} ;;
    filters: [has_atc_last1day: "yes"]
  }

  measure: cnt_customers_atc_from_cart_reco_last1day {
    group_label: "> Customer Counts"
    type: count_distinct
    sql: ${customer_uuid} ;;
    filters: [has_atc_cart_reco_last1day: "yes"]
  }

  measure: cnt_customers_atc_from_search_reco_last1day {
    group_label: "> Customer Counts"
    type: count_distinct
    sql: ${customer_uuid} ;;
    filters: [has_atc_search_reco_last1day: "yes"]
  }

  measure: cnt_customers_atc_from_category_reco_last1day {
    group_label: "> Customer Counts"
    type: count_distinct
    sql: ${customer_uuid} ;;
    filters: [has_atc_category_reco_last1day: "yes"]
  }

  measure: cnt_customers_atc_from_home_toppicks_last1day {
    group_label: "> Customer Counts"
    type: count_distinct
    sql: ${customer_uuid} ;;
    filters: [has_atc_home_toppicks_last1day: "yes"]
  }

  measure: cnt_customers_atc_from_pdp_reco_last1day {
    group_label: "> Customer Counts"
    type: count_distinct
    sql: ${customer_uuid} ;;
    filters: [has_atc_pdp_reco_last1day: "yes"]
  }

  measure: cnt_customers_atc_from_home_lastbought_last1day {
    group_label: "> Customer Counts"
    type: count_distinct
    sql: ${customer_uuid} ;;
    filters: [has_atc_home_lastbought_last1day: "yes"]
  }

  measure: cnt_customers_atc_from_lastboughtdetail_last1day {
    group_label: "> Customer Counts"
    type: count_distinct
    sql: ${customer_uuid} ;;
    filters: [has_atc_lastboughtdetail_last1day: "yes"]
  }

  measure: cnt_customers_atc_from_any_lastbought_last1day {
    group_label: "> Customer Counts"
    type: count_distinct
    sql: ${customer_uuid} ;;
    filters: [has_atc_any_lastbought_last1day: "yes", ]
  }

  measure: cnt_customers_atc_from_any_reco_last1day {
    group_label: "> Customer Counts"
    type: count_distinct
    sql: ${customer_uuid} ;;
    filters: [has_atc_any_reco_last1day: "yes"]
  }

  measure: avg_number_of_orders {
    label: "Avg # of Orders"
    type: average_distinct
    sql: if(${number_of_days_ordering}>0,${number_of_orders},null) ;;
    value_format_name: decimal_2
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: avg_unique_product_skus_atc {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC"
    description: "How many unique SKUs were ATC on average in the last 28 days?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc};;
  }

  measure: avg_unique_product_skus_atc_last1day {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Last 1 Day"
    description: "How many unique SKUs were ATC on average in the last 1 day?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day};;
  }

  measure: avg_unique_product_skus_atc_last1day_over28days {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Novel SKUs ATC"
    description: "How many unique SKUs were ATC on average in the last 1 day, which were not ATC any other day in the last 28 days? (novel items)"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_over28days};;
  }

  measure: avg_unique_product_skus_atc_cart_reco {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Cart Reco"
    description: "How many unique SKUs were ATC on average from recommendation on cart in the last 28 days?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_cart_reco};;
  }

  measure: avg_unique_product_skus_atc_last1day_cart_reco {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Cart Reco Last 1 Day"
    description: "How many unique SKUs were ATC on average from recommendation on cart in the last 1 day?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_cart_reco};;
  }

  measure: avg_unique_product_skus_atc_last1day_cart_reco_over28days {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Novel SKUs ATC Cart Reco"
    description: "How many unique SKUs were ATC on average from recommendation on cart in the last 1 day, which were not ATC any other day in the last 28 days? (novel items)"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_cart_reco_over28days};;
  }

  measure: avg_unique_product_skus_atc_search_reco {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Search Reco"
    description: "How many unique SKUs were ATC on average from recommendation on search in the last 28 days?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_search_reco};;
  }

  measure: avg_unique_product_skus_atc_last1day_search_reco {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Search Reco Last 1 Day"
    description: "How many unique SKUs were ATC on average from recommendation on search in the last 1 day?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_search_reco};;
  }

  measure: avg_unique_product_skus_atc_last1day_search_reco_over28days {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Novel SKUs ATC Search Reco"
    description: "How many unique SKUs were ATC on average from recommendation on search in the last 1 day, which were not ATC any other day in the last 28 days? (novel items)"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_search_reco_over28days};;
  }

  measure: avg_unique_product_skus_atc_category_reco {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Category Reco"
    description: "How many unique SKUs were ATC on average from recommendation on category in the last 28 days?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_category_reco};;
  }

  measure: avg_unique_product_skus_atc_last1day_category_reco {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Category Reco Last 1 Day"
    description: "How many unique SKUs were ATC on average from recommendation on category in the last 1 day?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_category_reco};;
  }

  measure: avg_unique_product_skus_atc_last1day_category_reco_over28days {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Novel SKUs ATC Category Reco"
    description: "How many unique SKUs were ATC on average from recommendation on category in the last 1 day, which were not ATC any other day in the last 28 days? (novel items)"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_category_reco_over28days};;
  }

  measure: avg_unique_product_skus_atc_home_toppicks {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Home Top Picks"
    description: "How many unique SKUs were ATC on average from home top picks in the last 28 days?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_home_toppicks};;
  }

  measure: avg_unique_product_skus_atc_last1day_home_toppicks {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Home Top Picks Last 1 Day"
    description: "How many unique SKUs were ATC on average from home top picks in the last 1 day?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_home_toppicks};;
  }

  measure: avg_unique_product_skus_atc_last1day_home_toppicks_over28days {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Novel SKUs ATC Home Top Picks"
    description: "How many unique SKUs were ATC on average from home top picks in the last 1 day, which were not ATC any other day in the last 28 days? (novel items)"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_home_toppicks_over28days};;
  }

  measure: avg_unique_product_skus_atc_pdp_reco {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC PDP Reco"
    description: "How many unique SKUs were ATC on average from recommendation on PDP in the last 28 days?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_pdp_reco};;
  }

  measure: avg_unique_product_skus_atc_last1day_pdp_reco {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC PDP Reco Last 1 Day"
    description: "How many unique SKUs were ATC on average from recommendation on PDP in the last 1 day?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_pdp_reco};;
  }

  measure: avg_unique_product_skus_atc_last1day_pdp_reco_over28days {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Novel SKUs ATC PDP Reco"
    description: "How many unique SKUs were ATC on average from recommendation on pdp in the last 1 day, which were not ATC any other day in the last 28 days? (novel items)"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_pdp_reco_over28days};;
  }

  measure: avg_unique_product_skus_atc_home_lastbought {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Home Lastbought"
    description: "How many unique SKUs were ATC on average from lastbought on home page in the last 28 days?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_home_lastbought};;
  }

  measure: avg_unique_product_skus_atc_last1day_home_lastbought {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Home Lastbought Last 1 Day"
    description: "How many unique SKUs were ATC on average from lastbought on home in the last 1 day?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_home_lastbought};;
  }

  measure: avg_unique_product_skus_atc_last1day_home_lastbought_over28days {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Novel SKUs ATC Home Lastbought"
    description: "How many unique SKUs were ATC on average from lastbought on home in the last 1 day, which were not ATC any other day in the last 28 days? (novel items)"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_home_lastbought_over28days};;
  }

  measure: avg_unique_product_skus_atc_lastboughtdetail {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Lastbought Detail"
    description: "How many unique SKUs were ATC on average from lastbought detail page in the last 28 days?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_lastboughtdetail};;
  }

  measure: avg_unique_product_skus_atc_last1day_lastboughtdetail {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Lastbought Detail Last 1 Day"
    description: "How many unique SKUs were ATC on average from lastbought detail page in the last 1 day?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_lastboughtdetail};;
  }

  measure: avg_unique_product_skus_atc_last1day_lastboughtdetail_over28days {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Novel SKUs ATC Lastbought Detail"
    description: "How many unique SKUs were ATC on average from lastbought details page in the last 1 day, which were not ATC any other day in the last 28 days? (novel items)"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_lastboughtdetail_over28days};;
  }

  measure: avg_unique_product_skus_atc_any_reco {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Any Reco"
    description: "How many unique SKUs were ATC on average from any recommendation lane in the last 28 days?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_any_reco};;
  }

  measure: avg_unique_product_skus_atc_last1day_any_reco {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Unique SKUs ATC Any Reco Last 1 Day"
    description: "How many unique SKUs were ATC on average from any recommendation lane in the last 1 day?"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_any_reco};;
  }

  measure: avg_unique_product_skus_atc_last1day_any_reco_over28days {
    group_label: "> # Unique SKUs ATC"
    label: "AVG # Novel SKUs ATC Any Reco"
    description: "How many unique SKUs were ATC on average from any recommendation lane in the last 1 day, which were not ATC any other day in the last 28 days? (novel items)"
    type: average
    value_format_name: decimal_2
    sql: ${number_of_unique_product_skus_atc_last1day_any_reco_over28days};;
  }

  measure: avg_total_gmv_gross {
    group_label: "> Sum GMV Per Customer"
    group_item_label: "AVG"
    label: "Total GMV AVG"
    description: "Average of the total GMV over customers"
    type: average
    sql: ${amt_gmv_gross} ;;
    value_format_name: eur
  }

  measure: total_gmv_gross {
    group_label: "> Sum GMV Per Customer"
    group_item_label: "Sum"
    label: "Total GMV Sum"
    description: "Sum of the total GMV over customers"
    type: sum
    sql: ${amt_gmv_gross} ;;
    value_format_name: eur
  }

  measure: total_gmv_min {
    group_label: "> Sum GMV Per Customer"
    group_item_label: "Minimum"
    label: "Total GMV Min"
    description: "Min of the total GMV over customers"
    type: min
    sql: ${amt_gmv_gross} ;;
    value_format_name: eur
  }

  measure: total_gmv_percentile_25 {
    group_label: "> Sum GMV Per Customer"
    group_item_label: "25th Percentile"
    label: "Total GMV 25th Perc."
    description: "25th percentile of the total GMV over customers"
    type: percentile
    percentile: 25
    sql: ${amt_gmv_gross} ;;
    value_format_name: eur
  }

  measure: total_gmv_percentile_50 {
    group_label: "> Sum GMV Per Customer"
    group_item_label: "50th Percentile"
    label: "Total GMV 50th Perc."
    description: "50th percentile of the total GMV over customers"
    type: median
    sql: ${amt_gmv_gross} ;;
    value_format_name: eur
  }

  measure: total_gmv_percentile_75 {
    group_label: "> Sum GMV Per Customer"
    group_item_label: "75th Percentile"
    label: "Total GMV 75th Perc."
    description: "75th percentile of the total GMV over customers"
    type: percentile
    percentile: 75
    sql: ${amt_gmv_gross} ;;
    value_format_name: eur
  }

  measure: total_gmv_percentile_95 {
    group_label: "> Sum GMV Per Customer"
    group_item_label: "95th Percentile"
    label: "Total GMV 95th Perc."
    description: "95th percentile of the total GMV over customers"
    type: percentile
    percentile: 95
    sql: ${amt_gmv_gross} ;;
    value_format_name: eur
  }
  measure: total_gmv_max {
    group_label: "> Sum GMV Per Customer"
    group_item_label: "Maximum"
    label: "Total GMV Max"
    description: "Max of the total GMV over customers"
    type: max
    sql: ${amt_gmv_gross} ;;
    # filters: [amt_gmv_gross: ">0"]
    value_format_name: eur
  }

  measure: avg_number_of_days_visiting {
    group_label: "> # Days Visiting"
    group_item_label: "AVG"
    label: "# Days Visiting AVG"
    description: "Average number of days visited"
    type: average
    sql: ${number_of_days_visited};;
    value_format_name: decimal_1
  }

  measure: number_of_days_visiting_min {
    group_label: "> # Days Visiting"
    group_item_label: "Minimum"
    label: "# Days Visiting Min"
    description: "Minimum number of days visited"
    type: min
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_25 {
    group_label: "> # Days Visiting"
    group_item_label: "25th Percentile"
    label: "# Days Visiting 25th Perc."
    description: "25th percentile of number of days visited"
    type: percentile
    percentile: 25
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_50 {
    group_label: "> # Days Visiting"
    group_item_label: "50th Percentile"
    label: "# Days Visiting 50th Perc."
    description: "50th percentile of number of days visited"
    type: median
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_75 {
    group_label: "> # Days Visiting"
    group_item_label: "75th Percentile"
    label: "# Days Visiting 75th Perc."
    description: "75th percentile of number of days visited"
    type: percentile
    percentile: 75
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_95 {
    group_label: "> # Days Visiting"
    group_item_label: "95th Percentile"
    label: "# Days Visiting 95th Perc."
    description: "95th percentile of number of days visited"
    type: percentile
    percentile: 95
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_max {
    group_label: "> # Days Visiting"
    group_item_label: "Maximum"
    label: "# Days Visiting Max"
    description: "Maximum number of days visited"
    type: max
    sql: ${number_of_days_visited} ;;
  }

  measure: avg_gmv_avg {
    group_label: "> AOV Per Customer"
    group_item_label: "AVG"
    label: "AOV (Gross) - AVG"
    description: "The average AOV across customers"
    type: average
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }

  measure: avg_gmv_min {
    group_label: "> AOV Per Customer"
    label: "AOV (Gross) - Min"
    group_item_label: "Minimum"
    description: "The minimum AOV Per Customer across customers"
    type: min
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_25 {
    group_label: "> AOV Per Customer"
    label: "AOV (Gross) - 25th Percentile"
    group_item_label: "25th Percentile"
    description: "The 25th percentile AOV Per Customer across customers"
    type: percentile
    percentile: 25
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_50 {
    group_label: "> AOV Per Customer"
    label: "AOV (Gross) - 50th Percentile"
    group_item_label: "50th Percentile"
    description: "The 50th percentile AOV Per Customer across customers"
    type: median
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_75 {
    group_label: "> AOV Per Customer"
    label: "AOV (Gross) - 75th Percentile"
    group_item_label: "75th Percentile"
    description: "The 75th percentile AOV Per Customer across customers"
    type: percentile
    percentile: 75
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_95 {
    group_label: "> AOV Per Customer"
    label: "AOV (Gross) - 95th Percentile"
    group_item_label: "95th Percentile"
    description: "The 95th percentile AOV Per Customer across customers"
    type: percentile
    percentile: 95
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_max {
    group_label: "> AOV Per Customer"
    label: "AOV (Gross) - Max"
    group_item_label: "Maximum"
    description: "The MAX AOV Per Customer across customers"
    type: max
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }

  measure: days_since_last_order_avg {
    group_label: "> # Days Since Last Order"
    label: "# Days Since Last Order AVG"
    group_item_label: "AVG"
    description: "Average days since last order"
    type: average
    sql: ${days_since_last_order} ;;
    value_format_name: decimal_1
  }
  measure: days_since_last_order_min {
    group_label: "> # Days Since Last Order"
    label: "# Days Since Last Order Min"
    group_item_label: "Minimum"
    description: "Minimum days since last order"
    type: min
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_percentile_25 {
    group_label: "> # Days Since Last Order"
    label: "# Days Since Last Order 25th Perc."
    group_item_label: "25th Percentile"
    description: "25th percentile of number of days since last order"
    type: percentile
    percentile: 25
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_percentile_50 {
    group_label: "> # Days Since Last Order"
    label: "# Days Since Last Order 50th Perc."
    group_item_label: "50th Percentile"
    description: "50th percentile of number of days since last order"
    type: median
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_percentile_75 {
    group_label: "> # Days Since Last Order"
    label: "# Days Since Last Order 75th Perc."
    group_item_label: "75th Percentile"
    description: "75th percentile of number of days since last order"
    type: percentile
    percentile: 75
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_percentile_95 {
    group_label: "> # Days Since Last Order"
    label: "# Days Since Last Order 95th Perc."
    group_item_label: "95th Percentile"
    description: "95th percentile of number of days since last order"
    type: percentile
    percentile: 95
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_max {
    group_label: "> # Days Since Last Order"
    label: "# Days Since Last Order Max"
    group_item_label: "Maximum"
    description: "Maximum days since last order"
    type: max
    sql: ${days_since_last_order} ;;
  }

  measure: days_since_last_visit_avg {
    group_label: "> # Days Since Last Visit"
    label: "# Days Since Last Visit AVG"
    group_item_label: "AVG"
    description: "Average days since last visit"
    type: average
    sql: ${days_since_last_visit} ;;
    value_format_name: decimal_1
  }
  measure: days_since_last_visit_min {
    group_label: "> # Days Since Last Visit"
    label: "# Days Since Last Visit Min"
    description: "Minimum days since last visit"
    group_item_label: "Minimum"
    type: min
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_percentile_25 {
    group_label: "> # Days Since Last Visit"
    label: "# Days Since Last Visit 25th Perc."
    group_item_label: "25th Percentile"
    description: "25th percentile of number of days since last visit"
    type: percentile
    percentile: 25
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_percentile_50 {
    group_label: "> # Days Since Last Visit"
    label: "# Days Since Last Visit 50th Perc."
    group_item_label: "50th Percentile"
    description: "50th percentile of number of days since last visit"
    type: median
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_percentile_75 {
    group_label: "> # Days Since Last Visit"
    label: "# Days Since Last Visit 75th Perc."
    group_item_label: "75th Percentile"
    description: "75th percentile of number of days since last visit"
    type: percentile
    percentile: 75
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_percentile_95 {
    group_label: "> # Days Since Last Visit"
    label: "# Days Since Last Visit 95th Perc."
    group_item_label: "95th Percentile"
    description: "95th percentile of number of days since last visit"
    type: percentile
    percentile: 95
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_max {
    group_label: "> # Days Since Last Visit"
    label: "# Days Since Last Visit Max"
    group_item_label: "Maximum"
    description: "Maximum days since last visit"
    type: max
    sql: ${days_since_last_visit} ;;
  }


  measure: avg_number_of_days_ordering {
    group_label: "> # Days Ordering"
    label: "# Days Ordering AVG"
    group_item_label: "AVG"
    description: "Average number of days ordered"
    type: average
    sql: ${number_of_days_ordering};;
    value_format_name: decimal_1
  }

  measure: number_of_days_ordering_min {
    group_label: "> # Days Ordering"
    label: "# Days Ordering Min"
    group_item_label: "Minimum"
    description: "Minimum number of days ordered"
    type: min
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_25 {
    group_label: "> # Days Ordering"
    label: "# Days Ordering 25th Perc."
    group_item_label: "25th Percentile"
    description: "25th percentile of number of days ordered"
    type: percentile
    percentile: 25
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_50 {
    group_label: "> # Days Ordering"
    label: "# Days Ordering 50th Perc."
    group_item_label: "50th Percentile"
    description: "50th percentile of number of days ordered"
    type: median
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_75 {
    group_label: "> # Days Ordering"
    label: "# Days Ordering 75th Perc."
    group_item_label: "75th Percentile"
    description: "75th percentile of number of days ordered"
    type: percentile
    percentile: 75
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_95 {
    group_label: "> # Days Ordering"
    label: "# Days Ordering 95th Perc."
    group_item_label: "95th Percentile"
    description: "95th percentile of number of days ordered"
    type: percentile
    percentile: 95
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_max {
    group_label: "> # Days Ordering"
    label: "# Days Ordering Max"
    group_item_label: "Maximum"
    description: "Max number of days ordered"
    type: max
    sql: ${number_of_days_ordering} ;;
  }
}
