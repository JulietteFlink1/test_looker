
include: "/explores/base_explores/*.explore"

explore: current_inventory_updated_hourly {
  extends: [current_inventory]
  group_label: "02) Inventory"
  # view_label: "Current Inventory - Updated Hourly"
  label: "Products & Inventory (Updated Hourly)"

  hidden: yes
  persist_with: flink_hourly_datagroup

}
