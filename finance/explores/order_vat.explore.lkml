include: "/*/**/vat_order.view.lkml"
include: "/*/**/orders.view.lkml"
include: "/*/**/shyftplan_riders_pickers_hours_clean.view.lkml"
include: "/*/**/employee_level_kpis.view.lkml"


explore: vat_order {
  hidden: no
  view_name:  vat_order
  label: "VAT on Order Level"
  view_label: "VAT on Order Level"
  group_label: "Finance"
  description: "Provides VAT data on order level"

  access_filter: {
    field: vat_order.country_iso
    user_attribute: country_iso
  }

  join: orders {
    view_label: "Orders"
    sql_on: ${orders.order_uuid} = ${vat_order.order_uuid} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    from: shyftplan_riders_pickers_hours_clean
    view_label: ""
    sql_on: ${orders.created_date} = ${shyftplan_riders_pickers_hours.shift_date} ;;
    relationship: many_to_many
    type: left_outer
  }

  join: employee_level_kpis {
    from: employee_level_kpis
    view_label: ""
    sql_on: ${orders.created_date} = ${employee_level_kpis.shift_date} ;;
    relationship: many_to_many
    type: left_outer
  }



  always_filter: {
    filters: [
      vat_order.order_date: "",
      vat_order.is_successful_order: "yes",
      vat_order.country_iso: ""
    ]
  }
}
