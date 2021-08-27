view: influencer_vouchers_input {
  sql_table_name: `flink-backend.gsheet_mktg_influencer_vouchers.voucher_data_input_global`
    ;;

  dimension: unique_key {
    type: string
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.country_iso, ${TABLE}.voucher_code) ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
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


#### MEASURES

  measure: cnt_influencer_community_voucher_redemptions {
    label: "# Influencer Community Voucher Redemptions"
    description: "Count of Community Voucher Redemptions"
    hidden:  no
    type: count_distinct
    sql: ${orders_cl.order_uuid} ;;
    sql_distinct_key: ${orders_cl.order_uuid} ;;
    filters: [voucher_type: "Community"]
    value_format: "0"
  }

  measure: cnt_influencer_promo_voucher_redemptions {
    label: "# Influencer Promo Voucher Redemptions"
    description: "Count of Promo Voucher Redemptions"
    hidden:  no
    type: count_distinct
    sql: ${orders_cl.order_uuid} ;;
    sql_distinct_key: ${orders_cl.order_uuid} ;;
    filters: [voucher_type: "Promo"]
    value_format: "0"
  }

  measure: sum_influencer_community_voucher_costs {
    label: "SUM Influencer Community Voucher Costs"
    description: "Sum of Discount amount Influencer Promo vouchers"
    type: sum
    filters: [voucher_type: "Community"]
    sql: ${orders_cl.discount_amount};;
    sql_distinct_key: ${orders_cl.order_uuid} ;;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_influencer_promo_voucher_costs {
    label: "SUM Influencer Promo Voucher Costs"
    description: "Sum of Discount amount Influencer Promo vouchers"
    type: sum
    filters: [voucher_type: "Promo"]
    sql: ${orders_cl.discount_amount};;
    sql_distinct_key: ${orders_cl.order_uuid} ;;
    value_format_name: euro_accounting_0_precision
  }

}
