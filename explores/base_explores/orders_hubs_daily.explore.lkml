include: "/explores/base_explores/orders_cl.explore"
include: "/views/sql_derived_tables/bottom_10_hubs.view"

explore: orders_hubs_daily {
  extends: [orders_cl]
  description: "Bottom 10 frequency for issue rate and order delivered in time"
  hidden: yes


  join: bottom_10_hubs {
    from:  botton_10_hubs
    view_label: "* Bottom 10 Hubs *"
    sql_on: lower(${orders_cl.hub_code}) = lower(${bottom_10_hubs.hub_code}) AND
          lower(${orders_cl.country_iso}) = lower(${bottom_10_hubs.country_iso}) AND
          ${orders_cl.date} = ${bottom_10_hubs.order_date};;
    relationship: many_to_one
    type: left_outer
  }

}
