# Owner: Andreas Stueber
# Created At: 2023-02-23
# Purpose: Get visibility on supplier-delivered-at-hub events

view: supplier_deliveries_received_at_hub {
  sql_table_name: `flink-data-prod.curated.supplier_deliveries_received_at_hub`
    ;;

  dimension: country_iso {
    label: "Country ISO"
    description: "Country ISO based on 'hub_code'."
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    label: "Hub Code"
    description: "Code of a hub identical to back-end source tables."
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: purchase_order_id {
    label: "Purchase Order ID"
    description: "Identifier of a purchase order. A purchase order is a document, that is sent to a supplier and indicates, which products Flink wants to buy."
    type: string
    sql: ${TABLE}.purchase_order_id ;;
  }

  dimension: supplier_parent_id {
    label: "Supplier ID"
    description: "Parent supplier ID as defined in Oracle - which groups every Child Supplier ID and its related supplier-location"
    type: string
    sql: ${TABLE}.supplier_parent_id ;;
  }

  dimension: supplier_parent_name {
    label: "Supplier Name"
    description: "The name of the parent supplier entity in Oracle."
    type: string
    sql: ${TABLE}.supplier_parent_name ;;
  }

  dimension_group: delivery {
    label: "Delivery"
    description: "Timestamp at which a supply delivery was made to a hub. This field is populated through the Hub-One app, when hub staff inputs that the delivery was made."
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
    ]
    sql: ${TABLE}.delivery_timestamp ;;
  }

  dimension: dispatch_notification_id {
    label: "Dispatch Notification ID"
    description: "Unique identifier of a dispatch notification (DESADV) as parsed from the EDI file provided by the supplier"
    type: string
    sql: ${TABLE}.dispatch_notification_id ;;
  }

  dimension: generated_delivery_id {
    label: "Delivery ID"
    description: "Unique identifier of a supplier_delivery_received_at_hub event."
    type: string
    sql: ${TABLE}.generated_delivery_id ;;
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Event Specific Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension_group: event_created_at_timestamp {
    label: "Event Created"
    description: "Timestamp at which an event was created/sent by the transmitting service."
    group_label: "Event"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.event_created_at_timestamp ;;
  }

  dimension: event_message_id {
    label: "Message ID"
    description: "Identifier of a unique event."
    group_label: "Event"
    type: string
    sql: ${TABLE}.event_message_id ;;
  }

  dimension_group: event_published_timestamp {
    label: "Event Published"
    description: "Timestamp at which an event was published by the transmitting service."
    group_label: "Event"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.event_published_timestamp ;;
  }

  dimension: event_type {
    label: "Event Type"
    description: "Event type from segment. This field can take the following values: Track, Page, Screen or Identify."
    group_label: "Event"
    type: string
    sql: ${TABLE}.event_type ;;
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Measures
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  measure: count {
    label: "# Events"
    type: count
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Hidden Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: delivered_product_categories {
    # hidden, as it's an array and exposed through a join
    hidden: yes
    sql: ${TABLE}.delivered_product_categories ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }
}


# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

# nested array of categories
view: supplier_deliveries_received_at_hub__delivered_product_categories {
  dimension: supplier_deliveries_received_at_hub__delivered_product_categories {
    label: "Delivered Product Categories"
    description: "Product categories, that have been delivered to a hub."
    type: string
    sql: supplier_deliveries_received_at_hub__delivered_product_categories ;;
  }
}
