view: voucher_api_failure_success {
  derived_table: {
    sql: WITH voucher_tb_union AS (
        SELECT anonymous_id, id, timestamp, context_device_id, event, NULL AS voucher_code, context_app_version, context_device_type
        , SUBSTRING(context_locale,4,2) AS country_iso
        FROM `flink-data-prod.flink_android_production.api_voucher_apply_failed_view`
        -- WHERE "FR" in (context_locale)

        UNION ALL

        SELECT anonymous_id, id, timestamp, context_device_id, event, NULL AS voucher_code, context_app_version, context_device_type
        , SUBSTRING(context_locale,4,2) AS country_iso
        FROM `flink-data-prod.flink_android_production.api_voucher_apply_succeeded_view`
        -- WHERE "FR" in (context_locale)

        UNION ALL

        SELECT anonymous_id, id, timestamp, context_device_id, event, voucher_code, context_app_version, context_device_type
        , SUBSTRING(context_locale,4,2) AS country_iso
        FROM `flink-data-prod.flink_android_production.voucher_redemption_attempted_view`
        -- WHERE "FR" in (context_locale)

        ORDER BY timestamp
        ),

        help_tb AS (SELECT
          anonymous_id
        , timestamp
        , id
        , event
        , context_device_id
        , context_app_version
        , context_device_type
        , voucher_code AS body_voucher_code
        , IF(country_iso IN ("DE", "FR", "NL"), country_iso, "N/A") AS country_iso
        , IF(event="voucher_redemption_attempted", IF(LEAD(event) OVER(PARTITION BY anonymous_id ORDER BY timestamp ASC)="api_voucher_apply_failed", "Fail", "Success"), "N/A") AS next_event
        FROM voucher_tb_union)

        SELECT
        anonymous_id
        , timestamp
        , id
        , next_event AS event_type
        , body_voucher_code
        , country_iso
        , context_app_version
        , context_device_type
        FROM help_tb
        WHERE event="voucher_redemption_attempted"
        ORDER BY timestamp
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

  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    description: "Number of Unique Users identified via Anonymous ID from Segment attempted voucher application"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
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

  measure: perc_unique_voucher_fail_to_attempt {
    type: number
    description: "% Unique Users with failed voucher application compared to total"
    sql: ${cnt_unique_anonymousid_fail}/(${cnt_unique_anonymousid_fail}+${cnt_unique_anonymousid_success}) ;;
    value_format_name: percent_1
  }

  measure: perc_absolute_voucher_fail_to_attempt {
    type: number
    description: "% absolute failed voucher applications compared to total"
    sql: ${cnt_fail}/(${cnt_fail}+${cnt_success}) ;;
    value_format_name: percent_1
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
    primary_key: yes
    hidden: yes
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
      context_device_type
    ]
  }
}
