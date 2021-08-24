view: order_placed_events {
  derived_table: {
    sql:
    WITH help_tb AS (
    SELECT
        ios_orders.id,
        ios_orders.order_token, -- in curated layer orders.token used for CT orders to make order_uuid (country+token)
        ios_orders.order_number, -- in curated layer orders.view used for Saleor orders to make order_uuid (country+number)
        ios_orders.anonymous_id,
        ios_orders.context_app_version,
        ios_orders.context_app_name,
        ios_orders.context_device_type,
        ios_orders.hub_city,
        ios_orders.timestamp
      FROM
        `flink-backend.flink_ios_production.order_placed_view` ios_orders
      WHERE
          NOT (ios_orders.context_app_version LIKE "%APP-RATING%" OR ios_orders.context_app_version LIKE "%DEBUG%")
      AND NOT (ios_orders.context_app_name = "Flink-Staging" OR ios_orders.context_app_name="Flink-Debug")
      AND NOT (ios_orders.order_number IS NULL) -- we have some cases where this happens (13)
      UNION ALL
      SELECT
        android_orders.id,
        android_orders.order_token, -- in curated layer orders.token used for CT orders to make order_uuid (country+token)
        android_orders.order_number, -- in curated layer orders.view used for Saleor orders to make order_uuid (country+number)
        android_orders.anonymous_id,
        android_orders.context_app_version,
        android_orders.context_app_name,
        android_orders.context_device_type,
        android_orders.hub_city,
        android_orders.timestamp
      FROM
        `flink-backend.flink_android_production.order_placed_view` android_orders
      WHERE
          NOT (android_orders.context_app_version LIKE "%APP-RATING%" OR android_orders.context_app_version LIKE "%DEBUG%")
      AND NOT (android_orders.context_app_name = "Flink-Staging" OR android_orders.context_app_name="Flink-Debug")
      AND NOT (android_orders.order_number IS NULL) -- we have some cases where this happens (13)
      )
    SELECT help_tb.*
      , IF(help_tb.hub_city LIKE '%Ludwigshafen%' OR help_tb.hub_city LIKE '%Mülheim%', "DE", hubs.country_iso) AS country_iso
    FROM help_tb
    LEFT JOIN `flink-data-prod.google_sheets.hub_metadata` hubs ON hubs.city = help_tb.hub_city
 ;;
  }

### Custom measures and dimensions ###
  measure: number_of_distinct_orders {
    type: count_distinct
    sql: ${TABLE}.order_id ;;
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
      IF(${is_ct_order}, ${country_iso}|| '_' ||${order_token}, ${country_iso}|| '_' ||${order_number})
    );;
  hidden: yes
  }

#######################################

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
    hidden: yes
  }

  dimension: order_token {
    type: string
    sql: ${TABLE}.order_token ;;
    hidden: yes
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
    hidden: yes
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: context_app_version {
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_app_name {
    type: string
    sql: ${TABLE}.context_app_name ;;
  }

  dimension: context_device_type {
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: hub_city {
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  set: detail {
    fields: [
      id,
      order_token,
      order_number,
      anonymous_id,
      context_app_version,
      context_app_name,
      context_device_type,
      hub_city,
      timestamp_time,
      country_iso
    ]
  }
}
