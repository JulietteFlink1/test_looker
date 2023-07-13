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

include: "/**/products_hub_assignment.view"
include: "/**/replenishment_purchase_orders.view"
include: "/**/bulk_items.view"
include: "/**/bulk_inbounding_performance.view"
include: "/**/shipping_methods_ct.view"





explore: supply_chain {


  label:       "SCM Explore (SKU-level)"
  description: "This explore covers inventory data based on CommerceTools
                and Stock Changelogs provided by Hub-Tech. It is enrichted with reporting tables to measure the
                vendor performance"
  group_label: "Supply Chain"

  tags: ["supply_chain_explore"]

  persist_with: supply_chain_daily_datagroup



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    BASE TABLE
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  from  :     products_hub_assignment
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

        {% if supply_chain_config.filter_terminated_hubs._parameter_value == "active" %}
          and ${hubs_ct.start_date} <= ${products_hub_assignment.report_date}
          and (${hubs_ct.termination_date} > ${products_hub_assignment.report_date} or ${hubs_ct.termination_date} is null)
        {% endif %}
        -- Filter for terminated hubs is {% parameter supply_chain_config.filter_terminated_hubs %}

        and coalesce(${products_hub_assignment.item_location_introduction_date},
                      ${products_hub_assignment.item_introduction_date},
                      date('2000-01-01')) <= ${products_hub_assignment.report_date}

        and coalesce(${products_hub_assignment.item_location_termination_date}, date('9999-12-31'))  >
             date_sub(${products_hub_assignment.report_date}, interval 7 day)


      ;;


  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

  join: supply_chain_config {
    sql: ;;
    relationship: one_to_one
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    JOINED TABLES
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # ~ ~ ~ ~ ~ ~  START: NEW AVAILIABILITY FILERING APPROACH ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
  join: inventory_daily {

    view_label: "02 Stock-Level (Daily)"

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

    view_label: "03 Stock-Level - last 8 days (Hourly)"

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

    view_label: "Products"

    type: left_outer
    relationship: many_to_one
    sql_on:
        ${products.product_sku} = ${products_hub_assignment.sku} and
        ${products.country_iso} = ${products_hub_assignment.country_iso}
        ;;

  }

  join: lexbizz_item {

    # HIDDEN - Deprecate in favor of the products table
    view_label: ""
    from: erp_item

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

  join: oracle_item_location_fact {
    view_label: "01 Products Hub Assignment"
    type: left_outer
    relationship: many_to_one
    sql_on:
        ${oracle_item_location_fact.hub_code} = ${products_hub_assignment.hub_code}
    and ${oracle_item_location_fact.sku}      = ${products_hub_assignment.sku}
    ;;
    fields: [oracle_item_location_fact.current_state__item_at_location_status]
  }

  join: inventory_changes_daily {

    view_label: "04 Stock-Level Updates with Update Reason (Daily)"
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
        view_label: "04 Stock-Level Updates with Update Reason (Daily)"

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

    view_label: ""

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

    view_label: "06 Order Lineitems"

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
    view_label: ""
    from: dispatch_notifications

    type: full_outer
    relationship: many_to_one

    sql_on:
        ${bulk_inbounding_performance.hub_code}                   = ${products_hub_assignment.hub_code}
    and ${bulk_inbounding_performance.delivery_date}              = ${products_hub_assignment.report_date}
    and ${bulk_inbounding_performance.sku}                        = ${products_hub_assignment.leading_sku_replenishment_substitute_group}
    and {% condition global_filters_and_parameters.datasource_filter %} ${bulk_inbounding_performance.delivery_date} {% endcondition %}
    ;;

  }

  join: replenishment_purchase_orders {

    view_label: ""

    type:         full_outer
    relationship: many_to_one

    sql_on:
        ${replenishment_purchase_orders.sku}              = coalesce(${products_hub_assignment.leading_sku_replenishment_substitute_group}, ${products_hub_assignment.sku}) and
        ${replenishment_purchase_orders.hub_code}         = ${products_hub_assignment.hub_code}                                        and
        ${replenishment_purchase_orders.order_date}    = ${products_hub_assignment.report_date}
    ;;
  }

  join: erp_master_data {

    from: erp_product_hub_vendor_assignment
    view_label: ""

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

      view_label: "08 ERP Vendor Prices *"


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
    view_label: "09 Top Selling Products (last 14days)"
    sql_on: ${top_50_skus_per_gmv_supply_chain_explore.sku}         = ${products_hub_assignment.sku}
        and ${top_50_skus_per_gmv_supply_chain_explore.country_iso} = ${products_hub_assignment.country_iso}
    ;;
    type: left_outer
    relationship: many_to_one
  }


  join: key_value_items {

    view_label: "10 Key Value Items"

    type: left_outer
    relationship: many_to_one

    sql_on:
           ${key_value_items.sku} =  ${products_hub_assignment.sku}
       and ${key_value_items.country_iso} =  ${products_hub_assignment.country_iso}
           -- get only the most recent KVIs (they are upadted every month)
       and extract(year from ${key_value_items.kvi_date})||extract(month from ${key_value_items.kvi_date}) = extract(year from current_date())||extract(month from current_date())
    ;;
  }

  join: product_prices_daily {

    view_label: "11 Product Prices"

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

    view_label: "12 Pricing Cluster"

    type: left_outer
    relationship: many_to_one
    fields: [price_hub_cluster]
    sql_on:
       ${geographic_pricing_hub_cluster.hub_code} = ${products_hub_assignment.hub_code}
    ;;
  }

  join: geographic_pricing_sku_cluster{

    view_label: ""

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

    view_label: ""

    type: full_outer
    relationship: many_to_one
    sql_on:
          ${products_hub_assignment.report_date} = ${assortment_puzzle_pieces.ingestion_date}
      and ${products_hub_assignment.hub_code}    = ${assortment_puzzle_pieces.hub_code}
      and ${products_hub_assignment.sku}         = ${assortment_puzzle_pieces.sku}
      and {% condition global_filters_and_parameters.datasource_filter %} ${assortment_puzzle_pieces.ingestion_date} {% endcondition %}
    ;;
  }

  join: shipping_methods_ct {

    view_label: ""

    type: left_outer
    relationship: one_to_many
    sql_on:
          ${hubs_ct.shipping_method_id} = ${shipping_methods_ct.shipping_method_id}
      and ${hubs_ct.country_iso}        = ${shipping_methods_ct.country_iso};;
  }

  join: erp_product_hub_vendor_assignment_unfiltered {
    view_label: "13 Product-Hub Data (historized)"
    sql_on:
        ${erp_product_hub_vendor_assignment_unfiltered.sku}            = ${products_hub_assignment.sku}
    and ${erp_product_hub_vendor_assignment_unfiltered.hub_code}       = ${products_hub_assignment.hub_code}
    and ${erp_product_hub_vendor_assignment_unfiltered.report_date}    = ${products_hub_assignment.report_date}
    and {% condition global_filters_and_parameters.datasource_filter %} ${erp_product_hub_vendor_assignment_unfiltered.report_date} {% endcondition %}
    ;;
    type: left_outer
    relationship: many_to_one
  }

  join: erp_product_hub_vendor_assignment_unfiltered_current {
    from: erp_product_hub_vendor_assignment_unfiltered
    view_label: "13 Product-Hub Data (as of today)"
    sql_on:
        ${erp_product_hub_vendor_assignment_unfiltered_current.sku}            = ${products_hub_assignment.sku}
    and ${erp_product_hub_vendor_assignment_unfiltered_current.hub_code}       = ${products_hub_assignment.hub_code}
    and ${erp_product_hub_vendor_assignment_unfiltered_current.report_date}    = current_date()
    ;;
    type: left_outer
    relationship: many_to_one
  }

}
