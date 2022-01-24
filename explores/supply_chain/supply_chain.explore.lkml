include: "/views/**/*.view"


explore: supply_chain {
  label: "Supply Chain Explore"
  description: "Covers ERP and Inventory data"

  from: products_hub_assignment_v2
  view_name: products_hub_assignment
  view_label: "01 Products Hub Assignment"

  sql_always_where:
      -- filter the time for all big tables of this explore
      {% condition global_filters_and_parameters.datasource_filter %} ${products_hub_assignment.report_date} {% endcondition %}

      -- filter for showing only 1 SKU per (Replenishment) Substitute Group
      and
      case
            when {% condition products_hub_assignment.select_calculation_granularity %} 'sku'           {% endcondition %}
            then true

            when {% condition products_hub_assignment.select_calculation_granularity %} 'replenishment' {% endcondition %}
            then ${products_hub_assignment.filter_one_sku_per_replenishment_substitute_group} is true

            when {% condition products_hub_assignment.select_calculation_granularity %} 'customer'      {% endcondition %}
            then ${products_hub_assignment.filter_one_sku_per_substitute_group} is true

            else null
        end
      ;;

  hidden: yes

  always_filter: {
    filters: [
      products_hub_assignment.erp_final_decision_is_sku_assigned_to_hub: "Yes",
      global_filters_and_parameters.datasource_filter: "last 30 days",
      products_hub_assignment.select_calculation_granularity: "sku"
    ]
  }

  join: global_filters_and_parameters {

    view_label: ""

    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: inventory_daily {

    view_label: "02 Inventory Daily"

    type: left_outer
    relationship: one_to_one
    sql_on:
        ${inventory_daily.hub_code}    = ${products_hub_assignment.hub_code}     and
        ${inventory_daily.sku}         = ${products_hub_assignment.sku}          and
        ${inventory_daily.report_date} = ${products_hub_assignment.report_date}  and
        {% condition global_filters_and_parameters.datasource_filter %} ${inventory_daily.report_date} {% endcondition %}
    ;;
  }

  join: inventory_hourly {

    view_label: "03 Inventory Hourly (last 5 days)"

    type: left_outer
    relationship: one_to_many
    sql_on:
        ${inventory_hourly.hub_code}              = ${products_hub_assignment.hub_code}     and
        ${inventory_hourly.sku}                   = ${products_hub_assignment.sku}          and
        ${inventory_hourly.report_timestamp_date} = ${products_hub_assignment.report_date}  and
        ${inventory_hourly.report_timestamp_date} >= current_date() - 5                     and -- today minus 5 days
        {% condition global_filters_and_parameters.datasource_filter %} ${inventory_hourly.report_timestamp_date} {% endcondition %}
    ;;
  }

  join: products {

    view_label: "* Products *"

    type: left_outer
    relationship: many_to_one
    sql_on: ${products.product_sku} = ${products_hub_assignment.sku} ;;

  }

  join: hubs_ct {

    view_label: "* Hubs *"

    type: left_outer
    relationship: many_to_one
    sql_on: ${hubs_ct.hub_code} = ${products_hub_assignment.hub_code} ;;
  }

  join: inbounding_times_per_vendor {

    view_label: "04 Inbounding Times"

    type: left_outer
    relationship: one_to_one
    sql_on:
        ${inbounding_times_per_vendor.erp_vendor_id} = ${products_hub_assignment.erp_vendor_id} and
        ${inbounding_times_per_vendor.hub_code}      = ${products_hub_assignment.hub_code}      and
        ${inbounding_times_per_vendor.report_date}   = ${products_hub_assignment.report_date}   and
        {% condition global_filters_and_parameters.datasource_filter %} ${inbounding_times_per_vendor.report_date} {% endcondition %}
    ;;
  }



}
