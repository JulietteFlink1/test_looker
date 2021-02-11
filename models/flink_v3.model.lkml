connection: "flink_bq"

include: "/**/*.view.lkml"                # include all views in the views/ folder in this project
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


label: "Flink Core Data Model"

# include all the views
include: "/views/**/*.view"


week_start_day: monday

datagroup: flink_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM order_order;;
  max_cache_age: "2 hour"
}


persist_with: flink_default_datagroup


named_value_format: euro_accounting_2_precision {
  value_format: "\"€\"#,##0.00"
}

named_value_format: euro_accounting_1_precision {
  value_format: "\"€\"#,##0.0"
}

named_value_format: euro_accounting_0_precision {
  value_format: "\"€\"#,##0"
}


explore: order_order {
  label: "Orders"
  view_label: "Orders"
  group_label: "1) Performance"
  description: "General Business Performance - Orders, Revenue, etc."
  always_filter: {
    filters:  [
                order_order.is_internal_order: "no",
                order_order.is_successful_order: "yes"
              ]
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

  join: user_order_facts {
    view_label: "Users"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_order.user_email} = ${user_order_facts.user_email} ;;
  }

  join: order_fulfillment_facts {
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_fulfillment_facts.order_fulfillment_id} = ${order_fulfillment.id} ;;
  }

}

explore: product_product {
  label: "Products"
  view_label: "Products"
  group_label: "2) Inventory"
  description: "Products, Productvariations, Categories, SKUs, Stock etc."
  always_filter: {
    filters:  [
      product_product.is_published: "yes",
      order_orderline_facts.is_internal_order: "no",
      order_orderline_facts.is_successful_order: "yes"
    ]
  }

  join: product_productvariant {
    sql_on: ${product_productvariant.product_id} = ${product_product.id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: product_category {
    sql_on: ${product_category.id} = ${product_product.category_id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: warehouse_stock {
    type: left_outer
    relationship: one_to_many
    sql_on: ${warehouse_stock.product_variant_id} = ${product_productvariant.id} ;;
  }

  join: warehouse_warehouse {
    type: left_outer
    relationship: one_to_one
    sql_on: ${warehouse_warehouse.id} = ${warehouse_stock.warehouse_id} ;;
  }

  join: order_orderline_facts {
    sql_on: ${order_orderline_facts.product_sku} = ${product_productvariant.sku} AND ${order_orderline_facts.warehouse_name} = ${warehouse_warehouse.slug};;
    relationship: one_to_many
    type: left_outer
  }
}

explore: answers {
  label: "Desired Products"
  view_label: "Desired Products"
  group_label: "2) Survey Data"
  description: "Customer Survey on Desired Products"
  join: questions {
    sql_on: ${questions.question_id} = ${answers.question_id} ;;
    relationship: many_to_one
    type: left_outer
  }
  join: landings {
    sql_on: ${landings.landing_id} = ${answers.landing_id} ;;
    relationship: one_to_one
    type: left_outer
  }
}


# explore: order_extends {
#   label: "Power User Orders..."
#   view_label: "Power User Orders..."
#   group_label: "1) Performance"
#   extends: [order_order]
#   view_name: order_order
#   # join: answers {
#   #   sql_on: ${answers.landing_id} = ${order_order.id} ;;
#   #   relationship: one_to_many
#   #   type: left_outer
#   # }
# }
