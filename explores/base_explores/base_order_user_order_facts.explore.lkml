include: "/cleaning/order_base.view.lkml"
include: "/cleaning/user_order_facts_clean.view.lkml"
include: "/explores/base_explores/base_orders.explore"
include: "/views/sql_derived_tables/hub_order_facts.view.lkml"

explore: base_order_user_order_facts {
  #group_label: "01) Performance"
  #label: "User Order Facts Clean"
  description: "This is the clean version of user order facts"
  extension: required
  extends: [base_orders]
  #view_label: "User Order Facts Clean"
  # The additional things you want to add or change
  # in the new Explore
  join: user_order_facts_clean {
    sql_on: ${base_orders.country_iso} = ${user_order_facts_clean.country_iso} and
      ${base_orders.user_email} = ${user_order_facts_clean.user_email};;
    type: left_outer
    relationship: many_to_one
  }

  join: hub_order_facts {
    sql_on: ${base_orders.country_iso} = ${hub_order_facts.country_iso} AND
      ${base_orders.warehouse_name} = ${hub_order_facts.warehouse_name}  ;;
      type: left_outer
      relationship: many_to_one
  }

  join: first_order_facts {
    view_label: "* Cohorts - First Order Facts *"
    type: inner
    from: order_base
    relationship: one_to_one
    sql_on: ${user_order_facts_clean.country_iso} = ${first_order_facts.country_iso} AND
      ${user_order_facts_clean.first_order_id} = ${first_order_facts.id} ;;
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
    from: order_base
    relationship: one_to_one
    sql_on: ${user_order_facts_clean.country_iso} = ${latest_order_facts.country_iso} AND
      ${user_order_facts_clean.latest_order_id} = ${latest_order_facts.id} ;;
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
    sql_on: ${base_orders.country_iso} = ${user_order_rank.country_iso} AND
      ${base_orders.id} = ${user_order_rank.id};;
    relationship: one_to_one
    type: left_outer
    fields:
    [
      user_order_rank.user_order_rank
    ]
  }

  join: weekly_cohorts_base {
    view_label: "Cohorts - Weekly"
    sql_on: ${user_order_facts_clean.country_iso} = ${weekly_cohorts_base.country_iso} AND
      ${user_order_facts_clean.first_order_week} = ${weekly_cohorts_base.first_order_week};;
    relationship: one_to_one
    type: left_outer
  }

  join: monthly_cohorts_base {
    view_label: "Cohorts - Monthly"
    sql_on: ${user_order_facts_clean.country_iso} = ${monthly_cohorts_base.country_iso} AND
      ${user_order_facts_clean.first_order_month} = ${monthly_cohorts_base.first_order_month} ;;
    relationship: one_to_one
    type: left_outer
  }
}
