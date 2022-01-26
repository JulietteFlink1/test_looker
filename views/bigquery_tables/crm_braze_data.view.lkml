view: crm_braze_data {
  sql_table_name: `flink-data-prod.curated.braze_campaign`
    ;;
  view_label: "* CRM Braze Data *"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Dimensions
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: campaign_id {
    label: "Campaign ID"
    description: "The email campaign ID defined in Braze"
    type: string
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: campaign_name {
    label: "Campaign Name"
    description: "The email campaign name defined in Braze"
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: canvas_id {
    label: "Canvas ID"
    description: "The email canvas ID defined in Braze"
    type: string
    sql: ${TABLE}.canvas_name ;;
  }

  dimension: canvas_name {
    label: "Canvas Name"
    description: "The email canvas name defined in Braze"
    type: string
    sql: ${TABLE}.canvas_name ;;
  }


  dimension: in_control_group_campaign {
    label: "Control Group for Campaign"
    description: "Campaign group name defined in Braze"
    type: yesno
    sql: ${TABLE}.is_control_group ;;
  }


  dimension: country {
    label: "Country"
    description: "The country code parsed from the email campaign name"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: email_sent_at {
    label: "Date Email Sent"
    description: "The date, when the email was sent to the customer"
    type: date
    datatype: date
    sql: ${TABLE}.email_sent_at_date ;;
    hidden: yes
  }

  dimension_group: email_sent_at {
    label: "Date Email Sent"
    description: "The date, when the email was sent to the customer"
    type: time
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${email_sent_at} ;;
    datatype: date
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Hidden Fields
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.braze_campaign_uuid ;;
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

  dimension: num_emails_sent {
    type: number
    sql: ${TABLE}.number_of_emails_sent ;;
    hidden: yes
  }

  dimension: num_all_sents {
    type: number
    sql: ${TABLE}.number_of_emails_sent ;;
    hidden: yes
  }

  dimension: num_emails_sent_count_all {
    type: number
    sql: ${TABLE}.number_of_emails_sent_count_all ;;
    hidden: yes
  }

  dimension: num_unique_emails_bounced {
    type: number
    sql: ${TABLE}.number_of_unique_emails_bounced ;;
    hidden: yes
  }

  dimension: num_emails_bounced {
    type: number
    sql: ${TABLE}.number_of_emails_bounced ;;
    hidden: yes
  }

  dimension: num_unique_emails_soft_bounced {
    type: number
    sql: ${TABLE}.number_of_unique_emails_soft_bounced ;;
    hidden: yes
  }

  dimension: num_emails_soft_bounced {
    type: number
    sql: ${TABLE}.number_of_emails_soft_bounced ;;
    hidden: yes
  }

  dimension: num_emails_delivered {
    type: number
    sql: ${TABLE}.number_of_emails_delivered ;;
    hidden: yes
  }

  dimension: num_unique_emails_opened {
    type: number
    sql: ${TABLE}.number_of_unique_emails_opened ;;
    hidden: yes
  }

  dimension: num_emails_opened {
    type: number
    sql: ${TABLE}.number_of_emails_opened ;;
    hidden: yes
  }

  dimension: num_unique_emails_clicked {
    type: number
    sql: ${TABLE}.number_of_unique_emails_clicked ;;
    hidden: yes
  }

  dimension: num_emails_clicked {
    type: number
    sql: ${TABLE}.number_of_emails_clicked ;;
    hidden: yes
  }

  dimension: num_unique_unsubscribed {
    type: number
    sql: ${TABLE}.number_of_unique_unsubscribed ;;
    hidden: yes
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    value_format_name: decimal_0
    hidden: yes
  }

  dimension: num_orders_opened {
    type: number
    sql: ${TABLE}.number_of_orders_opened ;;
    hidden: yes
  }

  dimension: num_orders_sent {
    type: number
    sql: ${TABLE}.number_of_orders_sent ;;
    hidden: yes
  }

  dimension: num_unique_orders_opened {
    type: number
    sql: ${TABLE}.number_of_unique_orders_opened ;;
    hidden: yes
  }

  dimension: num_unique_orders_sent {
    type: number
    sql: ${TABLE}.number_of_unique_orders_sent ;;
    hidden: yes
  }

  dimension: num_orders_with_vouchers_opened {
    type: number
    sql: ${TABLE}.number_of_orders_with_vouchers_opened ;;
    hidden: yes
  }

  dimension: num_orders_with_vouchers_sent {
    type: number
    sql: ${TABLE}.number_of_orders_with_vouchers_sent ;;
    hidden: yes
  }

  dimension: discount_amount_opened {
    type: number
    sql: ${TABLE}.amt_discount_gross_opened ;;
    hidden: yes
  }

  dimension: discount_amount_sent {
    type: number
    sql: ${TABLE}.amt_discount_gross_sent ;;
    hidden: yes
  }

  dimension: gmv_gross_opened {
    type: number
    sql: ${TABLE}.amt_gmv_gross_opened ;;
    hidden: yes
  }

  dimension: gmv_gross_sent {
    type: number
    sql: ${TABLE}.amt_gmv_gross_sent ;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Measures
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: total_recipients {
    type: sum
    label: "Unique Sents"
    description: "The number of unique recipients of an email campaign"
    group_label: "Numbers"
    sql: ${num_emails_sent} ;;
    value_format_name: decimal_0
  }

  measure: total_all_sent {
    type: sum
    label: "Total Emails Sent"
    description: "The number of unique recipients of an email campaign"
    group_label: "Numbers"
    sql: ${num_all_sents} ;;
    value_format_name: decimal_0
  }

  measure: total_emails_bounced_unique {
    type: sum
    label: "Bounces"
    description: "The number of emails, that have been bounced by the customers email provider"
    group_label: "Numbers"
    sql: ${num_unique_emails_bounced};;
    value_format_name: decimal_0
  }

  measure: total_emails_soft_bounced_unique {
    type: sum
    label: "Soft Bounces"
    description: "The number of emails, that have been bounced by the customers email provider"
    group_label: "Numbers"
    sql: ${num_unique_emails_soft_bounced} ;;
    value_format_name: decimal_0
  }

  measure: total_emails_delivered {
    type: sum
    label: "Deliveries"
    description: "The number of emails, that have been delivered to the customer - aka they have been received"
    group_label: "Numbers"
    sql: ${num_emails_delivered} ;;
    value_format_name: decimal_0
  }

  measure: total_emails_opened_unique {
    type:  sum
    label: "Unique Opens"
    description: "The number of unique opens of an email - one customer can be counted only once per sent-put"
    group_label: "Numbers"
    sql: ${num_unique_emails_opened} ;;
    value_format_name: decimal_0
  }

  measure: total_emails_opened {
    type:  sum
    label: "Total Opens"
    description: "The number of unique opens of an email - one customer can be counted n-times per sent-put"
    group_label: "Numbers"
    sql: ${num_emails_opened} ;;
    value_format_name: decimal_0
  }

  measure: total_emails_clicked_unique {
    type: sum
    label: "Unique Clicks"
    description: "The number of unique clicks of an email - one customer can be counted only once per sent-put"
    group_label: "Numbers"
    sql: ${num_unique_emails_clicked} ;;
    value_format_name: decimal_0
  }

  measure: total_emails_clicked {
    type: sum
    label: "Total Clicks"
    description: "The number of unique clicks of an email - one customer can be counted n-times per sent-put"
    group_label: "Numbers"
    sql: ${num_emails_clicked} ;;
    value_format_name: decimal_0
  }

  measure: total_cta_clicks {
    type: number
    label: "Total CTA Clicks"
    description: "The total clicks, that are not clicks on the unsubscribe-link"
    group_label: "Numbers"
    sql:  ${total_emails_clicked} - ${total_emails_unsubscribed};;
    value_format_name: decimal_0
  }

  measure: unique_cta_clicks {
    type: number
    label: "Unique CTA Clicks"
    description: "The unique clicks, that are not clicks on the unsubscribe-link"
    group_label: "Numbers"
    sql: ${total_emails_clicked_unique} - ${total_emails_unsubscribed}  ;;
    value_format_name: decimal_0
  }

  measure: total_emails_unsubscribed {
    type: sum
    label: "Unsubscribes"
    description: "The number of customers, that have clicked on the unsubscribe-link"
    group_label: "Numbers"
    sql: ${num_unique_unsubscribed} ;;
    value_format_name: decimal_0
  }

  measure: avg_days_sent_open {
    type: average
    label: "ø Days Sent to Open"
    description: "The days between the sent-out and the first opening of an email"
    group_label: "Numbers"
    sql:  ${days_sent_to_open};;
    value_format_name: decimal_2
  }

  measure: avg_days_sent_click {
    type: average
    label: "ø Days Sent to Click"
    description: "The days between the sent-out and the first click of an email"
    group_label: "Numbers"
    sql: ${days_sent_to_click} ;;
    value_format_name: decimal_2
  }

  measure: total_orders_opened {
    type: sum
    label: "Total Orders opened "
    description: "Number of Orders that happened in the 24h after the last email open"
    group_label: "Numbers"
    sql: ${num_orders_opened};;
    value_format_name: decimal_0
  }

  measure: total_orders_sent {
    type: sum
    label: "Total Orders sent"
    description: "Number of Orders that happened in the 24h after the last email open"
    group_label: "Numbers"
    sql: ${num_orders_sent};;
    value_format_name: decimal_0
  }

  measure: unique_orders_opened {
    type: sum
    label: "Unique Orders opened"
    description: "Number of Orders that happened in the 24h after the last email open"
    group_label: "Numbers"
    sql: ${num_unique_orders_opened};;
    value_format_name: decimal_0
  }

  measure: unique_orders_sent {
    type: sum
    label: "Unique Orders sent"
    description: "Number of Orders that happened in the 24h after the last email open"
    group_label: "Numbers"
    sql: ${num_unique_orders_sent};;
    value_format_name: decimal_0
  }

  measure: total_orders_with_vouchers_opened {
    type: sum
    label: "Total Orders with Vouchers opened"
    description: "Number of Orders with Vouchers that happened in the 24h after the last email open"
    group_label: "Numbers"
    sql: ${num_orders_with_vouchers_opened};;
    value_format_name: decimal_0
  }

  measure: total_orders_with_vouchers_sent {
    type: sum
    label: "Total Orders with Vouchers sent"
    description: "Number of Orders with Vouchers that happened in the 24h after the last email open"
    group_label: "Numbers"
    sql: ${num_orders_with_vouchers_sent};;
    value_format_name: decimal_0
  }

  measure: total_discount_opened {
    type: sum
    label: "Total Discount opened"
    description: "Total Value of discount vouchers"
    group_label: "Numbers"
    sql: ${discount_amount_opened};;
    value_format_name: decimal_0
  }

  measure: total_discount_sent {
    type: sum
    label: "Total Discount sent"
    description: "Total Value of discount vouchers"
    group_label: "Numbers"
    sql: ${discount_amount_sent};;
    value_format_name: decimal_0
  }

  measure: total_gmv_gross_opened {
    type: sum
    label: "Total GMV (gross) opened"
    description: "Total GMV (gross) of orders"
    group_label: "Numbers"
    sql: ${gmv_gross_opened};;
    value_format_name: decimal_0
  }

  measure: total_gmv_gross_sent {
    type: sum
    label: "Total GMV (gross) sent"
    description: "Total GMV (gross) of orders"
    group_label: "Numbers"
    sql: ${gmv_gross_sent};;
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
    sql: ${total_emails_bounced_unique} / NULLIF(${total_all_sent}, 0);;
    value_format_name: percent_2
  }

  measure: delivered_emails_per_total_emails_sent {
    type: number
    label: "Deliveries Rate"
    description: "Percentage: how many emails have been delivered based on all emails sent"
    group_label: "Ratios"
    sql: ${total_emails_delivered} / NULLIF(${total_all_sent}, 0);;
    value_format_name: percent_2
  }

  measure: total_opened_emails_per_emails_delivered {
    type: number
    label: "Total Opens Rate"
    description: "Percentage: number of emails opened divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_opened} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: unique_opened_emails_per_emails_delivered {
    type: number
    label: "Unique Opens Rate"
    description: "Percentage: number of unique emails opened divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_opened_unique} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: total_clicked_emails_per_emails_delivered {
    type: number
    label: "Total Clicks Rate"
    description: "Percentage: number of emails clicked divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_clicked} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: total_cta_clicked_emails_per_emails_delivered {
    type: number
    label: "Total CTA Clicks Rate"
    description: "Percentage: number of emails clicked on CTA (not the unsubscribe-link) divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_clicked} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: unique_clicked_emails_per_emails_delivered {
    type: number
    label: "Unique Clicks Rate"
    description: "Percentage: number of unique emails clicked divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_clicked_unique} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: unique_cta_clicked_emails_per_emails_delivered {
    type: number
    label: "Unique CTA Clicks Rate"
    description: "Percentage: number of unique emails clicked on CTA (not the unsubscribe-link) divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${unique_cta_clicks} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: unsubscribed_emails_per_emails_delivered {
    type: number
    label: "Unsubscribes Rate"
    description: "Percentage: number of emails clicked on unsubscribe-link divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_unsubscribed} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: total_order_rate_opened {
    type: number
    label: "Total Order Rate (opened)"
    description: "Percentage: number of orders made in the 12h after the last opening of the email divided by the number of emails opened"
    group_label: "Ratios"
    sql: ${total_orders_opened} / NULLIF(${total_emails_opened}, 0);;
    value_format_name: percent_2
  }

  measure: total_order_rate_sent {
    type: number
    label: "Total Order Rate (sent)"
    description: "Percentage: number of orders made in the 12h after email being sent divided by the number of emails opened"
    group_label: "Ratios"
    sql: ${total_orders_sent} / NULLIF(${total_all_sent}, 0);;
    value_format_name: percent_2
  }

  measure: unique_order_rate_opened {
    type: number
    label: "Unique Order Rate (opened)"
    description: "Percentage: number of unique orders made in the 24h after the last opening of the email divided by the number of unique emails opened"
    group_label: "Ratios"
    sql: ${unique_orders_opened} / NULLIF(${total_emails_opened_unique}, 0);;
    value_format_name: percent_2
  }

  measure: unique_order_rate_sent {
    type: number
    label: "Unique Order Rate (sent)"
    description: "Percentage: number of unique orders made in the 12h after sending an email divided by the number of unique emails opened"
    group_label: "Ratios"
    sql: ${unique_orders_sent} / NULLIF(${total_recipients}, 0);;
    value_format_name: percent_2
  }

  measure: total_order_rate_with_vouchers_opened {
    type: number
    label: "Total Order Rate with Vouchers (opened)"
    description: "Percentage: number of orders made in the 12h after the last opening of the email divided by the number of emails opened"
    group_label: "Ratios"
    sql: ${total_orders_with_vouchers_opened} / NULLIF(${total_emails_opened}, 0);;
    value_format_name: percent_2
  }

  measure: total_order_rate_with_vouchers_sent {
    type: number
    label: "Total Order Rate with Vouchers (sent)"
    description: "Percentage: number of orders made in the 12h after sending an email divided by the number of emails opened"
    group_label: "Ratios"
    sql: ${total_orders_with_vouchers_sent} / NULLIF(${total_all_sent}, 0);;
    value_format_name: percent_2
  }

  measure: discount_order_share_opened {
    type: number
    label: "Discount Order Share (opened)"
    description: "Percentage: number of orders with voucher discounts divided by the total number of ordres made in the 12h after the last opening of the email"
    group_label: "Ratios"
    sql: ${total_orders_with_vouchers_opened} / NULLIF(${total_orders_opened}, 0);;
    value_format_name: percent_2
  }

  measure: discount_order_share_sent {
    type: number
    label: "Discount Order Share (sent)"
    description: "Percentage: number of orders with voucher discounts divided by the total number of ordres made in the 12h after sending an email"
    group_label: "Ratios"
    sql: ${total_order_rate_with_vouchers_sent} / NULLIF(${total_orders_sent}, 0);;
    value_format_name: percent_2
  }

  measure: discount_value_share_opened {
    type: number
    label: "Discount Value Share (opened) "
    description: "Percentage: total of voucher discounts divided by the total gmv (gross) of ordres made in the 12h after the last opening of the email"
    group_label: "Ratios"
    sql: ${total_discount_opened} / NULLIF(${total_gmv_gross_opened}, 0);;
    value_format_name: percent_2
  }

  measure: discount_value_share_sent {
    type: number
    label: "Discount Value Share (sent) "
    description: "Percentage: total of voucher discounts divided by the total gmv (gross) of ordres made in the 12h after sending an email"
    group_label: "Ratios"
    sql: ${total_discount_sent} / NULLIF(${total_gmv_gross_sent}, 0);;
    value_format_name: percent_2
  }

  measure: average_order_value_opened {
    type: number
    label: "Average Order Value (opened)"
    description: "Average GMV (gross) based on Total Orders"
    group_label: "Ratios"
    sql: ${total_gmv_gross_opened} / NULLIF(${total_orders_opened}, 0);;
    value_format_name: decimal_2
  }

  measure: average_order_value_sent {
    type: number
    label: "Average Order Value (sent)"
    description: "Average GMV (gross) based on Total Orders"
    group_label: "Ratios"
    sql: ${total_gmv_gross_sent} / NULLIF(${total_orders_sent}, 0);;
    value_format_name: decimal_2
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Parameter
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter: KPI_parameter {
    label: "* KPI Parameter *"
    group_label: "* Dynamic KPI Fields *"
    type: unquoted
    # initial sends
    allowed_value: { value: "sends"                  label: "Sends"}
    allowed_value: { value: "unique_recipients"      label: "Unique Recipients"}
    allowed_value: { value: "bounces"                label: "Bounces"}
    allowed_value: { value: "bounce_rate"            label: "Bounce Rate"}
    allowed_value: { value: "soft_bounces"           label: "Soft Bounces"}
    allowed_value: { value: "deliveries"             label: "Deliveries"}
    allowed_value: { value: "deliveries_rate"        label: "Deliveries Rate"}
    # opens
    allowed_value: { value: "total_opens"            label: "Total Opens"}
    allowed_value: { value: "total_opens_rate"       label: "Total Opens Rate"}
    allowed_value: { value: "unique_opens"           label: "Unique Opens"}
    allowed_value: { value: "unique_opens_rate"      label: "Unique Opens Rate"}
    allowed_value: { value: "avg_days_sent_to_open"  label: "ø Days Sent to Open"}
    #clicks
    allowed_value: { value: "total_clicks"           label: "Total Clicks"}
    allowed_value: { value: "total_clicks_rate"      label: "Total Clicks Rate"}
    allowed_value: { value: "total_cta_clicks"       label: "Total CTA Clicks"}
    allowed_value: { value: "total_cta_clicks_rate"  label: "Total CTA Clicks Rate"}
    allowed_value: { value: "unique_clicks"          label: "Unique Clicks"}
    allowed_value: { value: "unique_clicks_rate"     label: "Unique Clicks Rate"}
    allowed_value: { value: "unique_cta_clicks"      label: "Unique CTA Clicks"}
    allowed_value: { value: "unique_cta_clicks_rate" label: "Unique CTA Clicks Rate"}
    allowed_value: { value: "avg_days_sent_to_click" label: "ø Days Sent to Click"}
    # unsubscribes
    allowed_value: { value: "unsubscribes"           label: "Unsubscribes"}
    allowed_value: { value: "unsubscribes_rate"      label: "Unsubscribe Rate"}
    # orders
    allowed_value: { value: "total_orders_opened"           label: "Total Orders (opened)"}
    allowed_value: { value: "total_orders_sent"           label: "Total Orders (sent)"}

    allowed_value: { value: "total_order_rate_opened"       label: "Total Order Rate (opened)"}
    allowed_value: { value: "total_order_rate_sent"       label: "Total Order Rate (sent)"}

    allowed_value: { value: "unique_order_rate_opened"      label: "Unique Order Rate (opened)"}
    allowed_value: { value: "unique_order_rate_sent"      label: "Unique Order Rate (sent)"}

    allowed_value: { value: "unique_orders_opened"          label: "Unique Orders (opened)"}
    allowed_value: { value: "unique_orders_sent"          label: "Unique Orders (sent)"}

    allowed_value: { value: "total_orders_with_vouchers_opened"        label: "Total Orders with Voucher (opened)"}
    allowed_value: { value: "total_orders_with_vouchers_sent"        label: "Total Orders with Voucher (sent)"}

    allowed_value: { value: "total_order_rate_with_vouchers_opened"    label: "Total Order Rate with Voucher (opened)"}
    allowed_value: { value: "total_order_rate_with_vouchers_sent"    label: "Total Order Rate with Voucher (sent)"}


    allowed_value: { value: "total_discount_opened"           label: "Total Discount Value (opened)"}
    allowed_value: { value: "total_discount_sent"           label: "Total Discount Value (sent)"}


    allowed_value: { value: "total_gmv_gross_opened"           label: "Total GMV (gross) (opened)"}
    allowed_value: { value: "total_gmv_gross_sent"           label: "Total GMV (gross) (sent)"}

    allowed_value: { value: "average_order_value_opened"           label: "Average Order Value (opened)"}
    allowed_value: { value: "average_order_value_sent"           label: "Average Order Value (sent)"}

    allowed_value: { value: "discount_order_share_opened"           label: "Discount Order Share (opened)"}
    allowed_value: { value: "discount_order_share_sent"           label: "Discount Order Share (sent)"}

    allowed_value: { value: "discount_value_share_opened"           label: "Discount Value Share (opened)"}
    allowed_value: { value: "discount_value_share_sent"           label: "Discount Value Share (sent)"}

    default_value: "sends"
  }

  measure: KPI_crm {
    label: "CRM KPI (dynamic)"
    group_label: "* Dynamic KPI Fields *"
    label_from_parameter: KPI_parameter
    #value_format: "#,##0.00"
    # value_format_name: id
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'bounces' %}
      ${total_emails_bounced_unique}
    {% elsif KPI_parameter._parameter_value == 'deliveries' %}
      ${total_emails_delivered}
    {% elsif KPI_parameter._parameter_value == 'avg_days_sent_to_click' %}
      ${avg_days_sent_click}
    {% elsif KPI_parameter._parameter_value == 'avg_days_sent_to_open' %}
      ${avg_days_sent_open}
    {% elsif KPI_parameter._parameter_value == 'sends' %}
      ${total_all_sent}
    {% elsif KPI_parameter._parameter_value == 'soft_bounces' %}
      ${total_emails_soft_bounced_unique}
    {% elsif KPI_parameter._parameter_value == 'total_clicks' %}
      ${total_emails_clicked}
    {% elsif KPI_parameter._parameter_value == 'total_opens' %}
      ${total_emails_opened}
    {% elsif KPI_parameter._parameter_value == 'unique_clicks' %}
      ${total_emails_clicked_unique}
    {% elsif KPI_parameter._parameter_value == 'unique_opens' %}
      ${total_emails_opened_unique}
    {% elsif KPI_parameter._parameter_value == 'unique_recipients' %}
      ${total_recipients}
    {% elsif KPI_parameter._parameter_value == 'unsubscribes' %}
      ${total_emails_unsubscribed}
    {% elsif KPI_parameter._parameter_value == 'bounce_rate' %}
      ${bounced_emails_per_total_emails_sent}
    {% elsif KPI_parameter._parameter_value == 'deliveries_rate' %}
      ${delivered_emails_per_total_emails_sent}
    {% elsif KPI_parameter._parameter_value == 'total_clicks_rate' %}
      ${total_clicked_emails_per_emails_delivered}
    {% elsif KPI_parameter._parameter_value == 'total_opens_rate' %}
      ${total_opened_emails_per_emails_delivered}
    {% elsif KPI_parameter._parameter_value == 'unique_clicks_rate' %}
      ${unique_clicked_emails_per_emails_delivered}
    {% elsif KPI_parameter._parameter_value == 'unique_opens_rate' %}
      ${unique_opened_emails_per_emails_delivered}
    {% elsif KPI_parameter._parameter_value == 'unsubscribes_rate' %}
      ${unsubscribed_emails_per_emails_delivered}

    {% elsif KPI_parameter._parameter_value == 'total_cta_clicks' %}
      ${total_cta_clicks}
    {% elsif KPI_parameter._parameter_value == 'total_cta_clicks_rate' %}
      ${total_cta_clicked_emails_per_emails_delivered}
    {% elsif KPI_parameter._parameter_value == 'unique_cta_clicks' %}
      ${unique_cta_clicks}
    {% elsif KPI_parameter._parameter_value == 'unique_cta_clicks_rate' %}
      ${unique_cta_clicked_emails_per_emails_delivered}


    {% elsif KPI_parameter._parameter_value == 'total_orders_opened' %}
      ${total_orders_opened}
    {% elsif KPI_parameter._parameter_value == 'total_orders_sent' %}
      ${total_orders_sent}

    {% elsif KPI_parameter._parameter_value == 'total_order_rate_opened' %}
      ${total_order_rate_opened}
    {% elsif KPI_parameter._parameter_value == 'total_order_rate_sent' %}
      ${total_order_rate_sent}

    {% elsif KPI_parameter._parameter_value == 'unique_orders_opened' %}
      ${unique_orders_opened}
    {% elsif KPI_parameter._parameter_value == 'unique_orders_sent' %}
      ${unique_orders_sent}

    {% elsif KPI_parameter._parameter_value == 'unique_order_rate_opened' %}
      ${unique_order_rate_opened}
    {% elsif KPI_parameter._parameter_value == 'unique_order_rate_sent' %}
      ${unique_order_rate_sent}

    {% elsif KPI_parameter._parameter_value == 'total_orders_with_vouchers_opened' %}
      ${total_orders_with_vouchers_opened}
    {% elsif KPI_parameter._parameter_value == 'total_orders_with_vouchers_sent' %}
      ${total_orders_with_vouchers_sent}

    {% elsif KPI_parameter._parameter_value == 'total_order_rate_with_vouchers_opened' %}
      ${total_order_rate_with_vouchers_opened}
    {% elsif KPI_parameter._parameter_value == 'total_order_rate_with_vouchers_sent' %}
      ${total_order_rate_with_vouchers_sent}

    {% elsif KPI_parameter._parameter_value == 'discount_order_share_opened' %}
      ${discount_order_share_opened}
    {% elsif KPI_parameter._parameter_value == 'discount_order_share_sent' %}
      ${discount_order_share_sent}

    {% elsif KPI_parameter._parameter_value == 'discount_value_share_opened' %}
      ${discount_value_share_opened}
    {% elsif KPI_parameter._parameter_value == 'discount_value_share_sent' %}
      ${discount_value_share_sent}

    {% elsif KPI_parameter._parameter_value == 'total_gmv_gross_opened' %}
      ${total_gmv_gross_opened}
    {% elsif KPI_parameter._parameter_value == 'total_gmv_gross_sent' %}
      ${total_gmv_gross_sent}

    {% elsif KPI_parameter._parameter_value == 'total_discount_opened' %}
      ${total_discount_opened}
    {% elsif KPI_parameter._parameter_value == 'total_discount_sent' %}
      ${total_discount_sent}

    {% elsif KPI_parameter._parameter_value == 'average_order_value_opened' %}
      ${average_order_value_opened}
    {% elsif KPI_parameter._parameter_value == 'average_order_value_sent' %}
      ${average_order_value_sent}

    {% endif %}
    ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Detail
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  set: detail {
    fields: [
      campaign_name,
      canvas_name,
      in_control_group_campaign,
      country,
      email_sent_at,
      days_sent_to_open,
      days_sent_to_click,
      num_emails_sent,
      total_all_sent,
      num_unique_emails_bounced,
      num_emails_bounced,
      num_unique_emails_soft_bounced,
      num_emails_soft_bounced,
      num_emails_delivered,
      num_unique_emails_opened,
      num_emails_opened,
      num_unique_emails_clicked,
      num_emails_clicked,
      num_orders_opened,
      num_orders_sent,
      num_unique_orders_opened,
      num_unique_orders_sent,
      num_orders_with_vouchers_opened,
      num_orders_with_vouchers_sent,
      discount_amount_opened,
      discount_amount_sent,
      gmv_gross_opened,
      gmv_gross_sent

    ]
  }
}
