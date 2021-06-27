view: checkout_tracking {
  derived_table: {
    sql:
    -- this query needs to be cleaned up because I first got city from address_confirmed but then also needed checkout_started event and that also has city, making address_confirmed union unnecessary
    WITH
        combined AS(
        SELECT
          change_attempt.anonymous_id,
          NULL AS hub_city,
          change_attempt.timestamp,
          change_attempt.event,
          change_attempt.context_app_version,
          change_attempt.context_device_type,
          change_attempt.context_os_version
        FROM
          `flink-backend.flink_android_production.address_change_at_checkout_message_viewed` change_attempt
        UNION ALL
        SELECT
          address.anonymous_id,
          address.hub_city,
          address.timestamp,
          address.event,
          address.context_app_version,
          address.context_device_type,
          address.context_os_version
        FROM
          `flink-backend.flink_android_production.address_confirmed` address
        UNION ALL
        SELECT
          checkout_started.anonymous_id,
          checkout_started.hub_city,
          checkout_started.timestamp,
          checkout_started.event,
          checkout_started.context_app_version,
          checkout_started.context_device_type,
          checkout_started.context_os_version
        FROM
          `flink-backend.flink_android_production.checkout_started` checkout_started),
        address_block AS (
        SELECT
          *,
          SUM(CASE
            -- the IS NOT NULL part ensures that if the user tries to confirm an address outside of the hub_city and this is value is null with this address_confirmed event, to take the value from the previous address_confirmed rather than setting it to null (because the app will use the previous address)
              WHEN (combined.event="address_confirmed" AND combined.hub_city IS NOT NULL) THEN 1
            ELSE
            0
          END
            ) OVER(PARTITION BY combined.anonymous_id ORDER BY combined.timestamp) AS address_block_per_id,
        FROM
          combined),
        derived_address_tb AS (
        SELECT
          *,
          FIRST_VALUE(address_block.hub_city) OVER (PARTITION BY address_block.anonymous_id, address_block.address_block_per_id ORDER BY address_block.timestamp) AS derived_city
        FROM
          address_block
        ORDER BY
          anonymous_id,
          timestamp),
        country_lookup AS (
        SELECT
          DISTINCT country_iso,
          city
        FROM
          `flink-backend.gsheet_store_metadata.hubs` ),
        derived_address_with_country_tb AS (
        SELECT
          derived_address_tb.*,
        IF
          (derived_city LIKE "Mülheim%"
            OR derived_city LIKE "%Ludwigshafen%",
            "DE",
            country_iso) AS country_iso
        FROM
          derived_address_tb
        LEFT JOIN
          country_lookup
        ON
          derived_city=city )
      SELECT
        anonymous_id,
        timestamp,
        event,
        derived_city,
        country_iso,
        context_app_version,
        context_device_type,
        context_os_version
      FROM
        derived_address_with_country_tb
       ;;
  }

  ### custom measures
  measure: cnt_checkoutstarted {
    type: count
    filters: [event: "checkout_started"]
  }

  measure: cnt_address_change_attempt {
    type: count
    filters: [event: "address_change_at_checkout_message_viewed"]
  }

  measure: cnt_unique_anonymousid_checkoutstarted {
    label: "# Unique Users Starting Checkout"
    description: "Number of Unique Users identified via Anonymous ID from Segment that started checkout"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "checkout_started"]
    value_format_name: decimal_0
  }

  measure: cnt_unique_anonymousid_addresstapped {
    label: "# Unique Users Tapping Address At Checkout"
    description: "Number of Unique Users identified via Anonymous ID from Segment that tapped address checkout"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "address_change_at_checkout_message_viewed"]
    value_format_name: decimal_0
  }

  ### Standard measures and dimensions

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: derived_city {
    type: string
    sql: ${TABLE}.derived_city ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: context_app_version {
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_type {
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: context_os_version {
    type: string
    sql: ${TABLE}.context_os_version ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      timestamp_time,
      event,
      derived_city,
      country_iso,
      context_app_version,
      context_device_type,
      context_os_version
    ]
  }
}
