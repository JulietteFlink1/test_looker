# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team
#
# Questions that can be answered
# - All questions around distribution centers inventory
#
include: "/**/*.view"



explore: distribution_center {

  label:       "Distribution Center Explore"
  description: "This explore covers Distribution Centers (Central Warehouses) inventory data.
  It is enrichted with reporting tables to measure the distribution center performance"
  group_label: "Supply Chain"

  from  :     replenishment_dc_batchbalance
  view_name:  replenishment_dc_batchbalance
  hidden: yes
  view_label: " 01 Distribution Center Inventory "

### FILTERS

  always_filter: {
    filters: [
        replenishment_dc_batchbalance.dc_code: "DE_BER_DC01, DE_NAG_WUST, DE_MEY_AICH, DE_FRU_WESS",
        replenishment_dc_batchbalance.stock_balance_date_date: "yesterday"
    ]
  }

  #conditionally_filter: {
  #  filters: [replenishment_dc_batchbalance.stock_balance_date_date: "1 day"]
  #}


### JOINS

  join: replenishment_dc_assortment {

    view_label: " 02 Distribution Center Assortment "

    type: left_outer
    relationship: many_to_one
    sql_on: ${replenishment_dc_assortment.sku}            = ${replenishment_dc_batchbalance.sku}
    ;;

   }



  join: lexbizz_item {

    view_label: " 03 Products (ERP) "

    type: left_outer
    relationship: many_to_one
    sql_on: ${lexbizz_item.sku}            = ${replenishment_dc_batchbalance.sku}
        and ${lexbizz_item.ingestion_date} = current_date()
    ;;

   }


  join: products {

    view_label: " 04 Products (CT) "

    type: left_outer
    relationship: many_to_one
    sql_on: ${products.product_sku} = ${replenishment_dc_batchbalance.sku} ;;

  }






  }
