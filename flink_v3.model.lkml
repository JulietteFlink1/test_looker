connection: "bq_flat_rate_slots"
# connection: "flink_bq"

label: "Flink Core Data Model"

include: "/**/*.view.lkml"                # include all views in the views/ folder in this project
include: "/**/*.dashboard.lookml"
include: "/**/*.explore.lkml"



week_start_day: monday
case_sensitive: no


# START ------------------------ defined persisting strategies ---------------------------------
# schedules based on the recommendations of the official Google documentation
# >> https://cloud.google.com/looker/docs/reference/param-view-sql-trigger-value
datagroup: flink_default_datagroup {
  # every hour
  sql_trigger: SELECT EXTRACT(HOUR FROM CURRENT_TIMESTAMP()) ;;
}

datagroup: flink_hourly_datagroup {
  # every hour
  sql_trigger: SELECT EXTRACT(HOUR FROM CURRENT_TIMESTAMP());;
}

datagroup: flink_daily_datagroup {
  # once per day at 3 a.m. UTC
  sql_trigger: SELECT FLOOR(((TIMESTAMP_DIFF(CURRENT_TIMESTAMP(),'1970-01-01 00:00:00',SECOND)) - 60*60*  3  )/(60*60*24));;
}


persist_with: flink_daily_datagroup
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

access_grant: can_access_pii {
  user_attribute: access_pii
  allowed_values: [ "Yes" ]
}

access_grant: can_access_pii_customers {
  user_attribute: access_pii_customers
  allowed_values: [ "Yes" ]
}

access_grant: can_access_pii_hq_employees {
  user_attribute: access_pii_hq_employees
  allowed_values: [ "Yes" ]
}

access_grant: can_access_pii_hub_employees {
  user_attribute: access_pii_hub_employees
  allowed_values: [ "Yes" ]
}

access_grant: can_access_pricing {
  user_attribute: access_pricing
  allowed_values: [ "Yes" ]
}

access_grant: can_access_pricing_margins {
  user_attribute: access_pricing_margins
  allowed_values: [ "Yes" ]
}

# END ------------------------ access_grant rules ----------------------------


# START ------------------------ custom value formats ----------------------------
named_value_format: euro_accounting_2_precision { value_format: "\"€\"#,##0.00" }
named_value_format: euro_accounting_1_precision { value_format: "\"€\"#,##0.0" }
named_value_format: euro_accounting_0_precision { value_format: "\"€\"#,##0" }
# END ------------------------ custom value formats ----------------------------
