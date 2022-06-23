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



explore: delivery_notifications {

  label:       "Delivery Notifications"
  description: "This explore covers all the necessary data coming from our Internal tool + Transus regarding dispatchs"
  group_label: "Supply Chain"

  from  :     replenishment_dc_desadvs
  view_name:  replenishment_dc_desadvs
  view_label: " 01 Delivery Notifications"
  hidden: yes

### FILTERS



### JOINS



  }
