# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-08-31

view: picking_times {
  derived_table: {
    explore_source: daily_hub_staff_events {
      column: order_id { field: event_order_state_updated.order_id }
      column: order_picked_time { field: event_order_state_updated.order_picked_time }
      column: order_packed_time { field: event_order_state_updated.order_packed_time }
      column: packed_to_picked_seconds { field: event_order_state_updated.packed_to_picked_seconds }
      column: event_timestamp_date {}
      bind_all_filters: yes
    }
  }
  dimension: order_id {
    primary_key: yes
    hidden: yes
    label: "Order ID"
    description: "A unique identifier generated by back-end when an order is placed."
  }
  dimension: order_picked_time {
    label: "Order Picked Time"
    description: "Timestamp for when the order changed to picked."
    type: number
  }
  dimension: order_packed_time {
    label: "Order Packed Time"
    description: "Timestamp for when the order changed to packed."
    type: number
  }
  dimension: packed_to_picked_seconds {
    label: "Packed to Picked Seconds"
    description: "Difference in seconds between packed and picked timestamps."
    type: number
  }
  dimension: event_timestamp_date {
    hidden: yes
    label: "Event Date"
    description: "Timestamp of when an event happened"
    type: date
  }
}
