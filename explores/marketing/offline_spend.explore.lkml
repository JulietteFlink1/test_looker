include: "/views/bigquery_tables/curated_layer/offline_marketing_spend.view"

explore: offline_marketing_spend {
  hidden: no

  group_label: "Marketing"
  label: "Offline spend"
  description: "Marketing offline spend"


  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

}
