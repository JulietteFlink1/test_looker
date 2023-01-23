# author: Victor Breda
# created date: 2023-01-23
# description: this file defines some metrics specfic to the hub_closures_reporting Explore, that are cross-referencing different tables

view: cr__hub_closure_reporting {

  measure: share_missed_orders_per_non_external_orders_daily {
    label: "% Missed orders (Daily)"
    description: "# Missed Orders / (# Missed Orders + # Succesful Non External Orders)"
    type: number
    sql: safe_divide(${hub_turf_closures_daily.sum_number_of_missed_orders_forced_closure},
      (${orders.number_of_succesful_non_external_orders} + ${hub_turf_closures_daily.sum_number_of_missed_orders_forced_closure}));;
    value_format_name: percent_1
  }

  measure: share_missed_orders_per_non_external_orders_30min {
    label: "% Missed orders (30min)"
    description: "# Missed Orders / (# Missed Orders + # Succesful Non External Orders)"
    type: number
    sql: safe_divide(${hub_turf_closures_30min.sum_number_of_missed_orders_forced_closure},
      (${orders.number_of_succesful_non_external_orders} + ${hub_turf_closures_30min.sum_number_of_missed_orders_forced_closure}));;
    value_format_name: percent_1
  }

}
