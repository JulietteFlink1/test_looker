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

}
