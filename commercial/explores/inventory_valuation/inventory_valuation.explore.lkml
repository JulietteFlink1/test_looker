include: "/commercial/views/sql_derived_tables/sdt_inventory_valuation.view"
include: "/core/views/bq_curated/products.view"
include: "/core/views/bq_curated/hubs_ct.view"


explore: inventory_valuation {

  label: "Inventory Valuation (Restricted)"
  group_label: "Finance"
  description: "This explore provides an overview over the inventory movements within a defined timeframe, both valued as quantities or valued in monetary value using the
  weighted average cost (WAC)"
  hidden: yes

  access_filter: {
    field: hubs_ct.country_iso
    user_attribute: country_iso
  }

  from:  sdt_inventory_valuation
  view_name: sdt_inventory_valuation
  view_label: "Inventory Valuation"

  always_filter: {
    filters: [
      sdt_inventory_valuation.select_timeframe: "last 3 days",
      sdt_inventory_valuation.select_hub: "",
      sdt_inventory_valuation.select_sku: ""
    ]
  }

  join: products {
    view_label: "Products"
    sql_on:
        ${products.product_sku} = ${sdt_inventory_valuation.sku}
    and ${products.country_iso} = ${sdt_inventory_valuation.country_iso}
    ;;
    type: left_outer
    relationship: many_to_one
  }

  join: hubs_ct {
    view_label: "Hubs"
    sql_on: ${hubs_ct.hub_code} = ${sdt_inventory_valuation.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }


}
