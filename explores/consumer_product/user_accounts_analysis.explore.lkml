include: "/views/sql_derived_tables/user_accounts_analysis.view.lkml"

explore: user_accounts_analysis {
  hidden: yes
  view_name:  user_accounts_analysis
  label: "User Accounts Rollout Analysis"
  view_label: "User Accounts Analysis"
  group_label: "Consumer Product"
}
