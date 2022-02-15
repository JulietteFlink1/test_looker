view: crm_braze_canvas {
  sql_table_name: `flink-data-prod.reporting.crm_braze_canvas_reporting` ;;

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #           Dimensions
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: country {
    label: "Country"
    description: "The country code parsed from the email canvas name"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: canvas_name {
    label: "Canvas Name"
    description: "The email canvas name defined in Braze"
    type: string
    sql: ${TABLE}.canvas_name ;;
  }

  dimension: canvas_variation_name {
    label: "Canvas Variation Name"
    description: "The email canvas variation name defined in Braze"
    type: string
    sql: ${TABLE}.canvas_variation_name ;;
  }

  dimension: canvas_step_name {
    label: "Canvas Step Name"
    description: "The email canvas step name defined in Braze"
    type: string
    sql: ${TABLE}.canvas_step_name ;;
  }

  dimension: in_control_group {
    label: "Control Group for Canvas"
    description: "Canvas group name defined in Braze"
    type: yesno
    sql: ${TABLE}.is_control_group ;;
  }

  dimension: email_sent_at {
    allow_fill: yes
    label: "Date Email Sent"
    description: "The date, when the email was sent to the customer"
    type: date
    datatype: date
    sql: ${TABLE}.email_sent_at_date ;;
    # hidden: yes
  }

  ## hidden dimensions

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.canvas_name,${TABLE}.canvas_variation_name,${TABLE}.canvas_step_name, ${TABLE}.country_iso, ${TABLE}.email_sent_at_date) ;;
  }

  dimension: total_emails_sent {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.number_of_total_emails_sent, 0) ;;

  }

  dimension: total_emails_bounced {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.number_of_total_emails_bounced, 0) ;;
  }

  dimension: total_emails_delivered {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.number_of_total_emails_delivered, 0) ;;
  }

  dimension: num_unique_emails_opened {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.number_of_unique_emails_opened, 0) ;;
  }

  dimension: total_emails_opened {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.number_of_total_emails_opened, 0) ;;
  }

  dimension: num_unique_emails_clicked {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.number_of_unique_emails_clicked, 0) ;;
  }

  dimension: total_emails_clicked {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.number_of_total_emails_clicked, 0) ;;
  }

  dimension: num_unique_unsubscribed {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.number_of_unique_unsubscribed, 0) ;;
  }

  dimension: num_unique_users_orders {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.number_of_unique_users_orders, 0) ;;
  }

  dimension: total_orders {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.number_of_total_orders, 0) ;;
  }

  dimension: total_orders_with_vouchers {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.number_of_total_orders_with_vouchers, 0) ;;
  }

  dimension: total_vouchers_sent {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.number_of_total_vouchers_sent, 0) ;;
  }

  dimension: total_discount_amount {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.amt_total_discount, 0) ;;
  }

  dimension: total_gmv_gross {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.amt_total_gmv_gross, 0) ;;
  }

  dimension: unique_users_denominator {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.number_of_unique_users_denominator, 0) ;;
  }

  dimension: order_rate {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.order_rate, 0) ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Measures
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: sum_total_emails_sent {
    group_label: "Numbers"
    label: "All Unique Sents"
    description: "The number of unique recipients of an email canvas"
    type: sum
    sql: ${total_emails_sent} ;;
    # value_format_name: decimal_0
  }

  measure: sum_total_emails_bounced {
    group_label: "Numbers"
    label: "Bounces"
    description: "The number of emails, that have been bounced by the customers email provider"
    type: sum
    sql: ${total_emails_bounced} ;;
    # value_format_name: decimal_0
  }

  measure: sum_total_emails_delivered {
    group_label: "Numbers"
    label: "Deliveries"
    description: "The number of emails, that have been delivered to the customer - aka they have been received"
    type: sum
    sql: ${total_emails_delivered} ;;
    # value_format_name: decimal_0
  }

  measure: sum_unique_emails_opened {
    group_label: "Numbers"
    label: "Unique Opens"
    description: "The number of unique opens of an email - one customer can be counted only once per sent-out"
    type: sum
    sql: ${num_unique_emails_opened} ;;
    # value_format_name: decimal_0
  }

  measure: sum_total_emails_opened {
    group_label: "Numbers"
    label: "Total Opens"
    description: "The number of unique opens of an email - one customer can be counted n-times per sent-out"
    type: sum
    sql: ${total_emails_opened} ;;
    # value_format_name: decimal_0
  }

  measure: sum_unique_emails_clicked {
    group_label: "Numbers"
    label: "Unique Clicks"
    description: "The number of unique clicks of an email - one customer can be counted only once per sent-put"
    type: sum
    sql: ${num_unique_emails_clicked} ;;
    # value_format_name: decimal_0
  }

  measure: sum_total_emails_clicked {
    group_label: "Numbers"
    label: "Total Clicks"
    description: "The number of unique clicks of an email - one customer can be counted n-times per sent-put"
    type: sum
    sql: ${total_emails_clicked} ;;
    # value_format_name: decimal_0
  }

  measure: sum_unique_unsubscribed {
    group_label: "Numbers"
    label: "Unsubscribes"
    description: "The number of customers, that have clicked on the unsubscribe-link"
    type: sum
    sql: ${num_unique_unsubscribed} ;;
    # value_format_name: decimal_0
  }

  measure: sum_unique_users_orders {
    group_label: "Numbers"
    label: "Unique Users with Orders "
    description: "Number of Unique Users with at leats 1 Order that happened in the 12h after the last email open"
    type: sum
    sql: ${num_unique_users_orders} ;;
    # value_format_name: decimal_0
  }

  measure: sum_total_orders {
    group_label: "Numbers"
    label: "Total Orders "
    description: "Number of Orders that happened in the 12h after the last email open"
    type: sum
    sql: ${total_orders} ;;
    # value_format_name: decimal_0
  }

  measure: sum_total_orders_with_vouchers {
    group_label: "Numbers"
    label: "Total Orders with Vouchers"
    description: "Number of Orders with Vouchers that happened in the 12h after the last email open"
    type: sum
    sql: ${total_orders_with_vouchers} ;;
    # value_format_name: decimal_0
  }

  measure: sum_unique_users_denominator {
    hidden:  yes
    group_label: "Numbers"
    label: "Unique Deliveries or Opens"
    description: "Denominator for Order Rate"
    type: sum
    sql: ${unique_users_denominator} ;;
    # value_format_name: decimal_0
  }

  measure: sum_total_vouchers_sent {
    group_label: "Numbers"
    label: "Total Vouchers Sent"
    description: "Number of Vouchers that sent in orders that happened in the 12h after the last email open"
    type: sum
    sql: ${total_vouchers_sent} ;;
    # value_format_name: decimal_0
  }

  measure: sum_total_discount_amount {
    group_label: "Numbers"
    label: "Total Discount"
    description: "Total Value of discount vouchers"
    type: sum
    sql: ${total_discount_amount} ;;
    # value_format_name: decimal_0
  }

  measure: sum_total_gmv_gross {
    group_label: "Numbers"
    label: "Total GMV (gross) "
    description: "Total GMV (gross) of orders"
    type: sum
    sql: ${total_gmv_gross} ;;
    # value_format_name: decimal_0
  }

  measure: avg_order_rate {
    hidden:  yes
    group_label: "Ratios"
    label: "Order Rate "
    description: "Average Order Rate"
    type: average
    sql: ${order_rate} ;;
    # value_format_name: decimal_0
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Ratios based on measures
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: bounce_rate {
    group_label: "Ratios"
    label: "Bounce Rate"
    description: "Percentage: how many emails have been bounced based on all emails sent"
    type: number
    sql: ${sum_total_emails_bounced} / NULLIF(${sum_total_emails_sent}, 0) ;;
    value_format_name: percent_1
  }

  measure: deliveries_rate {
    group_label: "Ratios"
    label: "Deliveries Rate"
    description: "Percentage: how many emails have been delivered based on all emails sent"
    type: number
    sql: ${sum_total_emails_delivered} / NULLIF(${sum_total_emails_sent}, 0) ;;
    value_format_name: percent_0
  }

  measure: total_opens_rate {
    group_label: "Ratios"
    label: "Total Opens Rate"
    description: "Percentage: how many emails have been delivered based on all emails delivered"
    type: number
    sql: ${sum_total_emails_opened} / NULLIF(${sum_total_emails_delivered}, 0) ;;
    value_format_name: percent_1
  }

  measure: unique_opens_rate {
    group_label: "Ratios"
    label: "Unique Opens Rate"
    description: "Percentage: how many emails have been delivered based on all emails delivered"
    type: number
    sql: ${sum_unique_emails_opened} / NULLIF(${sum_total_emails_delivered}, 0) ;;
    value_format_name: percent_1
  }

  measure: total_clicks_rate {
    group_label: "Ratios"
    label: "Total Clicks Rate"
    description: "Percentage: number of emails clicked divided by the number of emails delivered"
    type: number
    sql: ${sum_total_emails_clicked} / NULLIF(${sum_total_emails_delivered}, 0) ;;
    value_format_name: percent_1
  }

  measure: unique_clicks_rate {
    group_label: "Ratios"
    label: "Unique Clicks Rate"
    description: "Percentage: number of unique emails clicked divided by the number of emails delivered"
    type: number
    sql: ${sum_unique_emails_clicked} / NULLIF(${sum_total_emails_delivered}, 0) ;;
    value_format_name: percent_1
  }

  measure: unsubscribe_rate {
    group_label: "Ratios"
    label: "Unsubscribes Rate"
    description: "Percentage: number of emails clicked on unsubscribe-link divided by the number of emails delivered"
    type: number
    sql: ${sum_unique_unsubscribed} / NULLIF(${sum_total_emails_delivered}, 0) ;;
    value_format_name: percent_1
  }

  measure: total_order_rate {
    group_label: "Ratios"
    label: "Total Order Rate"
    description: "Percentage: number of orders made in the 12h after the last opening of the email divided by the number of emails opened (or sent)"
    type: number
    sql: ${sum_total_orders} / NULLIF(${sum_unique_users_denominator}, 0) ;;
    value_format_name: percent_1
  }

  measure: unique_order_rate {
    group_label: "Ratios"
    label: "Unique Order Rate"
    description: "Percentage: number of users who made at least 1 order in the 12h after the last opening of the email divided by the number of emails opened (or sent)"
    type: number
    sql: ${sum_unique_users_orders} / NULLIF(${sum_unique_users_denominator}, 0) ;;
    value_format_name: percent_1
  }

  measure: order_rate_with_voucher {
    group_label: "Ratios"
    label: "Total Order Rate with Vouchers"
    description: "Percentage: number of orders made in the 12h after sending an email divided by the number of emails opened (or sent)"
    type: number
    sql: ${sum_total_orders_with_vouchers} / NULLIF(${sum_unique_users_denominator}, 0) ;;
    value_format_name: percent_1
  }

  measure: discount_order_share {
    group_label: "Ratios"
    label: "Discount Order Share"
    description: "Percentage: number of orders with voucher discounts divided by the total number of ordres made in the 12h after the last opening of the email"
    type: number
    sql: ${sum_total_orders_with_vouchers} / NULLIF(${sum_total_orders}, 0);;
    value_format_name: percent_1
    }

  measure: discount_value_share {
    group_label: "Ratios"
    label: "Discount Value Share "
    description: "Percentage: total of voucher discounts divided by the total gmv (gross) of ordres made in the 12h after the last opening of the email"
    type: number
    sql: ${sum_total_discount_amount} / NULLIF(${sum_total_gmv_gross}, 0);;
    value_format_name: percent_1
    }

  measure: average_order_value {
    group_label: "Ratios"
    label: "Average Order Value"
    description: "Average GMV (gross) based on Total Orders"
    type: number
    sql: ${sum_total_gmv_gross} / NULLIF(${sum_total_orders}, 0);;
    value_format_name: percent_1
    }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Parameters
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter: reporting_parameter {
    label: "* Granularity Parameter *"
    group_label: "* Dynamic KPI Fields *"
    type: unquoted
    allowed_value: { value: "total"                  label: "Totals"}
    allowed_value: { value: "unique"                label: "Unique"}
  }


  parameter: KPI_absolute {
    label: "* Absolute KPI Parameter *"
    group_label: "* Dynamic KPI Fields *"
    type: unquoted
    allowed_value: { value: "emails_sent"                     label: "Emails Sent"}
    allowed_value: { value: "emails_delivered"                label: "Deliveries"}
    allowed_value: { value: "emails_bounced"                  label: "Bounces"}
    allowed_value: { value: "emails_opened"                   label: "Emails Opened"}
    allowed_value: { value: "emails_clicked"                  label: "Emails Clicked"}
    allowed_value: { value: "emails_unsubscribed"             label: "Emails Unsubscribed"}
    allowed_value: { value: "orders"                          label: "Orders"}
    allowed_value: { value: "orders_with_vouchers"            label: "Orders with vouchers"}
    allowed_value: { value: "discount_amount"                 label: "Discount Amount"}
    allowed_value: { value: "gmv_gross"                       label: "GMV Gross"}
    allowed_value: { value: "average_order_value"             label: "Average Order Value"}

    default_value: "emails_sent"
  }

  parameter: KPI_rates {
    label: "* Rates KPI Parameter *"
    group_label: "* Dynamic KPI Fields *"
    type: unquoted
    allowed_value: { value: "deliveries_rate"                 label: "Deliveries Rate"}
    allowed_value: { value: "bounce_rate"                     label: "Bounce Rate"}
    allowed_value: { value: "opens_rate"                      label: "Opens Rate"}
    allowed_value: { value: "click_rate"                      label: "Click Rate"}
    allowed_value: { value: "unsubscribe_rate"                label: "Unsubscribe Rate"}
    allowed_value: { value: "order_rate"                      label: "Order Rate"}
    allowed_value: { value: "order_rate_with_voucher"         label: "Order Rate with Voucher"}
    allowed_value: { value: "discount_order_share"            label: "Discount Order Share"}
    allowed_value: { value: "discount_value_share"            label: "Discount Value Share"}

    default_value: "discount_order_share"
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Dynamic Measures
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: emails_opened_dynamic {
    group_label: "* Dynamic KPI Fields *"
    label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Emails Opened {% else %} Total Opens {% endif%}"
    type: number
    # value_format_name: id
    sql:
    {% if reporting_parameter._parameter_value == 'total' %}
      ${sum_total_emails_opened}
    {% elsif reporting_parameter._parameter_value == 'unique' %}
      ${sum_unique_emails_opened}
    {% endif %};;
  }

  measure: emails_clicked_dynamic {
    group_label: "* Dynamic KPI Fields *"
    label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Emails Clicked {% else %} Total Clicks {% endif%}"
    type: number
    # value_format_name: id
    sql:
    {% if reporting_parameter._parameter_value == 'total' %}
      ${sum_total_emails_clicked}
    {% elsif reporting_parameter._parameter_value == 'unique' %}
      ${sum_unique_emails_clicked}
    {% endif %};;
  }

  measure: orders_dynamic {
    group_label: "* Dynamic KPI Fields *"
    label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Users Ordered {% else %} Total Orders {% endif%}"
    type: number
    # value_format_name: id
    sql:
    {% if reporting_parameter._parameter_value == 'total' %}
      ${sum_total_orders}
    {% elsif reporting_parameter._parameter_value == 'unique' %}
      ${sum_unique_users_orders}
    {% endif %};;
  }

  measure: opens_rate_dynamic {
    group_label: "* Dynamic KPI Fields *"
    label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Open Rate {% else %} Total Open Rate {% endif%}"
    type: number
    value_format: "0.0%"
    sql:
    {% if reporting_parameter._parameter_value == 'total' %}
      ${total_opens_rate}
    {% elsif reporting_parameter._parameter_value == 'unique' %}
     ${unique_opens_rate}
    {% endif %};;
  }

  measure: click_rate_dynamic {
    group_label: "* Dynamic KPI Fields *"
    label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Click Rate {% else %} Total Click Rate {% endif%}"
    type: number
    value_format: "0.0%"
    sql:
    {% if reporting_parameter._parameter_value == 'total' %}
      ${total_clicks_rate}
    {% elsif reporting_parameter._parameter_value == 'unique' %}
     ${unique_clicks_rate}
    {% endif %};;
  }

  measure: order_rate_dynamic {
    group_label: "* Dynamic KPI Fields *"
    label: "{% if reporting_parameter._parameter_value == \"unique\"%} Unique Order Rate {% else %} Total Order Rate {% endif%}"
    type: number
    value_format: "0.0%"
    sql:
    {% if reporting_parameter._parameter_value == 'total' %}
      ${total_order_rate}
    {% elsif reporting_parameter._parameter_value == 'unique' %}
      ${unique_order_rate}
    {% endif %};;
  }

  measure: KPI_absolute_dynamic {
    group_label: "* Dynamic KPI Fields *"
    label_from_parameter: KPI_absolute
    value_format_name: decimal_2
    type: number
    sql:
    {% if KPI_absolute._parameter_value == 'emails_sent' %}
      ${sum_total_emails_sent}
    {% elsif KPI_absolute._parameter_value == 'emails_delivered' %}
      ${sum_total_emails_delivered}
    {% elsif KPI_absolute._parameter_value == 'emails_opened' %}
      ${emails_opened_dynamic}
    {% elsif KPI_absolute._parameter_value == 'emails_clicked' %}
      ${emails_clicked_dynamic}
    {% elsif KPI_absolute._parameter_value == 'emails_bounced' %}
      ${sum_total_emails_bounced}
    {% elsif KPI_absolute._parameter_value == 'emails_unsubscribed' %}
      ${sum_unique_unsubscribed}
    {% elsif KPI_absolute._parameter_value == 'orders' %}
      ${orders_dynamic}
    {% elsif KPI_absolute._parameter_value == 'orders_with_vouchers' %}
      ${sum_total_orders_with_vouchers}
    {% elsif KPI_absolute._parameter_value == 'discount_amount' %}
      ${sum_total_discount_amount}
    {% elsif KPI_absolute._parameter_value == 'gmv_gross' %}
      ${sum_total_gmv_gross}
    {% elsif KPI_absolute._parameter_value == 'average_order_value' %}
      ${average_order_value}
    {% endif %}
    ;;
  }


  measure: KPI_rates_dynamic {
    group_label: "* Dynamic KPI Fields *"
    label_from_parameter: KPI_rates
    value_format: "0.0%"
    type: number
    sql:
    {% if KPI_rates._parameter_value == 'deliveries_rate' %}
      ${deliveries_rate}
    {% elsif KPI_rates._parameter_value == 'bounce_rate' %}
      ${bounce_rate}
    {% elsif KPI_rates._parameter_value == 'opens_rate' %}
      ${opens_rate_dynamic}
    {% elsif KPI_rates._parameter_value == 'click_rate' %}
      ${click_rate_dynamic}
    {% elsif KPI_rates._parameter_value == 'unsubscribe_rate' %}
      ${unsubscribe_rate}
    {% elsif KPI_rates._parameter_value == 'order_rate' %}
      ${order_rate_dynamic}
    {% elsif KPI_rates._parameter_value == 'order_rate_with_voucher' %}
      ${order_rate_with_voucher}
    {% elsif KPI_rates._parameter_value == 'discount_order_share' %}
      ${discount_order_share}
    {% elsif KPI_rates._parameter_value == 'discount_value_share' %}
      ${discount_value_share}
    {% endif %}
    ;;
    }


} # end view
