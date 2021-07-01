connection: "flink_bq"

include: "/**/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

label: "Flink Core Data Model"

# include all the views
include: "/views/**/*.view"


week_start_day: monday
case_sensitive: no

datagroup: flink_default_datagroup {
  sql_trigger: SELECT MAX(_sdc_extracted_at) FROM warehouse_stock;;
  max_cache_age: "24 hour"
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

####### ORDER EXPLORE #######
explore: order_order {
  label: "Orders"
  view_label: "* Orders *"
  group_label: "01) Performance"
  description: "General Business Performance - Orders, Revenue, etc."
  always_filter: {
    filters:  [
      hubs.country: "",
      hubs.hub_name: "",
      order_order.is_internal_order: "no",
      order_order.is_successful_order: "yes",
      order_order.created_date: "after 2021-01-25"
    ]
  }

  access_filter: {
    field: order_order.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  #filter Investor user so they can only see completed calendar weeks data and not week to date
  sql_always_where: CASE WHEN ({{ _user_attributes['id'] }}) = 28 THEN ${order_order.created_week} < ${now_week} ELSE 1=1 END;;

  join: order_fulfillment {
    sql_on: ${order_fulfillment.country_iso} = ${order_order.country_iso} AND
      ${order_fulfillment.order_id} = ${order_order.id};;
    relationship: one_to_many
    type: left_outer
  }

  join: order_orderline {
    sql_on: ${order_orderline.country_iso} = ${order_order.country_iso} AND
      ${order_orderline.order_id} = ${order_order.id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: user_order_facts {
    view_label: "* Customers *"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_order.country_iso} = ${user_order_facts.country_iso} AND
      ${order_order.user_email} = ${user_order_facts.user_email} ;;
  }

  join: hub_order_facts {
    view_label: "* Hubs *"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_order.country_iso} = ${hub_order_facts.country_iso} AND
      ${order_order.warehouse_name} = ${hub_order_facts.warehouse_name} ;;
  }

  join: order_fulfillment_facts {
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_fulfillment_facts.country_iso} = ${order_fulfillment.country_iso} AND
      ${order_fulfillment_facts.order_fulfillment_id} = ${order_fulfillment.id} ;;
  }

  join: discount_voucher {
    type: left_outer
    relationship: many_to_one
    sql_on: ${discount_voucher.country_iso} = ${order_order.country_iso} AND
      ${discount_voucher.id} = ${order_order.voucher_id} ;;
  }

  join: shipping_address {
    view_label: "* Customer Address (Shipping) *"
    from: account_address
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_order.country_iso} = ${shipping_address.country_iso} AND
      ${order_order.shipping_address_id} = ${shipping_address.id} ;;
  }

  join: billing_address {
    view_label: "* Customer Address (Billing) *"
    from: account_address
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_order.country_iso} = ${billing_address.country_iso} AND
      ${order_order.billing_address_id} = ${billing_address.id} ;;
  }

  join: first_order_facts {
    view_label: "* Cohorts - First Order Facts *"
    type: inner
    from: order_order
    relationship: one_to_one
    sql_on: ${user_order_facts.country_iso} = ${first_order_facts.country_iso} AND
      ${user_order_facts.first_order_id} = ${first_order_facts.id} ;;
    #sql_where: ${first_order_facts.is_successful_order} = "yes" AND ${first_order_facts.is_internal_order} = "no";; #not needed to filter join table if base table is already filtered?
    fields:
    [
      first_order_facts.warehouse_name,
      first_order_facts.is_voucher_order,
      first_order_facts.avg_delivery_time,
      first_order_facts.delivery_delay_since_eta,
      first_order_facts.is_delivery_less_than_0_minute,
      first_order_facts.is_delivery_more_than_30_minute,
      first_order_facts.delivery_delay_since_eta
    ]
  }

  join: first_order_hub {
    from: hubs
    view_label: "* Cohorts - First Order Facts *"
    sql_on: ${first_order_facts.country_iso} = ${first_order_hub.country_iso} AND
      ${first_order_facts.warehouse_name} = ${first_order_hub.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
    fields:
    [
      first_order_hub.country,
      first_order_hub.city,
      first_order_hub.hub_name
    ]
  }

  join: first_order_discount {
    view_label: "* Cohorts - First Order Facts *"
    type: left_outer
    from: discount_voucher
    relationship: one_to_one
    sql_on: ${first_order_facts.country_iso} = ${first_order_discount.country_iso} AND
      ${first_order_facts.voucher_id} = ${first_order_discount.id} ;;
    fields:
    [
      first_order_discount.code
    ]
  }

  join: first_order_billing_address {
    view_label: "* Cohorts - First Order Facts *"
    from: account_address
    type: left_outer
    relationship: one_to_one
    sql_on: ${first_order_facts.country_iso} = ${first_order_billing_address.country_iso} AND
      ${first_order_facts.billing_address_id} = ${first_order_billing_address.id} ;;
    fields:
    [
      first_order_billing_address.first_name,
      first_order_billing_address.last_name
    ]
  }

  join: latest_order_facts {
    view_label: "* Cohorts - Latest Order Facts *"
    type: inner
    from: order_order
    relationship: one_to_one
    sql_on: ${user_order_facts.country_iso} = ${latest_order_facts.country_iso} AND
      ${user_order_facts.latest_order_id} = ${latest_order_facts.id} ;;
    #sql_where: ${first_order_facts.is_successful_order} = "yes" AND ${first_order_facts.is_internal_order} = "no";; #not needed to filter join table if base table is already filtered?
    fields:
    [
      latest_order_facts.warehouse_name,
      latest_order_facts.is_voucher_order,
      latest_order_facts.avg_delivery_time,
      latest_order_facts.delivery_delay_since_eta,
      latest_order_facts.is_delivery_less_than_0_minute,
      latest_order_facts.is_delivery_more_than_30_minute,
      latest_order_facts.delivery_delay_since_eta
    ]
  }

  join: user_order_rank {
    view_label: "* Customers *"
    sql_on: ${order_order.country_iso} = ${user_order_rank.country_iso} AND
      ${order_order.id} = ${user_order_rank.id};;
    relationship: one_to_one
    type: left_outer
    fields:
    [
      user_order_rank.user_order_rank
    ]
  }

  join: weekly_cohorts_base {
    view_label: "Cohorts - Weekly"
    sql_on: ${user_order_facts.country_iso} = ${weekly_cohorts_base.country_iso} AND
      ${user_order_facts.first_order_week} = ${weekly_cohorts_base.first_order_week};;
    relationship: one_to_one
    type: left_outer
  }

  join: monthly_cohorts_base {
    view_label: "Cohorts - Monthly"
    sql_on: ${user_order_facts.country_iso} = ${monthly_cohorts_base.country_iso} AND
      ${user_order_facts.first_order_month} = ${monthly_cohorts_base.first_order_month} ;;
    relationship: one_to_one
    type: left_outer
  }


  join: hubs {
    view_label: "* Hubs *"
    sql_on: ${order_order.country_iso} = ${hubs.country_iso} AND
      ${order_order.warehouse_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: hub_leaderboard_shift_metrics {
    view_label: "* Hubs *"
    sql_on: ${order_order.warehouse_name} = ${hub_leaderboard_shift_metrics.hub_code_lowercase} and
      ${order_order.created_date}   = ${hub_leaderboard_shift_metrics.date};;
    relationship: many_to_one
    type: left_outer
  }

  join: hub_leaderboard {
    view_label: "* Hubs *"
    sql_on: ${order_order.warehouse_name} = ${hub_leaderboard.hub_code_lowercase} and
      ${order_order.created_date}   = ${hub_leaderboard.created_date};;
    relationship: many_to_one
    type: left_outer
  }



  join: product_productvariant {
    sql_on: ${order_orderline.country_iso} = ${product_productvariant.country_iso} AND
      ${order_orderline.product_sku} = ${product_productvariant.sku} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: product_product {
    sql_on: ${product_productvariant.country_iso} = ${product_product.country_iso} AND
      ${product_productvariant.product_id} = ${product_product.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: product_attribute_facts {
    sql_on: ${product_product.country_iso} = ${product_attribute_facts.country_iso} AND
      ${product_product.id} = ${product_attribute_facts.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: product_category {
    sql_on: ${product_category.country_iso} = ${product_product.country_iso} AND
      ${product_category.id} = ${product_product.category_id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: product_producttype {
    sql_on:${product_product.country_iso} = ${product_producttype.country_iso} AND
      ${product_product.product_type_id} = ${product_producttype.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: parent_category {
    view_label: "* Product / SKU Parent Category Data *"
    from: product_category
    sql_on: ${product_category.country_iso} = ${parent_category.country_iso} AND
      ${product_category.parent_id} = ${parent_category.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: nps_after_order {
    view_label: "* NPS *"
    sql_on: ${order_order.country_iso} = ${nps_after_order.country_iso} AND
      ${order_order.id} = ${nps_after_order.order_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    view_label: "* Shifts *"
    sql_on: ${order_order.created_date} = ${shyftplan_riders_pickers_hours.date} and
      ${hubs.hub_code} = ${shyftplan_riders_pickers_hours.hub_name};;
    relationship: many_to_one
    type: left_outer
  }

  join: payment_payment {
    view_label: "* Payments *"
    sql_on: ${order_order.country_iso} = ${payment_payment.country_iso} and
      ${order_order.id} = ${payment_payment.order_id};;
    relationship: one_to_many
    type: left_outer
  }

  join: payment_transaction {
    view_label: "* Payments *"
    sql_on: ${payment_payment.country_iso} = ${payment_transaction.country_iso} and
      ${payment_payment.id} = ${payment_transaction.payment_id};;
    relationship: one_to_many
    type: left_outer
  }

  join: gdpr_account_deletion {
    view_label: "* Customers *"
    sql_on: LOWER(${order_order.user_email}) = LOWER(${gdpr_account_deletion.email});;
    relationship: many_to_one
    type: left_outer
  }

  join: issue_rate_hub_level {
    view_label: "Order Issues on Hub-Level"
    sql_on: ${hubs.hub_code_lowercase} =  LOWER(${issue_rate_hub_level.hub_code}) and
      ${order_order.date}        =  ${issue_rate_hub_level.date};;
    relationship: many_to_one # decided against one_to_many: on this level, many orders have hub-level issue-aggregates
    type: left_outer
  }

}

####### PRODUCTS EXPLORE #######
explore: product_product {
  label: " Products"
  view_label: "* Product / SKU Data *"
  group_label: "02) Inventory"
  description: "Products, Productvariations, Categories, SKUs, Stock etc."
  always_filter: {
    filters:  [
      hubs.country: "",
      hubs.hub_name: "",
      product_product.is_published: "yes",
      order_orderline_facts.is_internal_order: "no",
      order_orderline_facts.is_successful_order: "yes"
    ]
  }

  access_filter: {
    field: product_product.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  join: product_productvariant {
    sql_on: ${product_productvariant.country_iso} = ${product_product.country_iso} AND
      ${product_productvariant.product_id} = ${product_product.id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: product_category {
    sql_on: ${product_category.country_iso} = ${product_product.country_iso} AND
      ${product_category.id} = ${product_product.category_id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: product_producttype {
    sql_on: ${product_product.country_iso} = ${product_producttype.country_iso} AND
      ${product_product.product_type_id} = ${product_producttype.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: parent_category {
    view_label: "* Product / SKU Parent Category Data *"
    from: product_category
    sql_on: ${product_category.country_iso} = ${parent_category.country_iso} AND
      ${product_category.parent_id} = ${parent_category.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: warehouse_stock {
    type: left_outer
    relationship: one_to_many
    sql_on: ${warehouse_stock.country_iso} = ${product_productvariant.country_iso} AND
      ${warehouse_stock.product_variant_id} = ${product_productvariant.id} ;;
  }

  join: warehouse_warehouse {
    type: left_outer
    relationship: one_to_one
    sql_on: ${warehouse_warehouse.country_iso} = ${warehouse_stock.country_iso} AND
      ${warehouse_warehouse.id} = ${warehouse_stock.warehouse_id} ;;
  }

  join: order_orderline_facts {
    sql_on: ${order_orderline_facts.country_iso} = ${product_productvariant.country_iso} AND
            ${order_orderline_facts.product_sku} = ${product_productvariant.sku} AND
            ${order_orderline_facts.warehouse_name} = ${warehouse_warehouse.slug};;
    relationship: one_to_many
    type: left_outer
  }

  join: hubs {
    view_label: "* Hubs *"
    sql_on: ${warehouse_warehouse.country_iso} = ${hubs.country_iso} AND
      ${warehouse_warehouse.slug} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: product_attribute_facts {
    sql_on: ${product_product.country_iso} = ${product_attribute_facts.country_iso} AND
      ${product_product.id} = ${product_attribute_facts.id} ;;
    relationship: one_to_one
    type: left_outer
    fields: [
      country_iso,
      id,
      sku,
      leading_product,
      noos_group,
      substitute_group,
      substitute_group_internal_ranking,
      ean
    ]
  }
}

####### NOOS EXPLORE #######
explore: hist_daily_stock {
  label: "NooS Substitute Groups"
  view_label: "NooS Substitute Groups"
  group_label: "02) Inventory"
  description: "Snapshots of Daily Inventory per Substitute group (only NooS)"

  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  join: hubs {
    view_label: "* Hubs *"
    sql_on: ${hist_daily_stock.slug} = ${hubs.hub_code_lowercase} ;;
    relationship: many_to_one
    type: left_outer
  }
}

####### Substitute Group Rating #######
explore: product_attribute_fact_ranking_hlp {
  label: "Substitute Group: Product Rating"
  view_label: "Substitute Group: Product Rating"
  group_label: "02) Inventory"

  # access filter : should be derived from the order_order explore
}

####### VOUCHER EXPLORE #######
explore: discount_voucher {
  label: "Vouchers"
  view_label: "Vouchers"
  group_label: "03) Vouchers"
  description: "All data around Vouchers created in the backend"

  always_filter: {
    filters:  [
      hubs.country: "",
      hubs.hub_name: ""
    ]
  }

  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  join: influencer_vouchers_input {
    view_label: "Voucher Mapping"
    sql_on: ${discount_voucher.country_iso} = ${influencer_vouchers_input.country_iso} AND
      ${discount_voucher.code} = ${influencer_vouchers_input.voucher_code} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: order_order {
    sql_on: ${discount_voucher.country_iso} = ${order_order.country_iso} AND
      ${discount_voucher.id} = ${order_order.voucher_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: user_order_facts {
    view_label: "* Customers *"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_order.country_iso} = ${user_order_facts.country_iso} AND
      ${order_order.user_email} = ${user_order_facts.user_email} ;;
  }

  join: hub_order_facts {
    view_label: "* Hubs *"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_order.country_iso} = ${hub_order_facts.country_iso} AND
      ${order_order.warehouse_name} = ${hub_order_facts.warehouse_name} ;;
  }

  join: order_fulfillment {
    relationship: one_to_many
    type: left_outer
    sql_on: ${order_fulfillment.country_iso} = ${order_order.country_iso} AND
      ${order_fulfillment.order_id} = ${order_order.id} ;;
  }

  join: order_fulfillment_facts {
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_fulfillment_facts.country_iso} = ${order_fulfillment.country_iso} AND
      ${order_fulfillment_facts.order_fulfillment_id} = ${order_fulfillment.id} ;;
  }

  join: hubs {
    view_label: "* Hubs *"
    sql_on: ${order_order.country_iso} = ${hubs.country_iso} AND
      ${order_order.warehouse_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    view_label: "* Shifts *"
    sql_on: ${order_order.created_date} = ${shyftplan_riders_pickers_hours.date} and
      ${hubs.hub_code} = ${shyftplan_riders_pickers_hours.hub_name};;
    relationship: many_to_one
    type: left_outer
  }

}

####### TYPEFORM ANSWERS EXPLORE #######
explore: answers {
  from: desired_products_survey
  label: "Desired Products"
  view_label: "Desired Products"
  group_label: "04) Survey Data"
  description: "Customer Survey on Desired Products"

}

####### ADJUST EXPLORE #######
explore: adjust_sessions {
  label: "Adjust app data"
  view_label: "Adjust sessions"
  group_label: "06) Adjust app data"
  description: "Adjust events by session from mobile apps data"
  #always_filter: {
  #  filters:
  #  [
  #    adjust_sessions._partitiondate: "7 days"
  #  ]
  #}

  access_filter: {
    field: adjust_sessions.country
    user_attribute: country_iso
  }

  access_filter: {
    field: adjust_sessions.city
    user_attribute: city
  }


  join: adjust_events {
    sql_on: ${adjust_sessions._adid_} = ${adjust_events._adid_}
          AND datetime(${adjust_events.event_time_raw}, 'Europe/Berlin') >= ${adjust_sessions.session_start_at_raw}
          AND
            (
              datetime(${adjust_events.event_time_raw}, 'Europe/Berlin') < ${adjust_sessions.next_session_start_at_raw}
              OR ${adjust_sessions.next_session_start_at_raw} is NULL
            )
              ;;
    relationship: one_to_many
    type: left_outer
  }

}

explore: adjust_user_funnel {
  label: "Adjust user data"
  view_label: "Adjust user data"
  group_label: "06) Adjust app data"
  description: "Adjust first events by user"

  access_filter: {
    field: adjust_user_funnel._country_
    user_attribute: country_iso
  }

  access_filter: {
    field: adjust_user_funnel._city_
    user_attribute: city
  }
}

####### USER ACTIVITY TRACKING EXPLORES #######
explore: segment_tracking_sessions30{
  label: "Tracking events sessions 30 min."
  view_label: "Tracking events sessions 30 min."
  group_label: "10) In-app tracking data"
  description: "Tracking events sessions 30 min."
}

explore: marketingbanners_mobile_events {
  label: "Marketing banner impressions"
  view_label: "Marketing banner impressions"
  group_label: "10) In-app tracking data"
  description: "Marketing banner events"
}
explore: marketingbanners_mobile_events_displayed_hours {
  label: "Marketing banner: display times"
  view_label: "Marketing banner display times"
  group_label: "10) In-app tracking data"
  description: "Information on the time, specific bannners where shown on specific banner_positions and hubs"
}

explore: productsearch_mobile_events {
  label: "Product Search Keywords"
  view_label: "Product Search Keywords"
  group_label: "10) In-app tracking data"
  description: "Product Search Keywords from event tracking"
}

explore: voucher_api_failure_success {
  label: "Voucher Application Success"
  view_label: "Voucher Application Success"
  group_label: "10) In-app tracking data"
  description: "Voucher application success from api-based tracking events"
}

explore: monitoring_metrics {
  label: "Monitoring Metrics"
  view_label: "Monitoring Metrics"
  group_label: "10) In-app tracking data"
  description: "Monitoring behavioural metrics for tracking events"
}

####### CS ISSUES EXPLORE #######
explore: cs_issues_post_delivery {
  label: "CS Contacts"
  view_label: "CS Contacts"
  group_label: "07) Customer Service"
  description: "Customer Service Contacts tracked via GSheet"

  always_filter: {
    filters:  [
      hubs.country: "",
      hubs.hub_name: ""
    ]
  }

  access_filter: {
    field: order_order.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  join: order_order {
    sql_on: ${order_order.country_iso} = ${cs_issues_post_delivery.country_iso} AND
      ${cs_issues_post_delivery.order_nr__} = ${order_order.id};;
    relationship: many_to_one
    type: left_outer
  }

  join: user_order_facts {
    view_label: "* Customers *"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_order.country_iso} = ${user_order_facts.country_iso} AND
      ${order_order.user_email} = ${user_order_facts.user_email} ;;
  }

  join: hub_order_facts {
    view_label: "* Hubs *"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_order.country_iso} = ${hub_order_facts.country_iso} AND
      ${order_order.warehouse_name} = ${hub_order_facts.warehouse_name} ;;
  }

  join: order_fulfillment {
    sql_on: ${order_fulfillment.country_iso} = ${order_order.country_iso} AND
      ${order_fulfillment.order_id} = ${order_order.id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: order_fulfillment_facts {
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_fulfillment_facts.country_iso} = ${order_fulfillment.country_iso} AND
      ${order_fulfillment_facts.order_fulfillment_id} = ${order_fulfillment.id} ;;
  }

  join: hubs {
    view_label: "* Hubs *"
    sql_on: ${order_order.country_iso} = ${hubs.country_iso} AND
      ${order_order.warehouse_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    view_label: "* Shifts *"
    sql_on: ${order_order.created_date} = ${shyftplan_riders_pickers_hours.date} and
      ${hubs.hub_code} = ${shyftplan_riders_pickers_hours.hub_name};;
    relationship: many_to_one
    type: left_outer
  }
}




####### Competitor Analysis #######
# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: gorillas_v1_items {
  hidden: no
  label: "Gorillas Items"
  view_label: "Gorillas Items"
  group_label: "08) Competitor Analysis"
  description: "Analysis of competitors."
  always_filter: {
    filters: {
      field: time_scraped_date
      value: "1 day ago"
    }
  }
  join: items__tags {
    view_label: "Items: Tags"
    sql: LEFT JOIN UNNEST(${gorillas_v1_items.tags}) as items__tags ;;
    relationship: one_to_many
  }

  join: items__barcodes {
    view_label: "Items: Barcodes"
    sql: LEFT JOIN UNNEST(${gorillas_v1_items.barcodes}) as items__barcodes ;;
    relationship: one_to_many
  }

  join: items__allergen_ids {
    view_label: "Items: Allergenids"
    sql: LEFT JOIN UNNEST(${gorillas_v1_items.allergen_ids}) as items__allergen_ids ;;
    relationship: one_to_many
  }

  join: items__additive_ids {
    view_label: "Items: Additiveids"
    sql: LEFT JOIN UNNEST(${gorillas_v1_items.additive_ids}) as items__additive_ids ;;
    relationship: one_to_many
  }

  join: items__additives {
    view_label: "Items: Additives"
    sql: LEFT JOIN UNNEST(${gorillas_v1_items.additives}) as items__additives ;;
    relationship: one_to_many
  }

  join: items__allergens {
    view_label: "Items: Allergens"
    sql: LEFT JOIN UNNEST(${gorillas_v1_items.allergens}) as items__allergens ;;
    relationship: one_to_many
  }

  join: items__recommendation_tags {
    view_label: "Items: Recommendationtags"
    sql: LEFT JOIN UNNEST(${gorillas_v1_items.recommendation_tags}) as items__recommendation_tags ;;
    relationship: one_to_many
  }

  join: items__customization_items {
    view_label: "Items: Customizationitems"
    sql: LEFT JOIN UNNEST(${gorillas_v1_items.customization_items}) as items__customization_items ;;
    relationship: one_to_many
  }

  join: items__additional_images {
    view_label: "Items: Additionalimages"
    sql: LEFT JOIN UNNEST(${gorillas_v1_items.additional_images}) as items__additional_images ;;
    relationship: one_to_many
  }

  join: items__product_collections {
    view_label: "Items: Productcollections"
    sql: LEFT JOIN UNNEST(${gorillas_v1_items.product_collections}) as items__product_collections ;;
    relationship: one_to_many
  }
  join: gorillas_v1_hubs_master {
    sql_on: ${gorillas_v1_items.hub_code} = ${gorillas_v1_hubs_master.id};;
    relationship: many_to_one
    type: left_outer
  }


}

explore: gorillas_v1_hubs_master{
  hidden:  no
  label: "Gorillas Hubs"
  view_label: "Gorillas Hubs"
  group_label: "08) Competitor Analysis"
  description: "Analysis of competitors."
}

explore: gorillas_v1_orders{
  hidden:  yes
  label: "Gorillas Orders"
  view_label: "Gorillas Orders"
  group_label: "08) Competitor Analysis"
  description: "Analysis of competitors."
}

explore: gorillas_v1_inventory{
  hidden:  yes
  label: "Gorillas Inventory"
  view_label: "Gorillas Inventory"
  group_label: "08) Competitor Analysis"
  description: "Analysis of competitors."

  always_filter: {
    filters: {
      field: time_scraped_date
      value: "1 day ago"
    }
  }

  join: gorillas_v1_hubs_master {
    sql_on: ${gorillas_v1_inventory.hub_code} = ${gorillas_v1_hubs_master.id};;
    relationship: many_to_one
    type: left_outer
  }

  join: gorillas_v1_items {
    sql_on: ${gorillas_v1_inventory.product_id} = ${gorillas_v1_items.id}
      and ${gorillas_v1_inventory.hub_code} = ${gorillas_v1_items.hub_code};;
    relationship: many_to_one
    type: left_outer
  }

  join: gorillas_item_mapping {
    sql_on: ${gorillas_v1_inventory.product_id} = ${gorillas_item_mapping.gorillas_id} ;;
    relationship: many_to_one
    type: left_outer
  }

}

explore: gorillas_item_mapping {
  hidden:  yes
  label: "Gorillas Item Mapping"
  view_label: "Gorillas Item Mapping"
  group_label: "08) Competitor Analysis"
  description: "Analysis of competitors."
}

explore: gorillas_v1_delivery_areas{
  hidden:  no
  label: "Gorillas Delivery Areas"
  view_label: "Gorillas Delivery Areas"
  group_label: "08) Competitor Analysis"
  description: "Analysis of competitors."

  join: gorillas_v1_hubs_master {
    sql_on: ${gorillas_v1_delivery_areas.scraping_hub_name} = ${gorillas_v1_hubs_master.scraping_hub_name};;
    relationship: one_to_many
    type: full_outer
  }
}


explore: gorillas_v1_item_hub_collection_group_allocation{
  hidden:  no
  label: "Gorillas Item Hub Collection Group Allocation"
  view_label: "Gorillas Item Hub Collection Group Allocation"
  group_label: "08) Competitor Analysis"
  description: "Analysis of competitors."

  join: gorillas_v1_hubs_master {
    sql_on: ${gorillas_v1_item_hub_collection_group_allocation.hub_id} = ${gorillas_v1_hubs_master.id};;
    relationship: one_to_many
    type: left_outer
  }

  join: gorillas_v1_items {
    sql_on: ${gorillas_v1_item_hub_collection_group_allocation.item_id} = ${gorillas_v1_items.id}
      and ${gorillas_v1_item_hub_collection_group_allocation.hub_id} = ${gorillas_v1_items.hub_code};;
    relationship: one_to_one
    type: left_outer
  }

  join: gorillas_category_mapping {
    sql_on: ${gorillas_v1_hubs_master.country_iso} = ${gorillas_category_mapping.country_iso}
            and ${gorillas_v1_item_hub_collection_group_allocation.collection_id} = ${gorillas_category_mapping.gorillas_collection_id}
            and ${gorillas_v1_item_hub_collection_group_allocation.group_id} = ${gorillas_category_mapping.gorillas_group_id};;
    relationship: one_to_one
    type: left_outer
  }

}

explore: product_product_competitive_intelligence {
   label: "CI Product Product Adaption"
  view_label: "CI Product Product Adaption"
  group_label: "08) Competitor Analysis"
  description: "Analysis of competitors."
  always_filter: {
    filters:  [
      product_product_competitive_intelligence.is_published: "yes",
    ]
  }

  access_filter: {
    field: product_product_competitive_intelligence.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  join: product_productvariant {
    sql_on: ${product_productvariant.country_iso} = ${product_product_competitive_intelligence.country_iso} AND
      ${product_productvariant.product_id} = ${product_product_competitive_intelligence.id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: product_category {
    sql_on: ${product_category.country_iso} = ${product_product_competitive_intelligence.country_iso} AND
      ${product_category.id} = ${product_product_competitive_intelligence.category_id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: product_producttype {
    sql_on: ${product_product_competitive_intelligence.country_iso} = ${product_product_competitive_intelligence.country_iso} AND
      ${product_product_competitive_intelligence.product_type_id} = ${product_producttype.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: parent_category {
    view_label: "* Product / SKU Parent Category Data *"
    from: product_category
    sql_on: ${product_category.country_iso} = ${parent_category.country_iso} AND
      ${product_category.parent_id} = ${parent_category.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: warehouse_stock {
    type: left_outer
    relationship: one_to_many
    sql_on: ${warehouse_stock.country_iso} = ${product_productvariant.country_iso} AND
      ${warehouse_stock.product_variant_id} = ${product_productvariant.id} ;;
  }

  join: warehouse_warehouse {
    type: left_outer
    relationship: one_to_one
    sql_on: ${warehouse_warehouse.country_iso} = ${warehouse_stock.country_iso} AND
      ${warehouse_warehouse.id} = ${warehouse_stock.warehouse_id} ;;
  }

  join: hubs {
    view_label: "* Hubs *"
    sql_on: ${warehouse_warehouse.country_iso} = ${hubs.country_iso} AND
      ${warehouse_warehouse.slug} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: product_attribute_facts {
    sql_on: ${product_product_competitive_intelligence.country_iso} = ${product_attribute_facts.country_iso} AND
      ${product_product_competitive_intelligence.id} = ${product_attribute_facts.id} ;;
    relationship: one_to_one
    type: left_outer
    fields: [
      country_iso,
      id,
      sku,
      leading_product,
      noos_group,
      substitute_group,
      substitute_group_internal_ranking,
      ean
    ]
  }
}


explore: flink_skus_per_category {
  hidden:  no
  label: "Flink SKUs per Category"
  view_label: "Flink SKUs per Category"
  group_label: "08) Competitor Analysis"
  description: "Analysis of competitors."

  join: gorillas_category_mapping {
    sql_on: ${flink_skus_per_category.country_iso} = ${gorillas_category_mapping.country_iso}
            and ${flink_skus_per_category.parent_id} = ${gorillas_category_mapping.parent_category_id}
            and ${flink_skus_per_category.category_id} = ${gorillas_category_mapping.category_id};;
    relationship: many_to_one
    type: left_outer
  }

  join: gorillas_v1_item_hub_collection_group_allocation {
    sql_on:  ${flink_skus_per_category.country_iso} = ${gorillas_v1_item_hub_collection_group_allocation.country_iso}
            and ${gorillas_category_mapping.gorillas_collection_id} = ${gorillas_v1_item_hub_collection_group_allocation.collection_id}
            and ${gorillas_category_mapping.gorillas_group_id} = ${gorillas_v1_item_hub_collection_group_allocation.group_id};;
    relationship: many_to_one
    type: left_outer
  }

  join: gorillas_v1_items {
    sql_on: ${gorillas_v1_item_hub_collection_group_allocation.item_id} = ${gorillas_v1_items.id}
      and ${gorillas_v1_item_hub_collection_group_allocation.hub_id} = ${gorillas_v1_items.hub_code};;
    relationship: many_to_one
    type: left_outer
  }

}




explore: riders_forecast_staffing {
  label: "Orders and Riders Forecasting"
  view_label: "Orders and Riders Forecasting"
  group_label: "09) Forecasting"
  description: "This explore allows to check the riders and orders forecast for the upcoming 7 days"

  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  join: hubs {
    sql_on:
    ${riders_forecast_staffing.hub_name} = ${hubs.hub_code_lowercase} ;;
    relationship: many_to_one
    type: left_outer
  }

}


explore: marketing_performance {
  label: "Marketing Performance"
  view_label: "Marketing Performance"
  group_label: "11) Marketing"
  description: "Marketing Performance: Installs, Orders, CAC, CPI"
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
########### CRM EXPLORE ###########


explore: braze_crm_data {
  label: "CRM Email Data (Braze)"
  view_label: "CRM Email Data"
  group_label: "11) Marketing"
  description: "Information on our CRM activities (using Braze as service provider)"
  always_filter: {
    filters:  [
      braze_crm_data.campaign_name: "",
      braze_crm_data.country: "",
      braze_crm_data.email_sent_at: "after 2021-04-01"
    ]
  }
}

########### HUB NPS EXPLORE ###########


explore: nps_hub_team {
  label: "NPS (Hub Teams)"
  view_label: "NPS (Hub Teams)"
  group_label: "12) NPS (Internal Teams)"
  description: "NPS surveys towards internal teams"

  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

  join: hubs {
    sql_on:
    ${nps_hub_team.hub_code} = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

}


########### AD-HOC EXPLORE ###########

explore: products_mba {
  label: "Market basket analysis at a product level"
  view_label: "Product MBA"
  group_label: "15) Ad-Hoc"
  description: "Product basket analysis"

}

explore: categories_mba {
  label: "Market basket analysis at a category level"
  view_label: "Category MBA"
  group_label: "15) Ad-Hoc"
  description: "Product category basket analysis"

}

explore: voucher_retention {
  label: "Voucher retention"
  view_label: "Voucher retention"
  group_label: "15) Ad-Hoc"
  description: "Voucher retention analysis - First voucher used by user is considered as the base. Thus, a user can only have a first used voucher."

  access_filter: {
    field: voucher_retention.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: voucher_retention.city
    user_attribute: city
  }
}

explore: user_order_facts_v2 {
  label: "User Order Facts - Unique User ID"
  view_label: "User Order Facts - Unique User ID"
  group_label: "15) Ad-Hoc"
  description: "User Order facts with phone number + last name as unique identifier"

  join: hubs {
    view_label: "* Hubs *"
    sql_on: ${user_order_facts_v2.country_iso} = ${hubs.country_iso} AND
      ${user_order_facts_v2.hub_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
  }

}

explore: retail_kpis {
  label: "SKU Analytics"
  group_label: "15) Ad-Hoc"
  hidden: yes
}
