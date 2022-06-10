include: "/**/user_attributes_daily_customer_lifecycle_aggregates.view.lkml"

explore: user_attributes_daily_customer_lifecycle_aggregates {
  from:  user_attributes_daily_customer_lifecycle_aggregates
  view_name: user_attributes_daily_customer_lifecycle_aggregates
  hidden: yes
}
