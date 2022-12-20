### Author: Artem Avramenko
### Created: 2022-12-13

### This view represents data for reporting on CRM canvas lifecycles efficiency.

view: braze_lifecycle_cohorts {
  sql_table_name: `flink-data-dev.dbt_aavramenko_curated.braze_lifecycle_cohorts_v2`
    ;;
  view_label: "* CRM Canvas Lifecycle Cohorts *"

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
    type: string
    sql: ${TABLE}.canvas_name ;;
  }

  dimension: country_iso {
    group_label: "* Cohort Dimensions *"
    label: "Country ISO"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: canvas_variation_name {
    group_label: "* Cohort Dimensions *"
    label: "Canvas Variation Name"
    type: string
    sql: ${TABLE}.canvas_variation_name ;;
  }

  dimension: in_control_group {
    group_label: "* Cohort Dimensions *"
    label: "Is Control Group"
    type: yesno
    sql: ${TABLE}.in_control_group ;;
  }

  dimension_group: cohort {
    type: time
    group_label: "* Dates and Timestamps *"
    label: "Cohort Entry"
    description: "Date when the cohort entered the canvas and started the journey"
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
    type: time
    group_label: "* Dates and Timestamps *"
    label: "First Contact"
    description: "Date of the first contact sent to customers within the cohort's canvas journey"
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
    type: time
    group_label: "* Dates and Timestamps *"
    label: "Last Contact"
    description: "Date of the last contact sent to customers within the cohort's canvas journey"
    timeframes: [
      date,
      week,
      month,
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_contact_date ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: number_of_users {
    group_label: "* Cohort Performance *"
    label: "# Contacted Users"
    description: "Number of customers who entered the cohort's canvas"
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
    description: "Number of messages sent to variant group customers within the cohort's journey"
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
    description: "Share of either tapped or clicked messages among all messages sent to variant"
    type: number
    sql: safe_divide(${number_of_engaged_messages},${number_of_sent_messages}) ;;
    value_format_name: percent_2
  }

  measure: number_of_customers_ordered {
    group_label: "* Cohort Performance *"
    label: "# Customers with Orders"
    description: "Number of customers who placed an order within the cohort's journey"
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

  measure: share_of_customers_ordered {
    group_label: "* Cohort Performance *"
    label: "% Customers With Orders"
    description: "Share of customers who placed an order among all customers within the cohort"
    type: number
    sql: safe_divide(${number_of_customers_ordered},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: incrementality_of_share_of_customers_ordered {
    group_label: "* Cohort Performance *"
    label: "Incr. ppt % Customers With Orders"
    description: "Ppt. positive difference in share of variant customers who placed an order compared to control group"
    type: number
    sql: (safe_divide(${number_of_variant_customers_ordered},${number_of_variant_users}) -
    safe_divide(${number_of_control_customers_ordered},${number_of_control_users})) * 100 ;;
    value_format_name: decimal_2
  }

  measure: number_of_orders {
    group_label: "* Cohort Performance *"
    label: "# Orders"
    description: "Number of orders placed by customers within the cohort"
    type: sum
    sql: ${orders_count} ;;
  }

  measure: share_of_orders_per_users {
    group_label: "* Cohort Performance *"
    label: "Orders per Users Frequency"
    description: "Number of orders placed by customers within the cohort divided by the number of all customers in the cohort"
    type: number
    sql: safe_divide(${number_of_orders},${number_of_users}) ;;
    value_format_name: decimal_2
  }

  measure: number_of_customers_visited {
    group_label: "* Cohort Performance *"
    label: "# Customers with Visits"
    description: "Number of daily visits by customers within the cohort"
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

  measure: share_of_customers_visited {
    group_label: "* Cohort Performance *"
    label: "% Customers with Visits"
    description: "Share of customers who had a daily visit among all customers within the cohort"
    type: number
    sql: safe_divide(${number_of_customers_visited},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: incrementality_of_share_of_customers_visited {
    group_label: "* Cohort Performance *"
    label: "Incr. ppt % Customers with Visits"
    description: "Ppt. positive difference in share of variant customers who had a daily visit compared to control group"
    type: number
    sql: (safe_divide(${number_of_variant_customers_visited},${number_of_variant_users}) -
    safe_divide(${number_of_control_customers_visited},${number_of_control_users})) * 100 ;;
    value_format_name: decimal_2
  }

  measure: number_of_daily_visits {
    group_label: "* Cohort Performance *"
    label: "# Daily Customer Visits"
    description: "Number of daily visits by customers within the cohort's journey"
    type: sum
    sql: ${daily_visits_count} ;;
  }

  measure: share_of_daily_visits_per_users {
    group_label: "* Cohort Performance *"
    label: "Daily Visits per Users Frequency"
    description: "Number of daily visits by customers within the cohort journey divided by the number of all customers in the cohort"
    type: number
    sql: safe_divide(${number_of_daily_visits},${number_of_users}) ;;
    value_format_name: decimal_2
  }

  measure: number_of_customers_discounted_ordered {
    group_label: "* Cohort Performance *"
    label: "# Customers with Discounted Orders"
    description: "Number of customers who placed an order with a discount code within the cohort's journey"
    type: sum
    sql: ${customers_discounted_ordered_count} ;;
  }

  measure: share_of_customers_discounted_ordered {
    group_label: "* Cohort Performance *"
    label: "% Customers With Discounted Orders"
    description: "Share of customers who placed an order with a discount code within the cohort's journey among all customers who placed an order"
    type: number
    sql: safe_divide(${number_of_customers_discounted_ordered},${number_of_customers_ordered}) ;;
    value_format_name: percent_2
  }

  measure: number_of_discounted_orders {
    group_label: "* Cohort Performance *"
    label: "# Discounted Orders"
    description: "Number of orders with discount codes placed by customers within the cohort"
    type: sum
    sql: ${discounted_orders_count} ;;
  }

  measure: share_of_discounted_orders {
    group_label: "* Cohort Performance *"
    label: "% Discounted Orders"
    description: "Share of orders with discount codes placed by customers within the cohort among all orders"
    type: number
    sql: safe_divide(${number_of_discounted_orders},${number_of_orders}) ;;
    value_format_name: percent_2
  }

  measure: share_of_discounted_orders_per_users {
    group_label: "* Cohort Performance *"
    label: "Discounted Orders per Users Frequency"
    description: "Number of orders with discount codes placed by customers within the cohort divided by the number of all customers who placed an order"
    type: number
    sql: safe_divide(${number_of_discounted_orders},${number_of_customers_ordered}) ;;
    value_format_name: decimal_2
  }

  measure: number_of_sent_emails {
    group_label: "* Message Performance *"
    label: "# Sent Emails"
    description: "Number of email contacts sent to variant group within the cohort's journey"
    type: sum
    sql: ${email_sent_count} ;;
  }

  measure: share_of_sent_emails {
    group_label: "* Message Performance *"
    label: "% Sent Emails"
    description: "Share of email contacts sent to variant group amongh all messages sent to variant group within the cohort's journey"
    type: number
    sql: safe_divide(${number_of_sent_emails},${number_of_sent_messages}) ;;
    value_format_name: percent_2
  }

  measure: number_of_delivered_emails {
    group_label: "* Message Performance *"
    label: "# Delivered Emails"
    description: "Number of delivered email contacts"
    type: sum
    sql: ${email_is_delivered_count} ;;
  }

  measure: share_of_delivered_emails {
    group_label: "* Message Performance *"
    label: "% Delivered Emails"
    description: "Share of delivered email contacts among all sent email contacts"
    type: number
    sql: safe_divide(${number_of_delivered_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_bounced_emails {
    group_label: "* Message Performance *"
    label: "# Bounced Emails"
    description: "Number of bounced email contacts"
    type: sum
    sql: ${email_is_bounced_count};;
  }

  measure: share_of_bounced_emails {
    group_label: "* Message Performance *"
    label: "% Bounced Emails"
    description: "Share of bounced email contacts among all sent email contacts"
    type: number
    sql: safe_divide(${number_of_bounced_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_soft_bounced_emails {
    group_label: "* Message Performance *"
    label: "# Soft Bounced Emails"
    description: "Number of soft bounced email contacts"
    type: sum
    sql: ${email_is_soft_bounced_count} ;;
  }

  measure: share_of_soft_bounced_emails {
    group_label: "* Message Performance *"
    label: "% Soft Bounced Emails"
    description: "Share of soft bounced email contacts among all sent email contacts"
    type: number
    sql: safe_divide(${number_of_soft_bounced_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_clicked_emails {
    group_label: "* Message Performance *"
    label: "# Clicked Emails"
    description: "Number of clicked email contacts"
    type: number
    sql: ${email_is_clicked_count} ;;
  }

  measure: share_of_clicked_emails {
    group_label: "* Message Performance *"
    label: "% Clicked Emails"
    description: "Share of clicked email contacts among all sent email contacts"
    type: number
    sql: safe_divide(${number_of_clicked_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_email_clicks {
    group_label: "* Message Performance *"
    label: "# Email Clicks"
    description: "Number of clicks on email contacts"
    type: sum
    sql: ${email_clicked_count} ;;
  }

  measure: number_of_general_opened_emails {
    group_label: "* Message Performance *"
    label: "# General Opened Emails"
    description: "Number of email contacts that were opened"
    type: sum
    sql: ${email_is_general_opened_count} ;;
  }

  measure: number_of_email_general_opens {
    group_label: "* Message Performance *"
    label: "# General Email Opens"
    description: "Number of opens of email contacts"
    type: sum
    sql: ${email_general_opens_count} ;;
  }

  measure: number_of_email_unique_opens {
    group_label: "* Message Performance *"
    label: "# Unique Email Opens"
    description: "Number of uniquely opened email contacts"
    type: sum
    sql: ${email_unique_opens_count} ;;
  }

  measure: number_of_unsubscribed_emails {
    group_label: "* Message Performance *"
    label: "# Unsubscribed Emails"
    description: "Number of email contacts that were unsubscribed"
    type: sum
    sql: ${email_is_unsubscribed_count} ;;
  }

  measure: share_of_unsubscribed_emails {
    group_label: "* Message Performance *"
    label: "% Unsubscribed Emails"
    description: "Number of email contacts that were unsubscribed among all sent email contacts"
    type: number
    sql: safe_divide(${number_of_unsubscribed_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_sent_pushes {
    group_label: "* Message Performance *"
    label: "# Sent Pushes"
    description: "Number of push contacts sent to variant group within the cohort's journey"
    type: sum
    sql: ${push_sent_count} ;;
  }

  measure: share_of_sent_pushes {
    group_label: "* Message Performance *"
    label: "% Sent Pushes"
    description: "Share of email push sent to variant group amongh all messages sent to variant group within the cohort's journey"
    type: number
    sql: safe_divide(${number_of_sent_pushes},${number_of_sent_messages}) ;;
    value_format_name: percent_2
  }

  measure: number_of_bounced_pushes {
    group_label: "* Message Performance *"
    label: "# Bounced Pushes"
    description: "Number of push contacts that bounced"
    type: sum
    sql: ${push_is_bounced_count} ;;
  }

  measure: share_of_bounced_pushes {
    group_label: "* Message Performance *"
    label: "% Bounced Pushes"
    description: "Share of push contacts that bounced among all push contacts that were sent"
    type: number
    sql: safe_divide(${number_of_bounced_pushes},${number_of_sent_pushes}) ;;
    value_format_name: percent_2
  }

  measure: number_of_tapped_pushes {
    group_label: "* Message Performance *"
    label: "# Tapped Pushes"
    description: "Number of push contacts that were tapped"
    type: sum
    sql: ${push_is_tapped_count} ;;
  }

  measure: share_of_tapped_pushes {
    group_label: "* Message Performance *"
    label: "% Tapped Pushes"
    description: "Share of push contacts that were tapped among all push contacts that were sent"
    type: number
    sql: safe_divide(${number_of_tapped_pushes},${share_of_sent_pushes}) ;;
    value_format_name: percent_2
  }

}
