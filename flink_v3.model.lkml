connection: "bq_flat_rate_slots"
# connection: "flink_bq"

label: "Flink Core Data Model"

include: "/**/*.view.lkml"                # include all views in the views/ folder in this project
include: "/**/*.dashboard.lookml"
include: "/**/*.explore.lkml"




week_start_day: monday
case_sensitive: no


# START ------------------------ defined persisting strategies ---------------------------------
datagroup: flink_default_datagroup {
  sql_trigger: SELECT MAX(order_timestamp) FROM `flink-data-prod.curated.orders` ;;
  max_cache_age: "24 hour"
}

datagroup: flink_hourly_datagroup {
  sql_trigger: SELECT MAX(order_timestamp) FROM `flink-data-prod.curated.orders`;;
  max_cache_age: "1 hour"
}

datagroup: flink_daily_datagroup {
  # define daily trigger at 5 am UTC as suggested by Looker documentation:
  # https://docs.looker.com/reference/view-params/sql_trigger_value  (part: Google BigQuery - Once per day at a specific hour)
  sql_trigger: SELECT FLOOR(((TIMESTAMP_DIFF(CURRENT_TIMESTAMP(),'1970-01-01 00:00:00',SECOND)) - 60*60*6)/(60*60*24));;
  max_cache_age: "24 hour"
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
