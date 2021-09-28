view: contact_customer_service_selected_view {
  derived_table: {
    persist_for: "1 hour"
    sql:
      SELECT
        anonymous_id
        , context_app_version
        , context_device_type
        , country_iso
        , delivery_eta
        , delivery_lat
        , delivery_lng
        , delivery_postcode
        , event
        , event_text
        , hub_city
        , hub_slug
        , id
        , order_id
        , order_number
        , order_status
        , timestamp
      FROM `flink-data-prod.flink_android_production.contact_customer_service_selected_view`

      UNION ALL

      SELECT
        anonymous_id
        , context_app_version
        , context_device_type
        , country_iso
        , delivery_eta
        , delivery_lat
        , delivery_lng
        , delivery_postcode
        , event
        , event_text
        , hub_city
        , hub_slug
        , id
        , order_id
        , order_number
        , status AS order_status
        , timestamp
      FROM `flink-data-prod.flink_ios_production.contact_customer_service_selected_view`
    ;;
  }

  dimension: is_ct_order {
    ## Can know whether is CT order by checking whether order_number is a number (Saleor: 11111) or a string (CT: de_muc_zue7y)
    type: yesno
    sql: (
          -- if safe_cast fails, returns null meaning order_number was not a number, meaning it was a CT order. Also ruling out NULL because with yesno, null turns into NO (FALSE).
          IF(SAFE_CAST(${order_number} AS INT64) is NULL,TRUE,FALSE) AND ${order_number} IS NOT NULL
          );;
  }

  dimension: order_uuid {
    ## This uuid is designed to follow the same format as order_uuid inside of orders.view (curated_layer).
    ## For saleor orders, it looks like this: DE_11111 (order_id is based on order_number)
    ## For CT orders, it looks like this: DE_c139c9c1-36b5-423b-97b2-79a94d116aea (order_id is based on order_token)
    ## The way we can know from the client side whether order_number or order_token should be used, is by checking whether order_number is a number (Saleor: 11111) or a string (CT: de_muc_zue7y)
    type: string
    sql: (
      IF(${is_ct_order}, ${country_iso}|| '_' ||${order_id}, ${country_iso}|| '_' ||${order_number})
    );;
    hidden: yes
  }

  measure: cnt_unique_order_ccs_intent {
    type: count_distinct
    sql: ${order_id} ;;
  }

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: context_app_version {
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_type {
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: delivery_eta {
    type: number
    sql: ${TABLE}.delivery_eta ;;
  }

  dimension: delivery_lat {
    type: number
    sql: ${TABLE}.delivery_lat ;;
  }

  dimension: delivery_lng {
    type: number
    sql: ${TABLE}.delivery_lng ;;
  }

  dimension: delivery_postcode {
    type: string
    sql: ${TABLE}.delivery_postcode ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: event_text {
    type: string
    sql: ${TABLE}.event_text ;;
  }

  dimension: hub_city {
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: hub_slug {
    type: string
    sql: ${TABLE}.hub_slug ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: order_status {
    type: string
    sql: ${TABLE}.order_status ;;
  }

  dimension_group: timestamp {
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
    sql: ${TABLE}.timestamp ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id
    ]
  }
}
