# Owner: Pete Kell
# Created: 2022-03-07

view: daily_picker_events {
  sql_table_name: `flink-data-prod.curated.daily_picker_events`
    ;;
  view_label: "Daily Picker Events"


  # This is the curated event stream data generated by the picker app.
  # It should be used only to understand how the picker app is used.
  # Although it has inventory adjustment events, it should not replace inventory tables.

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~ IDs & Date Filters ~~

  dimension_group: event_timestamp {
    group_label: "Date Dimensions"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.event_timestamp ;;
  }

  dimension: country_iso {
    group_label: "Location Dimensions"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    group_label: "Location Dimensions"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: order_id {
    group_label: "Order IDs"
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: anonymous_id {
    group_label: "Employee Attributes"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }


  # ~~ App, Device & Connectivity ~~

  dimension: app_build {
    group_label: "Device Attributes"
    type: string
    description: "The build number of the picker app generating the hit"
    sql: ${TABLE}.app_build ;;
  }

  dimension: app_version {
    group_label: "Device Attributes"
    type: string
    description: "The version of the picker app generating the hit"
    sql: ${TABLE}.app_version ;;
  }

  dimension: device_model {
    group_label: "Device Attributes"
    type: string
    description: "The model of the Zebra device being used"
    sql: ${TABLE}.device_model ;;
  }

  dimension: is_network_cellular {
    group_label: "Device Attributes"
    type: yesno
    description: "TRUE when the device was using a celluar network"
    sql: ${TABLE}.is_network_cellular ;;
  }

  dimension: is_network_wifi {
    group_label: "Device Attributes"
    type: yesno
    description: "TRUE when the device was using a wifi network"
    sql: ${TABLE}.is_network_wifi ;;
  }

  dimension: locale {
    group_label: "Device Attributes"
    type: string
    description: "The locale setting on the Zebra device"
    sql: ${TABLE}.locale ;;
  }

  dimension: os_version {
    group_label: "Device Attributes"
    type: string
    description: "The version of Android on the Zebra device"
    sql: ${TABLE}.os_version ;;
  }


  # ~~ Event ~~

  dimension: action {
    group_label: "Event Dimensions"
    type: string
    description: "Populated by the 'action' property in the order_progress event, and
                  the 'state' property in the order_state event"
    sql: ${TABLE}.action ;;
  }

  dimension: component_name {
    group_label: "Event Dimensions"
    description: "The name of the component clicked by the picker"
    type: string
    sql: ${TABLE}.component_name ;;
  }

  dimension: ean {
    group_label: "Event Dimensions"
    description: "The ean of the item scanned by the picker"
    type: string
    sql: ${TABLE}.ean ;;
  }

  dimension: event_name {
    group_label: "Event Dimensions"
    type: string
    sql: ${TABLE}.event_name ;;
  }

  dimension: is_customer_new {
    group_label: "Event Dimensions"
    type: yesno
    description: "If the order the event relates to has been placed by a new customer"
    sql: ${TABLE}.is_customer_new ;;
  }

  dimension: is_found {
    group_label: "Event Dimensions"
    type: yesno
    description: "If the ean scanned is found"
    sql: ${TABLE}.is_found ;;
  }

  dimension: sku {
    group_label: "Event Dimensions"
    type: string
    description: "The sku of the item scanned by the picker"
    sql: ${TABLE}.sku ;;
  }

  dimension: quantity {
    group_label: "Event Dimensions"
    type: number
    description: "The quantity of the item impacted by the action"
    sql: ${TABLE}.quantity ;;
  }

  dimension: reason {
    group_label: "Event Dimensions"
    type: string
    description: "The reason selected by the picker for the quantity adjustment"
    sql: ${TABLE}.reason ;;
  }

  # ~~ Hidden ~~

  dimension_group: event_recieved {
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
    sql: ${TABLE}.event_recieved_at ;;
    hidden:  yes
  }

  dimension: event_uuid {
    type: string
    primary_key: yes
    sql: ${TABLE}.event_uuid ;;
    hidden: yes
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}.ip_address ;;
    hidden: yes
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
    hidden: yes
  }


  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~     Measures.      ~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: count_events {
    type: count_distinct
    label: "# events"
    sql: ${TABLE}.event_uuid ;;
  }

  measure: count_orders {
    type: count_distinct
    label: "# orders"
    sql: ${TABLE}.order_id ;;
  }

  measure: sum_quantity {
    type: sum
    label: "# Total Quanity"
    sql: ${TABLE}.quantity ;;
  }

  measure: count_sku {
    type: count_distinct
    label: "# Distinct Items"
    sql: ${TABLE}.sku ;;
  }
}
