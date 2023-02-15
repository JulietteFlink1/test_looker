# Oracle tables
include: "/**/erp_product_hub_vendor_assignment_unfiltered.view"
# dim tables
include: "/**/hubs_ct.view"

# Owner: Andreas
# Content:
#    This Explore shows Oracle base data for the ERP team to check wrong/missing master-data.

explore: oracle_master_data {

  hidden: no
  label: "Oracle Master-Data"
  description: "This Explore shows Oracle base data for the ERP team to check wrong/missing master-data"
  group_label: "Supply Chain"

  from: erp_product_hub_vendor_assignment_unfiltered
  view_name: erp_product_hub_vendor_assignment_unfiltered
  sql_always_where: ${erp_product_hub_vendor_assignment_unfiltered.report_date} >= '2023-01-27' ;;

  access_filter: {
    field: hubs_ct.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      erp_product_hub_vendor_assignment_unfiltered.report_date: "last 7 days"
    ]
  }

  join: hubs_ct {
    relationship: many_to_one
    type: left_outer
    sql_on: ${hubs_ct.hub_code} = ${erp_product_hub_vendor_assignment_unfiltered.hub_code} ;;
  }

}
