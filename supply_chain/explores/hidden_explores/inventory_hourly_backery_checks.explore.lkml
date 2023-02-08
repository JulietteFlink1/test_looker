# Owner:
# Andreas Stüber
#
# Main Stakeholder:
# - Supply Chain team FR
#
# Questions that can be answered
# - Are french backery products being inbounded properly
# build in scope of this tikcet: https://goflink.atlassian.net/browse/DATA-4833

include: "/**/products_hub_assignment.view"
include: "/**/global_filters_and_parameters.view"
include: "/**/supply_chain_config.view"
include: "/**/inventory_hourly.view"
include: "/**/products.view"
include: "/**/hubs_ct.view"


explore: supply_chain_backery_checks {

  label:       "Supply Chain Backery Checks (last 75d)"
  description: "This explore covers very specific data: For the last 2 months, showing the inbounding data for french bakery products"
  group_label: "Supply Chain"
  hidden: yes


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    BASE TABLE
  from  :     products_hub_assignment
  view_name:  products_hub_assignment
  view_label: "01 Products Hub Assignment"


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    FILTER & SETTINGS
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

    -- only last 75d
    and ${products_hub_assignment.report_date} >= current_date() - 75
    -- only selected list of FR bakeries
    and ${products_hub_assignment.erp_vendor_name} in ('Fournil des Capucins', 'Maison Papillon', 'Boulangerie Lafayette', 'La Bonoise', 'Pont Juvénal', 'Boulangerie Élégance', 'Le Boulanger Feydeau', 'Les Frères Chapelier', 'Chez Meunier')
    -- only FR:
    and ${products_hub_assignment.country_iso} = 'FR'

    {% if supply_chain_config.filter_terminated_hubs._parameter_value == "active" %}
    and ${hubs_ct.start_date} <= ${products_hub_assignment.report_date}
    and (${hubs_ct.termination_date} > ${products_hub_assignment.report_date} or ${hubs_ct.termination_date} is null)
    {% endif %}
    -- Filter for terminated hubs is {% parameter supply_chain_config.filter_terminated_hubs %}
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

  join: inventory_hourly {
    view_label: "Inventory Hourly (last 75 days)"
    type: left_outer
    relationship: one_to_many
    sql_on:
        ${inventory_hourly.hub_code}              = ${products_hub_assignment.hub_code}     and
        ${inventory_hourly.sku}                   = ${products_hub_assignment.sku}          and
        ${inventory_hourly.report_timestamp_date} = ${products_hub_assignment.report_date}  and
        -- only last 75d
        ${inventory_hourly.report_timestamp_date} >= current_date() - 75                     and
        {% condition global_filters_and_parameters.datasource_filter %} ${inventory_hourly.report_timestamp_date} {% endcondition %}
    ;;
  }

  join: products {
    view_label: "Products (CT)"
    type: left_outer
    relationship: many_to_one
    sql_on:
        ${products.product_sku} = ${products_hub_assignment.sku} and
        ${products.country_iso} = ${products_hub_assignment.country_iso}
        ;;
  }

  join: hubs_ct {
    view_label: "Hubs"
    type: left_outer
    relationship: many_to_one
    sql_on: ${hubs_ct.hub_code} = ${products_hub_assignment.hub_code} ;;
  }
}
