view: transaction_payment_fraud {
  derived_table: {
    sql: SELECT
          o.country_iso,
          o.shipping_city,
          o.hub_code,
          o.customer_email,
          o.order_date,
          o.order_number,
          o.platform,
          o.amt_revenue_gross,
          p.transaction_amount,
          p.transaction_payment_type,
          CASE WHEN p.transaction_amount < o.amt_revenue_gross THEN "Transaction Amount < Revenue Gross"
               WHEN p.transaction_amount > o.amt_revenue_gross THEN "Transaction Amount > Revenue Gross""
          END as payment_discrepancy
      FROM `flink-data-prod.curated.orders` o
      LEFT JOIN `flink-data-prod.curated.payment_transactions` p on o.order_uuid = p.order_uuid
      where true
      --and p.transaction_amount < o.amt_revenue_gross
      and transaction_state = 'success'
      --and o.is_successful_order is true
      and order_date >= current_date - 90
      and p.transaction_type = 'authorization'
       ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: [detail*]
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: shipping_city {
    type: string
    sql: ${TABLE}.shipping_city ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: order_date {
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: amt_revenue_gross {
    type: number
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: transaction_amount {
    type: number
    sql: ${TABLE}.transaction_amount ;;
  }

  dimension: transaction_payment_type {
    type: string
    sql: ${TABLE}.transaction_payment_type ;;
  }

  # measure: transaction_amount_eur {
  #   hidden:  no
  #   type: sum
  #   sql: ${transaction_amount};;
  #   value_format_name: decimal_1
  # }

  # measure: amt_revenue_gross_eur {
  #   hidden:  no
  #   type: sum
  #   sql: ${amt_revenue_gross};;
  #   value_format_name: decimal_1
  # }

  dimension: payment_discrepancy {
    type: string
    sql: ${TABLE}.payment_discrepancy ;;
  }

  set: detail {
    fields: [
      country_iso,
      shipping_city,
      hub_code,
      customer_email,
      order_date,
      order_number,
      platform,
      amt_revenue_gross,
      transaction_amount,
      transaction_payment_type
    ]
  }
}
