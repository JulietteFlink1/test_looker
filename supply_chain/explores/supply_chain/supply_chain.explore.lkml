# Owner:
# Andreas Stüber
#
# Main Stakeholder:
# - Supply Chain team
# - Retail / Commercial team
# - Hub-Ops team
#
# Questions that can be answered
# - All questions around replenishment performance
# - Questions around inventory movements

include: "/**/*.view"

include: "/**/products_hub_assignment_v2.view"
include: "/**/replenishment_purchase_orders.view"
include: "/**/bulk_items.view"
include: "/**/bulk_inbounding_performance.view"






explore: supply_chain {


  label:       "Supply Chain Explore"
  description: "This explore covers inventory data based on CommerceTools
                and Stock Changelogs provided by Hub-Tech. It is enrichted with reporting tables to measure the
                vendor performance"
  group_label: "Supply Chain"

  tags: ["supply_chain_explore"]

  persist_with: flink_daily_datagroup



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    BASE TABLE
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  from  :     products_hub_assignment_v2
  view_name:  products_hub_assignment
  view_label: "01 Products Hub Assignment"





  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    FILTER & SETTINGS
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  hidden: no

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",

      products_hub_assignment.select_calculation_granularity: "customer"

    ]
  }

  access_filter: {
    field: hubs_ct.country_iso
    user_attribute: country_iso

  }

  sql_always_where:
      -- filter the time for all big tables of this explore
      {% condition global_filters_and_parameters.datasource_filter %} ${products_hub_assignment.report_date} {% endcondition %}

        and ${products_hub_assignment.hub_code} not in ('de_ham_alto')
        and ${hubs_ct.is_test_hub} is false
        and ${hubs_ct.start_date} <= ${products_hub_assignment.report_date}
        and (${hubs_ct.termination_date} > ${products_hub_assignment.report_date} or ${hubs_ct.termination_date} is null)
      ;;


  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    JOINED TABLES
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # ~ ~ ~ ~ ~ ~  START: NEW AVAILIABILITY FILERING APPROACH ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
  join: inventory_daily {

    view_label: "02 Inventory Daily"

    type: left_outer
    relationship: many_to_one
    sql_on:
        ${inventory_daily.hub_code}    = ${products_hub_assignment.hub_code}     and
        ${inventory_daily.sku}         = ${products_hub_assignment.sku}          and
        ${inventory_daily.report_date} = ${products_hub_assignment.report_date}  and
        {% condition global_filters_and_parameters.datasource_filter %} ${inventory_daily.report_date} {% endcondition %}
        -- dynamic filtering per Assignment and Groups
        and
            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment' %}
              ${products_hub_assignment.one_sku_per_erp_assignment_logic} = ${inventory_daily.sku}

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
              ${products_hub_assignment.one_sku_per_ct_assignment_logic} = ${inventory_daily.sku}

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
              ${products_hub_assignment.one_sku_per_replenishment_substitute_group} = ${inventory_daily.sku}

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
              ${products_hub_assignment.one_sku_per_substitute_group} = ${inventory_daily.sku}

            {% endif %}
    ;;
  }

  # ~ ~ ~ ~ ~ ~  END: NEW AVAILIABILITY FILERING APPROACH ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

  join: inventory_hourly {

    view_label: "03 Inventory Hourly (last 8 days)"

    type: left_outer
    relationship: one_to_many
    sql_on:
        ${inventory_hourly.hub_code}              = ${products_hub_assignment.hub_code}     and
        ${inventory_hourly.sku}                   = ${products_hub_assignment.sku}          and
        ${inventory_hourly.report_timestamp_date} = ${products_hub_assignment.report_date}  and
        ${inventory_hourly.report_timestamp_date} >= current_date() - 8                     and -- today minus 5 days
        {% condition global_filters_and_parameters.datasource_filter %} ${inventory_hourly.report_timestamp_date} {% endcondition %}
    ;;
  }

  join: products {

    view_label: "Products (CT)"

    type: left_outer
    relationship: many_to_one
    sql_on: ${products.product_sku} = ${products_hub_assignment.sku} ;;

  }

  join: lexbizz_item {

    view_label: "Products (ERP)"

    type: left_outer
    relationship: many_to_one
    sql_on: ${lexbizz_item.sku}            = ${products_hub_assignment.sku}
        and ${lexbizz_item.ingestion_date} = current_date()
    ;;

  }

  join: hubs_ct {

    view_label: "Hubs"

    type: left_outer
    relationship: many_to_one
    sql_on: ${hubs_ct.hub_code} = ${products_hub_assignment.hub_code} ;;
  }

  join: hub_demographics {
    view_label: "Hubs"
    sql_on: ${hubs_ct.hub_code} = ${hub_demographics.hub_code} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: inventory_changes_daily {

    view_label: "04 Inventory Changes Daily"
    from: inventory_changes_daily_extended

    type: left_outer
    relationship: one_to_many
    sql_on:
        ${inventory_changes_daily.sku}                   = ${products_hub_assignment.sku}         and
        ${inventory_changes_daily.hub_code}              = ${products_hub_assignment.hub_code}    and
        ${inventory_changes_daily.inventory_change_date} = ${products_hub_assignment.report_date} and
        {% condition global_filters_and_parameters.datasource_filter %} ${inventory_changes_daily.inventory_change_date} {% endcondition %}
    ;;
  }
      # depends 100% on inventory_changes_daily
      join: sku_hub_day_level_orders {
        type: left_outer
        relationship: many_to_one
        view_label: "04 Inventory Changes Daily"

        sql_on:
            ${sku_hub_day_level_orders.product_sku}   =  ${inventory_changes_daily.sku} and
            ${sku_hub_day_level_orders.hub_code}      =  ${inventory_changes_daily.hub_code} and
            ${sku_hub_day_level_orders.created_date}  =  ${inventory_changes_daily.inventory_change_date}
        ;;
      }


  join: inventory_changes {

    view_label: "05 Inventory Change-Logs"

    type:         left_outer
    relationship: one_to_many
    sql_on:
        ${inventory_changes.sku}                             = ${products_hub_assignment.sku}         and
        ${inventory_changes.hub_code}                        = ${products_hub_assignment.hub_code}    and
        ${inventory_changes.inventory_change_timestamp_date} = ${products_hub_assignment.report_date} and
        {% condition global_filters_and_parameters.datasource_filter %} ${inventory_changes.inventory_change_timestamp_date} {% endcondition %}
    ;;
  }

  join: inbounding_times_per_vendor {

    view_label: "06 Inbounding Times"

    type: left_outer
    relationship: one_to_one

    sql_on:
        ${inbounding_times_per_vendor.erp_vendor_id} = ${products_hub_assignment.erp_vendor_id} and
        ${inbounding_times_per_vendor.hub_code}      = ${products_hub_assignment.hub_code}      and
        ${inbounding_times_per_vendor.report_date}   = ${products_hub_assignment.report_date}   and
        {% condition global_filters_and_parameters.datasource_filter %} ${inbounding_times_per_vendor.report_date} {% endcondition %}
    ;;
  }


  join: order_lineitems {

    from: orderline

    view_label: "07 Order Lineitems"

    type: left_outer
    relationship: one_to_many

    sql_on:
        ${order_lineitems.product_sku}         = ${products_hub_assignment.sku}         and
        ${order_lineitems.hub_code}            = ${products_hub_assignment.hub_code}    and
        ${order_lineitems.created_date}        = ${products_hub_assignment.report_date} and
        {% condition global_filters_and_parameters.datasource_filter %} ${order_lineitems.created_date} {% endcondition %}
    ;;
  }

  join: bulk_inbounding_performance {

    # keep hidden for now
    view_label: "08 Dispatch Notifications"

    type: full_outer
    relationship: many_to_one

    sql_on:
        ${bulk_inbounding_performance.hub_code}                   = ${products_hub_assignment.hub_code}
    and ${bulk_inbounding_performance.estimated_delivery_date}    = ${products_hub_assignment.report_date}
    and ${bulk_inbounding_performance.sku}                        = ${products_hub_assignment.leading_sku_replenishment_substitute_group}
    and {% condition global_filters_and_parameters.datasource_filter %} ${bulk_inbounding_performance.estimated_delivery_date} {% endcondition %}
    ;;

  }

  join: replenishment_purchase_orders {

    view_label: "09 Purchase Orders"

    type:         full_outer
    relationship: many_to_one

    sql_on:
        ${replenishment_purchase_orders.sku}              = coalesce(${products_hub_assignment.leading_sku_replenishment_substitute_group}, ${products_hub_assignment.sku}) and
        ${replenishment_purchase_orders.hub_code}         = ${products_hub_assignment.hub_code}                                        and
        ${replenishment_purchase_orders.order_date}    = ${products_hub_assignment.report_date}
    ;;
  }

  join: erp_master_data {

    from: erp_product_hub_vendor_assignment_v2
    view_label: "10 Lexbizz Master Data"

    type: left_outer
    relationship: many_to_one

    sql_on:
        ${erp_master_data.report_date} = ${products_hub_assignment.report_date} and
        ${erp_master_data.hub_code}    = ${products_hub_assignment.hub_code}    and
        ${erp_master_data.sku}         = ${products_hub_assignment.sku}         and
        ${erp_master_data.vendor_id}   = ${products_hub_assignment.erp_vendor_id}
    ;;
  }

  join: erp_buying_prices {

      view_label: "11 ERP Vendor Prices *"


      type: left_outer
      relationship: many_to_one

      sql_on:
        ${erp_buying_prices.hub_code}         =  ${products_hub_assignment.hub_code}        and
        ${erp_buying_prices.sku}              =  ${products_hub_assignment.sku}             and
        ${erp_buying_prices.report_date}      = ${products_hub_assignment.report_date}
    ;;
  }
      #
      # --- Adding this join only to make a cross-referenced variable work in erp_buying_prices
      #
      join: orderline {

        view_label: ""

        type: left_outer
        relationship: one_to_many

        sql_on:
            ${orderline.product_sku}         = ${products_hub_assignment.sku}         and
            ${orderline.hub_code}            = ${products_hub_assignment.hub_code}    and
            ${orderline.created_date}        = ${products_hub_assignment.report_date} and
            {% condition global_filters_and_parameters.datasource_filter %} ${orderline.created_date} {% endcondition %}
        ;;
      }



  join: top_50_skus_per_gmv_supply_chain_explore {
    view_label: "12 Top Selling Products (last 14days)"
    sql_on: ${top_50_skus_per_gmv_supply_chain_explore.sku}         = ${products_hub_assignment.sku}
        and ${top_50_skus_per_gmv_supply_chain_explore.country_iso} = ${products_hub_assignment.country_iso}
    ;;
    type: left_outer
    relationship: many_to_one
  }


  join: mean_and_std {
    view_label: "07 Order Lineitems"
    type: left_outer
    relationship: many_to_one
    sql_on:  ${mean_and_std.hub_code}     = ${products_hub_assignment.hub_code}
        and  ${mean_and_std.product_sku}  = ${products_hub_assignment.sku};;
  }


  join: waste_index {
    view_label: "07 Order Lineitems"
    type: left_outer
    relationship: many_to_one
    sql_on: ${waste_index.hub_code} = ${products_hub_assignment.hub_code}
    and ${waste_index.product_sku} = ${products_hub_assignment.sku} ;;
}

  join: avg_waste_index_per_hub {
    view_label: "07 Order Lineitems"
    type: left_outer
    relationship: many_to_one
    sql_on: ${avg_waste_index_per_hub.hub_code} = ${products_hub_assignment.hub_code}
      and ${avg_waste_index_per_hub.product_sku} = ${products_hub_assignment.sku} ;;
  }

  join: v2_avg_waste_index_per_hub {
    view_label: "07 Order Lineitems"
    type: left_outer
    relationship: many_to_one
    sql_on: ${v2_avg_waste_index_per_hub.hub_code} = ${products_hub_assignment.hub_code} ;;
  }


  join: key_value_items {

    view_label: "13 Key Value Items"

    type: left_outer
    relationship: many_to_one

    sql_on:
           ${key_value_items.sku} =  ${products_hub_assignment.sku}
           -- get only the most recent KVIs (they are upadted every Monday)
       and ${key_value_items.kvi_date} >= current_date() - 6
    ;;
  }

  join: product_prices_daily {

    view_label: "14 Product Prices"

    type: left_outer
    relationship: one_to_one
    sql_on:
          ${product_prices_daily.reporting_date} = ${products_hub_assignment.report_date}
      and ${product_prices_daily.hub_code}       = ${products_hub_assignment.hub_code}
      and ${product_prices_daily.sku}            = ${products_hub_assignment.sku}
      and {% condition global_filters_and_parameters.datasource_filter %} ${product_prices_daily.reporting_date} {% endcondition %}
    ;;
  }

  join: geographic_pricing_hub_cluster{

    view_label: "15 Pricing Hub Cluster"

    type: left_outer
    relationship: many_to_one
    fields: [price_hub_cluster]
    sql_on:
       ${geographic_pricing_hub_cluster.hub_code} = ${products_hub_assignment.hub_code}
    ;;
  }

  join: geographic_pricing_sku_cluster{

    view_label: "15 Pricing SKU Cluster"

    type: left_outer
    relationship: many_to_one
    fields: [price_sku_cluster, price_sku_cluster_desc]
    sql_on:
       ${geographic_pricing_sku_cluster.sku} = ${products_hub_assignment.sku}
    ;;
  }

  join: hub_monthly_orders {
    view_label: "Hubs"
    sql_on:
      ${products_hub_assignment.hub_code} = ${hub_monthly_orders.hub_code} and
      date_trunc(${products_hub_assignment.report_date},month) = ${hub_monthly_orders.created_month};;
    relationship: many_to_one
    type: left_outer
  }

  join: assortment_puzzle_pieces {

    view_label: "16 Puzzle Pieces Logic"

    type: full_outer
    relationship: many_to_one
    sql_on:
          ${products_hub_assignment.report_date} = ${assortment_puzzle_pieces.ingestion_date}
      and ${products_hub_assignment.hub_code}    = ${assortment_puzzle_pieces.hub_code}
      and ${products_hub_assignment.sku}         = ${assortment_puzzle_pieces.sku}
      and {% condition global_filters_and_parameters.datasource_filter %} ${assortment_puzzle_pieces.ingestion_date} {% endcondition %}
    ;;
  }

}
