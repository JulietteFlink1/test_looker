view: app_session_orders {
  sql_table_name: `flink-data-prod.curated.app_session_orders_full_load`
    ;;

  view_label: "* App Orders per Session *"
  drill_fields: [core_dimensions*]

  set: core_dimensions {
    fields: [
      hub_code,
      city,
      country_iso
    ]
  }

  ## IDs

  dimension: session_order_uuid {
    group_label: "IDs"
    label: "Session Order UUID"
    type: string
    sql: ${TABLE}.session_order_uuid ;;
    primary_key: yes
    hidden: yes
  }
  dimension: order_uuid {
    group_label: "IDs"
    label: "Order UUID"
    type: string
    sql: ${TABLE}.order_uuid ;;
    description: "Order Unique Identifier"
    hidden: no
  }
  dimension: order_id {
    group_label: "IDs"
    label: "Order ID"
    type: string
    sql: ${TABLE}.order_id ;;
    hidden: yes
  }
  dimension: session_id {
    group_label: "IDs"
    label: "Session ID"
    type: string
    sql: ${TABLE}.session_id ;;
    hidden: no
  }
  dimension: user_id  {
    group_label: "IDs"
    label: "User ID"
    description: "User ID populated when account is created"
    type: string
    sql: ${TABLE}.user_id  ;;
    hidden: yes
  }
  dimension: anonymous_id {
    group_label: "IDs"
    label: "Anonymous ID"
    description: "User identificator set by Segment"
    type: string
    sql: ${TABLE}.anonymous_id ;;
    hidden: no
  }

  ## Hub attributes

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }
  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  ## Dates / Timestamp

  dimension_group: order_at {
    group_label: "Dates / Timestamps"
    type: time
    datatype: timestamp
    timeframes: [
      minute,
      hour,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_timestamp ;;
  }


## Measures

  measure: cnt_unique_orders {
    label: "# Unique Orders"
    description: "Number of unique orders"
    type: count_distinct
    sql: ${order_uuid};;
    value_format_name: decimal_0
    hidden: no
  }
  measure: cnt_unique_sessions{
    label: "# Unique Sessions"
    description: "Number of unique sessions"
    type: count_distinct
    sql: ${session_id};;
    value_format_name: decimal_0
    hidden: no
  }
  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    description: "Number of Unique Users identified via Anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }
  measure: cnt_unique_userid {
    label: "# Unique Users"
    description: "Number of Unique Users identified via User ID when account is created"
    hidden:  yes
    type: count_distinct
    sql: ${user_id};;
    value_format_name: decimal_0
  }

}
