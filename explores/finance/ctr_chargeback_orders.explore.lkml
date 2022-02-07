include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: ctr_chargeback_orders {
  view_name:  ctr_chargeback_orders
  label: "CTR Chargeback Orders"
  view_label: "* CTR Chargeback Orders *"
  group_label: "Finance"
  description: "Provides Monthly Aggregations for CTR Reporting "


  required_access_grants: [can_view_buying_information]



}
