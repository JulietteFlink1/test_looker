connection: "flink_bq"

include: "/**/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

include: "/**/*.dashboard.lookml"

label: "Flink Core Data Model"

# include all the views
include: "/views/**/*.view"

# include retail explores
include: "/explores/**/*.explore.lkml"
include: "/explores/base_explores/orders_cl.explore.lkml"
#include: "/explores/base_explores/orders_cl_cleaned.explore.lkml"
include: "/explores/base_explores/order_orderline_cl.explore.lkml"
include: "/explores/base_explores/orders_customers.explore.lkml"
#include: "/explores/base_explores/orders_customers_cleaned.explore.lkml"

week_start_day: monday
case_sensitive: no

datagroup: flink_default_datagroup {
  sql_trigger: SELECT MAX(partition_timestamp) FROM `flink-data-prod.curated.inventory` ;;
  max_cache_age: "24 hour"
}

datagroup: flink_hourly_datagroup {
  sql_trigger: SELECT MAX(partition_timestamp) FROM `flink-data-prod.curated.inventory`;;
  max_cache_age: "1 hour"
}

persist_with: flink_default_datagroup

access_grant: can_view_customer_data {
  user_attribute: access_customer_data
  allowed_values: [ "Yes" ]
}

access_grant: can_view_buying_information {
  user_attribute: access_buying_information
  allowed_values: [ "Yes" ]
}

named_value_format: euro_accounting_2_precision {
  value_format: "\"€\"#,##0.00"
}

named_value_format: euro_accounting_1_precision {
  value_format: "\"€\"#,##0.0"
}

named_value_format: euro_accounting_0_precision {
  value_format: "\"€\"#,##0"
}






# STAY- NEW FILE
####### TYPEFORM ANSWERS EXPLORE #######
explore: answers {
  from: desired_products_survey
  label: "Desired Products"
  view_label: "Desired Products"
  group_label: "04) Survey Data"
  description: "Customer Survey on Desired Products"

}


# REMOVE
####### CS ISSUES EXPLORE #######
explore: cs_issues_post_delivery {
  hidden: yes
  label: "CS Contacts"
  view_label: "CS Contacts"
  group_label: "07) Customer Service"
  description: "Customer Service Contacts tracked via GSheet"

  always_filter: {
    filters:  [
      hubs.country: "",
      hubs.hub_name: ""
    ]
  }

  access_filter: {
    field: order_order.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  join: order_order {
    sql_on: ${order_order.country_iso} = ${cs_issues_post_delivery.country_iso} AND
      ${cs_issues_post_delivery.order_nr__} = ${order_order.id};;
    relationship: many_to_one
    type: full_outer
  }

  join: user_order_facts {
    view_label: "* Customers *"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_order.country_iso} = ${user_order_facts.country_iso} AND
      ${order_order.user_email} = ${user_order_facts.user_email} ;;
  }

  join: hub_order_facts {
    view_label: "* Hubs *"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_order.country_iso} = ${hub_order_facts.country_iso} AND
      ${order_order.warehouse_name} = ${hub_order_facts.warehouse_name} ;;
  }

  join: order_fulfillment {
    sql_on: ${order_fulfillment.country_iso} = ${order_order.country_iso} AND
      ${order_fulfillment.order_id} = ${order_order.id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: order_fulfillment_facts {
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_fulfillment_facts.country_iso} = ${order_fulfillment.country_iso} AND
      ${order_fulfillment_facts.order_fulfillment_id} = ${order_fulfillment.id} ;;
  }

  join: hubs {
    view_label: "* Hubs *"
    sql_on: ${order_order.country_iso} = ${hubs.country_iso} AND
      ${order_order.warehouse_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    view_label: "* Shifts *"
    sql_on: ${order_order.created_date} = ${shyftplan_riders_pickers_hours.date} and
      ${hubs.hub_code} = ${shyftplan_riders_pickers_hours.hub_name};;
    relationship: many_to_one
    type: left_outer
  }
}




####### Competitor Analysis #######
# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view






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


# STAY- NEW FILE
explore: marketing_performance {
  label: "Marketing Performance"
  view_label: "Marketing Performance"
  group_label: "11) Marketing"
  description: "Marketing Performance: Installs, Orders, CAC, CPI"
}



########### CRM EXPLORE ###########

## NEW FILE
explore: braze_crm_data {
  label: "CRM Email Data (Braze)"
  view_label: "CRM Email Data"
  group_label: "11) Marketing"
  description: "Information on our CRM activities (using Braze as service provider)"
  always_filter: {
    filters:  [
      braze_crm_data.campaign_name: "",
      braze_crm_data.country: ""
      ]
  }
}

########### HUB NPS EXPLORE ###########

# NEW FILE
explore: nps_hub_team {
  hidden: yes
  label: "NPS (Hub Teams)"
  view_label: "NPS (Hub Teams)"
  group_label: "12) NPS (Internal Teams)"
  description: "NPS surveys towards internal teams"

  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

  join: hubs {
    sql_on:
    ${nps_hub_team.hub_code} = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

}


########### AD-HOC EXPLORE ###########

explore: products_mba {
  hidden: yes
  label: "Market basket analysis at a product level"
  view_label: "Product MBA"
  group_label: "15) Ad-Hoc"
  description: "Product basket analysis"

}

explore: categories_mba {
  hidden: yes
  label: "Market basket analysis at a category level"
  view_label: "Category MBA"
  group_label: "15) Ad-Hoc"
  description: "Product category basket analysis"

}

explore: user_order_facts_phone_number {
  hidden: yes
  label: "User Order Facts - Unique User ID"
  view_label: "User Order Facts - Unique User ID"
  group_label: "15) Ad-Hoc"
  description: "User Order facts with phone number + last name as unique identifier"

  join: hubs {
    view_label: "* Hubs *"
    sql_on: ${user_order_facts_phone_number.country_iso} = ${hubs.country_iso} AND
      ${user_order_facts_phone_number.hub_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
  }

}
