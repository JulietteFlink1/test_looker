view: influencer_vouchers_input {
  sql_table_name: `flink-backend.sandbox_nima.gsheet_influencer_vouchers_input`
    ;;

  dimension: unique_id {
    primary_key: yes
    type: string
    sql: concat(${username}, ${voucher_code}) ;;
  }

  dimension: username {
    type: string
    sql: ${TABLE}.username ;;
  }

  dimension: voucher_code {
    type: string
    sql: ${TABLE}.voucher_code ;;
  }

  dimension: voucher_type {
    type: string
    sql: ${TABLE}.voucher_type ;;
  }

  measure: count {
    type: count
    drill_fields: [username]
  }

#### MEASURES

  measure: cnt_influencer_community_voucher_redemptions {
    label: "# Influencer Community Voucher Redemptions"
    description: "Count of Community Voucher Redemptions"
    hidden:  no
    type: count_distinct
    sql: ${order_order.id} ;;
    filters: [voucher_type: "Community"]
    value_format: "0"
  }

  measure: cnt_influencer_promo_voucher_redemptions {
    label: "# Influencer Promo Voucher Redemptions"
    description: "Count of Promo Voucher Redemptions"
    hidden:  no
    type: count_distinct
    sql: ${order_order.id} ;;
    filters: [voucher_type: "Promo"]
    value_format: "0"
  }

  measure: sum_influencer_community_voucher_costs {
    label: "SUM Influencer Community Voucher Costs"
    description: "Sum of Discount amount Influencer Promo vouchers"
    type: sum
    filters: [voucher_type: "Community"]
    sql: ${order_order.discount_amount};;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_influencer_promo_voucher_costs {
    label: "SUM Influencer Promo Voucher Costs"
    description: "Sum of Discount amount Influencer Promo vouchers"
    type: sum
    filters: [voucher_type: "Promo"]
    sql: ${order_order.discount_amount};;
    value_format_name: euro_accounting_0_precision
  }

}
