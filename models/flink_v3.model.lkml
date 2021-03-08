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
case_sensitive: no

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
                order_order.is_successful_order: "yes",
                order_order.created_date: "after 2020-01-25"
              ]
  }

  #filter Investor user so they can only see completed calendar weeks data and not week to date
  sql_always_where: CASE WHEN ({{ _user_attributes['id'] }}) = 28 THEN ${order_order.created_week} < ${now_week} ELSE 1=1 END;;

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

  join: discount_voucher {
    type: left_outer
    relationship: many_to_one
    sql_on: ${discount_voucher.id} = ${order_order.voucher_id} ;;
  }

  join: shipping_address {
    from: account_address
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_order.shipping_address_id} = ${shipping_address.id} ;;
  }

  join: billing_address {
    from: account_address
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_order.billing_address_id} = ${shipping_address.id} ;;
  }

  join: first_order_facts {
    view_label: "First Order Facts"
    type: inner
    from: order_order
    relationship: one_to_one
    sql_on: ${user_order_facts.first_order_id} = ${first_order_facts.id} ;;
    #sql_where: ${first_order_facts.is_successful_order} = "yes" AND ${first_order_facts.is_internal_order} = "no";; #not needed to filter join table if base table is already filtered?
    fields:
    [
      first_order_facts.warehouse_name,
      first_order_facts.is_voucher_order,
      first_order_facts.avg_delivery_time,
      first_order_facts.delivery_delay_since_eta,
      first_order_facts.is_delivery_less_than_0_minute,
      first_order_facts.is_delivery_more_than_30_minute
    ]
  }

  join: first_order_discount {
    view_label: "First Order Facts"
    type: left_outer
    from: discount_voucher
    relationship: one_to_one
    sql_on: ${first_order_facts.voucher_id} = ${first_order_discount.id} ;;
    fields:
    [
      first_order_discount.code,
    ]
  }

  join: latest_order_facts {
    view_label: "Latest Order Facts"
    type: inner
    from: order_order
    relationship: one_to_one
    sql_on: ${user_order_facts.latest_order_id} = ${latest_order_facts.id} ;;
    #sql_where: ${first_order_facts.is_successful_order} = "yes" AND ${first_order_facts.is_internal_order} = "no";; #not needed to filter join table if base table is already filtered?
    fields:
    [
      latest_order_facts.warehouse_name,
      latest_order_facts.is_voucher_order,
      latest_order_facts.avg_delivery_time,
      latest_order_facts.delivery_delay_since_eta,
      latest_order_facts.is_delivery_less_than_0_minute,
      latest_order_facts.is_delivery_more_than_30_minute
    ]
  }

  join: weekly_cohorts_stable_base {
    view_label: "First Order Facts (Weekly Cohorts)"
    sql_on: ${user_order_facts.first_order_week} = ${weekly_cohorts_stable_base.first_order_week};;
    relationship: one_to_one
    type: left_outer
  }

  join: monthly_cohorts_stable_base {
    view_label: "First Order Facts (Monthly Cohorts)"
    sql_on: ${user_order_facts.first_order_month} = ${monthly_cohorts_stable_base.first_order_month} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: hubs {
    view_label: "Hubs"
    sql_on: ${order_order.warehouse_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
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

  join: product_producttype {
    sql_on: ${product_product.product_type_id} = ${product_producttype.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: parent_category {
    from: product_category
    sql_on: ${product_category.parent_id} = ${parent_category.id} ;;
    relationship: one_to_one
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

  join: hubs {
    view_label: "Hubs"
    sql_on: ${warehouse_warehouse.slug} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
  }
}

explore: answers {
  label: "Desired Products"
  view_label: "Desired Products"
  group_label: "3) Survey Data"
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

explore: adjust_sessions {
  label: "Adjust app data"
  view_label: "Adjust sessions"
  group_label: "5) Adjust app data"
  description: "Adjust events by session from mobile apps data"
  always_filter: {
    filters:
    [
      adjust_sessions._partitiondate: "7 days"
    ]
  }
  join: adjust_events {
    sql_on: ${adjust_sessions._adid_} = ${adjust_events._adid_}
    AND ${adjust_events._created_at__raw} >= ${adjust_sessions.session_start_raw}
    AND
      (
        ${adjust_events._created_at__raw} < ${adjust_sessions.next_session_start_raw}
        OR ${adjust_sessions.next_session_start_time} is NULL
      )
        ;;
    relationship: one_to_many
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
