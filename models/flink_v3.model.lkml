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

####### ORDER EXPLORE #######
explore: order_order {
  label: "Orders"
  view_label: "Orders"
  group_label: "1) Performance"
  description: "General Business Performance - Orders, Revenue, etc."
  always_filter: {
    filters:  [
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
    view_label: "Users"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_order.country_iso} = ${user_order_facts.country_iso} AND
            ${order_order.user_email} = ${user_order_facts.user_email} ;;
  }

  join: hub_order_facts {
    view_label: "Hubs"
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
    from: account_address
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_order.country_iso} = ${shipping_address.country_iso} AND
            ${order_order.shipping_address_id} = ${shipping_address.id} ;;
  }

  join: billing_address {
    from: account_address
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_order.country_iso} = ${billing_address.country_iso} AND
            ${order_order.billing_address_id} = ${billing_address.id} ;;
  }

  join: first_order_facts {
    view_label: "First Order Facts"
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
    view_label: "First Order Facts"
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
    view_label: "First Order Facts"
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
    view_label: "First Order Facts"
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
    view_label: "Latest Order Facts"
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
    view_label: "Orders"
    sql_on: ${order_order.country_iso} = ${user_order_rank.country_iso} AND
            ${order_order.id} = ${user_order_rank.id};;
    relationship: one_to_one
    type: left_outer
    fields:
    [
      user_order_rank.user_order_rank
    ]
  }

  join: weekly_cohorts_stable_base {
    view_label: "Cohorts - Weekly"
    sql_on: ${user_order_facts.country_iso} = ${weekly_cohorts_stable_base.country_iso} AND
            ${user_order_facts.first_order_week} = ${weekly_cohorts_stable_base.first_order_week};;
    relationship: one_to_one
    type: left_outer
  }

  join: monthly_cohorts_stable_base {
    view_label: "Cohorts - Monthly"
    sql_on: ${user_order_facts.country_iso} = ${monthly_cohorts_stable_base.country_iso} AND
            ${user_order_facts.first_order_month} = ${monthly_cohorts_stable_base.first_order_month} ;;
    relationship: one_to_one
    type: left_outer
  }


  join: hubs {
    view_label: "Hubs"
    sql_on: ${order_order.country_iso} = ${hubs.country_iso} AND
            ${order_order.warehouse_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
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
    from: product_category
    sql_on: ${product_category.country_iso} = ${parent_category.country_iso} AND
            ${product_category.parent_id} = ${parent_category.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: cs_issues_post_delivery {
    sql_on: ${order_order.country_iso} = ${cs_issues_post_delivery.country_iso} and
            ${order_order.id} = ${cs_issues_post_delivery.order_nr__} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: nps_after_order {
    view_label: "NPS After Order"
    sql_on: ${order_order.country_iso} = ${nps_after_order.country_iso} AND
            ${order_order.id} = ${nps_after_order.order_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    view_label: "Shifts"
    sql_on: ${order_order.created_date} = ${shyftplan_riders_pickers_hours.date} and
            ${hubs.hub_code} = ${shyftplan_riders_pickers_hours.hub_name};;
    relationship: many_to_one
    type: left_outer
  }

  join: payment_payment {
    view_label: "Payments"
    sql_on: ${order_order.country_iso} = ${payment_payment.country_iso} and
            ${order_order.id} = ${payment_payment.order_id};;
    relationship: one_to_many
    type: left_outer
  }

  join: payment_transaction {
    view_label: "Payments"
    sql_on: ${payment_payment.country_iso} = ${payment_transaction.country_iso} and
            ${payment_payment.id} = ${payment_transaction.payment_id};;
    relationship: one_to_many
    type: left_outer
  }

  join: gdpr_account_deletion {
    view_label: "Users"
    sql_on: LOWER(${order_order.user_email}) = LOWER(${gdpr_account_deletion.email});;
    relationship: many_to_one
    type: left_outer
  }

}

####### PRODUCTS EXPLORE #######
explore: product_product {
  label: " Products"
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
    view_label: "Hubs"
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
  }
}

####### NOOS EXPLORE #######
explore: hist_daily_stock {
  label: "NooS Substitute Groups"
  view_label: "NooS Substitute Groups"
  group_label: "2) Inventory"
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
    view_label: "Hubs"
    sql_on: ${hist_daily_stock.slug} = ${hubs.hub_code_lowercase} ;;
    relationship: many_to_one
    type: left_outer
  }
}

####### VOUCHER EXPLORE #######
explore: discount_voucher {
  label: "Vouchers"
  view_label: "Vouchers"
  group_label: "3) Vouchers"
  description: "All data around Vouchers created in the backend"

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
    view_label: "Users"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_order.country_iso} = ${user_order_facts.country_iso} AND
            ${order_order.user_email} = ${user_order_facts.user_email} ;;
  }

  join: hub_order_facts {
    view_label: "Hubs"
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
    view_label: "Hubs"
    sql_on: ${order_order.country_iso} = ${hubs.country_iso} AND
            ${order_order.warehouse_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    view_label: "Shifts"
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
  group_label: "4) Survey Data"
  description: "Customer Survey on Desired Products"

}

####### ADJUST EXPLORE #######
explore: adjust_sessions {
  label: "Adjust app data"
  view_label: "Adjust sessions"
  group_label: "6) Adjust app data"
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
  group_label: "6) Adjust app data"
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
explore: marketingbanners_mobile_events {
  label: "Marketing banner impressions"
  view_label: "Marketing banner impressions"
  group_label: "9) In-app tracking data"
  description: "Marketing banner events"
}

####### CS ISSUES EXPLORE #######
explore: cs_issues_post_delivery {
  label: "CS Contacts"
  view_label: "CS Contacts"
  group_label: "7) Customer Service"
  description: "Customer Service Contacts tracked via GSheet"

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
    view_label: "Users"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_order.country_iso} = ${user_order_facts.country_iso} AND
            ${order_order.user_email} = ${user_order_facts.user_email} ;;
  }

  join: hub_order_facts {
    view_label: "Hubs"
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
    view_label: "Hubs"
    sql_on: ${order_order.country_iso} = ${hubs.country_iso} AND
            ${order_order.warehouse_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    view_label: "Hub shifts"
    sql_on: ${order_order.created_date} = ${shyftplan_riders_pickers_hours.date} and
            ${hubs.hub_code} = ${shyftplan_riders_pickers_hours.hub_name};;
    relationship: many_to_one
    type: left_outer
  }
}

########### ISSUE-RATES ##############


explore: issue_rate {
  label: "Issue Rate / Post Delivery Issues"
  view_label: "Issue Rate / Post Delivery Issues"
  group_label: "7) Customer Service"
  description: "Daily issue rates per hub using CS Gsheet and total orders per hub"

  access_filter: {
    field: issue_rate.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: issue_rate.city
    user_attribute: city
  }
}


########### AD-HOC EXPLORE ###########

explore: products_mba {
  label: "Market basket analysis at a product level"
  view_label: "Product MBA"
  group_label: "7) Ad-Hoc"
  description: "Product basket analysis"

}

explore: categories_mba {
  label: "Market basket analysis at a category level"
  view_label: "Category MBA"
  group_label: "7) Ad-Hoc"
  description: "Product category basket analysis"

}

explore: voucher_retention {
  label: "Voucher retention"
  view_label: "Voucher retention"
  group_label: "7) Ad-Hoc"
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

####### Competitor Analysis #######
explore: competitor_analysis {
  label: "Competitor Analysis"
  view_label: "Competitor Analysis"
  group_label: "8) Competitor Analysis"
  description: "Analysis of competitors."
  always_filter: {
    filters: {
      field: time_scraped_date
      value: "1 day ago"
    }
  }

  join: gorillas_stores {
    sql_on: ${competitor_analysis.gorillas_hub_code} = ${gorillas_stores.id};;
    relationship: many_to_one
    type: left_outer
  }


}

explore: gorillas_stores {
  label: "Gorillas Stores"
  view_label: "Gorillas Stores"
  group_label: "8) Competitor Analysis"
  description: "Store Locations of Gorillas"
}



# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: gorillas_items {
  label: "Gorillas Items Overview"
  view_label: "Gorillas Items Overview"
  group_label: "8) Competitor Analysis"
  description: "Current Gorillas Items"
  always_filter: {
    filters: [gorillas_items.time_scraped_date: "1 day ago"]
  }



  join: gorillas_items__tags {
    view_label: "Gorillas Items: Tags"
    sql: LEFT JOIN UNNEST(${gorillas_items.tags}) as gorillas_items__tags ;;
    relationship: one_to_many
  }

  join: gorillas_items__barcodes {
    view_label: "Gorillas Items: Barcodes"
    sql: LEFT JOIN UNNEST(${gorillas_items.barcodes}) as gorillas_items__barcodes ;;
    relationship: one_to_many
  }

  join: gorillas_items__additives {
    view_label: "Gorillas Items: Additives"
    sql: LEFT JOIN UNNEST(${gorillas_items.additives}) as gorillas_items__additives ;;
    relationship: one_to_many
  }

  join: gorillas_items__allergens {
    view_label: "Gorillas Items: Allergens"
    sql: LEFT JOIN UNNEST(${gorillas_items.allergens}) as gorillas_items__allergens ;;
    relationship: one_to_many
  }

  join: gorillas_items__recommendation_tags {
    view_label: "Gorillas Items: Recommendationtags"
    sql: LEFT JOIN UNNEST(${gorillas_items.recommendation_tags}) as gorillas_items__recommendation_tags ;;
    relationship: one_to_many
  }

  join: gorillas_items__customization_items {
    view_label: "Gorillas Items: Customizationitems"
    sql: LEFT JOIN UNNEST(${gorillas_items.customization_items}) as gorillas_items__customization_items ;;
    relationship: one_to_many
  }

  join: gorillas_items__additional_images {
    view_label: "Gorillas Items: Additionalimages"
    sql: LEFT JOIN UNNEST(${gorillas_items.additional_images}) as gorillas_items__additional_images ;;
    relationship: one_to_many
  }

  join: gorillas_items__product_collections {
    view_label: "Gorillas Items: Productcollections"
    sql: LEFT JOIN UNNEST(${gorillas_items.product_collections}) as gorillas_items__product_collections ;;
    relationship: one_to_many
  }

  join: gorillas_stores {
    sql_on: ${gorillas_items.hub_code} = ${gorillas_stores.id};;
    relationship: one_to_many
    type: left_outer
  }

  join: category_matching {
    sql_on: ${gorillas_items.category} = ${category_matching.gorillas_category_name};;
    relationship: one_to_many
    type: left_outer
  }
}

explore: gorillas_current_assortment {
  label: "Gorillas Assortment Overview"
  view_label: "Gorillas Assortment Overview"
  group_label: "8) Competitor Analysis"
  description: "Current Gorillas Assortment"
  always_filter: {
    filters: [gorillas_current_assortment.time_scraped_date: "1 day ago"]
  }
  hidden: yes


  join: gorillas_stores {
    sql_on: ${gorillas_current_assortment.hub_code} = ${gorillas_stores.id};;
    relationship: one_to_many
    type: left_outer
  }

  join: category_matching {
    sql_on: ${gorillas_current_assortment.category} = ${category_matching.gorillas_category_name};;
    relationship: one_to_many
    type: left_outer
  }
}





explore: gorillas_turfs {
  label: "Gorillas Turfs"
  view_label: "Gorillas Turfs"
  group_label: "8) Competitor Analysis"
  description: "Current Gorillas Turfs"
  # sql_always_where: ${time_scraped_raw} = '2021-04-25 16:35:41.402 UTC';;
  always_filter: {
    filters: {
      field: time_scraped_date
      value: "1 day ago"
    }
  }

  join: gorillas_turfs__points {
    view_label: "Gorillas Turfs: Points"
    sql: LEFT JOIN UNNEST(${gorillas_turfs.points}) as gorillas_turfs__points ;;
    relationship: one_to_many
  }

  join: gorillas_turfs__gorillas_store_ids {
    view_label: "Gorillas Turfs: Gorillas Store Ids"
    sql: LEFT JOIN UNNEST(${gorillas_turfs.gorillas_store_ids}) as gorillas_turfs__gorillas_store_ids ;;
    relationship: one_to_many
  }

  join: gorillas_stores {
    view_label: "Gorillas Turfs: Gorillas Store Ids"
    sql_on:  ${gorillas_turfs__gorillas_store_ids.gorillas_turfs__gorillas_store_ids} = ${gorillas_stores.id} ;;
    relationship: one_to_many
  }
}

# explore: hist_avg_items_per_category_comparison{
#   label: "Items per Category Provider Comparison"
#   view_label: "Items per Category Provider Comparison"
#   group_label: "8) Competitor Analysis"
#   description: "Items per Category Provider Comparison"

# }

# date_time_scraped

explore: comparison_current_ids_per_category {
  label: "Current Items per Category Provider Comparison"
  view_label: "Current Items per Category Provider Comparison"
  group_label: "8) Competitor Analysis"
  description: "Current Items per Category Provider Comparison"
  always_filter: {
    filters: {
      field: time_scraped_date
      value: "1 day ago"
    }
  }
}

explore: gorillas_test{
  label: "Gorillas Test"
  view_label: "Gorillas Test"
  group_label: "8) Competitor Analysis"
  description: "Current Gorillas Assortment"
  hidden: yes
  always_filter: {
    filters: {
      field: time_scraped_date
      value: "today"
    }
    filters: {
      field: assortment_time_scraped_date
      value: "1 day ago"
    }
  }

  join: gorillas_stores {
    sql_on: ${gorillas_test.hub_code} = ${gorillas_stores.id};;
    relationship: many_to_one
    type: left_outer
  }

  join: gorillas_items {
    sql_on: ${gorillas_test.product_id} = ${gorillas_items.id} and ${gorillas_test.hub_code} = ${gorillas_items.hub_code};;
    type: left_outer
    relationship: many_to_one
  }

  # join: gorillas_turfs {
  #   sql_on: ${gorillas_test.hub_code} = ${gorillas_turfs.gorillas_store_ids} ;;
  #   type: left_outer
  #   relationship: many_to_one
  # }
}

explore: gorillas_items_hist{
  label: "Gorillas Items Added/ Removed"
  view_label: "Gorillas Items Added/ Removed"
  group_label: "8) Competitor Analysis"
  description: "Gorillas Items Added/ Removed"

  join: gorillas_stores {
    sql_on: ${gorillas_items_hist.hub_code} = ${gorillas_stores.id};;
    relationship: many_to_one
    type: left_outer
  }

  join: gorillas_items {
    sql_on: ${gorillas_items_hist.id} = ${gorillas_items.id} and ${gorillas_items_hist.hub_code} = ${gorillas_items.hub_code};;
    type: left_outer
    relationship: many_to_one
  }

  join: gorillas_turfs {
    sql_on: ${gorillas_items_hist.hub_code} = ${gorillas_turfs.gorillas_store_ids} ;;
    type: left_outer
    relationship: many_to_one
  }
}

################ Rider Stuffing

explore: riders_forecast_stuffing {
  label: "Orders and Riders Forecasting"
  view_label: "Orders and Riders Forecasting"
  group_label: "9) Forecasting"
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
    ${riders_forecast_stuffing.hub_name} = ${hubs.hub_code_lowercase} ;;
    relationship: many_to_one
    type: left_outer
  }

}

explore: riders_forecast_staffing_v2 {
  label: "Orders and Riders Forecasting V2"
  view_label: "Orders and Riders Forecasting V2"
  group_label: "9) Forecasting"
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
    ${riders_forecast_staffing_v2.hub_name} = ${hubs.hub_code_lowercase} ;;
    relationship: many_to_one
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
