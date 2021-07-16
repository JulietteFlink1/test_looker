# view: gorillas_v1_orders_wow {
#     derived_table: {
#           explore_source: gorillas_v1_orders {

#             column: orders_date {}
#             column: sum_orders {}
#           }
#         }
#         dimension: label {
#           label: "Gorillas Orders Label"
#         }
#         dimension: orders_date {
#           label: "Gorillas V1 Orders Wow Date Last Week Date"
#           type: date
#         }
#         dimension: orders_last_week {
#           label: "Gorillas V1 Orders Wow Orders Last Week TEST"
#         }
#         dimension: orders_date {
#           label: "Gorillas Orders Orders Date"
#           type: date
#         }
#         dimension: sum_orders {
#           label: "Gorillas Orders Sum Orders"
#           type: number
#         }
#       }



#   dimension_group: orders {
#     label : "Date Last Week"
#     type: time
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     datatype: date
#     sql: ${TABLE}.orders_date ;;
#   }



#   dimension: id {
#       label: "Gorillas Hub ID"
#     }

#   dimension: orders_last_week {
#       label: "Orders Last Week TEST"
#     sql: ${TABLE}.orders_last_week ;;
#     }

#   measure: sum_orders_last_week {
#     type: sum
#     label: "Sum Orders Last Week"
#     sql: ${orders_last_week} ;;

#   }


# # LIMIT 1000
#   }
# # WHERE DATE(o.orders_date, 'Europe/Berlin') = "2021-07-07"
