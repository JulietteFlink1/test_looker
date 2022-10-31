include: "/*/**/vat_order.view.lkml"
include: "/*/**/orders.view.lkml"
include: "/*/**/shyftplan_riders_pickers_hours_clean.view.lkml"
include: "/*/**/employee_level_kpis.view.lkml"
include: "/*/**/discounts.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"


explore: vat_order {


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    BASE TABLE
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  hidden: no
  view_name:  vat_order
  label: "VAT on Order Level"
  view_label: "VAT on Order Level"
  group_label: "Finance"
  description: "Provides VAT data on order level"


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    FILTER & SETTINGS
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  access_filter: {
    field: vat_order.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      vat_order.is_successful_order: "yes",
      vat_order.country_iso: ""

    ]
  }

  sql_always_where:
  -- filter the time for all big tables of this explore
  {% condition global_filters_and_parameters.datasource_filter %} ${vat_order.order_date} {% endcondition %}
;;

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    JOINED TABLES
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  join: orders {
    view_label: "Orders"
    sql_on: ${orders.order_uuid} = ${vat_order.order_uuid}
    and {% condition global_filters_and_parameters.datasource_filter %} ${orders.created_date} {% endcondition %};;
    relationship: one_to_one
    type: left_outer
  }


  join: discounts {
    sql_on:
        -- For T1 the discount id is null and we join only on the discount code.
        ${orders.discount_code} = ${discounts.discount_code}
        and coalesce(${orders.voucher_id},'') = coalesce(${discounts.discount_id},'')
    ;;
    type: left_outer
    relationship: many_to_one
    fields: [discounts.use_case]
  }

}
