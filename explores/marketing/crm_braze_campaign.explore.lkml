include: "/views/bigquery_tables/crm_braze_campaign.view.lkml"

explore: crm_braze_campaign {
  hidden: yes
  view_name: crm_braze_campaign
  # hidden:  yes
  label: "CRM Campaign Data (Braze)"
  view_label: "CRM Braze Campaign"
  group_label: "11) Marketing"
  description: "Performance of Emails per Campaign"
  always_filter: {
    filters:  [
      crm_braze_campaign.email_sent_at: "",
      crm_braze_campaign.campaign_name: "",
      crm_braze_campaign.country: ""
    ]
  }

}
