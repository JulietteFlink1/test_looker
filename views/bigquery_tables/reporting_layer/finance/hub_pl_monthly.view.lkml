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

  dimension: amt_discount_net {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_discount_net ;;
  }

  dimension: amt_discount_net_marketing_acquisition {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_discount_net_marketing_acquisition ;;
  }

  dimension: amt_discount_net_marketing_brand {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_discount_net_marketing_brand ;;
  }

  dimension: amt_discount_net_marketing_retention {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_discount_net_marketing_retention ;;
  }

  dimension: amt_discount_net_customer_service {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_discount_net_customer_service ;;
  }

  dimension: amt_discount_net_unknown_use_case {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_discount_net_unknown_use_case ;;
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

  dimension: amt_internal_picker_wages {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_internal_picker_wages ;;
  }

  dimension: amt_external_pickerzenjob_salaries {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_external_pickerzenjob_salaries ;;
  }


  dimension: amt_external_riderzenjob_salalries {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_external_riderzenjob_salalries ;;
  }

  dimension: amt_external_riderother_salalries {
    type: string
    hidden: yes
    sql: ${TABLE}.amt_external_riderother_salalries ;;
  }

  dimension: amt_external_operationsStuditemps_salaries {
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

  dimension: amt_hub_staff_compensation {
    hidden: yes
    sql: coalesce(${amt_hubmanager_salaries},0) +
       coalesce(${amt_external_operations_salaries},0) +
       coalesce(${amt_internal_operations_salaries},0) +
       coalesce(${amt_citymanager_salaries},0) +
       coalesce(${amt_shiftlead_salaries},0) +
       coalesce(${amt_internal_picker_wages},0) +
       coalesce(${amt_external_pickerzenjob_salaries},0) +
       coalesce(${amt_external_operationsStuditemps_salaries},0)
       ;;
    value_format_name: euro_accounting_2_precision
  }

  dimension: amt_rider_wages {
    hidden: yes
    sql:
       coalesce(${amt_external_rider_salalries},0) +
       coalesce(${amt_internal_rider_salaries},0) +
      coalesce(${amt_external_riderzenjob_salalries},0) +
      coalesce(${amt_external_riderother_salalries},0)

       ;;
    value_format_name: euro_accounting_2_precision
  }

  dimension: amt_operational_hub_cost {
    hidden: yes
    sql:
       coalesce(${amt_rent},0) +
       coalesce(${amt_ebikes},0) +
       coalesce(${amt_packaging},0) +
       coalesce(${amt_other_hub_recurring},0) +
       coalesce(${amt_rider_equipment},0)      ;;
    value_format_name: euro_accounting_2_precision
  }

  dimension: amt_total_logistics_cost {
    hidden: yes
    sql:
       coalesce(${amt_logistics_costs},0) + coalesce(${amt_other_logistics_costs} ,0)    ;;
    value_format_name: euro_accounting_2_precision
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








######### Hub Staff Compensation



  measure: sum_amt_hubmanager_salaries {
    type: sum
    group_label: "* Hub Staff Compensation *"
    label: "Hub Managers Salaries"
    sql: ${amt_hubmanager_salaries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_internal_operations_salaries {
    type: sum
    group_label: "* Hub Staff Compensation *"
    label: "Internal Operation Salaries"
    sql: ${amt_internal_operations_salaries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_internal_picker_wages {
    type: sum
    group_label: "* Hub Staff Compensation *"
    label: "Internal Picker Salaries"
    sql: ${amt_internal_picker_wages};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_citymanager_salaries {
    type: sum
    group_label: "* Hub Staff Compensation *"
    label: "City Manager Salaries"
    sql: ${amt_citymanager_salaries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_shiftlead_salaries {
    type: sum
    group_label: "* Hub Staff Compensation *"
    label: "Shiftlead Salaries"
    sql: ${amt_shiftlead_salaries};;
    value_format_name: euro_accounting_2_precision
  }


  measure: sum_amt_external_pickerzenjob_salaries {
    type: sum
    group_label: "* Hub Staff Compensation *"
    label: "Zenjob Picker Salaries"
    sql: ${amt_external_pickerzenjob_salaries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_external_operationsStuditemps_salaries {
    type: sum
    group_label: "* Hub Staff Compensation *"
    label: "Other (Zenjob/Studitemps)"
    sql: ${amt_external_operationsStuditemps_salaries};;
    value_format_name: euro_accounting_2_precision
  }


  measure: sum_amt_external_operations_salaries {
    type: sum
    group_label: "* Hub Staff Compensation *"
    label: "External Operation Salaries"
    sql: ${amt_external_operations_salaries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_hub_staff_compensation {
    type: sum
    group_label: "* Hub Staff Compensation *"
    label: "Total Hub Staff Compensation"
    sql: ${amt_hub_staff_compensation};;
    value_format_name: euro_accounting_2_precision
  }

  measure: share_hub_staff_compensation_over_total_net {
    type: average
    group_label: "* Hub Staff Compensation *"
    label: "% Total Hub Staff Compensation / Revenue Net"
    sql: ${amt_hub_staff_compensation}/${amt_total_net};;
    value_format_name: percent_1
  }





################ Rider Wages



  measure: sum_amt_external_rider_salalries {
    type: sum
    group_label: "* Rider Wages *"
    label: "External Rider Salaries"
    sql: ${amt_external_rider_salalries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_internal_rider_salaries {
    type: sum
    group_label: "* Rider Wages *"
    label: "Internal Rider Salaries"
    sql: ${amt_internal_rider_salaries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_rider_wages {
    type: sum
    group_label: "* Rider Wages *"
    label: "Total Rider Wages"
    sql: ${amt_rider_wages}
       ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_external_riderzenjob_salalries {
    type: sum
    group_label: "* Rider Wages *"
    label: "Zenjob Rider Salaries"
    sql: ${amt_external_riderzenjob_salalries};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_external_riderother_salalries {
    type: sum
    group_label: "* Rider Wages *"
    label: "Other Rider Salaries"
    sql: ${amt_external_riderother_salalries}rider};;
    value_format_name: euro_accounting_2_precision
  }

  measure: share_rider_wages_over_total_net {
    type: average
    group_label: "* Rider Wages *"
    label: "% Rider Wages / Revenue Net"
    sql: ${amt_rider_wages}/${amt_total_net};;
    value_format_name: percent_1
  }







  ################# Waste




  measure: sum_amt_waste_gross {
    type: sum
    group_label: "* Waste *"
    label: "Waste Gross"
    sql: ${amt_waste_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: share_waste_over_total_net {
    type: average
    group_label: "* Waste *"
    label: "% Waste / Revenue Net"
    sql: ${amt_waste_gross}/${amt_total_net};;
    value_format_name: percent_1
  }


  measure: sum_amt_total_deposit {
    type: sum
    label: "Deposit"
    group_label: "* Deposit *"
    sql: ${amt_total_deposit};;
    value_format_name: euro_accounting_2_precision
  }


  ################# Discounts



  measure: sum_amt_discount_gross {
    type: sum
    label: "Discounts Gross"
    group_label: "* Discounts *"
    sql: ${amt_discount_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_discount_net {
    type: sum
    label: "Discounts Net"
    group_label: "* Discounts *"
    sql: ${amt_discount_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_discount_net_customer_service {
    type: sum
    label: "Discounts Customer Service Net"
    group_label: "* Discounts *"
    sql: ${amt_discount_net_customer_service};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_discount_net_marketing_acquisition {
    type: sum
    label: "Discounts Marketing Acquisition Net"
    group_label: "* Discounts *"
    sql: ${amt_discount_net_marketing_acquisition};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_discount_net_marketing_retention {
    type: sum
    label: "Discounts Marketing Retention Net"
    group_label: "* Discounts *"
    sql: ${amt_discount_net_marketing_retention};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_discount_net_marketing_brand{
    type: sum
    label: "Discounts Marketing Brand Net"
    group_label: "* Discounts *"
    sql: ${amt_discount_net_marketing_brand};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_aamt_discount_net_unknown_use_case{
    type: sum
    label: "Discounts Unknown Use Case Net"
    group_label: "* Discounts *"
    sql: ${amt_discount_net_unknown_use_case};;
    value_format_name: euro_accounting_2_precision
  }






############## Logistics





  measure: sum_amt_logistics_costs {
    type: sum
    label: "Logictic Costs"
    group_label: "* Logistics *"
    sql: ${amt_logistics_costs};;
    value_format_name: euro_accounting_2_precision
  }


  measure: sum_amt_other_logistics_costs {
    type: sum
    label: "Other Logictic Costs"
    group_label: "* Logistics *"
    sql: ${amt_other_logistics_costs};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_total_logistics_costs {
    type: sum
    label: "Total Logictic Costs"
    group_label: "* Logistics *"
    sql: ${amt_total_logistics_cost};;
    value_format_name: euro_accounting_2_precision
  }

  measure: share_total_logistics_costs_over_total_net {
    type: average
    group_label: "* Logistics *"
    label: "% Total Logistics Costs / Revenue Net"
    sql: ${amt_total_logistics_cost}/${amt_total_net};;
    value_format_name: percent_1
  }




############## Operational Hub Costs




  measure: sum_amt_total_operational_hub_costs {
    type: sum
    label: "Total Operational Hub Costs"
    group_label: "* Operational Hub Costs *"
    sql: ${amt_operational_hub_cost};;
    value_format_name: euro_accounting_2_precision
  }



  measure: sum_amt_other_hub_recurring {
    type: sum
    group_label: "* Operational Hub Costs *"
    label: "Other Hub Recurring"
    sql: ${amt_other_hub_recurring};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_rider_equipment {
    type: sum
    group_label: "* Operational Hub Costs *"
    label: "Rider Equipment"
    sql: ${amt_rider_equipment};;
    value_format_name: euro_accounting_2_precision
  }

  measure: share_operational_hub_costs_over_total_net {
    type: average
    group_label: "* Operational Hub Costs *"
    label: "% Total Operational Hub Costs / Revenue Net"
    sql: ${amt_operational_hub_cost}/${amt_total_net};;
    value_format_name: percent_1
  }


  measure: sum_amt_ebikes {
    type: sum
    label: "E-Bikes"
    group_label: "* Operational Hub Costs *"
    sql: ${amt_ebikes};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_rent {
    type: sum
    group_label: "* Operational Hub Costs *"
    label: "Rent"
    sql: ${amt_rent};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_packaging {
    type: sum
    label: "Packaging"
    group_label: "* Operational Hub Costs *"
    sql: ${amt_packaging};;
    value_format_name: euro_accounting_2_precision
  }





  ################# GMV : Groceries/Discounts/Delivery Fees




  measure: sum_amt_refund_gross {
    type: sum
    group_label: "* GMV *"
    label: "Refunds Gross"
    sql: ${amt_refund_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_refund_net {
    type: sum
    group_label: "* GMV *"
    label: "Refunds Net"
    sql: ${amt_refund_net};;
    value_format_name: euro_accounting_2_precision
  }


  measure: sum_amt_vat {
    type: sum
    group_label: "* GMV *"
    label: "VAT"
    sql: ${amt_vat};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_gmv_groceries_gross {
    type: sum
    group_label: "* GMV *"
    label: "GMV Groceries Gross"
    sql: ${amt_gmv_groceries_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_gmv_groceries_net {
    type: sum
    label: "GMV Groceries Net"
    group_label: "* GMV *"
    sql: ${amt_gmv_groceries_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_gmv_after_refunds_gross {
    type: sum
    label: "GMV after Refunds Gross"
    group_label: "* GMV *"
    sql: ${amt_gmv_after_refunds_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_total_gross {
    type: sum
    group_label: "* GMV *"
    sql: ${amt_total_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: share_gmv_groceries_gross_over_gmv_gross {
    type: average
    group_label: "* GMV *"
    label: "% GMV Groceries Gross / GMV Gross"
    sql: ${amt_gmv_groceries_gross}/${amt_gmv_gross};;
    value_format_name: percent_1
  }

  measure: share_gmv_delivery_fees_gross_over_gmv_gross {
    type: average
    group_label: "* GMV *"
    label: "% GMV Delivery Fees Gross / GMV Gross"
    sql: ${amt_delivery_fee_gross}/${amt_gmv_gross};;
    value_format_name: percent_1
  }

  measure: share_gmv_refunds_gross_over_gmv_gross {
    type: average
    group_label: "* GMV *"
    label: "% GMV Refunds Gross / GMV Gross"
    sql: ${amt_refund_gross}/${amt_gmv_gross};;
    value_format_name: percent_1
  }

  measure: share_vat_over_total_net {
    type: average
    group_label: "* GMV *"
    label: "% VAT / Revenue Net"
    sql: ${amt_vat}/${amt_total_net};;
    value_format_name: percent_1
  }


  measure: sum_amt_delivery_fee_gross {
    type: sum
    group_label: "* GMV *"
    label: "Delivery Fees Gross"
    sql: ${amt_delivery_fee_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_gmv_gross {
    type: sum
    label: "GMV Gross"
    group_label: "* GMV *"
    sql: ${amt_gmv_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_delivery_fee_net {
    type: sum
    label: "Delivery Fees Net"
    group_label: "* GMV *"
    sql: ${amt_delivery_fee_net};;
    value_format_name: euro_accounting_2_precision
  }




  ############### Revenue





  measure: sum_amt_revenue_net {
    type: sum
    group_label: "* Revenue *"
    sql: ${amt_revenue_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_revenue_gross {
    type: sum
    group_label: "* Revenue *"
    sql: ${amt_revenue_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_total_net {
    type: sum
    label: "Revenue Net"
    description: "Revenue Net = Items Price Net + Delivery Fee Net - Discount Amount Net - Refund Amount Net"
    group_label: "* Revenue *"
    sql: ${amt_total_net};;
    value_format_name: euro_accounting_2_precision
  }


  measure: share_suppliers_funding_over_total_net {
    type: average
    group_label: "* Revenue *"
    label: "% Supplier Funding / Revenue Net"
    sql: ${amt_supplier_funding}/${amt_total_net};;
    value_format_name: percent_1
  }

  measure: sum_amt_supplier_funding {
    type: sum
    group_label: "* Revenue *"
    description: "Supplier Fundings Revenue is Revenue coming from the suppliers for product advertisment"
    label: "Supplier Fundings"
    sql: ${amt_supplier_funding};;
    value_format_name: euro_accounting_2_precision
  }





  ################ Transaction Fees





  measure: sum_amt_transaction_fees {
    type: sum
    label: "Transaction Fees"
    group_label: "* Transaction Fees *"
    description: "Sum of Processing Fees, Scheme Fee and Interchange Fee"
    sql: ${amt_transaction_fees};;
    value_format_name: euro_accounting_2_precision
  }

  measure: share_transaction_fees_over_total_net {
    type: average
    group_label: "* Transaction Fees *"
    label: "% Transaction Fees / Revenue Net"
    sql: ${amt_waste_gross}/${amt_total_net};;
    value_format_name: percent_1
  }



  measure: count {
    type: count
    drill_fields: []
  }
}
