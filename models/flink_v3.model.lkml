connection: "flink_bq"
label: "Flink Core Data Model"

include: "/**/*.view.lkml"                # include all views in the views/ folder in this project
include: "/**/*.dashboard.lookml"
include: "/**/*.explore.lkml"


week_start_day: monday
case_sensitive: no


# START ------------------------ defined persisting strategies ---------------------------------
datagroup: flink_default_datagroup {
  sql_trigger: SELECT MAX(partition_timestamp) FROM `flink-data-prod.curated.inventory` ;;
  max_cache_age: "24 hour"
}

datagroup: flink_hourly_datagroup {
  sql_trigger: SELECT MAX(partition_timestamp) FROM `flink-data-prod.curated.inventory`;;
  max_cache_age: "1 hour"
}
persist_with: flink_default_datagroup
# END ------------------------ defined persisting strategies ---------------------------------


# START ------------------------ access_grant rules ----------------------------
access_grant: can_view_customer_data {
  user_attribute: access_customer_data
  allowed_values: [ "Yes" ]
}

access_grant: can_view_buying_information {
  user_attribute: access_buying_information
  allowed_values: [ "Yes" ]
}
# END ------------------------ access_grant rules ----------------------------


# START ------------------------ custom value formats ----------------------------
named_value_format: euro_accounting_2_precision { value_format: "\"€\"#,##0.00" }
named_value_format: euro_accounting_1_precision { value_format: "\"€\"#,##0.0" }
named_value_format: euro_accounting_0_precision { value_format: "\"€\"#,##0" }
# END ------------------------ custom value formats ----------------------------




# STAY- HERE (move soon)
explore: riders_forecast_staffing {
  hidden: yes
  label: "Orders and Riders Forecasting"
  view_label: "Orders and Riders Forecasting"
  group_label: "09) Forecasting"
  description: "This explore allows to check the riders and orders forecast for the upcoming 7 days"

  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  join: hubs {
    sql_on:
    ${riders_forecast_staffing.hub_name} = ${hubs.hub_code_lowercase} ;;
    relationship: many_to_one
    type: left_outer
  }

}
