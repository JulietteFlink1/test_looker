view: checkout_tracking {
  derived_table: {
    sql: WITH
        tracks_tb AS (
          SELECT tracks.anonymous_id,
          tracks.timestamp,
          IF(tracks.event="purchase_confirmed", "payment_started", tracks.event) AS event,
          tracks.id,
          tracks.context_app_version,
          tracks.context_device_type,
          tracks.context_os_version
          FROM `flink-backend.flink_android_production.tracks_view` tracks
          WHERE tracks.event NOT LIKE "api%" AND tracks.event NOT LIKE "deep_link%"

          UNION ALL

          SELECT tracks.anonymous_id,
          tracks.timestamp,
          IF(tracks.event="purchase_confirmed", "payment_started", tracks.event) AS event,
          tracks.id,
          tracks.context_app_version,
          tracks.context_device_type,
          tracks.context_os_version
          FROM `flink-backend.flink_ios_production.tracks_view` tracks
          WHERE tracks.event NOT LIKE "api%" AND tracks.event NOT LIKE "deep_link%"
        ),
        checkout_tb AS(
        SELECT
          checkout_started.anonymous_id,
          checkout_started.hub_city,
          checkout_started.timestamp,
          checkout_started.event,
          checkout_started.id,
          checkout_started.context_app_version,
          checkout_started.context_device_type,
          checkout_started.context_os_version
        FROM
          `flink-backend.flink_android_production.checkout_started_view` checkout_started
        UNION ALL
        SELECT
          checkout_started.anonymous_id,
          checkout_started.hub_city,
          checkout_started.timestamp,
          checkout_started.event,
          checkout_started.id,
          checkout_started.context_app_version,
          checkout_started.context_device_type,
          checkout_started.context_os_version
        FROM
          `flink-backend.flink_ios_production.checkout_started_view` checkout_started

          ),

        joined_tb AS (
            SELECT tracks_tb.*,
            checkout_tb.hub_city,
            FROM tracks_tb
            LEFT JOIN checkout_tb
            ON tracks_tb.id=checkout_tb.id
        ),
        address_block AS (
        SELECT
          *,
          SUM(CASE
            -- the IS NOT NULL part ensures that if the user tries to confirm an address outside of the hub_city and this is value is null with this address_confirmed event, to take the value from the previous address_confirmed rather than setting it to null (because the app will use the previous address)
              WHEN (joined_tb.event="checkout_started" AND joined_tb.hub_city IS NOT NULL) THEN 1
            ELSE
            0
          END
            ) OVER(PARTITION BY joined_tb.anonymous_id ORDER BY joined_tb.timestamp) AS address_block_per_id,
        FROM
          joined_tb),
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
        LEAD(event) OVER(PARTITION BY anonymous_id ORDER BY timestamp ASC) AS next_event,
        hub_city,
        derived_city,
        country_iso,
        context_app_version,
        context_device_type,
        context_os_version
      FROM
        derived_address_with_country_tb
      ORDER BY 1,2
       ;;
  }

  ### custom measures
  measure: cnt_checkoutstarted {
    type: count
    filters: [event: "checkout_started"]
  }

  measure: cnt_hub_updated {
    type: count
    filters: [event: "hub_update_message_viewed"]
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

  measure: cnt_unique_anonymousid_hubupdated {
    label: "# Unique Users Losing Cart Due To Hub Update"
    description: "Number of Unique Users identified via Anonymous ID from Segment that lost their cart due to updating hub after adding something to the cart"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "hub_update_message_viewed"]
    value_format_name: decimal_0
  }

  ### Standard dimensions and measures

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

  dimension: next_event {
    type: string
    sql: ${TABLE}.next_event ;;
  }


  dimension: hub_city {
    type: string
    sql: ${TABLE}.hub_city ;;
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
      next_event,
      hub_city,
      derived_city,
      country_iso,
      context_app_version,
      context_device_type,
      context_os_version
    ]
  }
}
