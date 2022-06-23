# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team
#
# Questions that can be answered
# - All questions around dispatchs (based on delivery notificatiolns)
#
include: "/**/*.view"



explore: bulk_items {

  label:       "Delivery Notifications REWE"
  description: "This explore covers all the necessary data coming from REWE Notifications"
  group_label: "Supply Chain"

  from  :     bulk_items
  view_name:  bulk_items
  view_label: " 01 Delivery Notifications REWE"
  hidden: yes

  fields: [ALL_FIELDS*, -bulk_items.cross_referenced_fields*]

### FILTERS



### JOINS



}
