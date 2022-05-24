# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team
#
# Questions that can be answered
# - Purchase Orders data alone, since we found and issue in PO linked in SC explore due missing skus
# that are have been not assigned in product_hub_assigment_v2
#
include: "/**/*.view"



explore: purchase_orders {

  label:       "Purchase Orders"
  description: "This explore covers all the necessary data coming Replenishment Purchase Orders"
  group_label: "Supply Chain"

  from  :     replenishment_purchase_orders
  view_name:  purchase_orders
  view_label: " 01 Purchase Orders"
  hidden: yes

### FILTERS

fields: [ALL_FIELDS*,-purchase_orders.pct_order_inbounded,-purchase_orders.sum_purchase_price]

  always_filter: {
    filters: [
      purchase_orders.order_date: "last 30 days",

      purchase_orders.vendor_id: "",

      purchase_orders.status: "Sent"

    ]
  }


### JOINS



}
