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
          timestamp DESC),

        aggregated_failures AS (
        SELECT
          DATE(timestamp) AS date,
          country_iso,
          COUNT(DISTINCT anonymous_id) AS unique_ids_with_failures,
          COUNT(anonymous_id) AS total_failures
        FROM
          location_help_table
        GROUP BY 1,2
        ORDER BY 1 DESC,2),

      aggregated_successes AS (
        SELECT
          DATE(timestamp) AS date,
          country_iso,
          COUNT(DISTINCT anonymous_id) AS unique_ids_with_successes,
          COUNT(anonymous_id) AS total_successes
        FROM
          location_help_table2
        GROUP BY 1,2
        ORDER BY 1 DESC,2)

      SELECT
        aggregated_failures.*, aggregated_successes.unique_ids_with_successes, aggregated_successes.total_successes
      FROM
        aggregated_failures
      LEFT JOIN aggregated_successes
      ON aggregated_failures.date=aggregated_successes.date AND aggregated_failures.country_iso=aggregated_successes.country_iso
      ORDER BY
        1 DESC,
        2
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: date {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: unique_ids_with_failures {
    type: number
    sql: ${TABLE}.unique_ids_with_failures ;;
  }

  dimension: total_failures {
    type: number
    sql: ${TABLE}.total_failures ;;
  }

  dimension: unique_ids_with_successes {
    type: number
    sql: ${TABLE}.unique_ids_with_successes ;;
  }

  dimension: total_successes {
    type: number
    sql: ${TABLE}.total_successes ;;
  }

  set: detail {
    fields: [
      date,
      country_iso,
      unique_ids_with_failures,
      total_failures,
      unique_ids_with_successes,
      total_successes
    ]
  }
}
