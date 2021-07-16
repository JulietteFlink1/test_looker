include: "/explores/base_explores/base_orders.explore"
include: "/explores/base_explores/base_order_address.explore"
include: "/explores/base_explores/base_order_discount_order_vouchers.explore"
include: "/explores/base_explores/base_order_fulfillment.explore"
include: "/explores/base_explores/base_order_payment.explore"
include: "/explores/base_explores/base_order_user_order_facts.explore"
include: "/explores/base_explores/base_order_orderline.explore"
include: "/explores/base_explores/base_order_hub_level.explore"
include: "/views/bigquery_tables/discount_voucher.view.lkml"
include: "/views/bigquery_tables/order_order.view.lkml"
include: "/views/bigquery_tables/discount_voucher.view.lkml"

explore: base_order_order {
  group_label: "01) Performance"
  label: "Order test"
  # description: "This is the clean version of orders explore"
  hidden: yes
  extends: [base_orders,
            base_order_address,
            base_order_discount_order_vouchers,
            base_order_fulfillment,
            base_order_payment,
            base_order_user_order_facts,
            base_order_orderline,
            base_order_hub_level
            ]
  fields: [ALL_FIELDS*
  ]

  join: gdpr_account_deletion {
    view_label: "* Customers *"
    sql_on: LOWER(${base_orders.user_email}) = LOWER(${gdpr_account_deletion.email});;
    relationship: many_to_one
    type: left_outer
  }

  join: order_sku_count {
    sql_on: ${base_orders.country_iso} = ${order_sku_count.country_iso} AND
            ${base_orders.id}          = ${order_sku_count.order_id} ;;
    relationship: one_to_one
    type: left_outer
  #view_label: "Discount Vouchers Clean"
  # The additional things you want to add or change
  # in the new Explore
  }

}
