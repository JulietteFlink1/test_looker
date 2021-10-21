include: "/views/sql_derived_tables/crm_braze_canvas.view.lkml"
# include: "/views/**/*.view"
# include: "/**/*.view"

explore: crm_braze_canvas {
  hidden: no
  view_name: crm_braze_canvas
  label: "CRM Canvas Data (Braze)"
  view_label: "CRM Braze Canvas"
  # group_label: "11) Marketing"
  group_label: "ZZ Test Explores"
  description: "Performance of Emails per Canvas"
  always_filter: {
    filters:  [
      crm_braze_canvas.email_sent_at: "",
      crm_braze_canvas.canvas_name: "",
      crm_braze_canvas.country: ""
    ]
  }

}
