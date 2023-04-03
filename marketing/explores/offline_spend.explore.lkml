include: "/marketing/views/bigquery_curated/offline_marketing_spend.view.lkml"

explore: offline_marketing_spend {
  hidden: no

  group_label: "Marketing"
  label: "Offline spend"
  description: "Marketing offline spend"


  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#  - - - - - - - - - -    FILTER & SETTINGS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  always_filter: {
    filters: [
      offline_marketing_spend.week_week: "last 4 weeks",
      offline_marketing_spend.date_granularity: "Week",
      offline_marketing_spend.country_iso: "",
      offline_marketing_spend.channel: "",
      offline_marketing_spend.network: ""

    ]
  }

}
