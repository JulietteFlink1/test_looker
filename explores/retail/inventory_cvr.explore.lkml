include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"


explore: inventory_cvr {
  from: inventory_stock_count_hourly
  view_name: inventory_stock_count_hourly
  group_label: "16) Retail Test"
  view_label: "* # SKUs & CVR *"
  label: "# SKUs & CVR"
  hidden: no

  always_filter: {
    filters: [
      inventory_stock_count_hourly.inventory_tracking_timestamp_date: "5 days"
    ]
  }


  join: cvr {
    sql_on: CAST(${cvr.session_start_at_week} AS DATE) = CAST(${inventory_stock_count_hourly.inventory_tracking_timestamp_week} as DATE)
            AND ${cvr.country} = ${inventory_stock_count_hourly.country_iso}
            ;;
    relationship: many_to_one
    type: left_outer
  }
}
