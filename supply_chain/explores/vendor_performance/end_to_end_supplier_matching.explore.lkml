# Owner: Andreas Stueber / Lautaro Ruiz
# Created At: 2022-10-04
# Purpose: This explore exposes advanced matching logic of PO > DESADV > Inbound defined by the Supply Chain team
#         >> see this ticket for reference: https://goflink.atlassian.net/browse/DATA-3876

include: "/supply_chain/views/bigquery_reporting/advanced_supplier_matching.view"
include: "/core/views/bq_curated/products.view"
include: "/core/views/bq_curated/hubs_ct.view"

explore: end_to_end_supplier_matching {

  label: "Supplier End-to-End matching"
  description: "This Explores provides matching data for PO to DESADV to Inbounds and consideres also inbounds on different dates then the promised delivery dates of DESADV or PO"
  group_label: "Supply Chain"

  access_filter: {
    field: hubs_ct.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      advanced_supplier_matching.promised_delivery_date_combined_date: "last 7 days"
    ]
  }

  from: advanced_supplier_matching
  view_name: advanced_supplier_matching
  view_label: "E2E Matching Fields"

  join: products {
    view_label: "Products"
    type: left_outer
    relationship: many_to_one
    sql_on: ${advanced_supplier_matching.parent_sku} = ${products.replenishment_substitute_group_parent_sku} ;;
    fields: [products.category, products.subcategory,
             products.replenishment_substitute_group,
             products.replenishment_substitute_group_parent_sku]
  }

  join: hubs_ct {
    view_label: "Hubs"
    type: left_outer
    relationship: many_to_one
    sql_on: ${advanced_supplier_matching.hub_code} = ${hubs_ct.hub_code} ;;
    fields: [hubs_ct.country_iso,
             hubs_ct.country,
             hubs_ct.regional_cluster,
             hubs_ct.region_iso,
             hubs_ct.region,
             hubs_ct.hub_name,
             hubs_ct.is_active_hub
            ]
  }

}
