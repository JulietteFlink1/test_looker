include: "/views/**/*.view"


explore: supply_chain {
  label: "Supply Chain Explore"
  description: "Covers ERP and Inventory data"

  from: products_hub_assignment_v2
  hidden: yes

  always_filter: {
    filters: [
      supply_chain.erp_final_decision_is_sku_assigned_to_hub: "Yes"
    ]
  }


}
