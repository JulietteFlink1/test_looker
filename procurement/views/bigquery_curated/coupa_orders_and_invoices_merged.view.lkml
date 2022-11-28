view: coupa_orders_and_invoices_merged {
  sql_table_name: `flink-data-prod.curated_finance.coupa_orders_and_invoices_merged`
    ;;

# This view provides information about the orders and invoices that influence the budget of hubs.
# Author: Victor Breda
# Created: 2022-11-22

  dimension: coupa_orders_merged_uuid {
    type: string
    hidden: yes
    primary_key: yes
    description: "Unique identifier of the coupa_orders_and_invoices_merged model."
    sql: ${TABLE}.coupa_orders_merged_uuid ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    hidden: yes
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension_group: order_created {
    type: time
    group_label: "Dates & Timestamp"
    description: "Timestamp at which the order has been recorded in Coupa."
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.order_created_at_timestamp ;;
  }

  dimension: cost_center_id {
    type: string
    hidden: yes
    label: "Cost Center ID"
    description: "ID of the cost center linked to the purchase."
    sql: ${TABLE}.cost_center_id ;;
  }

  dimension: gl_account_id {
    type: string
    hidden: yes
    label: "GL Account ID"
    description: "ID of the General Ledger account linked to the purchase."
    sql: ${TABLE}.gl_account_id ;;
  }

  dimension: period_name {
    type: string
    hidden: yes
    description: "Name of the budgeted period. Contains information about the country and month. Eg. DE Budget 10/22."
    sql: ${TABLE}.period_name ;;
  }

  dimension: is_invoice {
    group_label: "Orders"
    type: yesno
    label: "Is Invoice"
    description: "Yes if the line comes from an invoice, No if it comes from an order."
    sql: ${purchase_order_number} is null ;;
  }

  dimension: invoice_number {
    group_label: "Orders"
    type: string
    description: "Invoice number reported in Coupa."
    sql: ${TABLE}.invoice_number ;;
  }

  dimension: purchase_order_number {
    group_label: "Orders"
    type: string
    description: "Purchase Order number reported in Coupa."
    sql: ${TABLE}.purchase_order_number ;;
  }

  dimension: requester_name {
    group_label: "Orders"
    description: "Name of the person who requested the order."
    type: string
    sql: ${TABLE}.requester_name ;;
  }

  dimension: item_description {
    group_label: "Orders"
    type: string
    description: "Description of the item that was ordered."
    sql: ${TABLE}.item_description ;;
  }

  dimension: number_of_ordered_units {
    type: number
    hidden: yes
    description: "Number of units of the item ordered."
    sql: ${TABLE}.number_of_ordered_units ;;
  }

  dimension: amt_ordered_gross_eur {
    type: number
    hidden: yes
    description: "Total amount of the order line, in euros. It corresponds to the unit price multiplied by the quantity ordered."
    sql: ${TABLE}.amt_ordered_gross_eur ;;
  }

  dimension: amt_unit_price_gross_eur {
    group_label: "Orders"
    type: number
    label: "€ Amount Unit Price Gross"
    description: "Price of a single unit of the item that was purchased. Incl. VAT, in euros."
    sql: ${TABLE}.amt_unit_price_gross_eur ;;
    value_format_name: eur
  }

  measure: sum_amt_ordered_gross_eur {
    group_label: "Orders"
    label: "€ Budget Spend Gross (Order based)"
    description: "Retrieved directly from Coupa. It corresponds to the unit prices multiplied by the quantities ordered. Incl. VAT, in euros"
    type: sum
    sql: ${amt_ordered_gross_eur} ;;
    value_format_name: eur
  }

  measure: sum_number_of_ordered_units {
    group_label: "Orders"
    label: "# Ordered Units"
    description: "Number of units of the item ordered."
    type: sum
    sql: ${number_of_ordered_units} ;;
    value_format_name: decimal_0
  }

  ######### Parameters

  parameter: date_granularity {
    group_label: "Dates & Timestamp"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  dimension: date_granularity_pass_through {
    group_label: "Parameters"
    description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
    type: string
    hidden: no # yes
    sql:
            {% if date_granularity._parameter_value == 'Day' %}
              "Day"
            {% elsif date_granularity._parameter_value == 'Week' %}
              "Week"
            {% elsif date_granularity._parameter_value == 'Month' %}
              "Month"
            {% endif %};;
  }


  ######## Dynamic Dimensions

  dimension: order_created_date_dynamic {
    group_label: "Dates & Timestamp"
    label: "Order Created Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${order_created_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${order_created_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${order_created_month}
    {% endif %};;
  }

}
