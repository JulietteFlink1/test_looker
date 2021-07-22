view: voucher_api_failure_success {
  derived_table: {
    sql: WITH
        voucher_application_failed_tb AS (
        SELECT
          anonymous_id,
          timestamp,
          id,
          body_voucher_code,
          context_app_version,
          context_device_model,
          context_device_type,
          context_os_version,
          headers_hub,
          headers_locale,
          response,
          status,
          SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(headers_hub)),':')[
        OFFSET
          (1)] AS hub_id,
          context_network_carrier,
          context_locale
        FROM
          `flink-backend.flink_ios_production.api_voucher_apply_failed_view`
        UNION ALL
        SELECT
          anonymous_id,
          timestamp,
          id,
          NULL AS body_voucher_code,
          context_app_version,
          context_device_model,
          context_device_type,
          context_os_version,
          NULL AS headers_hub,
          NULL AS headers_locale,
          NULL AS response,
          NULL AS status,
          NULL AS hub_id,
          context_network_carrier,
          context_locale,
        FROM
          `flink-backend.flink_android_production.api_voucher_apply_failed_view` ),

        location_help_table AS (
        SELECT
          anonymous_id,
          timestamp,
          voucher_application_failed_tb.id,
          "Fail" as event_type,
          body_voucher_code,
          hub.slug AS hub_code,
        IF
          (
          IF
            (hub_id IS NULL,
              SUBSTRING(voucher_application_failed_tb.context_locale,
                4,
                2),
              country_iso) IN ("DE",
              "FR",
              "NL"),
          IF
            (hub_id IS NULL,
              SUBSTRING(voucher_application_failed_tb.context_locale,
                4,
                2),
              country_iso),
            "N/A") AS country_iso,
          context_app_version,
          context_device_model,
          context_device_type,
          context_os_version,
          response,
          status,
          context_network_carrier,
        FROM
          voucher_application_failed_tb
        LEFT JOIN
          `flink-backend.saleor_db_global.warehouse_warehouse` AS hub
        ON
          voucher_application_failed_tb.hub_id = hub.id
        ORDER BY
          anonymous_id,
          timestamp DESC),
        voucher_application_succeeded_tb AS (
        SELECT
          anonymous_id,
          timestamp,
          id,
          body_voucher_code,
          context_app_version,
          context_device_model,
          context_device_type,
          context_os_version,
          headers_hub,
          headers_locale,
          status,
          SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(headers_hub)),':')[
        OFFSET
          (1)] AS hub_id,
          context_network_carrier,
          context_locale
        FROM
          `flink-backend.flink_ios_production.api_voucher_apply_succeeded_view`
        UNION ALL
        SELECT
          anonymous_id,
          timestamp,
          id,
          NULL AS body_voucher_code,
          context_app_version,
          context_device_model,
          context_device_type,
          context_os_version,
          NULL AS headers_hub,
          NULL AS headers_locale,
          NULL AS status,
          NULL AS hub_id,
          context_network_carrier,
          context_locale,
        FROM
          `flink-backend.flink_android_production.api_voucher_apply_succeeded_view` ),

        location_help_table2 AS (
        SELECT
          anonymous_id,
          timestamp,
          voucher_application_succeeded_tb.id,
          "Success" as event_type,
          body_voucher_code,
          hub.slug AS hub_code,
        IF
          (
          IF
            (hub_id IS NULL,
              SUBSTRING(voucher_application_succeeded_tb.context_locale,
                4,
                2),
              country_iso) IN ("DE",
              "FR",
              "NL"),
          IF
            (hub_id IS NULL,
              SUBSTRING(voucher_application_succeeded_tb.context_locale,
                4,
                2),
              country_iso),
            "N/A") AS country_iso,
          context_app_version,
          context_device_model,
          context_device_type,
          context_os_version,
          CAST(NULL AS STRING) AS response,
          status,
          context_network_carrier,
        FROM
          voucher_application_succeeded_tb
        LEFT JOIN
          `flink-backend.saleor_db_global.warehouse_warehouse` AS hub
        ON
          voucher_application_succeeded_tb.hub_id = hub.id
        ORDER BY
          anonymous_id,
          timestamp DESC)

      SELECT * FROM location_help_table
      UNION ALL
      SELECT * FROM location_help_table2
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: cnt_success {
    label: "Count of successful voucher application"
    description: "Number of vouchers successfully applied"
    type: sum
    sql: if(${event_type}="Success",1,0) ;;
  }

  measure: cnt_fail {
    label: "Count of failed voucher application"
    description: "Number of failures to apply voucher"
    type: sum
    sql: if(${event_type}="Fail",1,0) ;;
  }

  measure: cnt_unique_anonymousid_success {
    label: "# Unique Users Success"
    description: "Number of Unique Users identified via Anonymous ID from Segment with successful voucher application"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event_type: "Success"]
    value_format_name: decimal_0
  }

  measure: cnt_unique_anonymousid_fail{
    label: "# Unique Users Fail"
    description: "Number of Unique Users identified via Anonymous ID from Segment with failed voucher application"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event_type: "Fail"]
    value_format_name: decimal_0
  }


  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: body_voucher_code {
    type: string
    sql: ${TABLE}.body_voucher_code ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: context_app_version {
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_model {
    type: string
    sql: ${TABLE}.context_device_model ;;
  }

  dimension: context_device_type {
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: context_os_version {
    type: string
    sql: ${TABLE}.context_os_version ;;
  }

  dimension: response {
    type: string
    sql: ${TABLE}.response ;;
  }

  dimension: status {
    type: number
    sql: ${TABLE}.status ;;
  }

  dimension: context_network_carrier {
    type: string
    sql: ${TABLE}.context_network_carrier ;;
  }



  set: detail {
    fields: [
      anonymous_id,
      timestamp_time,
      id,
      event_type,
      body_voucher_code,
      hub_code,
      country_iso,
      context_app_version,
      context_device_model,
      context_device_type,
      context_os_version,
      response,
      status,
      context_network_carrier
    ]
  }
}
