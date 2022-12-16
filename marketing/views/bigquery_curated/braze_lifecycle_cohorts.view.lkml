### Author: Artem Avramenko
### Created: 2022-12-13

### This view represents data for reporting on CRM canvas lifecycles efficiency.

view: braze_lifecycle_cohorts {
  sql_table_name: `flink-data-dev.dbt_aavramenko_curated.braze_lifecycle_cohorts`
    ;;
  view_label: "* CRM Canvas Lifecycle Cohorts *"

  # =========  hidden   =========

  dimension: customers_android_visited_count {
    type: number
    sql: ${TABLE}.customers_android_visited_count ;;
    hidden: yes
  }

  dimension: customers_discounted_ordered_count {
    type: number
    sql: ${TABLE}.customers_discounted_ordered_count ;;
    hidden: yes
  }

  dimension: customers_ios_visited_count {
    type: number
    sql: ${TABLE}.customers_ios_visited_count ;;
    hidden: yes
  }

  dimension: customers_ordered_count {
    type: number
    sql: ${TABLE}.customers_ordered_count ;;
    hidden: yes
  }

  dimension: customers_visited_count {
    type: number
    sql: ${TABLE}.customers_visited_count ;;
    hidden: yes
  }

  dimension: customers_web_visited_count {
    type: number
    sql: ${TABLE}.customers_web_visited_count ;;
    hidden: yes
  }

  dimension: daily_android_visits_count {
    type: number
    sql: ${TABLE}.daily_android_visits_count ;;
    hidden: yes
  }

  dimension: daily_ios_visits_count {
    type: number
    sql: ${TABLE}.daily_ios_visits_count ;;
    hidden: yes
  }

  dimension: daily_visits_count {
    type: number
    sql: ${TABLE}.daily_visits_count ;;
    hidden: yes
  }

  dimension: daily_web_visits_count {
    type: number
    sql: ${TABLE}.daily_web_visits_count ;;
    hidden: yes
  }

  dimension: discounted_orders_count {
    type: number
    sql: ${TABLE}.discounted_orders_count ;;
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

  dimension: post_journey_28_days_customers_android_visited_count {
    type: number
    sql: ${TABLE}.post_journey_28_days_customers_android_visited_count ;;
    hidden: yes
  }

  dimension: post_journey_28_days_customers_discounted_ordered_count {
    type: number
    sql: ${TABLE}.post_journey_28_days_customers_discounted_ordered_count ;;
    hidden: yes
  }

  dimension: post_journey_28_days_customers_ios_visited_count {
    type: number
    sql: ${TABLE}.post_journey_28_days_customers_ios_visited_count ;;
    hidden: yes
  }

  dimension: post_journey_28_days_customers_ordered_count {
    type: number
    sql: ${TABLE}.post_journey_28_days_customers_ordered_count ;;
    hidden: yes
  }

  dimension: post_journey_28_days_customers_visited_count {
    type: number
    sql: ${TABLE}.post_journey_28_days_customers_visited_count ;;
    hidden: yes
  }

  dimension: post_journey_28_days_customers_web_visited_count {
    type: number
    sql: ${TABLE}.post_journey_28_days_customers_web_visited_count ;;
    hidden: yes
  }

  dimension: post_journey_28_days_daily_android_visits_count {
    type: number
    sql: ${TABLE}.post_journey_28_days_daily_android_visits_count ;;
    hidden: yes
  }

  dimension: post_journey_28_days_daily_ios_visits_count {
    type: number
    sql: ${TABLE}.post_journey_28_days_daily_ios_visits_count ;;
    hidden: yes
  }

  dimension: post_journey_28_days_daily_visits_count {
    type: number
    sql: ${TABLE}.post_journey_28_days_daily_visits_count ;;
    hidden: yes
  }

  dimension: post_journey_28_days_daily_web_visits_count {
    type: number
    sql: ${TABLE}.post_journey_28_days_daily_web_visits_count ;;
    hidden: yes
  }

  dimension: post_journey_28_days_discounted_orders_count {
    type: number
    sql: ${TABLE}.post_journey_28_days_discounted_orders_count ;;
    hidden: yes
  }

  dimension: post_journey_28_days_orders_count {
    type: number
    sql: ${TABLE}.post_journey_28_days_orders_count ;;
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
    sql: ${TABLE}.cohort_date ;;
  }

  dimension_group: first_contact {
    type: time
    group_label: "* Dates and Timestamps *"
    label: "First Contact"
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
    sql: ${TABLE}.first_contact_date ;;
  }

  dimension_group: last_contact {
    type: time
    group_label: "* Dates and Timestamps *"
    label: "Last Contact"
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
    sql: ${TABLE}.last_contact_date ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: number_of_users {
    group_label: "* Cohort Performance *"
    label: "# Contacted Users"
    type: sum
    sql: ${users_count} ;;
  }

  measure: number_of_sent_messages {
    group_label: "* Message Performance *"
    label: "# Sent Messages"
    type: sum
    sql: ${message_sent_count} ;;
  }

  measure: number_of_engaged_messages {
    group_label: "* Message Performance *"
    label: "# Engaged Messages"
    type: sum
    sql: ${message_is_engaged_count} ;;
  }

  measure: share_of_engaged_messages {
    group_label: "* Message Performance *"
    label: "% Engaged Messages"
    type: number
    sql: safe_divide(${number_of_engaged_messages},${number_of_sent_messages}) ;;
    value_format_name: percent_3
  }

  measure: number_of_customers_ordered {
    group_label: "* Cohort Performance *"
    label: "# Customers with Orders"
    type: sum
    sql: ${customers_ordered_count};;
  }

  measure: share_of_customers_ordered {
    group_label: "* Cohort Performance *"
    label: "% Customers With Orders"
    type: number
    sql: safe_divide(${number_of_customers_ordered},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: number_of_orders {
    group_label: "* Cohort Performance *"
    label: "# Orders"
    type: sum
    sql: ${orders_count} ;;
  }

  measure: share_of_orders_per_users {
    group_label: "* Cohort Performance *"
    label: "% Orders per Users"
    type: number
    sql: safe_divide(${number_of_orders},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: number_of_customers_visited {
    group_label: "* Cohort Performance *"
    label: "# Customers with Visits"
    type: sum
    sql: ${customers_visited_count} ;;
  }

  measure: share_of_customers_visited {
    group_label: "* Cohort Performance *"
    label: "% Customers with Visits"
    type: number
    sql: safe_divide(${number_of_customers_visited},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: number_of_daily_visits {
    group_label: "* Cohort Performance *"
    label: "# Daily Customer Visits"
    type: sum
    sql: ${daily_visits_count} ;;
  }

  measure: share_of_daily_visits_per_users {
    group_label: "* Cohort Performance *"
    label: "% Daily Visits per Users"
    type: number
    sql: safe_divide(${number_of_daily_visits},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: number_of_customers_ordered_post_28_days {
    group_label: "* Cohort Performance post 28 days *"
    label: "# Customers with Orders post 28 days"
    type: sum
    sql: ${post_journey_28_days_customers_ordered_count} ;;
  }

  measure: share_of_customers_ordered_post_28_days {
    group_label: "* Cohort Performance post 28 days *"
    label: "% Customers with Orders post 28 days"
    type: number
    sql: safe_divide(${number_of_customers_ordered_post_28_days},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: number_of_orders_post_28_days {
    group_label: "* Cohort Performance post 28 days *"
    label: "# Orders post 28 days"
    type: sum
    sql: ${post_journey_28_days_orders_count};;
  }

  measure: share_of_orders_per_users_post_28_days {
    group_label: "* Cohort Performance post 28 days *"
    label: "% Orders per Users post 28 days"
    type: number
    sql: safe_divide(${number_of_orders_post_28_days},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: number_of_customers_visited_post_28_days {
    group_label: "* Cohort Performance post 28 days *"
    label: "# Customers with Visits post 28 days"
    type: sum
    sql: ${post_journey_28_days_customers_visited_count} ;;
  }

  measure: share_of_customers_visited_post_28_days {
    group_label: "* Cohort Performance post 28 days *"
    label: "% Customers with Visits post 28 days"
    type: number
    sql: safe_divide(${number_of_customers_visited_post_28_days},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: number_of_daily_visits_post_28_days {
    group_label: "* Cohort Performance post 28 days *"
    label: "# Daily Customer Visits post 28 days"
    type: number
    sql: ${post_journey_28_days_daily_visits_count} ;;
  }

  measure: share_of_daily_visits_per_users_post_28_days {
    group_label: "* Cohort Performance post 28 days *"
    label: "% Daily Visits per Users post 28 days"
    type: number
    sql: safe_divide(${number_of_daily_visits_post_28_days},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: number_of_customers_discounted_ordered {
    group_label: "* Cohort Performance *"
    label: "# Customers with Discounted Orders"
    type: sum
    sql: ${customers_discounted_ordered_count} ;;
  }

  measure: share_of_customers_discounted_ordered {
    group_label: "* Cohort Performance *"
    label: "% Customers With Discounted Orders"
    type: number
    sql: safe_divide(${number_of_customers_discounted_ordered},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: number_of_discounted_orders {
    group_label: "* Cohort Performance *"
    label: "# Discounted Orders"
    type: sum
    sql: ${discounted_orders_count} ;;
  }

  measure: share_of_discounted_orders_per_users {
    group_label: "* Cohort Performance *"
    label: "% Discounted Orders per Users"
    type: number
    sql: safe_divide(${number_of_discounted_orders},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: number_of_customers_discounted_ordered_post_28_days {
    group_label: "* Cohort Performance post 28 days *"
    label: "# Customers with Discounted Orders post 28 days"
    type: sum
    sql: ${post_journey_28_days_customers_discounted_ordered_count} ;;
  }

  measure: share_of_customers_discounted_ordered_post_28_days {
    group_label: "* Cohort Performance post 28 days *"
    label: "% Customers With Discounted Orders post 28 days"
    type: number
    sql: safe_divide(${number_of_customers_discounted_ordered_post_28_days},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: number_of_discounted_orders_post_28_days {
    group_label: "* Cohort Performance post 28 days *"
    label: "# Discounted Orders post 28 days"
    type: sum
    sql: ${post_journey_28_days_discounted_orders_count} ;;
  }

  measure: share_of_discounted_orders_per_users_post_28_days {
    group_label: "* Cohort Performance post 28 days *"
    label: "% Discounted Orders per Users post 28 days"
    type: number
    sql: safe_divide(${number_of_discounted_orders_post_28_days},${number_of_users}) ;;
    value_format_name: percent_2
  }

  measure: number_of_sent_emails {
    group_label: "* Message Performance *"
    label: "# Sent Emails"
    type: sum
    sql: ${email_sent_count} ;;
  }

  measure: share_of_sent_emails {
    group_label: "* Message Performance *"
    label: "% Sent Emails"
    type: number
    sql: safe_divide(${number_of_sent_emails},${number_of_sent_messages}) ;;
    value_format_name: percent_2
  }

  measure: number_of_delivered_emails {
    group_label: "* Message Performance *"
    label: "# Delivered Emails"
    type: sum
    sql: ${email_is_delivered_count} ;;
  }

  measure: share_of_delivered_emails {
    group_label: "* Message Performance *"
    label: "% Delivered Emails"
    type: number
    sql: safe_divide(${number_of_delivered_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_bounced_emails {
    group_label: "* Message Performance *"
    label: "# Bounced Emails"
    type: sum
    sql: ${email_is_bounced_count};;
  }

  measure: share_of_bounced_emails {
    group_label: "* Message Performance *"
    label: "% Bounced Emails"
    type: number
    sql: safe_divide(${number_of_bounced_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_soft_bounced_emails {
    group_label: "* Message Performance *"
    label: "# Soft Bounced Emails"
    type: sum
    sql: ${email_is_soft_bounced_count} ;;
  }

  measure: share_of_soft_bounced_emails {
    group_label: "* Message Performance *"
    label: "% Soft Bounced Emails"
    type: number
    sql: safe_divide(${number_of_soft_bounced_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_clicked_emails {
    group_label: "* Message Performance *"
    label: "# Clicked Emails"
    type: number
    sql: ${email_is_clicked_count} ;;
  }

  measure: share_of_clicked_emails {
    group_label: "* Message Performance *"
    label: "% Clicked Emails"
    type: number
    sql: safe_divide(${number_of_clicked_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_email_clicks {
    group_label: "* Message Performance *"
    label: "# Email Clicks"
    type: sum
    sql: ${email_clicked_count} ;;
  }

  measure: number_of_general_opened_emails {
    group_label: "* Message Performance *"
    label: "# General Opened Emails"
    type: sum
    sql: ${email_is_general_opened_count} ;;
  }

  measure: number_of_email_general_opens {
    group_label: "* Message Performance *"
    label: "# General Email Opens"
    type: sum
    sql: ${email_general_opens_count} ;;
  }

  measure: number_of_email_unique_opens {
    group_label: "* Message Performance *"
    label: "# Unique Email Opens"
    type: sum
    sql: ${email_unique_opens_count} ;;
  }

  measure: number_of_unsubscribed_emails {
    group_label: "* Message Performance *"
    label: "# Unsubscribed Emails"
    type: sum
    sql: ${email_is_unsubscribed_count} ;;
  }

  measure: share_of_unsubscribed_emails {
    group_label: "* Message Performance *"
    label: "% Unsubscribed Emails"
    type: number
    sql: safe_divide(${number_of_unsubscribed_emails},${number_of_sent_emails}) ;;
    value_format_name: percent_2
  }

  measure: number_of_sent_pushes {
    group_label: "* Message Performance *"
    label: "# Sent Pushes"
    type: sum
    sql: ${TABLE}.push_sent_count ;;
  }

  measure: share_of_sent_pushes {
    group_label: "* Message Performance *"
    label: "% Sent Pushes"
    type: number
    sql: safe_divide(${number_of_sent_pushes},${number_of_sent_messages}) ;;
    value_format_name: percent_2
  }

  measure: number_of_bounced_pushes {
    group_label: "* Message Performance *"
    label: "# Sent Pushes"
    type: sum
    sql: ${push_is_bounced_count} ;;
  }

  measure: share_of_bounced_pushes {
    group_label: "* Message Performance *"
    label: "% Bounced Pushes"
    type: number
    sql: safe_divide(${number_of_bounced_pushes},${share_of_sent_pushes}) ;;
    value_format_name: percent_2
  }

  measure: number_of_tapped_pushes {
    group_label: "* Message Performance *"
    label: "# Sent Pushes"
    type: sum
    sql: ${push_is_tapped_count} ;;
  }

  measure: share_of_tapped_pushes {
    group_label: "* Message Performance *"
    label: "% Tapped Pushes"
    type: number
    sql: safe_divide(${number_of_tapped_pushes},${share_of_sent_pushes}) ;;
    value_format_name: percent_2
  }


  # dimension: customers_android_visited_count {
  #   type: number
  #   sql: ${TABLE}.customers_android_visited_count ;;
  #   hidden: yes
  # }

  # dimension: customers_ios_visited_count {
  #   type: number
  #   sql: ${TABLE}.customers_ios_visited_count ;;
  #   hidden: yes
  # }

  # dimension: customers_web_visited_count {
  #   type: number
  #   sql: ${TABLE}.customers_web_visited_count ;;
  #   hidden: yes
  # }

  # dimension: daily_android_visits_count {
  #   type: number
  #   sql: ${TABLE}.daily_android_visits_count ;;
  #   hidden: yes
  # }

  # dimension: daily_ios_visits_count {
  #   type: number
  #   sql: ${TABLE}.daily_ios_visits_count ;;
  #   hidden: yes
  # }

  # dimension: daily_web_visits_count {
  #   type: number
  #   sql: ${TABLE}.daily_web_visits_count ;;
  #   hidden: yes
  # }

  # dimension: post_journey_28_days_customers_android_visited_count {
  #   type: number
  #   sql: ${TABLE}.post_journey_28_days_customers_android_visited_count ;;
  #   hidden: yes
  # }

  # dimension: post_journey_28_days_customers_ios_visited_count {
  #   type: number
  #   sql: ${TABLE}.post_journey_28_days_customers_ios_visited_count ;;
  #   hidden: yes
  # }

  # dimension: post_journey_28_days_customers_web_visited_count {
  #   type: number
  #   sql: ${TABLE}.post_journey_28_days_customers_web_visited_count ;;
  #   hidden: yes
  # }

  # dimension: post_journey_28_days_daily_android_visits_count {
  #   type: number
  #   sql: ${TABLE}.post_journey_28_days_daily_android_visits_count ;;
  #   hidden: yes
  # }

  # dimension: post_journey_28_days_daily_ios_visits_count {
  #   type: number
  #   sql: ${TABLE}.post_journey_28_days_daily_ios_visits_count ;;
  #   hidden: yes
  # }

  # dimension: post_journey_28_days_daily_web_visits_count {
  #   type: number
  #   sql: ${TABLE}.post_journey_28_days_daily_web_visits_count ;;
  #   hidden: yes
  # }

}
