include: "/explores/base_explores/orders_cl.explore"

explore: orders_cl_updated_hourly {
  extends: [orders_cl]
  persist_with: flink_hourly_datagroup
  hidden: yes
}
