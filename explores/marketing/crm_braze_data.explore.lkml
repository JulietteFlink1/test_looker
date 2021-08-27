include: "/views/bigquery_tables/crm_braze_data.view.lkml"

explore: crm_braze_data {
  view_name: crm_braze_data
  label: "CRM Email Data (Braze) - BQ based"
  view_label: "CRM Email Data"
  group_label: "11) Marketing"
  description: "Performance of Emails per Campaign and Canvas"
  always_filter: {
    filters:  [
      crm_braze_data.email_sent_at_date: "",
      crm_braze_data.campaign_name: "",
      crm_braze_data.country: ""
      ]
}
}
