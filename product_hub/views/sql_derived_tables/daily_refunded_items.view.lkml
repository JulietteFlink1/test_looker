# If necessary, uncomment the line below to include explore_source.
# include: "daily_hub_staff_events.explore.lkml"

view: daily_refunded_items {
  derived_table: {
    explore_source: daily_hub_staff_events {
      column: event_timestamp_date {}
      column: hub_code {}
      column: product_sku { field: event_order_progressed.product_sku }
      column: sum_quantity_refunded { field: event_order_progressed.sum_quantity_refunded }
      column: sum_of_quantity { field: event_order_progressed.sum_of_quantity }
      filters: {
        field: global_filters_and_parameters.datasource_filter
        value: "7 days"
      }
      filters: {
        field: event_order_progressed.sum_quantity_refunded
        value: ">0"
      }
    }
  }

  dimension: primary_key {
    hidden: yes
    sql: concat(${event_timestamp_date}, ${hub_code}, ${product_sku}) ;;
  }

  dimension: event_timestamp_date {
    label: "1 Daily Hub Staff Events Event Date"
    description: "Timestamp of when an event happened"
    type: date
  }
  dimension: hub_code {
    label: "1 Daily Hub Staff Events Hub Code"
    description: "Code of a hub identical to back-end source tables."
  }
  dimension: product_sku {
    label: "2 Event: Order Progressed Product SKU"
    description: "The sku of the product, as available in the backend."
  }
  dimension: sum_quantity_refunded {
    label: "2 Event: Order Progressed Quantity Refunded"
    description: "Sum of quantity refunded."
    type: number
  }
  dimension: sum_of_quantity {
    label: "2 Event: Order Progressed Quantity Picked and Refunded"
    description: "Sum of quantity if item is picked or refunded."
    type: number
  }
}
