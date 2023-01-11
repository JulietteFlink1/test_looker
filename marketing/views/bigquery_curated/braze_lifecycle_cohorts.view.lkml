### Author: Artem Avramenko
### Created: 2022-12-13

### This view represents data for reporting on CRM canvas lifecycles efficiency.

view: braze_lifecycle_cohorts {
  sql_table_name: `flink-data-dev.dbt_aavramenko_curated.braze_lifecycle_cohorts_v2` --`flink-data-prod.curated.braze_lifecycle_cohorts`
    ;;
  view_label: "* CRM Lifecycle Canvases *"

  # =========  hidden   =========

  dimension: customers_discounted_ordered_count {
    type: number
    sql: ${TABLE}.customers_discounted_ordered_count ;;
    hidden: yes
  }

  dimension: control_customers_discounted_ordered_count {
    type: number
    sql: ${TABLE}.control_customers_discounted_ordered_count ;;
    hidden: yes
  }

  dimension: customers_ordered_count {
    type: number
    sql: ${TABLE}.customers_ordered_count ;;
    hidden: yes
  }

  dimension: control_customers_ordered_count {
    type: number
    sql: ${TABLE}.control_customers_ordered_count ;;
    hidden: yes
  }

  dimension: customers_visited_count {
    type: number
    sql: ${TABLE}.customers_visited_count ;;
    hidden: yes
  }

  dimension: control_customers_visited_count {
    type: number
    sql: ${TABLE}.control_customers_visited_count ;;
    hidden: yes
  }

  dimension: daily_visits_count {
    type: number
    sql: ${TABLE}.daily_visits_count ;;
    hidden: yes
  }

  dimension: control_daily_visits_count {
    type: number
    sql: ${TABLE}.control_daily_visits_count ;;
    hidden: yes
  }

  dimension: discounted_orders_count {
    type: number
    sql: ${TABLE}.discounted_orders_count ;;
    hidden: yes
  }

  dimension: control_discounted_orders_count {
    type: number
    sql: ${TABLE}.control_discounted_orders_count ;;
    hidden: yes
  }

  dimension: email_clicked_count {
    type: number
    sql: ${TABLE}.email_clicked_count ;;
    hidden: yes
  }

  dimension: email_general_opens_count {
    type: number
    sql: ${TABLE}.email_general_opens_count ;;
    hidden: yes
  }

  dimension: email_is_bounced_count {
    type: number
    sql: ${TABLE}.email_is_bounced_count ;;
    hidden: yes
  }

  dimension: email_is_clicked_count {
    type: number
    sql: ${TABLE}.email_is_clicked_count ;;
    hidden: yes
  }

  dimension: email_is_delivered_count {
    type: number
    sql: ${TABLE}.email_is_delivered_count ;;
    hidden: yes
  }

  dimension: email_is_general_opened_count {
    type: number
    sql: ${TABLE}.email_is_general_opened_count ;;
    hidden: yes
  }

  dimension: email_is_soft_bounced_count {
    type: number
    sql: ${TABLE}.email_is_soft_bounced_count ;;
    hidden: yes
  }

  dimension: email_is_unsubscribed_count {
    type: number
    sql: ${TABLE}.email_is_unsubscribed_count ;;
    hidden: yes
  }

  dimension: email_sent_count {
    type: number
    sql: ${TABLE}.email_sent_count ;;
    hidden: yes
  }

  dimension: email_unique_opens_count {
    type: number
    sql: ${TABLE}.email_unique_opens_count ;;
    hidden: yes
  }

  dimension: message_is_engaged_count {
    type: number
    sql: ${TABLE}.message_is_engaged_count ;;
    hidden: yes
  }

  dimension: message_sent_count {
    type: number
    sql: ${TABLE}.message_sent_count ;;
    hidden: yes
  }

  dimension: orders_count {
    type: number
    sql: ${TABLE}.orders_count ;;
    hidden: yes
  }

  dimension: control_orders_count {
    type: number
    sql: ${TABLE}.control_orders_count ;;
    hidden: yes
  }

  dimension: push_is_bounced_count {
    type: number
    sql: ${TABLE}.push_is_bounced_count ;;
    hidden: yes
  }

  dimension: push_is_tapped_count {
    type: number
    sql: ${TABLE}.push_is_tapped_count ;;
    hidden: yes
  }

  dimension: push_sent_count {
    type: number
    sql: ${TABLE}.push_sent_count ;;
    hidden: yes
  }

  dimension: users_count {
    type: number
    sql: ${TABLE}.users_count ;;
    hidden: yes
  }

  dimension: control_users_count {
    type: number
    sql: ${TABLE}.control_users_count ;;
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
    label: "Canvas Variation"
    description: "Name of the test/control variation within canvas"
    type: string
    sql: ${TABLE}.canvas_variation_name ;;
  }

  dimension: in_control_group {
    group_label: "* Cohort Dimensions *"
    label: "Is Control Group"
    description: "Flag stating if the variation is a control group. Only one variation per canvas can be a control group"
    type: yesno
    sql: ${TABLE}.in_control_group ;;
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

  measure: number_of_users {
    group_label: "* Cohort Performance *"
    label: "# Cohort Users"
    description: "Number of Braze users who entered the canvas’s cohort"
    type: sum
    sql: ${users_count} ;;
  }

  measure: number_of_variant_users {
    hidden: yes
    type: sum
    sql: ${users_count} ;;
    filters: {
      field: in_control_group
      value: "No"
    }
  }

  measure: number_of_control_users {
    hidden: yes
    type: sum
    sql: ${control_users_count} ;;
    filters: {
      field: in_control_group
      value: "No"
    }
  }

  measure: number_of_sent_messages {
    group_label: "* Message Performance *"
    label: "# Sent Messages"
    description: "Number of messages sent to variant group users within the cohort's journey"
    type: sum
    sql: ${message_sent_count} ;;
  }

  measure: number_of_engaged_messages {
    group_label: "* Message Performance *"
    label: "# Engaged Messages"
    description: "Number of messages sent to variant users which were either tapped or clicked"
    type: sum
    sql: ${message_is_engaged_count} ;;
  }

  measure: share_of_engaged_messages {
    group_label: "* Message Performance *"
    label: "% Engaged Messages"
    description: "Share of either tapped or clicked messages among all messages sent to variant group"
    type: number
    sql: safe_divide(${number_of_engaged_messages},${number_of_sent_messages}) ;;
    value_format_name: percent_2
  }

  measure: number_of_customers_ordered {
    group_label: "* Cohort Performance *"
    label: "# Users Ordered"
    description: "Number of users who placed an order within the cohort's journey"
    type: sum
    sql: ${customers_ordered_count};;
  }

  measure: number_of_variant_customers_ordered {
    hidden: yes
    type: sum
    sql: ${customers_ordered_count};;
    filters: {
      field: in_control_group
      value: "No"
    }
  }

  measure: number_of_control_customers_ordered {
    hidden: yes
    type: sum
    sql: ${control_customers_ordered_count};;
    filters: {
      field: in_control_group
      value: "No"
    }
  }

  measure: share_of_variant_customers_ordered {
    hidden: yes
    type: number
    sql: safe_divide(${number_of_variant_customers_ordered},${number_of_variant_users});;
  }

  measure: share_of_control_customers_ordered {
    hidden: yes
    type: number
    sql: safe_divide(${number_of_control_customers_ordered},${number_of_control_users});;
  }

  measure: share_of_customers_ordered {
    group_label: "* Cohort Performance *"
    label: "% Users Ordered"
    description: "Share of users who placed an order among all users within the cohort"
    type: number
    sql: safe_divide(${number_of_customers_ordered},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: incrementality_of_share_of_customers_ordered {
    group_label: "* Cohort Performance *"
    label: "Incrementality - Δ ppt. in Users Ordered"
    description: "Positive difference in share of users who placed an order in variant group compared to the share of users who placed an order in control group"
    type: number
    sql: (${share_of_variant_customers_ordered} - ${share_of_control_customers_ordered}) * 100 ;;
    value_format_name: decimal_2
  }

  measure: incremental_lift_of_share_of_customers_ordered {
    group_label: "* Cohort Performance *"
    label: "Incremental lift - Δ % in Users Ordered"
    description: "% increase in share of users who placed an order in variant group compared to the share of users who placed an order in control group"
    type: number
    sql: safe_divide((${share_of_variant_customers_ordered} - ${share_of_control_customers_ordered}),
    ${share_of_control_customers_ordered}) ;;
    value_format_name: percent_2
  }

  measure: number_of_orders {
    group_label: "* Cohort Performance *"
    label: "# Orders"
    description: "Number of orders placed by users within the cohort"
    type: sum
    sql: ${orders_count} ;;
  }

  measure: share_of_orders_per_users {
    group_label: "* Cohort Performance *"
    label: "Order Frequency"
    description: "AVG number of orders among users within the cohort who placed at least one order"
    type: number
    sql: safe_divide(${number_of_orders},${number_of_customers_ordered}) ;;
    value_format_name: decimal_2
  }

  measure: number_of_customers_visited {
    group_label: "* Cohort Performance *"
    label: "# Users Visited"
    description: "Number of users who visited the app or web within the cohort's journey"
    type: sum
    sql: ${customers_visited_count} ;;
  }

  measure: number_of_variant_customers_visited {
    hidden: yes
    type: sum
    sql: ${customers_visited_count} ;;
    filters: {
      field: in_control_group
      value: "No"
    }
  }

  measure: number_of_control_customers_visited {
    hidden: yes
    type: sum
    sql: ${control_customers_visited_count} ;;
    filters: {
      field: in_control_group
      value: "No"
    }
  }

  measure: share_of_variant_customers_visited {
    hidden: yes
    type: number
    sql: safe_divide(${number_of_variant_customers_visited},${number_of_variant_users});;
  }

  measure: share_of_control_customers_visited {
    hidden: yes
    type: number
    sql: safe_divide(${number_of_control_customers_visited},${number_of_control_users});;
  }

  measure: share_of_customers_visited {
    group_label: "* Cohort Performance *"
    label: "% Users Visited"
    description: "Share of users who visited the app or web within the cohort's journey among all users"
    type: number
    sql: safe_divide(${number_of_customers_visited},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: incrementality_of_share_of_customers_visited {
    group_label: "* Cohort Performance *"
    label: "Incrementality - Δ ppt. in Users Visited"
    description: "Positive difference in share of users who visited app or web in variant group compared to the share of users who visited app or web in control group"
    type: number
    sql: (${share_of_variant_customers_visited} - ${share_of_control_customers_visited}) * 100 ;;
    value_format_name: decimal_2
  }

  measure: incremental_lift_of_share_of_customers_visited {
    group_label: "* Cohort Performance *"
    label: "Incremental lift - Δ % in Users Visited"
    description: "% increase in share of users who visited app or web in variant group compared to the share of users who visited app or web in control group"
    type: number
    sql: safe_divide((${share_of_variant_customers_visited} - ${share_of_control_customers_visited}),
    ${share_of_control_customers_visited}) ;;
    value_format_name: percent_2
  }

  measure: number_of_daily_visits {
    group_label: "* Cohort Performance *"
    label: "# Customer Visits (Days)"
    description: "Aggregated total number of days each user was active within the cohort's journey. We can't calculate the absolute number of visits by each customer on a particular day, we calculate only one visit per day"
    type: sum
    sql: ${daily_visits_count} ;;
  }

  measure: share_of_daily_visits_per_users {
    group_label: "* Cohort Performance *"
    label: "Visit Frequency (Days)"
    description: "AVG number of days with visits among users within the cohort who have at least one visit"
    type: number
    sql: safe_divide(${number_of_daily_visits},${number_of_customers_visited}) ;;
    value_format_name: decimal_2
  }

  measure: number_of_customers_discounted_ordered {
    group_label: "* Cohort Performance *"
    label: "# Users Ordered with a Discount Code"
    description: "Number of users who placed an order with a discount code within the cohort's journey"
    type: sum
    sql: ${customers_discounted_ordered_count} ;;
  }

  measure: share_of_customers_discounted_ordered {
    group_label: "* Cohort Performance *"
    label: "% Users Ordered with a Discount Code"
    description: "Share of users who placed an order with a discount code within the cohort's journey among all users who placed an order"
    type: number
    sql: safe_divide(${number_of_customers_discounted_ordered},${number_of_customers_ordered}) ;;
    value_format_name: percent_2
  }

  measure: number_of_discounted_orders {
    group_label: "* Cohort Performance *"
    label: "# Discounted Orders"
    description: "Number of orders with discount codes placed by users within the cohort"
    type: sum
    sql: ${discounted_orders_count} ;;
  }

  measure: share_of_discounted_orders {
    group_label: "* Cohort Performance *"
    label: "% Discounted Orders"
    description: "Share of orders with discount codes placed by users within the cohort's journey among all orders placed by the cohort"
    type: number
    sql: safe_divide(${number_of_discounted_orders},${number_of_orders}) ;;
    value_format_name: percent_2
  }

  measure: share_of_discounted_orders_per_users {
    group_label: "* Cohort Performance *"
    label: "Discounted Order Frequency"
    description: "AVG number of discounted orders among users within the cohort who placed at least one any order"
    type: number
    sql: safe_divide(${number_of_discounted_orders},${number_of_customers_ordered}) ;;
    value_format_name: decimal_2
  }

  measure: number_of_sent_emails {
    group_label: "* Message Performance *"
    label: "# Sent Emails"
    description: "Number of emails sent to variant group within the cohort's journey"
    type: sum
    sql: ${email_sent_count} ;;
  }

  measure: share_of_sent_emails {
    group_label: "* Message Performance *"
    label: "% Sent Emails"
    description: "Share of emails sent to variant group amongh all messages sent to variant group within the cohort's journey"
    type: number
    sql: safe_divide(${number_of_sent_emails},${number_of_sent_messages}) ;;
    value_format_name: percent_2
  }

  measure: number_of_delivered_emails {
    group_label: "* Message Performance *"
    label: "# Delivered Emails"
    description: "Number of delivered emails"
    type: sum
    sql: ${email_is_delivered_count} ;;
  }

  measure: share_of_delivered_emails {
    group_label: "* Message Performance *"
    label: "% Delivered Emails"
    description: "Share of delivered emails among all sent emails"
    type: number
    sql: safe_divide(${number_of_delivered_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_bounced_emails {
    group_label: "* Message Performance *"
    label: "# Bounced Emails"
    description: "Number of bounced emails"
    type: sum
    sql: ${email_is_bounced_count};;
  }

  measure: share_of_bounced_emails {
    group_label: "* Message Performance *"
    label: "% Bounced Emails"
    description: "Share of bounced emails among all sent emails"
    type: number
    sql: safe_divide(${number_of_bounced_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_soft_bounced_emails {
    group_label: "* Message Performance *"
    label: "# Soft Bounced Emails"
    description: "Number of soft bounced emails"
    type: sum
    sql: ${email_is_soft_bounced_count} ;;
  }

  measure: share_of_soft_bounced_emails {
    group_label: "* Message Performance *"
    label: "% Soft Bounced Emails"
    description: "Share of soft bounced emails among all sent emails"
    type: number
    sql: safe_divide(${number_of_soft_bounced_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_clicked_emails {
    group_label: "* Message Performance *"
    label: "# Clicked Emails"
    description: "Number of emails that were clicked"
    type: sum
    sql: ${email_is_clicked_count} ;;
  }

  measure: share_of_clicked_emails {
    group_label: "* Message Performance *"
    label: "% Clicked Emails"
    description: "Share of clicked emails among all sent emails"
    type: number
    sql: safe_divide(${number_of_clicked_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_email_clicks {
    group_label: "* Message Performance *"
    label: "# Email Clicks"
    description: "Number of times emails were clicked"
    type: sum
    sql: ${email_clicked_count} ;;
  }

  measure: number_of_general_opened_emails {
    group_label: "* Message Performance *"
    label: "# General Opened Emails"
    description: "Number of emails that were opened"
    type: sum
    sql: ${email_is_general_opened_count} ;;
  }

  measure: number_of_email_general_opens {
    group_label: "* Message Performance *"
    label: "# General Email Opens"
    description: "Total number of times emails were opened"
    type: sum
    sql: ${email_general_opens_count} ;;
  }

  measure: number_of_email_unique_opens {
    group_label: "* Message Performance *"
    label: "# Unique Email Opens"
    description: "Number of uniquely opened emails - unque opens are caluclated according to Braze's approach for dealing with machine opens"
    type: sum
    sql: ${email_unique_opens_count} ;;
  }

  measure: number_of_unsubscribed_emails {
    group_label: "* Message Performance *"
    label: "# Unsubscribed Emails"
    description: "Number of emails that caused unsubscribtion"
    type: sum
    sql: ${email_is_unsubscribed_count} ;;
  }

  measure: share_of_unsubscribed_emails {
    group_label: "* Message Performance *"
    label: "% Unsubscribed Emails"
    description: "Number of emails that caused unsubscribtion among all sent emails"
    type: number
    sql: safe_divide(${number_of_unsubscribed_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_sent_pushes {
    group_label: "* Message Performance *"
    label: "# Sent Pushes"
    description: "Number of push messages sent to variant group within the cohort's journey"
    type: sum
    sql: ${push_sent_count} ;;
  }

  measure: share_of_sent_pushes {
    group_label: "* Message Performance *"
    label: "% Sent Pushes"
    description: "Share of push messages sent to variant group amongh all messages sent to variant group within the cohort's journey"
    type: number
    sql: safe_divide(${number_of_sent_pushes},${number_of_sent_messages}) ;;
    value_format_name: percent_2
  }

  measure: number_of_bounced_pushes {
    group_label: "* Message Performance *"
    label: "# Bounced Pushes"
    description: "Number of push messages that bounced"
    type: sum
    sql: ${push_is_bounced_count} ;;
  }

  measure: share_of_bounced_pushes {
    group_label: "* Message Performance *"
    label: "% Bounced Pushes"
    description: "Share of push messages that bounced among all push messages that were sent"
    type: number
    sql: safe_divide(${number_of_bounced_pushes},${number_of_sent_pushes}) ;;
    value_format_name: percent_2
  }

  measure: number_of_tapped_pushes {
    group_label: "* Message Performance *"
    label: "# Tapped Pushes"
    description: "Number of push messages that were tapped"
    type: sum
    sql: ${push_is_tapped_count} ;;
  }

  measure: share_of_tapped_pushes {
    group_label: "* Message Performance *"
    label: "% Tapped Pushes"
    description: "Share of push messages that were tapped among all push messages that were sent"
    type: number
    sql: safe_divide(${number_of_tapped_pushes},${number_of_sent_pushes}) ;;
    value_format_name: percent_2
  }

}
