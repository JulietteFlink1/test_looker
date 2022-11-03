# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - FR Team (Supply Chain and Commercial)
#
#

include: "/supply_chain/views/bigquery_curated/carrefour_schedule.view"


explore: carrefour_schedule {

  label:       "Carrefour Schedule"
  description: "This explore covers all the necessary data coming Carrefour Schedule"
  group_label: "Supply Chain"

  from  :     carrefour_schedule
  view_label: "Carrefour Schedule (Raw)"
  hidden: no

### FILTERS

  fields: [ALL_FIELDS*]

  always_filter: {
    filters: [
      carrefour_schedule.schedule_emited_date: "last 7 days",

    ]
  }

}
