# If necessary, uncomment the line below to include explore_source.
# include: "supply_chain.explore.lkml"

view: last_hour_inventory_level {
  derived_table: {
    explore_source: supply_chain {
      column: report_timestamp_date { field: inventory_hourly.report_timestamp_date }
      column: report_timestamp_time { field: inventory_hourly.report_timestamp_time }
      column: sku { field: lexbizz_item.sku }
      column: hub_code { field: hubs_ct.hub_code }
      column: avg_inventory { field: inventory_hourly.avg_inventory }
      column: avg_quantity_from { field: inventory_hourly.avg_quantity_from }
      column: avg_quantity_to { field: inventory_hourly.avg_quantity_to }
      bind_all_filters: yes
    }
  }
  dimension: report_timestamp_date {
    label: "03 Inventory Hourly (last 8 days) Inventory Report Date"
    description: ""
    hidden: yes
    type: date
  }
  dimension: report_timestamp_time {
    label: "03 Inventory Hourly (last 8 days) Inventory Report Time"
    description: ""
    hidden: yes
    type: date_time
  }
  dimension: sku {
    label: "* Products (ERP) * SKU"
    hidden: yes
    description: ""
  }
  dimension: hub_code {
    label: "* Hubs * Hub Code"
    hidden: yes
    description: ""
  }
  dimension: avg_inventory {
    label: "03 Inventory Hourly (last 8 days) AVG Inventory Level"
    description: "The average stock level, based on averaged starting and ending inventory level per day and hub"
    value_format: "#,##0.0"
    hidden: yes
    type: number
  }
  dimension: avg_quantity_from {
    label: "03 Inventory Hourly (last 8 days) AVG Quantity From"
    description: "The average inventory quantity at the start of every hour"
    value_format: "#,##0.0"
    hidden: yes
    type: number
  }
  dimension: avg_quantity_to {
    label: "# Last Inventory Level"
    group_label: "Inventory Change"
    description: ""
    value_format: "#,##0.0"
    hidden: no
    type: number
  }

  dimension: table_uuid {
    hidden: yes
    primary_key: yes
    sql: concat(${report_timestamp_time},${sku},${hub_code}) ;;
  }

  dimension: time {
    type: number
    hidden: yes
    sql: extract (hour from cast(${report_timestamp_time}as datetime)) ;;
  }


}
