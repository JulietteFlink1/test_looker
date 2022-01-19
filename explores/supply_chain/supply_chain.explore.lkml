include: "/views/**/*.view"


explore: supply_chain {
  label: "Supply Chain Explore"
  description: "Covers ERP and Inventory data"

  from: products_hub_assignment_v2
  view_name: products_hub_assignment_v2
  view_label: "01 Products Hub Assignment"

  hidden: yes

  always_filter: {
    filters: [
      products_hub_assignment_v2.erp_final_decision_is_sku_assigned_to_hub: "Yes"
    ]
  }

  join: inventory_daily {
    view_label: "02 Inventory Daily"
    type: left_outer
    relationship: one_to_one
    sql_on:
        ${inventory_daily.hub_code}    = ${products_hub_assignment_v2.hub_code}     and
        ${inventory_daily.sku}         = ${products_hub_assignment_v2.sku}          and
        ${inventory_daily.report_date} = ${products_hub_assignment_v2.report_date}
    ;;
  }


}
