connection: "pickery_bq"

label: "Flink Data Model v1"

# include all the views
include: "/views/**/*.view"


week_start_day: monday

datagroup: flink_v1_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM order_order;;
  max_cache_age: "2 hour"
}


persist_with: flink_v1_default_datagroup

explore: order_order {
  view_label: "Orders"
  group_label: "1) Performance"
  description: "General Business Performance - Orders, Revenue, etc."
  sql_always_where: status not in ('canceled','draft') and total_gross_amount > 5 and user_email not like ('%pickery%');;

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


# explore: account_address {}

# explore: account_customerevent {}

# explore: account_staffnotificationrecipient {}

# explore: account_user {}

# explore: account_user_addresses {}

# explore: account_user_groups {}

# explore: checkout_checkout {}

# explore: checkout_checkoutline {}

# explore: discount_sale {}

# explore: discount_voucher {}

# explore: menu_menu {}

# explore: menu_menuitem {}

# explore: order_fulfillment {}

# explore: order_fulfillmentline {}

# explore: order_orderevent {}

# explore: order_orderline {}

# explore: payment_payment {}

# explore: payment_transaction {}

# explore: product_assignedproductattribute {}

# explore: product_assignedproductattribute_values {}

# explore: product_attribute {}

# explore: product_attributevalue {}

# explore: product_category {}

# explore: product_collectionproduct {}

# explore: product_product {}

# explore: product_productimage {}

# explore: product_producttype {}

# explore: product_productvariant {}

# explore: warehouse_allocation {}

# explore: warehouse_stock {}

# explore: warehouse_warehouse {}

# explore: warehouse_warehouse_shipping_zones {}
