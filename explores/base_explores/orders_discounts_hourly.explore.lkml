
include: "/explores/base_explores/orders_discounts.explore"


explore: orders_discounts_hourly {
  extends: [orders_discounts]
  hidden: yes
  persist_with: flink_hourly_datagroup
}
