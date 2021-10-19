include: "/views/bigquery_tables/crm_braze_canvas.view.lkml"
# include: "/views/**/*.view"
# include: "/**/*.view"

explore: crm_braze_canvas {
  hidden: yes
  view_name: crm_braze_canvas
  label: "CRM Canvas Data (Braze)"
  view_label: "CRM Braze Canvas"
  group_label: "11) Marketing"
  description: "Performance of Emails per Canvas"
  always_filter: {
    filters:  [
      crm_braze_canvas.email_sent_at: "",
      crm_braze_canvas.canvas_name: "",
      crm_braze_canvas.country: ""
    ]
  }

}
