connection: "pickery_backend_bq"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }


label: "Flink Data Model v2"

# include all the views
include: "/views/**/*.view"


week_start_day: monday

datagroup: flink_v2_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM order_order;;
  max_cache_age: "2 hour"
}


persist_with: flink_v2_default_datagroup

explore: order_order {
  view_label: "Orders"
  group_label: "1) Performance"
  description: "General Business Performance - Orders, Revenue, etc."
  always_filter: {
    filters: [status : "-canceled", status : "-draft", total_gross_amount : ">5",
      user_email : "-%pickery%"]
  }

  join: order_fulfillment {
    sql_on: ${order_fulfillment.order_id} = ${order_order.id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: order_orderline {
    sql_on: ${order_orderline.order_id} = ${order_order.id} ;;
    relationship: one_to_many
    type: left_outer
  }

}
