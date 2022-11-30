# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team
#
# Questions that can be answered
# - Bucketing logic for Availability(OOS) definitions
#
#
include: "/**/*.view"
explore: oos_reason_buckets {
  label:       "OOS Reason Buckets"
  description: "This explore covers all the necessary data coming from waste_waterfall_definition reporting model"
  from  :     oos_reason_bucketing
  view_label: " 01 OOS Reasons Buckets"
  group_label: "Supply Chain"
  hidden: yes

  always_filter: {
    filters: [
      oos_reason_buckets.report_week_week: "last week",

      oos_reason_buckets.country_iso: "",

      oos_reason_buckets.report_week_week_of_year: ""

    ]
  }

  access_filter: {
    field: hubs_ct.country_iso
    user_attribute: country_iso

  }


  join: products {
    view_label: "03 Products (CT) "
    type: left_outer
    relationship: many_to_many
    sql_on:
        ${products.replenishment_substitute_group_parent_sku} = ${oos_reason_buckets.parent_sku} and
        ${products.country_iso} = ${oos_reason_buckets.country_iso}
        ;;
  }

  join: hubs_ct {
    view_label: "02 Hubs"
    type: left_outer
    relationship: many_to_one
    sql_on: ${hubs_ct.hub_code} = ${oos_reason_buckets.hub_code} ;;
  }

}
