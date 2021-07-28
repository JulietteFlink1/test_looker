view: discount_voucher {
  sql_table_name: `flink-data-prod.saleor_prod_global.discount_voucher`
    ;;
  drill_fields: [id]
  view_label: "* Vouchers *"

  dimension: id {
    primary_key: no
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: unique_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: apply_once_per_customer {
    type: yesno
    sql: ${TABLE}.apply_once_per_customer ;;
  }

  dimension: apply_once_per_order {
    type: yesno
    sql: ${TABLE}.apply_once_per_order ;;
  }

  dimension: code {
    type: string
    label: "Voucher Code"
    sql: ${TABLE}.code ;;
  }

  dimension: countries {
    type: string
    hidden: yes
    sql: ${TABLE}.countries ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: discount_value {
    type: number
    sql: ${TABLE}.discount_value ;;
  }

  dimension: discount_value_type {
    type: string
    sql: ${TABLE}.discount_value_type ;;
  }

  dimension_group: end {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.end_date ;;
  }

  dimension: min_checkout_items_quantity {
    type: number
    sql: ${TABLE}.min_checkout_items_quantity ;;
  }

  dimension: min_spent_amount {
    type: number
    sql: ${TABLE}.min_spent_amount ;;
  }

  dimension_group: start {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.start_date ;;
  }

  dimension: type {
    label: "Voucher Type"
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: use_case {
    label: "Voucher Use Case"
    type: string
    sql:  CASE WHEN UPPER(${TABLE}.code) LIKE '%EMP%' THEN 'Employees'
              WHEN LENGTH(REGEXP_REPLACE(code, r'[\d.]', '')) = 0 THEN 'Employees'
              WHEN UPPER(${TABLE}.code) LIKE 'AP%' THEN 'Customer Service'
              WHEN UPPER(${TABLE}.code) LIKE '%SORRY%' THEN 'Customer Service'
              WHEN ${TABLE}.type = 'shipping' THEN 'Free Delivery'
              WHEN UPPER(${TABLE}.code) LIKE '%EMP%' THEN 'Employees'
              ELSE 'Marketing'
          END
    ;;
  }

  dimension: usage_limit {
    type: number
    sql: ${TABLE}.usage_limit ;;
  }

  dimension: used {
    type: number
    sql: ${TABLE}.used ;;
  }

  measure: cnt_vouchers {
    label: "# Voucher Codes"
    group_label: "* Basic Counts *"
    description: "Count of Total Voucher Codes"
    hidden:  no
    type: count
    value_format: "0"
  }

}
