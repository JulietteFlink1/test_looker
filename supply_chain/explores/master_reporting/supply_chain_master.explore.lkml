# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team
#
# Questions that can be answered
# - This explore shows the most important KPIs for Supply Chain team combined in the same place.
# In here we can see:
         # Availability
         # Waste
         # Fill Rate
         # GMV


include: "/supply_chain/explores/master_reporting/supply_chain_master_report.view"



explore: supply_chain_master {

  hidden: no

  label: "Supply Chain Master Explore"
  group_label: "Supply Chain"

  from: supply_chain_master_report

  access_filter: {
    field: country_iso
    user_attribute: country_iso

  }


  }
