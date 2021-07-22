view: order_placed_with_order_order_events {
  derived_table: {
    sql: SELECT
      created
      , token
      , user_email
      , status
      , metadata
      , IF(ios_order.anonymous_id IS NULL, android_order.anonymous_id, ios_order.anonymous_id) as anonymous_id
      , IF(ios_order.context_device_type IS NULL, android_order.context_device_type, ios_order.context_device_type) as device_type
  FROM `flink-backend.saleor_db.order_order` backend_order
  LEFT JOIN `flink-backend.flink_ios_production.order_placed_view` ios_order
      ON backend_order.token=ios_order.order_token
  LEFT JOIN `flink-backend.flink_android_production.order_placed_view` android_order
      ON backend_order.token=android_order.order_token
  --WHERE
  --    DATE(created) > "2021-06-25"
  ORDER BY created
 ;;
  }

  dimension: fulfillment_time {
    type: number
    label: "Fulfillment time (min)"
    value_format_name: decimal_1
    sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryTime')),${created_raw}, SECOND) / 60 ;;
  }

  dimension: fulfillment_time_tier {
    group_label: "* Operations / Logistics *"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    style: interval
    sql: ${fulfillment_time} ;;
  }

  dimension: is_fulfillment_less_than_1_minute {
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${fulfillment_time} < 1 ;;
  }

  dimension: is_successful_order {
    group_label: "* Order Status / Type *"
    type: yesno
    sql: ${status} IN ('fulfilled', 'partially fulfilled');;
  }

  dimension: delivery_time {
    label: "Delivery Time"
    type: number
    sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryTime')), TIMESTAMP(JSON_EXTRACT_SCALAR(${TABLE}.metadata, '$.trackingTimestamp')), SECOND) / 60 ;;
  }

  dimension: delivery_eta_minutes {
    label: "Delivery PDT (min)"
    type: number
    sql: CAST(REGEXP_REPLACE(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryETA'),'[^0-9 ]','') AS INT64) ;;
  }

  dimension: is_internal_order {
    label: "Internal Order"
    type: yesno
    sql: ${user_email} LIKE '%goflink%' OR ${user_email} LIKE '%pickery%' OR LOWER(${user_email}) IN ('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com', 'alenaschneck@gmx.de', 'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com', 'fabian.hardenberg@gmail.com', 'benjamin.zagel@gmail.com');;
  }

  dimension_group: delivery_eta_timestamp {
    group_label: "* Dates and Timestamps *"
    label: "Delivery PDT Date/Timestamp"
    type: time
    timeframes: [
      raw,
      minute15,
      minute30,
      hour_of_day,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: TIMESTAMP_ADD(${created_raw}, INTERVAL CAST(REGEXP_REPLACE(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryETA'),'[^0-9 ]','') AS INT64) MINUTE) ;;
  }

  dimension_group: delivery_timestamp {
    group_label: "* Dates and Timestamps *"
    label: "Delivery Date/Timestamp"
    type: time
    timeframes: [
      raw,
      hour_of_day,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryTime')) ;;
  }

  dimension: delivery_delay_since_eta {
    group_label: "* Operations / Logistics *"
    label: "Delta to PDT (min)"
    type: duration_minute
    sql_start: ${delivery_eta_timestamp_raw};;
    sql_end: ${delivery_timestamp_raw};;
  }

  dimension: delivery_delay_tier {
    group_label: "* Operations / Logistics *"
    type: tier
    tiers: [-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    style: interval
    sql: ${delivery_delay_since_eta} ;;
  }

  dimension: hub_slug {
    label: "Hub slug"
    type: string
    sql: JSON_EXTRACT_SCALAR(${metadata}, '$.warehouse') ;;
  }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: created {
    type: time
    sql: ${TABLE}.created ;;
  }

  dimension: token {
    type: string
    sql: ${TABLE}.token ;;
  }

  dimension: user_email {
    type: string
    sql: ${TABLE}.user_email ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: metadata {
    type: string
    sql: ${TABLE}.metadata ;;
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }

  set: detail {
    fields: [created_time, token, metadata, user_email, status, anonymous_id, device_type]
  }
}
