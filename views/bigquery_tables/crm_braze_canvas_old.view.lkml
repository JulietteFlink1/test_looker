view: crm_braze_canvas_old {
  sql_table_name:`flink-data-staging.sandbox.crm_braze_canvas`
      ;;
  # view_label: "* CRM Braze Canvas *"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Dimensions
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  dimension: canvas_id {
    label: "Canvas ID"
    description: "The email canvas ID defined in Braze"
    type: string
    sql: ${TABLE}.canvas_id;;
  }

  dimension: canvas_name {
    label: "Canvas Name"
    description: "The email canvas name defined in Braze"
    type: string
    sql: ${TABLE}.canvas_name ;;
  }

  dimension: in_control_group {
    label: "Control Group for Canvas"
    description: "Canvas group name defined in Braze"
    type: yesno
    sql: ${TABLE}.in_control_group ;;
  }

  dimension: canvas_step_name {
    label: "Canvas Step Name"
    description: "The email canvas step name defined in Braze"
    type: string
    sql: ${TABLE}.canvas_step_name ;;
  }

  dimension: canvas_variation_name {
    label: "Canvas Variation Name"
    description: "The email canvas variation name defined in Braze"
    type: string
    sql: ${TABLE}.canvas_variation_name ;;
  }

  dimension: country {
    label: "Country"
    description: "The country code parsed from the email canvas name"
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: email_sent_at {
    allow_fill: yes
    label: "Date Email Sent"
    description: "The date, when the email was sent to the customer"
    type: date
    datatype: date
    sql: ${TABLE}.email_sent_at ;;
    # hidden: yes
  }

  # dimension_group: email_sent_at {
  #   label: "Date Email Sent"
  #   description: "The date, when the email was sent to the customer"
  #   type: time
  #   datatype: date
  #   timeframes: [
  #     date,
  #     day_of_week,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}.email_sent_at ;;
  # }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Hidden Fields
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.canvas_name, ${TABLE}.canvas_variation_name,${TABLE}.canvas_step_name, ${TABLE}.country, ${TABLE}.email_sent_at) ;;
  }

  dimension: days_sent_to_open {
    type: number
    sql: ${TABLE}.days_sent_to_open ;;
    hidden: yes
  }

  dimension: days_sent_to_click {
    type: number
    sql: ${TABLE}.days_sent_to_click ;;
    hidden: yes
  }

  dimension: total_emails_sent {
    type: number
    sql: ${TABLE}.total_emails_sent ;;
    hidden: yes
  }

  dimension: num_unique_emails_bounced {
    type: number
    sql: ${TABLE}.num_unique_emails_bounced ;;
    hidden: yes
  }

  dimension: total_emails_bounced {
    type: number
    sql: ${TABLE}.total_emails_bounced ;;
    hidden: yes
  }

  dimension: num_unique_emails_soft_bounced {
    type: number
    sql: ${TABLE}.num_unique_emails_soft_bounced ;;
    hidden: yes
  }

  dimension: total_emails_soft_bounced {
    type: number
    sql: ${TABLE}.total_emails_soft_bounced ;;
    hidden: yes
  }

  dimension: total_emails_delivered {
    type: number
    sql: ${TABLE}.total_emails_delivered ;;
    hidden: yes
  }

  dimension: num_unique_emails_opened {
    type: number
    sql: ${TABLE}.num_unique_emails_opened ;;
    hidden: yes
  }

  dimension: total_emails_opened {
    type: number
    sql: ${TABLE}.total_emails_opened ;;
    hidden: yes
  }

  dimension: num_unique_emails_clicked {
    type: number
    sql: ${TABLE}.num_unique_emails_clicked ;;
    hidden: yes
  }

  dimension: total_emails_clicked {
    type: number
    sql: ${TABLE}.total_emails_clicked ;;
    hidden: yes
  }

  dimension: num_unique_unsubscribed {
    type: number
    sql: ${TABLE}.num_unique_unsubscribed ;;
    hidden: yes
  }

  # measure: count {
  #   type: count
  #   drill_fields: [detail*]
  #   value_format_name: decimal_0
  #   hidden: yes
  # }

  dimension: num_unique_users_orders {
    type: number
    sql: ${TABLE}.num_unique_users_orders ;;
    hidden: yes
  }

  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
    hidden: yes
  }

  dimension: total_orders_with_vouchers {
    type: number
    sql: ${TABLE}.total_orders_with_vouchers ;;
    hidden: yes
  }

  dimension: total_vouchers_sent {
    type: number
    sql: ${TABLE}.total_vouchers_sent ;;
    hidden: yes
  }

  dimension: total_discount_amount {
    type: number
    sql: ${TABLE}.total_discount_amount ;;
    hidden: yes
  }

  dimension: total_gmv_gross   {
    type: number
    sql: ${TABLE}.total_gmv_gross  ;;
    hidden: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Measures
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: emails_sent {
    type: sum
    label: "All Unique Sents"
    description: "The number of unique recipients of an email canvas"
    group_label: "Numbers"
    sql: ${total_emails_sent} ;;
    value_format_name: decimal_0
  }

  measure: emails_bounced {
    type: sum
    label: "Bounces"
    description: "The number of emails, that have been bounced by the customers email provider"
    group_label: "Numbers"
    sql: ${total_emails_bounced};;
    value_format_name: decimal_0
  }

  measure: emails_soft_bounced {
    type: sum
    label: "Total Soft Bounces"
    description: "The number of emails, that have been bounced by the customers email provider"
    group_label: "Numbers"
    sql: ${total_emails_soft_bounced} ;;
    value_format_name: decimal_0
  }

  measure: emails_delivered {
    type: sum
    label: "Deliveries"
    description: "The number of emails, that have been delivered to the customer - aka they have been received"
    group_label: "Numbers"
    sql: ${total_emails_delivered} ;;
    value_format_name: decimal_0
  }

  measure: unique_emails_opened {
    type:  sum
    label: "Unique Opens"
    description: "The number of unique opens of an email - one customer can be counted only once per sent-put"
    group_label: "Numbers"
    sql: ${num_unique_emails_opened} ;;
    value_format_name: decimal_0
  }

  measure: emails_opened{
    type:  sum
    label: "Total Opens"
    description: "The number of unique opens of an email - one customer can be counted n-times per sent-put"
    group_label: "Numbers"
    sql: ${total_emails_opened} ;;
    value_format_name: decimal_0
  }

  measure: emails_clicked {
    type: sum
    label: "Total Clicks"
    description: "The number of unique clicks of an email - one customer can be counted n-times per sent-put"
    group_label: "Numbers"
    sql: ${total_emails_clicked} ;;
    value_format_name: decimal_0
  }

  measure: unique_emails_clicked {
    type: sum
    label: "Unique Clicks"
    description: "The number of unique clicks of an email - one customer can be counted only once per sent-put"
    group_label: "Numbers"
    sql: ${num_unique_emails_clicked} ;;
    value_format_name: decimal_0
  }


  measure: unique_emails_unsubscribed {
    type: sum
    label: "Unsubscribes"
    description: "The number of customers, that have clicked on the unsubscribe-link"
    group_label: "Numbers"
    sql: ${num_unique_unsubscribed} ;;
    value_format_name: decimal_0
  }

  measure: cta_clicks {
    type: number
    label: "Total CTA Clicks"
    description: "The total clicks, that are not clicks on the unsubscribe-link"
    group_label: "Numbers"
    sql:  ${emails_clicked} - ${unique_emails_unsubscribed};;
    value_format_name: decimal_0
  }

  measure: unique_cta_clicks {
    type: number
    label: "Unique CTA Clicks"
    description: "The unique clicks, that are not clicks on the unsubscribe-link"
    group_label: "Numbers"
    sql: ${unique_emails_clicked} - ${unique_emails_unsubscribed}  ;;
    value_format_name: decimal_0
  }

  measure: avg_days_sent_open {
    type: average
    label: "ø Days Sent to Open"
    description: "The days between the sent-out and the first opening of an email"
    group_label: "Numbers"
    sql:  ${days_sent_to_open};;
    value_format_name: decimal_2
    hidden: yes
  }

  measure: avg_days_sent_click {
    type: average
    label: "ø Days Sent to Click"
    description: "The days between the sent-out and the first click of an email"
    group_label: "Numbers"
    sql: ${days_sent_to_click} ;;
    value_format_name: decimal_2
    hidden: yes
  }

  measure: orders {
    type: sum
    label: "Total Orders "
    description: "Number of Orders that happened in the 12h after the last email open"
    group_label: "Numbers"
    sql: ${total_orders};;
    value_format_name: decimal_0
  }

  measure: unique_users_orders {
    type: sum
    label: "Unique Users with Orders "
    description: "Number of Unique Users with at leats 1 Order that happened in the 12h after the last email open"
    group_label: "Numbers"
    sql: ${num_unique_users_orders};;
    value_format_name: decimal_0
  }

  measure: orders_with_vouchers {
    type: sum
    label: "Total Orders with Vouchers"
    description: "Number of Orders with Vouchers that happened in the 12h after the last email open"
    group_label: "Numbers"
    sql: ${total_orders_with_vouchers};;
    value_format_name: decimal_0
  }

  measure: discount_amount {
    type: sum
    label: "Total Discount"
    description: "Total Value of discount vouchers"
    group_label: "Numbers"
    sql: ${total_discount_amount};;
    value_format_name: decimal_0
  }

  measure: gmv_gross {
    type: sum
    label: "Total GMV (gross) "
    description: "Total GMV (gross) of orders"
    group_label: "Numbers"
    sql: ${total_gmv_gross};;
    value_format_name: decimal_0
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Ratios
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: bounced_emails_per_total_emails_sent {
    type: number
    label: "Bounce Rate"
    description: "Percentage: how many emails have been bounced based on all emails sent"
    group_label: "Ratios"
    sql: ${total_emails_bounced} / NULLIF(${total_emails_sent}, 0);;
    value_format: "0.00%"
  }

  measure: delivered_emails_per_total_emails_sent {
    type: number
    label: "Deliveries Rate"
    description: "Percentage: how many emails have been delivered based on all emails sent"
    group_label: "Ratios"
    sql: ${total_emails_delivered} / NULLIF(${total_emails_sent}, 0);;
    value_format: "0.00%"
  }

  measure: total_opened_emails_per_emails_delivered {
    type: number
    label: "Total Opens Rate"
    description: "Percentage: number of emails opened divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_opened} / NULLIF(${total_emails_delivered}, 0);;
    value_format: "0.00%"
  }

  measure: unique_opened_emails_per_emails_delivered {
    type: number
    label: "Unique Opens Rate"
    description: "Percentage: number of unique emails opened divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${unique_emails_opened} / NULLIF(${total_emails_delivered}, 0);;
    value_format: "0.00%"
  }

  measure: total_clicked_emails_per_emails_delivered {
    type: number
    label: "Total Clicks Rate"
    description: "Percentage: number of emails clicked divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_clicked} / NULLIF(${total_emails_delivered}, 0);;
    value_format: "0.00%"
  }

  measure: total_cta_clicked_emails_per_emails_delivered {
    type: number
    label: "Total CTA Clicks Rate"
    description: "Percentage: number of emails clicked on CTA (not the unsubscribe-link) divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_clicked} / NULLIF(${total_emails_delivered}, 0);;
    value_format: "0.00%"
  }

  measure: unique_clicked_emails_per_emails_delivered {
    type: number
    label: "Unique Clicks Rate"
    description: "Percentage: number of unique emails clicked divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${unique_emails_clicked} / NULLIF(${total_emails_delivered}, 0);;
    value_format: "0.00%"
  }

  measure: unique_cta_clicked_emails_per_emails_delivered {
    type: number
    label: "Unique CTA Clicks Rate"
    description: "Percentage: number of unique emails clicked on CTA (not the unsubscribe-link) divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${unique_cta_clicks} / NULLIF(${total_emails_delivered}, 0);;
    value_format: "0.00%"
  }

  measure: unsubscribed_emails_per_emails_delivered {
    type: number
    label: "Unsubscribes Rate"
    description: "Percentage: number of emails clicked on unsubscribe-link divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${num_unique_unsubscribed} / NULLIF(${total_emails_delivered}, 0);;
    value_format: "0.00%"
  }

  measure: unique_order_rate {
    type: number
    label: "Unique Order Rate"
    description: "Percentage: number of users who made at least 1 order in the 12h after the last opening of the email divided by the number of emails opened"
    group_label: "Ratios"
    sql:
          CASE WHEN ${in_control_group} THEN ${num_unique_users_orders} / NULLIF(${total_emails_sent}, 0)
               ELSE ${num_unique_users_orders} / NULLIF(${total_emails_delivered}, 0)
          END;;
    value_format: "0.00%"
  }

  measure: order_rate {
    type: number
    label: "Total Order Rate"
    description: "Percentage: number of orders made in the 12h after the last opening of the email divided by the number of emails opened"
    group_label: "Ratios"
    sql:
          CASE WHEN ${in_control_group} THEN ${total_orders} / NULLIF(${total_emails_sent}, 0)
                ELSE ${total_orders} / NULLIF(${total_emails_delivered}, 0)
          END;;
    value_format: "0.00%"
  }

  measure: order_rate_with_vouchers {
    type: number
    label: "Total Order Rate with Vouchers"
    description: "Percentage: number of orders made in the 12h after sending an email divided by the number of emails opened"
    group_label: "Ratios"
    sql:  CASE WHEN ${in_control_group}
                THEN ${total_orders_with_vouchers} / NULLIF(${total_emails_sent}, 0)
                ELSE ${total_orders_with_vouchers} / NULLIF(${total_emails_delivered}, 0)
          END;;
    value_format: "0.00%"
  }

  # measure: order_rate_with_vouchers {
  #   type: number
  #   label: "Total Order Rate with Vouchers"
  #   description: "Percentage: number of orders made in the 12h after sending an email divided by the number of emails opened"
  #   group_label: "Ratios"
  #   sql: {% if ${TABLE}.in_control_group == 'yes' %}
  #   ${total_orders_with_vouchers} / NULLIF(${total_emails_sent}, 0)
  #   {% else %}
  #   ${total_orders_with_vouchers} / NULLIF(${total_emails_delivered}, 0)
  #   {% endif %};;
  #   value_format: "0.00%"
  # }

  measure: discount_order_share {
    type: number
    label: "Discount Order Share"
    description: "Percentage: number of orders with voucher discounts divided by the total number of ordres made in the 12h after the last opening of the email"
    group_label: "Ratios"
    sql: ${total_orders_with_vouchers} / NULLIF(${total_orders}, 0);;
    value_format: "0.00%"
  }


  measure: discount_value_share {
    type: number
    label: "Discount Value Share "
    description: "Percentage: total of voucher discounts divided by the total gmv (gross) of ordres made in the 12h after the last opening of the email"
    group_label: "Ratios"
    sql: ${total_discount_amount} / NULLIF(${total_gmv_gross}, 0);;
    value_format: "0.00%"
  }

  measure: average_order_value {
    type: number
    label: "Average Order Value"
    description: "Average GMV (gross) based on Total Orders"
    group_label: "Ratios"
    sql: ${total_gmv_gross} / NULLIF(${total_orders}, 0);;
    value_format_name: decimal_2
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Parameter
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  parameter: reporting_parameter {
    label: "* Granularity Parameter *"
    group_label: "* Dynamic KPI Fields *"
    type: string
    allowed_value: { value: "total"                  label: "Totals"}
    allowed_value: { value: "unique"                label: "Unique"}
  }


  parameter: KPI_parameter {
    label: "* KPI Parameter *"
    group_label: "* Dynamic KPI Fields *"
    type: string
 # initial sends
    allowed_value: { value: "emails_sent"                     label: "Emails Sent"}
    allowed_value: { value: "emails_delivered"                label: "Deliveries"}
    allowed_value: { value: "emails_bounced"                  label: "Bounces"}
    allowed_value: { value: "emails_soft_bounced"             label: "Soft Bounces"}
    allowed_value: { value: "emails_opened"                   label: "Emails Opened"}
    allowed_value: { value: "emails_clicked"                  label: "Emails Clicked"}
    allowed_value: { value: "emails_unsubscribed"             label: "Emails Unsubscribed"}
    allowed_value: { value: "orders"                          label: "Orders"}
    allowed_value: { value: "orders_with_vouchers"            label: "Orders with vouchers"}
    allowed_value: { value: "discount_amount"                 label: "Discount Amount"}
    allowed_value: { value: "gmv_gross"                       label: "GMV Gross"}
# rates
    # allowed_value: { value: "deliveries_rate"                 label: "Deliveries Rate"}
    # allowed_value: { value: "bounce_rate"                     label: "Bounce Rate"}
    # allowed_value: { value: "opens_rate"                      label: "Opens Rate"}
    # allowed_value: { value: "order_rate"                      label: "Order Rate"}
    # allowed_value: { value: "order_rate_with_voucher"         label: "Order Rate with Voucher"}
    # allowed_value: { value: "discount_order_share"            label: "Discount Order Share"}
    # allowed_value: { value: "discount_value_share"            label: "Discount Value Share"}
    # allowed_value: { value: "average_order_value"             label: "Average Order Value"}

    # default_value: "opens_rate"
  }


  # measure: open_parameter {
  #   label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Emails Opened {% else %} Total Opens {% endif%}"
  #   group_label: "* Dynamic KPI Fields *"
  #   type: number
  #   sql:
  #       {% if reporting_parameter._parameter_value == 'total' %}
  #     ${emails_opened}
  #   {% elsif reporting_parameter._parameter_value == 'unique' %}
  #     ${unique_emails_opened}
  #   {% endif %};;
  # }

  measure: open_parameter {
    label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Emails Opened {% else %} Total Opens {% endif%}"
    group_label: "* Dynamic KPI Fields *"
    type: number
    sql:
    CASE
      WHEN {% parameter reporting_parameter %} = 'total' THEN (${emails_opened})
      WHEN {% parameter reporting_parameter %} = 'unique' THEN (${unique_emails_opened})
    END;;
  }


  # measure: clicks_parameter {
  #   label: "{% if reporting_parameter._parameter_value == \"unique\"%}
  #   Unique Emails Clicked {% else %} Total Clicks {% endif%}"
  #   group_label: "* Dynamic KPI Fields *"
  #   type: number
  #   sql:
  #       {% if reporting_parameter._parameter_value == 'total' %}
  #     ${cta_clicks}
  #   {% elsif reporting_parameter._parameter_value == 'unique' %}
  #     ${unique_cta_clicks}
  #   {% endif %};;
  # }

  measure: clicks_parameter {
    label: "{% if reporting_parameter._parameter_value == \"unique\"%}
    Unique Emails Clicked {% else %} Total Clicks {% endif%}"
    group_label: "* Dynamic KPI Fields *"
    type: number
    sql:
    CASE
      WHEN {% parameter reporting_parameter %} = 'total' THEN (${cta_clicks})
      WHEN {% parameter reporting_parameter %} = 'unique' THEN (${unique_cta_clicks})
    END;;
  }



  # measure: order_parameter {
  #   label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Users Ordered {% else %} Total Orders {% endif%}"
  #   group_label: "* Dynamic KPI Fields *"
  #   type: number
  #   sql:
  #       {% if reporting_parameter._parameter_value == 'total' %}
  #     ${orders}
  #   {% elsif reporting_parameter._parameter_value == 'unique' %}
  #     ${unique_users_orders}
  #   {% endif %};;
  # }


  measure: order_parameter {
    label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Users Ordered {% else %} Total Orders {% endif%}"
    group_label: "* Dynamic KPI Fields *"
    type: number
    sql:
    CASE
      WHEN {% parameter reporting_parameter %} = 'total' THEN (${orders})
      WHEN {% parameter reporting_parameter %} = 'unique' THEN (${unique_users_orders})
    END;;
  }


  # measure: order_rate_parameter {
  #   label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Order Rate {% else %} Total Order Rate {% endif%}"
  #   group_label: "* Dynamic KPI Fields *"
  #   value_format: "0.00%"
  #   sql:
  #       {% if reporting_parameter._parameter_value == 'total' %}
  #     avg(${order_rate})
  #   {% elsif reporting_parameter._parameter_value == 'unique' %}
  #     avg(${unique_order_rate})
  #   {% endif %};;
  # }

  measure: order_rate_parameter {
    label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Order Rate {% else %} Total Order Rate {% endif%}"
    group_label: "* Dynamic KPI Fields *"
    value_format: "0.00%"
    type: average
    sql:
        CASE
          WHEN {% parameter reporting_parameter %} = 'total' THEN (${order_rate})
          WHEN {% parameter reporting_parameter %} = 'unique' THEN (${unique_order_rate})
        END;;
  }

  # measure: open_rate_parameter {
  #   label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Open Rate {% else %} Total Open Rate {% endif%}"
  #   group_label: "* Dynamic KPI Fields *"
  #   value_format: "0.00%"
  #   sql:
  #   {% if reporting_parameter._parameter_value == 'total' %}
  #     avg(${total_opened_emails_per_emails_delivered})
  #   {% elsif reporting_parameter._parameter_value == 'unique' %}
  #     avg(${unique_opened_emails_per_emails_delivered})
  #   {% endif %};;
  # }

  measure: open_rate_parameter {
    label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Open Rate {% else %} Total Open Rate {% endif%}"
    group_label: "* Dynamic KPI Fields *"
    value_format: "0.00%"
    type: average
    sql:
    CASE
    WHEN {% parameter reporting_parameter %} = 'total' THEN (${total_opened_emails_per_emails_delivered})
    WHEN {% parameter reporting_parameter %} = 'unique' THEN (${unique_opened_emails_per_emails_delivered})
    END;;
  }

    # measure: KPI_crm {
  #   # label: "{% if reporting_parameter._parameter_value == \"unique\"%}
  #   # {{ KPI_parameter._label_from_parameter }} {% else %} Total & label_from_parameter {% endif%}"
  #   group_label: "* Dynamic KPI Fields *"
  #   label_from_parameter: KPI_parameter
  #   value_format: "#,##0.00"
  #   type: number
  #   sql:
  #   {% if KPI_parameter._parameter_value == 'emails_sent' %}
  #     ${emails_sent}
  #   {% elsif KPI_parameter._parameter_value == 'emails_delivered' %}
  #     ${emails_delivered}
  #   {% elsif KPI_parameter._parameter_value == 'emails_opened' %}
  #     ${open_parameter}
  #   {% elsif KPI_parameter._parameter_value == 'emails_clicked' %}
  #     ${clicks_parameter}
  #   {% elsif KPI_parameter._parameter_value == 'emails_bounced' %}
  #     ${emails_bounced}
  #   {% elsif KPI_parameter._parameter_value == 'emails_soft_bounced' %}
  #     ${emails_soft_bounced}
  #   {% elsif KPI_parameter._parameter_value == 'emails_unsubscribed' %}
  #     ${unique_emails_unsubscribed}
  #   {% elsif KPI_parameter._parameter_value == 'orders' %}
  #     ${order_parameter}
  #   {% elsif KPI_parameter._parameter_value == 'orders_with_vouchers' %}
  #     ${orders_with_vouchers}
  #   {% elsif KPI_parameter._parameter_value == 'discount_amount' %}
  #     ${discount_amount}
  #   {% elsif KPI_parameter._parameter_value == 'gmv_gross' %}
  #     ${gmv_gross}

  #   {% elsif KPI_parameter._parameter_value == 'deliveries_rate' %}
  #     avg(${delivered_emails_per_total_emails_sent})*100
  #   {% elsif KPI_parameter._parameter_value == 'bounce_rate' %}
  #     avg(${bounced_emails_per_total_emails_sent})
  #   {% elsif KPI_parameter._parameter_value == 'order_rate' %}
  #     (${order_rate_parameter})*100
  #   {% elsif KPI_parameter._parameter_value == 'opens_rate' %}
  #     (${open_rate_parameter})*100
  #   {% elsif KPI_parameter._parameter_value == 'order_rate_with_voucher' %}
  #     avg(${order_rate_with_vouchers})*100
  #   {% elsif KPI_parameter._parameter_value == 'discount_order_share' %}
  #     avg(${discount_order_share})*100
  #   {% elsif KPI_parameter._parameter_value == 'discount_value_share' %}
  #     avg(${discount_value_share})*100
  #   {% elsif KPI_parameter._parameter_value == 'average_order_value' %}
  #     ${average_order_value}
  #   {% endif %}
  #   ;;

  # }

  measure: KPI_crm {
    # label: "{% if reporting_parameter._parameter_value == \"unique\"%}
    # {{ KPI_parameter._label_from_parameter }} {% else %} Total & label_from_parameter {% endif%}"
    group_label: "* Dynamic KPI Fields *"
    label_from_parameter: KPI_parameter
    value_format: "#,##0.00"
    type: number
    sql:
    CASE
    WHEN {% parameter KPI_parameter %} = 'emails_sent' THEN (${emails_sent})
    WHEN {% parameter KPI_parameter %} = 'emails_delivered' THEN (${emails_delivered})
    WHEN {% parameter KPI_parameter %} = 'emails_opened' THEN (${open_parameter})
    WHEN {% parameter KPI_parameter %} = 'emails_clicked' THEN (${clicks_parameter})
    WHEN {% parameter KPI_parameter %} = 'emails_bounced' THEN (${emails_bounced})
    WHEN {% parameter KPI_parameter %} = 'emails_soft_bounced' THEN (${emails_soft_bounced})
    WHEN {% parameter KPI_parameter %} = 'emails_unsubscribed' THEN (${unique_emails_unsubscribed})
    WHEN {% parameter KPI_parameter %} = 'orders' THEN (${order_parameter})
    WHEN {% parameter KPI_parameter %} = 'orders_with_vouchers' THEN (${orders_with_vouchers})
    WHEN {% parameter KPI_parameter %} = 'discount_amount' THEN (${discount_amount})
    WHEN {% parameter KPI_parameter %} = 'gmv_gross' THEN (${gmv_gross})
    END;;

    }


    #     WHEN {% parameter KPI_parameter %} = 'deliveries_rate' THEN avg(${delivered_emails_per_total_emails_sent})*100
    # WHEN {% parameter KPI_parameter %} = 'bounce_rate' THEN avg(${bounced_emails_per_total_emails_sent})
    # WHEN {% parameter KPI_parameter %} = 'order_rate' THEN avg(${order_rate_parameter})*100
    # WHEN {% parameter KPI_parameter %} = 'opens_rate' THEN avg(${open_rate_parameter})*100
    # WHEN {% parameter KPI_parameter %} = 'order_rate_with_voucher' THEN  avg(${order_rate_with_vouchers})*100
    # WHEN {% parameter KPI_parameter %} = 'discount_order_share' THEN avg(${discount_order_share})*100
    # WHEN {% parameter KPI_parameter %} = 'discount_value_share' THEN avg(${discount_value_share})*100
    # WHEN {% parameter KPI_parameter %} = 'average_order_value' THEN ${average_order_value}

    # html:
    #   {% if KPI_parameter._parameter_value == 'deliveries_rate' %}
    #     {{ rendered_value | round: 2  | append: "%" }}
    #   {% elsif KPI_parameter._parameter_value == 'bounce_rate' %}
    #     {{ rendered_value | round: 2  | append: "%" }}
    #   {% elsif KPI_parameter._parameter_value == 'order_rate' %}
    #     {{ rendered_value | round: 2  | append: "%" }}
    #   {% elsif KPI_parameter._parameter_value == 'opens_rate' %}
    #     {{ rendered_value | round: 2  | append: "%" }}
    #   {% elsif KPI_parameter._parameter_value == 'order_rate_with_voucher' %}
    #     {{ rendered_value | round: 2  | append: "%" }}
    #   {% elsif KPI_parameter._parameter_value == 'discount_order_share' %}
    #     {{ rendered_value | round: 2  | append: "%" }}
    #   {% elsif KPI_parameter._parameter_value == 'discount_value_share' %}
    #     {{ rendered_value | round: 2  | append: "%" }}
    #   {% elsif KPI_parameter._parameter_value == 'gmv_gross' %}
    #     €{{ value | round }}
    #   {% elsif KPI_parameter._parameter_value == 'discount_amount' %}
    #     €{{ value | round }}
    #   {% elsif KPI_parameter._parameter_value == 'average_order_value' %}
    #     €{{ rendered_value }}
    #   {% else %}
    #     {{ value | round: 2 }}
    #   {% endif %};;




  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Detail
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # set: detail {
  #   fields: [
  #     canvas_name,
  #     in_control_group,
  #     canvas_step_name,
  #     canvas_variation_name,
  #     country,
  #     email_sent_at,
  #     days_sent_to_open,
  #     days_sent_to_click,
  #     emails_sent,
  #     emails_bounced,
  #     emails_soft_bounced,
  #     emails_delivered,
  #     unique_emails_opened,
  #     emails_opened,
  #     unique_emails_clicked,
  #     emails_clicked,
  #     cta_clicks,
  #     unique_cta_clicks,
  #     orders,
  #     unique_users_orders,
  #     orders_with_vouchers,
  #     discount_amount,
  #     gmv_gross,
  #     order_parameter,
  #     open_parameter,
  #     order_rate_parameter,
  #     unique_order_rate,
  #     order_rate
  #   ]
  # }
}
