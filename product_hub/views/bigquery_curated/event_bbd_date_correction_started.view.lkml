# The name of this view in Looker is "Event Bbd Date Correction Started"
view: event_bbd_date_correction_started {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `flink-data-prod.curated.event_bbd_date_correction_started`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Anonymous ID" in Explore.

  dimension: anonymous_id {
    type: string
    description: "Unique ID for each user set by Segement."
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: context_ip {
    type: string
    sql: ${TABLE}.context_ip ;;
  }

  dimension: country_iso {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: device_id {
    type: string
    description: "Unique ID for each device. Since we cannot access the real deviceId from the zebras, it corresponds to an identifier generated at app launch and stored in the localStorage where it persists even if the user signs out. (Available from 17/3/23 ) (slack thread: https://goflink.slack.com/archives/C03UH8FK3QV/p1678391276541939)"
    sql: ${TABLE}.device_id ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: event {
    type: time
    description: "Date when an event was triggered."
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  dimension: event_name {
    type: string
    description: "Name of an event triggered."
    sql: ${TABLE}.event_name ;;
  }

  dimension_group: event_timestamp {
    type: time
    description: "Timestamp when an event was triggered within the app / web."
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.event_timestamp ;;
  }

  dimension: event_uuid {
    primary_key: yes
    type: string
    description: "Unique ID for each event defined by Segment."
    sql: ${TABLE}.event_uuid ;;
  }

  dimension: hub_code {
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: locale {
    type: string
    sql: ${TABLE}.locale ;;
  }

  dimension_group: original_timestamp {
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
    sql: ${TABLE}.original_timestamp ;;
  }

  dimension: page_path {
    type: string
    description: "Page path of users' page view. Page path does not contain domain information nor query parameters."
    sql: ${TABLE}.page_path ;;
  }

  dimension: page_title {
    type: string
    sql: ${TABLE}.page_title ;;
  }

  dimension: page_url {
    type: string
    sql: ${TABLE}.page_url ;;
  }

  dimension: product_sku {
    type: string
    description: "SKU of the product, as available in the backend."
    sql: ${TABLE}.product_sku ;;
  }

  dimension: quinyx_badge_number {
    type: string
    description: "Employment ID that was initially generated by bambooHR. It is used to identify staff members from hub operations. To be able to map employees between different HR systems (after migrating to SAP), we still refered to it as quiniyx badge number. Quiniyx is used as our workforce management tool for rider ops."
    sql: ${TABLE}.quinyx_badge_number ;;
  }

  dimension_group: received {
    type: time
    description: "Timestamp when an event was received on the server, used for data laod."
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.received_at ;;
  }

  dimension: shelf_number {
    type: string
    description: "Unique identifier of the shelf where the SKU is stored in the hub.
    Number of the shelf (from 0 to 86) followed by a letter which indicates
    the level within the shelf."
    sql: ${TABLE}.shelf_number ;;
  }

  dimension: stock_correction_origin {
    type: string
    description: "Describes the origin of the stock correction started point. Can be performed by using search bar or scanning a product."
    sql: ${TABLE}.stock_correction_origin ;;
  }

  dimension: user_agent {
    type: string
    sql: ${TABLE}.user_agent ;;
  }

  dimension: user_id {
    type: string
    description: "Should be populated with Auth0Id, but as of now we are receiving null in this field and using quynix_badge_number to identify users/ employees in the hubs."
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [event_name]
  }
}
