### Author: Artem Avramenko & James Davies
### Created: 2022-12-13

### This view represents data for reporting on CRM canvas lifecycles efficiency.

view: braze_lifecycle_cohorts {
  sql_table_name: `flink-data-prod.curated.braze_canvas_reporting`
    ;;
  view_label: "* CRM Lifecycle Canvases *"

  # =========  hidden   =========

  dimension: number_of_unique_customers_discounted_ordered {
    type: number
    sql: ${TABLE}.number_of_unique_customers_discounted_ordered ;;
    hidden: yes
  }

  dimension: number_of_unique_control_customers_discounted_ordered {
    type: number
    sql: ${TABLE}.number_of_unique_control_customers_discounted_ordered ;;
    hidden: yes
  }

  dimension: number_of_unique_customers_ordered {
    type: number
    sql: ${TABLE}.number_of_unique_customers_ordered ;;
    hidden: yes
  }

  dimension: number_of_unique_control_customers_ordered {
    type: number
    sql: ${TABLE}.number_of_unique_control_customers_ordered ;;
    hidden: yes
  }

  dimension: amount_of_gmv_gross {
    type: number
    sql: ${TABLE}.amt_of_gmv_gross ;;
    hidden: yes
  }

  dimension: amount_of_control_gmv_gross {
    type: number
    sql: ${TABLE}.amt_of_control_gmv_gross ;;
    hidden: yes
  }

  dimension: amount_of_cart_discount_gross {
    type: number
    sql: ${TABLE}.amt_of_cart_discount_gross ;;
    hidden: yes
  }

  dimension: amount_of_control_cart_discount_gross {
    type: number
    sql: ${TABLE}.amt_of_control_cart_discount_gross ;;
    hidden: yes
  }

  dimension: amount_of_total_price_gross {
    type: number
    sql: ${TABLE}.amt_of_total_price_gross ;;
    hidden: yes
  }

  dimension: amount_of_control_total_price_gross {
    type: number
    sql: ${TABLE}.amt_of_control_total_price_gross ;;
    hidden: yes
  }

  dimension: number_of_unique_customers_visited {
    type: number
    sql: ${TABLE}.number_of_unique_customers_visited ;;
    hidden: yes
  }

  dimension: number_of_unique_control_customers_visited {
    type: number
    sql: ${TABLE}.number_of_unique_control_customers_visited ;;
    hidden: yes
  }

  dimension: number_of_unique_daily_visits {
    type: number
    sql: ${TABLE}.number_of_unique_daily_visits ;;
    hidden: yes
  }

  dimension: number_of_control_unique_daily_visits {
    type: number
    sql: ${TABLE}.number_of_control_unique_daily_visits ;;
    hidden: yes
  }

  dimension: number_of_unique_discounted_orders {
    type: number
    sql: ${TABLE}.number_of_unique_discounted_orders ;;
    hidden: yes
  }

  dimension: number_of_unique_control_discounted_orders {
    type: number
    sql: ${TABLE}.number_of_unique_control_discounted_orders ;;
    hidden: yes
  }

  dimension: source_number_of_email_clicks {
    type: number
    sql: ${TABLE}.number_of_email_clicks ;;
    hidden: yes
  }

  dimension: number_of_general_email_opens {
    type: number
    sql: ${TABLE}.number_of_general_email_opens ;;
    hidden: yes
  }

  dimension: number_of_unique_bounced_emails {
    type: number
    sql: ${TABLE}.number_of_unique_bounced_emails ;;
    hidden: yes
  }

  dimension: number_of_unique_clicked_emails {
    type: number
    sql: ${TABLE}.number_of_unique_clicked_emails ;;
    hidden: yes
  }

  dimension: number_of_unique_delivered_emails {
    type: number
    sql: ${TABLE}.number_of_unique_delivered_emails ;;
    hidden: yes
  }

  dimension: number_of_unique_generally_opened_emails {
    type: number
    sql: ${TABLE}.number_of_unique_generally_opened_emails ;;
    hidden: yes
  }

  dimension: number_of_unique_soft_bounced_emails {
    type: number
    sql: ${TABLE}.number_of_unique_soft_bounced_emails ;;
    hidden: yes
  }

  dimension: number_of_unique_unsubscribed_emails {
    type: number
    sql: ${TABLE}.number_of_unique_unsubscribed_emails ;;
    hidden: yes
  }

  dimension: source_number_of_sent_emails {
    type: number
    sql: ${TABLE}.number_of_sent_emails ;;
    hidden: yes
  }

  dimension: number_of_unique_opened_emails {
    type: number
    sql: ${TABLE}.number_of_unique_opened_emails ;;
    hidden: yes
  }

  dimension: number_of_unique_engaged_messages {
    type: number
    sql: ${TABLE}.number_of_unique_engaged_messages ;;
    hidden: yes
  }

  dimension: source_number_of_sent_messages {
    type: number
    sql: ${TABLE}.number_of_sent_messages ;;
    hidden: yes
  }

  dimension: number_of_unique_orders {
    type: number
    sql: ${TABLE}.number_of_unique_orders ;;
    hidden: yes
  }

  dimension: number_of_unique_control_orders {
    type: number
    sql: ${TABLE}.number_of_unique_control_orders ;;
    hidden: yes
  }

  dimension: number_of_unique_bounced_pushes {
    type: number
    sql: ${TABLE}.number_of_unique_bounced_pushes ;;
    hidden: yes
  }

  dimension: number_of_unique_tapped_pushes {
    type: number
    sql: ${TABLE}.number_of_unique_tapped_pushes ;;
    hidden: yes
  }

  dimension: source_number_of_sent_pushes {
    type: number
    sql: ${TABLE}.number_of_sent_pushes ;;
    hidden: yes
  }

  dimension: number_of_unique_users {
    type: number
    sql: ${TABLE}.number_of_unique_users ;;
    hidden: yes
  }

  dimension: number_of_unique_control_users {
    type: number
    sql: ${TABLE}.number_of_unique_control_users ;;
    hidden: yes
  }

  dimension: amt_commercial_profit_net_eur {
    type: number
    sql: ${TABLE}.amt_commercial_profit_net_eur ;;
    hidden: yes
  }

  dimension: amt_control_commercial_profit_net_eur {
    type: number
    sql: ${TABLE}.amt_control_commercial_profit_net_eur ;;
    hidden: yes
  }

  # =========  IDs   =========

  dimension: canvas_id {
    type: string
    sql: ${TABLE}.canvas_id ;;
    hidden: yes
  }

  dimension: canvas_variation_id {
    type: string
    sql: ${TABLE}.canvas_variation_id ;;
    hidden: yes
  }

  dimension: cohort_variation_id {
    type: string
    sql: ${TABLE}.cohort_variation_id ;;
    hidden: yes
    primary_key: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  dimension: canvas_name {
    group_label: "* Cohort Dimensions *"
    label: "Canvas Name"
    description: "Name of the Braze canvas entity - marketing campaign with multiple messages and steps forming a cohesive journey"
    type: string
    sql: ${TABLE}.canvas_name ;;
  }

  dimension: country_iso {
    group_label: "* Cohort Dimensions *"
    label: "Country ISO"
    description: "Target country of the canvas"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: canvas_variation_name {
    group_label: "* Cohort Dimensions *"
    label: "Canvas Variation Name"
    description: "Name of the test/control variation within canvas"
    type: string
    sql: ${TABLE}.canvas_variation_name ;;
  }

  dimension: is_control_group {
    alias: [in_control_group]
    group_label: "* Cohort Dimensions *"
    label: "Is Control Group"
    description: "Flag stating if the variation is a control group. Only one variation per canvas can be a control group"
    type: yesno
    sql: ${TABLE}.is_control_group ;;
  }

  dimension_group: cohort {
    group_label: "* Dates and Timestamps *"
    label: "Cohort Entry"
    description: "Time when Braze users entered the canvas. Not always equal to first contact date, as the first step can be delayed from the canvas entry date"
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
    sql: ${TABLE}.cohort_date ;;
  }

  dimension_group: first_contact {
    group_label: "* Dates and Timestamps *"
    label: "First Contact"
    description: "Time of the first contact sent to users within the cohort's journey"
    type: time
    timeframes: [
      date,
      week,
      month,
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_contact_date ;;
  }

  dimension_group: last_contact {
    group_label: "* Dates and Timestamps *"
    label: "Last Contact"
    description: "Time of the last contact sent to users within the cohort's journey"
    type: time
    timeframes: [
      date,
      week,
      month,
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_contact_date ;;
  }

  dimension_group: canvas_journey_duration {
    group_label: "* Dates and Timestamps *"
    label: "Canvas Duration"
    description: "Timeframe between first and last contact within the cohort's journey"
    type: duration
    intervals: [day, week, month]
    convert_tz: no
    sql_start: ${TABLE}.first_contact_date ;;
    sql_end: ${TABLE}.last_contact_date;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  # =========  Users + Customers Ordered   =========


  measure: sum_of_number_of_unique_users {
    alias: [number_of_users]
    group_label: "* Cohort Performance *"
    label: "# Cohort Users"
    description: "Number of Braze users who entered the canvas’s cohort"
    type: sum
    sql: ${number_of_unique_users} ;;
  }

  measure: sum_of_number_of_unique_customers_ordered {
    alias: [number_of_customers_ordered]
    group_label: "* Cohort Performance *"
    label: "# Users Ordered"
    description: "Number of users who placed an order within the cohort's journey"
    type: sum
    sql: ${number_of_unique_customers_ordered};;
  }

  measure: share_of_customers_ordered {
    group_label: "* Cohort Performance *"
    label: "% Users Ordered"
    description: "Share of users who placed an order among all users within the cohort"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_customers_ordered},${sum_of_number_of_unique_users}) ;;
    value_format_name: percent_2
  }

  # === Incrementality in Customers Ordered

  #
  #
  # For calculation of incrementality we need to compare variant variation's performance with respective control group's performance.
  # Association of control group's performance metrics with variant variations is already done in dbt model.
  # That's why each cohort record has two sets of performance metrics:
  # a) primary (describing this variation cohort's performance)
  # b) and control (that describe respective control group performance).
  #
  # Incrementality should be calculated only for variant variations, that's why we are using is_control_group = "No" filter conditions.
  # This filtering logic and usage of intermediate hidden measures alows us to split primary and control metrics into respective _variant_ and _control_ groups.
  # Later we use them to calculate performance of variant and control cohorts and derive incrementality without dependency on other records.
  #
  #

  measure: sum_of_number_of_unique_control_users {
    hidden: yes
    type: sum
    sql: ${number_of_unique_control_users} ;;
    filters: {
      field: is_control_group
      value: "No"
    }
  }

  measure: sum_of_number_of_unique_control_customers_ordered {
    hidden: yes
    type: sum
    sql: ${number_of_unique_control_customers_ordered};;
    filters: {
      field: is_control_group
      value: "No"
    }
  }

  measure: share_of_control_customers_ordered {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_number_of_unique_control_customers_ordered},${sum_of_number_of_unique_control_users});;
  }

  measure: sum_of_number_of_unique_variant_users {
    hidden: yes
    type: sum
    sql: ${number_of_unique_users} ;;
    filters: {
      field: is_control_group
      value: "No"
    }
  }
  measure: sum_of_number_of_unique_variant_customers_ordered {
    hidden: yes
    type: sum
    sql: ${number_of_unique_customers_ordered};;
    filters: {
      field: is_control_group
      value: "No"
    }
  }

  measure: share_of_variant_customers_ordered {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_number_of_unique_variant_customers_ordered},${sum_of_number_of_unique_variant_users});;
  }

  measure: incrementality_of_share_of_customers_ordered {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Absolute, pp) in Users Ordered"
    description: "Difference in % of users who placed an order in variant group compared to the % of users who placed an order in control group"
    type: number
    sql: ${share_of_variant_customers_ordered} - ${share_of_control_customers_ordered} ;;
    value_format_name: percent_2
  }

  measure: incremental_lift_of_share_of_customers_ordered {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Relative, %) in Users Ordered"
    description: "% increase in share of users who placed an order in variant group compared to the share of users who placed an order in control group"
    type: number
    sql: safe_divide((${share_of_variant_customers_ordered} - ${share_of_control_customers_ordered}),
      ${share_of_control_customers_ordered}) ;;
    value_format_name: percent_2
  }

  measure: absolute_incrementality_of_share_of_customers_ordered {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Absolute, #) in Users Ordered"
    description: "Absolute number of customers who placed orders in variant group that were incrementally resulted by canvas efforts"
    type: number
    sql: ${sum_of_number_of_unique_variant_customers_ordered} * safe_divide((${share_of_variant_customers_ordered} - ${share_of_control_customers_ordered}),
      ${share_of_variant_customers_ordered}) ;;
    value_format_name: decimal_0
  }

  # === Customers Discounted Ordered

  measure: sum_of_number_of_unique_customers_discounted_ordered {
    alias: [number_of_customers_discounted_ordered]
    group_label: "* Cohort Performance *"
    label: "# Users Ordered with a Discount Code"
    description: "Number of users who placed an order with a discount code within the cohort's journey"
    type: sum
    sql: ${number_of_unique_customers_discounted_ordered} ;;
  }

  measure: share_of_customers_discounted_ordered {
    group_label: "* Cohort Performance *"
    label: "% Users Ordered with a Discount Code"
    description: "Share of users who placed an order with a discount code within the cohort's journey among all users who placed an order"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_customers_discounted_ordered},${sum_of_number_of_unique_customers_ordered}) ;;
    value_format_name: percent_2
  }


  # =========  Orders   =========


  measure: sum_of_number_of_unique_orders {
    alias: [number_of_orders]
    group_label: "* Cohort Performance *"
    label: "# Orders"
    description: "Number of orders placed by users within the cohort"
    type: sum
    sql: ${number_of_unique_orders} ;;
  }

  measure: share_of_orders_per_users {
    group_label: "* Cohort Performance *"
    label: "Order Frequency"
    description: "AVG number of orders among users within the cohort who placed at least one order"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_orders},${sum_of_number_of_unique_customers_ordered}) ;;
    value_format_name: decimal_2
  }

  measure: share_of_orders_per_contacted_users {
    group_label: "* Cohort Performance *"
    label: "AVG # Orders (per Contacted User)"
    description: "AVG number of orders among all contacted users within the cohort"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_orders},${sum_of_number_of_unique_users}) ;;
    value_format_name: decimal_2
  }

  # =========  GMV  =========

  # Step 1: Create Overall Metric
  measure: sum_of_amount_of_gmv_gross {
    group_label: "* Cohort Performance *"
    label: "SUM GMV (Gross)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (incl. VAT)"
    type: sum
    value_format_name: eur
    sql: ${amount_of_gmv_gross} ;;
  }

  # Step 2: Create Overall Variant/Control Metrics
  measure: sum_of_variant_amount_of_gmv_gross {
    hidden: yes
    type: sum
    sql: ${amount_of_gmv_gross};;
    filters: {
      field: is_control_group
      value: "No"
    }
  }

  measure: sum_of_control_amount_of_gmv_gross {
    hidden: yes
    type: sum
    sql: ${amount_of_control_gmv_gross};;
    filters: {
      field: is_control_group
      value: "No"
    }
  }

  # Step 3: Create Variant/Control per User Metrics
  measure: share_of_variant_amount_of_gmv {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_variant_amount_of_gmv_gross},${sum_of_number_of_unique_variant_users});;
  }

  measure: share_of_control_amount_of_gmv {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_control_amount_of_gmv_gross},${sum_of_number_of_unique_control_users});;
  }

  # Step 4: Overall incrementality: Difference between Variant per user and control per user
  measure: incrementality_of_share_of_amount_of_gmv {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Absolute, pp) in GMV (Gross)"
    description: "Difference in Gross GMV per user for variant group compared to Gross GMV per user in control group"
    type: number
    sql: ${share_of_variant_amount_of_gmv} - ${share_of_control_amount_of_gmv} ;;
    value_format_name: eur
  }

  # Step 5: Percentage Incrementality: Diff between Variant and control (per User) // Control per User
  measure: incremental_lift_of_share_of_amount_of_gmv {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Relative, %) in GMV (Gross)"
    description: "% increase in share of Gross GMV per user in variant group compared to Gross GMV per user in control group"
    type: number
    sql: safe_divide((${share_of_variant_amount_of_gmv} - ${share_of_control_amount_of_gmv}),
      ${share_of_control_amount_of_gmv}) ;;
    value_format_name: percent_2
  }

  # Step 6: Absolute Incrementality: % Uplift in Variant per User mutliplied by the raw variant amount.
  measure: absolute_incrementality_of_share_of_amount_of_gmv {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Absolute, #) in GMV (Gross)"
    description: "Absolute sum of Gross GMV in variant group that were incrementally resulted by canvas efforts"
    type: number
    sql: ${sum_of_variant_amount_of_gmv_gross} * safe_divide((${share_of_variant_amount_of_gmv} - ${share_of_control_amount_of_gmv}),
      ${share_of_variant_amount_of_gmv}) ;;
    value_format_name: eur
  }

  # =========  SUM of Discounts & SUM of Discounts per Order =========

      # Step 1: Create Overall Metric
    measure: sum_of_amount_of_cart_discount_gross {
      group_label: "* Cohort Performance *"
      label: "SUM Cart Discounts (Gross)"
      description: "Sum of Cart Discounts Gross (Discount Code applied at a checkout). Includes delivery discounts."
      type: sum
      sql: ${amount_of_cart_discount_gross} ;;
      value_format_name: eur
    }

  measure: sum_of_amount_of_cart_discount_gross_per_order {
    group_label: "* Cohort Performance *"
    label: "AVG Cart Discount Value"
    description: "Average Cart Discounts Value per Order"
    type: number
    sql: safe_divide(${sum_of_amount_of_cart_discount_gross},${sum_of_number_of_unique_orders}) ;;
    value_format_name: eur
  }

    # Step 2: Create Overall Variant/Control Metrics
    measure: sum_of_variant_amount_of_cart_discount_gross {
      hidden: yes
      type: sum
      sql: ${amount_of_cart_discount_gross};;
      filters: {
        field: is_control_group
        value: "No"
      }
    }

    measure: sum_of_control_amount_of_cart_discount_gross {
      hidden: yes
      type: sum
      sql: ${amount_of_control_cart_discount_gross};;
      filters: {
        field: is_control_group
        value: "No"
      }
    }

    # Step 3: Create Variant/Control per User Metrics
    measure: share_of_variant_amount_of_cart_discount_per_order {
      hidden: yes
      type: number
      sql: safe_divide(${sum_of_variant_amount_of_cart_discount_gross},${sum_of_number_of_unique_variant_orders});;
    }

    measure: share_of_control_amount_of_cart_discount_per_order {
      hidden: yes
      type: number
      sql: safe_divide(${sum_of_control_amount_of_cart_discount_gross},${sum_of_number_of_unique_control_orders});;
    }

    # Step 4: Overall incrementality: Difference between Variant per user and control per user
    measure: incrementality_of_share_of_amount_of_cart_discount {
      group_label: "* Cohort Performance *"
      label: "Incrementality (Absolute, pp) in AVG Cart Discount Value"
      description: "Difference in AVG Cart Discount Value for variant group compared to AVG Cart Discount Value in control group"
      type: number
      sql: ${share_of_variant_amount_of_cart_discount_per_order} - ${share_of_control_amount_of_cart_discount_per_order} ;;
      value_format_name: eur
    }

    # Step 5: Percentage Incrementality: Diff between Variant and control (per User) // Control per User
    measure: incremental_lift_of_share_of_amount_of_cart_discount {
      group_label: "* Cohort Performance *"
      label: "Incrementality (Relative, %) in AVG Cart Discount Value"
      description: "% increase in share of AVG Cart Discount Value in variant group compared to AVG Cart Discount Value in control group"
      type: number
      sql: safe_divide((${share_of_variant_amount_of_cart_discount_per_order} - ${share_of_control_amount_of_cart_discount_per_order}),
        ${share_of_control_amount_of_cart_discount_per_order}) ;;
      value_format_name: percent_2
    }

    # Step 6: Absolute Incrementality: % Uplift in Variant per User mutliplied by the raw variant amount.
    measure: absolute_incrementality_of_share_of_amount_of_cart_discount {
      group_label: "* Cohort Performance *"
      label: "Incrementality (Absolute, #) in AVG Cart Discount Value"
      description: "Absolute sum of AVG Cart Discount Value in variant group that were incrementally resulted by canvas efforts"
      hidden: yes
      type: number
      sql: ${share_of_variant_amount_of_cart_discount_per_order} * safe_divide((${share_of_variant_amount_of_cart_discount_per_order} - ${share_of_control_amount_of_cart_discount_per_order}),
        ${share_of_variant_amount_of_cart_discount_per_order}) ;;
      value_format_name: eur
    }

  # =========  SUM of Discounts & SUM of Discounts per GMV =========
  # Step 1: Create Overall Metric

  measure: sum_of_amount_of_cart_discount_gross_per_gmv {
    group_label: "* Cohort Performance *"
    label: "% Cart Discount Value Share"
    description: "The percentage of GMV made up of cart discounts"
    type: number
    sql: safe_divide(${sum_of_amount_of_cart_discount_gross},${sum_of_amount_of_gmv_gross});;
    value_format_name: percent_2
  }

  # Step 3: Create Variant/Control per User Metrics
  measure: share_of_variant_amount_of_cart_discount_per_gmv {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_variant_amount_of_cart_discount_gross},${sum_of_variant_amount_of_gmv_gross});;
  }

  measure: share_of_control_amount_of_cart_discount_per_gmv {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_control_amount_of_cart_discount_gross},${sum_of_control_amount_of_gmv_gross});;
  }

  # Step 4: Overall incrementality: Difference between Variant per user and control per user
  measure: incrementality_of_amount_of_cart_discount_per_gmv {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Absolute, pp) in % Cart Discount Value Share"
    description: "Difference in % Cart Discount Value Share for variant group compared to % Cart Discount Value Share in control group"
    type: number
    sql: ${share_of_variant_amount_of_cart_discount_per_gmv} - ${share_of_control_amount_of_cart_discount_per_gmv} ;;
    value_format_name: percent_2
  }

  # Step 5: Percentage Incrementality: Diff between Variant and control (per User) // Control per User
  measure: incremental_lift_of_amount_of_cart_discount_per_gmv {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Relative, %) in % Cart Discount Value Share"
    description: "% increase in % Cart Discount Value Share in variant group compared to % Cart Discount Value Share in control group"
    type: number
    sql: safe_divide((${share_of_variant_amount_of_cart_discount_per_gmv} - ${share_of_control_amount_of_cart_discount_per_gmv}),
      ${share_of_control_amount_of_cart_discount_per_gmv}) ;;
    value_format_name: percent_2
  }

  # Step 6: Absolute Incrementality: % Uplift in Variant per User mutliplied by the raw variant amount.
  measure: absolute_incrementality_of_amount_of_cart_discount_per_gmv {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Absolute, #) in % Cart Discount Value Share"
    description: "Absolute sum of % Cart Discount Value Share in variant group that were incrementally resulted by canvas efforts"
    type: number
    hidden: yes
    sql: ${share_of_variant_amount_of_cart_discount_per_gmv} * safe_divide((${share_of_variant_amount_of_cart_discount_per_gmv} - ${share_of_control_amount_of_cart_discount_per_gmv}),
      ${share_of_variant_amount_of_cart_discount_per_gmv}) ;;
    value_format_name: percent_2
  }

  # =========  AOV  =========

  # Step 1: Create Overall Metric
  measure: avg_order_value {
    group_label: "* Cohort Performance *"
    label: "AVG Order Value (Gross)"
    description: "Average value of orders considering total gross order values. Includes fees (gross), before deducting discounts."
    type: number
    sql: safe_divide(${sum_of_amount_of_gmv_gross},${sum_of_number_of_unique_orders}) ;;
    value_format_name: eur
  }

  # Step 2: Create Overall Variant/Control Metrics
  measure: variant_avg_order_value {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_variant_amount_of_gmv_gross},${sum_of_number_of_unique_variant_orders});;
  }

  measure: control_avg_order_value {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_control_amount_of_gmv_gross},${sum_of_number_of_unique_control_orders});;
 }

  # Step 3: Create Variant/Control per User Metrics
   #Not needed in this case

  # Step 4: Overall incrementality: Difference between Variant per user and control per user
  measure: incrementality_of_share_of_amount_of_average_order_value {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Absolute, pp) in AOV (Gross)"
    description: "Difference in Gross Average Order Value for variant group compared to Gross Average Order Value in control group"
    type: number
    sql: ${variant_avg_order_value} - ${control_avg_order_value} ;;
    value_format_name: eur
  }

  # Step 5: Percentage Incrementality: Diff between Variant and control (per User) // Control per User
  measure: incremental_lift_of_share_of_amount_of_average_order_value {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Relative, %) in AOV (Gross)"
    description: "% increase in share of Gross Average Order Value in variant group compared to Gross Average Order Value in control group"
    type: number
    sql: safe_divide((${variant_avg_order_value} - ${control_avg_order_value}),
      ${control_avg_order_value}) ;;
    value_format_name: percent_2
  }

  # Step 6: Absolute Incrementality: % Uplift in Variant per User mutliplied by the raw variant amount.
  measure: absolute_incrementality_of_share_of_amount_of_average_order_value {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Absolute, #) in AOV (Gross)"
    description: "Absolute sum of Gross Average Order Value in variant group that were incrementally resulted by canvas efforts"
    hidden: yes
    type: number
    sql: ${variant_avg_order_value} * safe_divide((${variant_avg_order_value} - ${control_avg_order_value}),
      ${variant_avg_order_value}) ;;
    value_format_name: eur
  }

  # =========  AIV (Average Item Value)  =========

  # Step 1: Create Overall Metric
  measure: sum_of_amount_of_total_price_gross {
    hidden: yes
    type: sum
    sql: ${amount_of_total_price_gross} ;;
  }

  measure: average_item_value {
    group_label: "* Cohort Performance *"
    label: "AVG Item Value (Gross)"
    description: "AIV represents the Average value of items (incl. VAT). Excludes fees (gross), before deducting discounts."
    type: number
    sql: safe_divide(${sum_of_amount_of_total_price_gross},${sum_of_number_of_unique_orders}) ;;
    value_format_name: eur
  }

  # Step 2: Create Overall Variant/Control Metrics
  measure: sum_of_variant_amount_of_total_price_gross {
    hidden: yes
    type: sum
    sql: ${amount_of_total_price_gross};;
    filters: {
      field: is_control_group
      value: "No"
    }
  }

  measure: sum_of_control_amount_of_total_price_gross {
    hidden: yes
    type: sum
    sql: ${amount_of_control_total_price_gross};;
    filters: {
      field: is_control_group
      value: "No"
    }
  }

  measure: variant_avg_item_value {
    hidden: yes
    type: number
    sql: NULLIF(${sum_of_variant_amount_of_total_price_gross},0)/NULLIF(${sum_of_number_of_unique_variant_orders},0);;
  }

  measure: control_avg_item_value {
    hidden: yes
    type: number
    sql: NULLIF(${sum_of_control_amount_of_total_price_gross},0)/NULLIF(${sum_of_number_of_unique_control_orders},0);;
  }

  # Step 3: Create Variant/Control per User Metrics
  #Not needed here as there are averages

  # Step 4: Overall incrementality: Difference between Variant per user and control per user
  measure: incrementality_of_share_of_amount_of_average_item_value {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Absolute, pp) in AIV (Gross)"
    description: "Difference in Gross Average Item Value for variant group compared to Gross Average Item Value in control group"
    type: number
    sql: ${variant_avg_item_value} - ${control_avg_item_value} ;;
    value_format_name: eur
  }

  # Step 5: Percentage Incrementality: Diff between Variant and control (per User) // Control per User
  measure: incremental_lift_of_share_of_amount_of_average_item_value {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Relative, %) in AIV (Gross)"
    description: "% increase in share of Gross Average Item Value in variant group compared to Gross Average Item Value in control group"
    type: number
    sql: safe_divide((${variant_avg_item_value} - ${control_avg_item_value}),
      ${control_avg_item_value}) ;;
    value_format_name: percent_2
  }

  # Step 6: Absolute Incrementality: % Uplift in Variant per User mutliplied by the raw variant amount.
  measure: absolute_incrementality_of_share_of_amount_of_average_item_value {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Absolute, #) in AIV (Gross)"
    description: "Absolute sum of Gross Average Item Value in variant group that were incrementally resulted by canvas efforts"
    hidden: yes
    type: number
    sql: ${variant_avg_item_value} * safe_divide((${variant_avg_item_value} - ${control_avg_item_value}),
      ${variant_avg_item_value}) ;;
    value_format_name: eur
  }

  # === Incrementality in AVG number of orders

  measure: sum_of_number_of_unique_control_orders {
    hidden: yes
    type: sum
    sql: ${number_of_unique_control_orders};;
    filters: {
      field: is_control_group
      value: "No"
    }
  }

  measure: avg_number_of_orders_per_control_cohort_users {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_number_of_unique_control_orders},${sum_of_number_of_unique_control_users});;
  }

  measure: sum_of_number_of_unique_variant_orders {
    hidden: yes
    type: sum
    sql: ${number_of_unique_orders};;
    filters: {
      field: is_control_group
      value: "No"
    }
  }

  measure: avg_number_of_orders_per_variant_cohort_users {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_number_of_unique_variant_orders},${sum_of_number_of_unique_variant_users});;
  }

  measure: relative_incrementality_of_avg_number_of_orders_per_contacted_user {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Relative, %) in AVG # Orders (per Contacted User)"
    description: "% increase in AVG number of orders per contacted user in variant group compared to the AVG number of orders in control group"
    type: number
    sql: safe_divide((${avg_number_of_orders_per_variant_cohort_users} - ${avg_number_of_orders_per_control_cohort_users}),
      ${avg_number_of_orders_per_control_cohort_users}) ;;
    value_format_name: percent_2
  }

  measure: absolute_incrementality_of_avg_number_of_orders_per_contacted_user {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Absolute, #) in Orders"
    description: "Absolute number of orders placed by variant group that were incrementally resulted by canvas efforts"
    type: number
    sql: ${sum_of_number_of_unique_variant_orders} * safe_divide((${avg_number_of_orders_per_variant_cohort_users} - ${avg_number_of_orders_per_control_cohort_users}),
      ${avg_number_of_orders_per_variant_cohort_users}) ;;
    value_format_name: decimal_0
  }

  # === Discounted Orders

  measure: sum_of_number_of_unique_discounted_orders {
    alias: [number_of_discounted_orders]
    group_label: "* Cohort Performance *"
    label: "# Discounted Orders"
    description: "Number of orders with discount codes placed by users within the cohort"
    type: sum
    sql: ${number_of_unique_discounted_orders} ;;
  }

  measure: share_of_discounted_orders {
    group_label: "* Cohort Performance *"
    label: "% Discounted Orders"
    description: "Share of orders with discount codes placed by users within the cohort's journey among all orders placed by the cohort"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_discounted_orders},${sum_of_number_of_unique_orders}) ;;
    value_format_name: percent_2
  }

  measure: share_of_discounted_orders_per_users {
    group_label: "* Cohort Performance *"
    label: "Discounted Order Frequency"
    description: "AVG number of discounted orders among users within the cohort who placed at least one any order"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_discounted_orders},${sum_of_number_of_unique_customers_ordered}) ;;
    value_format_name: decimal_2
  }


  # =========  Commercial Profit   =========

  # === Incrementality in Commercial Profit

  measure: sum_of_amt_control_commercial_profit_net_eur {
    hidden: yes
    type: sum
    sql: ${amt_control_commercial_profit_net_eur};;
    filters: {
      field: is_control_group
      value: "No"
    }
  }

  measure: avg_amt_commercial_profit_per_control_cohort_users {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_amt_control_commercial_profit_net_eur},${sum_of_number_of_unique_control_users});;
  }

  measure: sum_of_amt_variant_commercial_profit_net_eur {
    hidden: yes
    type: sum
    sql: ${amt_commercial_profit_net_eur};;
    filters: {
      field: is_control_group
      value: "No"
    }
  }

  measure: avg_amt_commercial_profit_per_variant_cohort_users {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_amt_variant_commercial_profit_net_eur},${sum_of_number_of_unique_variant_users});;
  }

  measure: relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Relative, %) in AVG Commercial Profit (per Contacted User)"
    description: "% increase in AVG commercial profit per contacted user compared to AVG commercial profit in control group"
    type: number
    sql: safe_divide((${avg_amt_commercial_profit_per_variant_cohort_users} - ${avg_amt_commercial_profit_per_control_cohort_users}),
      ${avg_amt_commercial_profit_per_control_cohort_users}) ;;
    value_format_name: percent_2
  }


  # =========  Daily Visits   =========


  measure: sum_of_number_of_unique_daily_visits {
    alias: [number_of_daily_visits]
    group_label: "* Cohort Performance *"
    label: "# Customer Visits (Days)"
    description: "Aggregated total number of days each user was active within the cohort's journey. We can't calculate the absolute number of visits by each customer on a particular day, we calculate only one visit per day"
    type: sum
    sql: ${number_of_unique_daily_visits} ;;
  }

  measure: sum_of_number_of_unique_customers_visited {
    alias: [number_of_customers_visited]
    group_label: "* Cohort Performance *"
    label: "# Users Visited"
    description: "Number of users who visited the app or web within the cohort's journey"
    type: sum
    sql: ${number_of_unique_customers_visited} ;;
  }

  measure: share_of_daily_visits_per_users {
    group_label: "* Cohort Performance *"
    label: "Visit Frequency (Days)"
    description: "AVG number of days with visits among users within the cohort who have at least one visit"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_daily_visits},${sum_of_number_of_unique_customers_visited}) ;;
    value_format_name: decimal_2
  }

  measure: share_of_customers_visited {
    group_label: "* Cohort Performance *"
    label: "% Users Visited"
    description: "Share of users who visited the app or web within the cohort's journey among all users"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_customers_visited},${sum_of_number_of_unique_users}) ;;
    value_format_name: percent_2
  }

  # === Incrementality in Daily Visits

  measure: sum_of_number_of_unique_control_customers_visited {
    hidden: yes
    type: sum
    sql: ${number_of_unique_control_customers_visited} ;;
    filters: {
      field: is_control_group
      value: "No"
    }
  }

  measure: share_of_control_customers_visited {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_number_of_unique_control_customers_visited},${sum_of_number_of_unique_control_users});;
  }

  measure: sum_of_number_of_unique_variant_customers_visited {
    hidden: yes
    type: sum
    sql: ${number_of_unique_customers_visited} ;;
    filters: {
      field: is_control_group
      value: "No"
    }
  }

  measure: share_of_variant_customers_visited {
    hidden: yes
    type: number
    sql: safe_divide(${sum_of_number_of_unique_variant_customers_visited},${sum_of_number_of_unique_variant_users});;
  }

  measure: incrementality_of_share_of_customers_visited {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Absolute, pp) in Users Visited"
    description: "Positive difference in share of users who visited app or web in variant group compared to the share of users who visited app or web in control group"
    type: number
    sql: ${share_of_variant_customers_visited} - ${share_of_control_customers_visited};;
    value_format_name: percent_2
  }

  measure: incremental_lift_of_share_of_customers_visited {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Relative, %) in Users Visited"
    description: "% increase in share of users who visited app or web in variant group compared to the share of users who visited app or web in control group"
    type: number
    sql: safe_divide((${share_of_variant_customers_visited} - ${share_of_control_customers_visited}),
      ${share_of_control_customers_visited}) ;;
    value_format_name: percent_2
  }

  measure: absolute_incrementality_of_share_of_customers_visited {
    group_label: "* Cohort Performance *"
    label: "Incrementality (Absolute, #) in Users Visited"
    description: "Absolute number of customers who made a daily visit in variant group that were incrementally resulted by canvas efforts"
    type: number
    sql: ${sum_of_number_of_unique_variant_customers_visited} * safe_divide((${share_of_variant_customers_visited} - ${share_of_control_customers_visited}),
      ${share_of_variant_customers_visited}) ;;
    value_format_name: decimal_0
  }


  # =========  Messages   =========


  measure: sum_of_number_of_sent_messages {
    alias: [number_of_sent_messages]
    group_label: "* Message Performance *"
    label: "# Sent Messages"
    description: "Number of messages sent to variant group users within the cohort's journey"
    type: sum
    sql: ${source_number_of_sent_messages} ;;
  }

  measure: sum_of_number_of_unique_engaged_messages {
    alias: [number_of_engaged_messages]
    group_label: "* Message Performance *"
    label: "# Engaged Messages"
    description: "Number of messages sent to variant users which were either tapped or clicked"
    type: sum
    sql: ${number_of_unique_engaged_messages} ;;
  }

  measure: share_of_engaged_messages {
    group_label: "* Message Performance *"
    label: "% Engaged Messages"
    description: "Share of either tapped or clicked messages among all messages sent to variant group"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_engaged_messages},${sum_of_number_of_sent_messages}) ;;
    value_format_name: percent_2
  }

  # === Emails

  measure: sum_of_number_of_sent_emails {
    alias: [number_of_sent_emails]
    group_label: "* Message Performance *"
    label: "# Sent Emails"
    description: "Number of emails sent to variant group within the cohort's journey"
    type: sum
    sql: ${source_number_of_sent_emails} ;;
  }

  measure: share_of_sent_emails {
    group_label: "* Message Performance *"
    label: "% Sent Emails"
    description: "Share of emails sent to variant group amongh all messages sent to variant group within the cohort's journey"
    type: number
    sql: safe_divide(${sum_of_number_of_sent_emails},${sum_of_number_of_sent_messages}) ;;
    value_format_name: percent_2
  }

  measure: sum_of_number_of_unique_delivered_emails {
    alias: [number_of_delivered_emails]
    group_label: "* Message Performance *"
    label: "# Delivered Emails"
    description: "Number of delivered emails"
    type: sum
    sql: ${number_of_unique_delivered_emails} ;;
  }

  measure: share_of_delivered_emails {
    group_label: "* Message Performance *"
    label: "% Delivered Emails"
    description: "Share of delivered emails among all sent emails"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_delivered_emails},${sum_of_number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: sum_of_number_of_unique_bounced_emails {
    alias: [number_of_bounced_emails]
    group_label: "* Message Performance *"
    label: "# Bounced Emails"
    description: "Number of bounced emails"
    type: sum
    sql: ${number_of_unique_bounced_emails};;
  }

  measure: share_of_bounced_emails {
    group_label: "* Message Performance *"
    label: "% Bounced Emails"
    description: "Share of bounced emails among all sent emails"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_bounced_emails},${sum_of_number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: sum_of_number_of_unique_soft_bounced_emails {
    alias: [number_of_soft_bounced_emails]
    group_label: "* Message Performance *"
    label: "# Soft Bounced Emails"
    description: "Number of soft bounced emails"
    type: sum
    sql: ${number_of_unique_soft_bounced_emails} ;;
  }

  measure: share_of_soft_bounced_emails {
    group_label: "* Message Performance *"
    label: "% Soft Bounced Emails"
    description: "Share of soft bounced emails among all sent emails"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_soft_bounced_emails},${sum_of_number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: sum_of_number_of_unique_generally_opened_emails {
    alias: [number_of_general_opened_emails]
    group_label: "* Message Performance *"
    label: "# General Opened Emails"
    description: "Number of emails that were opened"
    type: sum
    sql: ${number_of_unique_generally_opened_emails} ;;
  }

  measure: share_of_generally_opened_emails {
    group_label: "* Message Performance *"
    label: "% General Opened Emails"
    description: "Share of generally opened emails among all sent emails"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_generally_opened_emails},${sum_of_number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: sum_of_number_of_general_email_opens {
    alias: [number_of_email_general_opens]
    group_label: "* Message Performance *"
    label: "# General Email Opens"
    description: "Total number of times emails were opened"
    type: sum
    sql: ${number_of_general_email_opens} ;;
  }

  measure: sum_of_number_of_unique_opened_emails {
    alias: [number_of_email_unique_opens]
    group_label: "* Message Performance *"
    label: "# Unique Email Opens"
    description: "Number of uniquely opened emails - unque opens are caluclated according to Braze's approach for dealing with machine opens"
    type: sum
    sql: ${number_of_unique_opened_emails} ;;
  }

  measure: share_of_unique_opened_emails {
    group_label: "* Message Performance *"
    label: "% Unique Opened Emails"
    description: "Share of unique opened emails among all sent emails"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_opened_emails},${sum_of_number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: sum_of_number_of_unique_clicked_emails {
    alias: [number_of_clicked_emails]
    group_label: "* Message Performance *"
    label: "# Clicked Emails"
    description: "Number of emails that were clicked"
    type: sum
    sql: ${number_of_unique_clicked_emails} ;;
  }

  measure: share_of_clicked_emails {
    group_label: "* Message Performance *"
    label: "% Clicked Emails"
    description: "Share of clicked emails among all sent emails"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_clicked_emails},${sum_of_number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: share_of_clicked_emails_among_opened_emails {
    group_label: "* Message Performance *"
    label: "% Click-to-Open Rate"
    description: "Share of clicked emails among all open emails"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_clicked_emails},${sum_of_number_of_unique_opened_emails}) ;;
    value_format_name: percent_2
  }

  measure: sum_of_number_of_email_clicks {
    alias: [number_of_email_clicks]
    group_label: "* Message Performance *"
    label: "# Email Clicks"
    description: "Number of times emails were clicked"
    type: sum
    sql: ${source_number_of_email_clicks} ;;
  }

  measure: sum_of_number_of_unique_unsubscribed_emails {
    alias: [number_of_unsubscribed_emails]
    group_label: "* Message Performance *"
    label: "# Unsubscribed Emails"
    description: "Number of emails that caused unsubscribtion"
    type: sum
    sql: ${number_of_unique_unsubscribed_emails} ;;
  }

  measure: share_of_unsubscribed_emails {
    group_label: "* Message Performance *"
    label: "% Unsubscribed Emails"
    description: "Number of emails that caused unsubscribtion among all sent emails"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_unsubscribed_emails},${sum_of_number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  # === Push Notifications

  measure: sum_of_number_of_sent_pushes {
    alias: [number_of_sent_pushes]
    group_label: "* Message Performance *"
    label: "# Sent Pushes"
    description: "Number of push messages sent to variant group within the cohort's journey"
    type: sum
    sql: ${source_number_of_sent_pushes} ;;
  }

  measure: share_of_sent_pushes {
    group_label: "* Message Performance *"
    label: "% Sent Pushes"
    description: "Share of push messages sent to variant group amongh all messages sent to variant group within the cohort's journey"
    type: number
    sql: safe_divide(${sum_of_number_of_sent_pushes},${sum_of_number_of_sent_messages}) ;;
    value_format_name: percent_2
  }

  measure: sum_of_number_of_unique_bounced_pushes {
    alias: [number_of_bounced_pushes]
    group_label: "* Message Performance *"
    label: "# Bounced Pushes"
    description: "Number of push messages that bounced"
    type: sum
    sql: ${number_of_unique_bounced_pushes} ;;
  }

  measure: share_of_bounced_pushes {
    group_label: "* Message Performance *"
    label: "% Bounced Pushes"
    description: "Share of push messages that bounced among all push messages that were sent"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_bounced_pushes},${sum_of_number_of_sent_pushes}) ;;
    value_format_name: percent_2
  }

  measure: sum_of_number_of_unique_tapped_pushes {
    alias: [number_of_tapped_pushes]
    group_label: "* Message Performance *"
    label: "# Tapped Pushes"
    description: "Number of push messages that were tapped"
    type: sum
    sql: ${number_of_unique_tapped_pushes} ;;
  }

  measure: share_of_tapped_pushes {
    group_label: "* Message Performance *"
    label: "% Tapped Pushes"
    description: "Share of push messages that were tapped among all push messages that were sent"
    type: number
    sql: safe_divide(${sum_of_number_of_unique_tapped_pushes},${sum_of_number_of_sent_pushes}) ;;
    value_format_name: percent_2
  }

}
