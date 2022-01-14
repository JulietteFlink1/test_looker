view: hub_pl_monthly {
  sql_table_name: `flink-data-dev.reporting.hub_pl_monthly`
    ;;

  dimension: amt_citymanager_salaries {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_citymanager_salaries ;;
  }

  dimension: amt_delivery_fee_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_delivery_fee_gross ;;
  }

  dimension: amt_delivery_fee_net {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_delivery_fee_net ;;
  }

  dimension: amt_discount_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_discount_gross ;;
  }

  dimension: amt_ebikes {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_ebikes ;;
  }

  dimension: amt_external_operations_salaries {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_external_operations_salaries ;;
  }

  dimension: amt_external_rider_salalries {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_external_rider_salalries ;;
  }

  dimension: amt_gmv_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: amt_gmv_net {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_gmv_net ;;
  }

  dimension: amt_gmv_groceries_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_gmv_groceries_gross ;;
  }

  dimension: amt_gmv_groceries_net {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_gmv_groceries_net ;;
  }

  dimension: amt_gmv_after_refunds_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_gmv_after_refunds_gross ;;
  }

  dimension: amt_hubmanager_salaries {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_hubmanager_salaries ;;
  }

  dimension: amt_internal_operations_salaries {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_internal_operations_salaries ;;
  }

  dimension: amt_internal_rider_salaries {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_internal_rider_salaries ;;
  }

  dimension: amt_logistics_costs {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_logistics_costs ;;
  }

  dimension: amt_other_hub_recurring {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_other_hub_recurring ;;
  }

  dimension: amt_other_logistics_costs {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_other_logistics_costs ;;
  }

  dimension: amt_packaging {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_packaging ;;
  }

  dimension: amt_refund_gross {
    type: string
    hidden: yes
    sql: ${TABLE}.amt_refund_gross ;;
  }

  dimension: amt_refund_net {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_refund_net ;;
  }

  dimension: amt_rent {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_rent ;;
  }

  dimension: amt_revenue_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: amt_revenue_net {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_revenue_net ;;
  }

  dimension: amt_rider_equipment {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_rider_equipment ;;
  }

  dimension: amt_shiftlead_salaries {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_shiftlead_salaries ;;
  }

  dimension: amt_supplier_funding {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_supplier_funding ;;
  }

  dimension: amt_total_deposit {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_total_deposit ;;
  }

  dimension: amt_total_net {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_total_net ;;
  }

  dimension: amt_total_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_total_gross ;;
  }

  dimension: amt_transaction_fees {
    type: string
    hidden: yes
    sql: ${TABLE}.amt_transaction_fees ;;
  }

  dimension: amt_vat {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_vat ;;
  }

  dimension: amt_waste_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_waste_gross ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }


  dimension: hub_pl_monthly_uuid {
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.hub_pl_monthly_uuid ;;
  }

  dimension_group: order_month {
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
    sql: ${TABLE}.order_month ;;
  }


########### Measures

  measure: sum_amt_citymanager_salaries {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_citymanager_salaries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_delivery_fee_gross {
    type: sum
    group_label: "* Profit *"
    sql: ${amt_delivery_fee_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_gmv_gross {
    type: sum
    group_label: "* Profit *"
    sql: ${amt_gmv_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_delivery_fee_net {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_delivery_fee_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_ebikes {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_ebikes};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_hubmanager_salaries {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_hubmanager_salaries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_internal_operations_salaries {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_internal_operations_salaries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_external_operations_salaries {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_external_operations_salaries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_external_rider_salalries {
    type: sum
    group_label: "* Loss *"
    label: "Sum Amt External Rider Salaries"
    sql: ${amt_external_rider_salalries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_internal_rider_salaries {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_internal_rider_salaries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_waste_gross {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_waste_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_rent {
    type: sum
    group_label: "* Loss *"
    label: "Sum Amt External Rider Salaries"
    sql: ${amt_rent};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_total_deposit {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_total_deposit};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_discount_gross {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_discount_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_supplier_funding {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_supplier_funding};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_logistics_costs {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_logistics_costs};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_other_logistics_costs {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_other_logistics_costs};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_other_hub_recurring {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_other_hub_recurring};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_refund_gross {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_refund_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_refund_net {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_refund_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_vat {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_vat};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_revenue_net {
    type: sum
    group_label: "* Profit *"
    sql: ${amt_revenue_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_revenue_gross {
    type: sum
    group_label: "* Profit *"
    sql: ${amt_revenue_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_transaction_fees {
    type: sum
    group_label: "* Loss *"
    sql: ${amt_transaction_fees};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_total_net {
    type: sum
    group_label: "* Profit *"
    sql: ${amt_total_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_total_gross {
    type: sum
    group_label: "* Profit *"
    sql: ${amt_total_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_gmv_groceries_gross {
    type: sum
    group_label: "* Profit *"
    sql: ${amt_gmv_groceries_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_gmv_groceries_net {
    type: sum
    group_label: "* Profit *"
    sql: ${amt_gmv_groceries_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_gmv_after_refunds_gross {
    type: sum
    group_label: "* Profit *"
    sql: ${amt_gmv_after_refunds_gross};;
    value_format_name: euro_accounting_2_precision
  }

  ############## Relative measures

  measure: share_gmv_groceries_gross_over_gmv_gross {
    type: average
    group_label: "* Relative Profit *"
    label: "% GMV Groceries Gross / GMV Gross"
    sql: ${amt_gmv_groceries_gross}/${amt_gmv_gross};;
    value_format_name: percent_1
  }

  measure: share_gmv_delivery_fees_gross_over_gmv_gross {
  type: average
  group_label: "* Relative Profit *"
  label: "% GMV Delivery Fees Gross / GMV Gross"
  sql: ${amt_delivery_fee_gross}/${amt_gmv_gross};;
  value_format_name: percent_1
}

  measure: share_gmv_refunds_gross_over_gmv_gross {
    type: average
    group_label: "* Relative Loss *"
    label: "% GMV Refunds Gross / GMV Gross"
    sql: ${amt_refund_gross}/${amt_gmv_gross};;
    value_format_name: percent_1
  }

  measure: share_vat_over_total_net {
    type: average
    group_label: "* Relative Loss *"
    label: "% VAT / Revenue Net"
    sql: ${amt_vat}/${amt_total_net};;
    value_format_name: percent_1
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
