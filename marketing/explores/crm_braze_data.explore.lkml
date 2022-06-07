include: "/marketing/views/bigquery_curated/crm_braze_data.view.lkml"

explore: crm_braze_data {
  hidden: no
  view_name: crm_braze_data
  label: "[CRM] Campaigns (Braze)"
  view_label: "CRM Email Data"
  group_label: "Marketing"
  description: "Performance of Campaigns"
  always_filter: {
    filters:  [
      crm_braze_data.email_sent_at_date: "",
      crm_braze_data.campaign_name: "",
      crm_braze_data.country: ""
      ]
}
}
