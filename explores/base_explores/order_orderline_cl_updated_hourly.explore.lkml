include: "/explores/base_explores/order_orderline_cl.explore"

explore: order_orderline_cl_updated_hourly {
  extends: [order_orderline_cl]

  persist_with: flink_hourly_datagroup
  hidden: yes
}
