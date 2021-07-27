view: appopened_events {
  derived_table: {
    sql: SELECT
          anonymous_id
          , timestamp
          , context_app_version
          , context_device_type
          , context_locale
          , id
          , city
          , country_iso
          , address
          , hub_slug
          , has_selected_address
      FROM `flink-backend.flink_android_production.app_opened_view`

      UNION ALL

      SELECT
          anonymous_id
          , timestamp
          , context_app_version
          , context_device_type
          , context_locale
          , id
          , city
          , country_iso
          , address
          , hub_slug
          , has_selected_address
      FROM `flink-backend.flink_ios_production.app_opened_view`
       ;;
  }

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

  dimension: context_app_version {
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_type {
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: context_locale {
    type: string
    sql: ${TABLE}.context_locale ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
  }

  dimension: hub_slug {
    type: string
    sql: ${TABLE}.hub_slug ;;
  }

  dimension: has_selected_address {
    type: string
    sql: ${TABLE}.has_selected_address ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      timestamp_time,
      context_app_version,
      context_device_type,
      context_locale,
      id,
      city,
      country_iso,
      address,
      hub_slug,
      has_selected_address
    ]
  }
}
