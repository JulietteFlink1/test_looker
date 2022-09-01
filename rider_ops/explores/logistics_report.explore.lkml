include: "/**/logistics_report.explore"
include: "/**/orders_cl.explore"

explore: logistics_report {
  extends: [orders_cl]
  group_label: "Rider Ops"
  label: "Logistics Report"
  description: "operational performance KPIs in a hub level such as AVG rider UTR, AVG delivery time, %late order, % no_show,  etc."
  hidden: yes
}
