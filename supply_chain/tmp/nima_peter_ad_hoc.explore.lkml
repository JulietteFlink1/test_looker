include: "/**/ad_hoc_nima_peter_inventory_vs_rewe_desadv.view"
include:"/**/*.view"

# Ad-Hoc Explore by Andreas

explore: sc_adhoc {

  from: ad_hoc_nima_peter_inventory_vs_rewe_desadv
  view_label: "REWE Desadv to Inbound UNION"
  view_name: rewe_inbound_match

  hidden: yes

  join: products {
    view_label: "Products Master Data (CT)"
    relationship: many_to_one
    type: left_outer
    sql_on:  ${products.product_sku} = ${rewe_inbound_match.sku};;
  }

  join: lexbizz_item {
    view_label: "Product Master Data (ERP)"
    relationship: many_to_one
    type: left_outer
    sql_on: ${lexbizz_item.sku} = ${rewe_inbound_match.sku}
        and ${lexbizz_item.ingestion_date} = current_date()
    ;;
  }
}
