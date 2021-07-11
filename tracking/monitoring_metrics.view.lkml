view: monitoring_metrics {
  derived_table: {
    sql: SELECT
      paymentfail.metadata,
      paymentfail.payment_method,
        tracks.anonymous_id,
        tracks.context_app_build,
        tracks.context_app_namespace,
        tracks.context_app_version,
        CAST(NULL AS BOOL) AS context_device_ad_tracking_enabled,
        tracks.context_device_id,
        tracks.context_device_manufacturer,
        tracks.context_device_model,
        tracks.context_device_name,
        tracks.context_device_type,
        tracks.context_ip,
        tracks.context_library_name,
        tracks.context_library_version,
        tracks.context_locale,
        CAST(NULL AS BOOL) AS context_network_bluetooth,
        tracks.context_network_carrier,
        tracks.context_network_cellular,
        tracks.context_network_wifi,
        tracks.context_os_name,
        tracks.context_os_version,
        tracks.context_protocols_source_id,
        tracks.context_timezone,
        CAST(NULL AS STRING) AS context_traits_anonymous_id,
        CAST(NULL AS STRING) AS context_user_agent,
        tracks.event,
        tracks.event_text,
        tracks.id,
        tracks.loaded_at,
        tracks.original_timestamp,
        tracks.received_at,
        tracks.sent_at,
        tracks.timestamp,
        tracks.uuid_ts,
      FROM
        `flink-backend.flink_ios_production.tracks_view` tracks
      LEFT JOIN
        `flink-backend.flink_ios_production.payment_failed_view` paymentfail
      ON
        tracks.id=paymentfail.id
      LEFT JOIN
        `flink-backend.flink_ios_production.payment_method_added` paymentcomplete
      ON
        tracks.id=paymentcomplete.id
      LEFT JOIN
        `flink-backend.flink_ios_production.purchase_confirmed_view` paymentstart
      ON
        tracks.id=paymentstart.id
        AND tracks.event NOT LIKE "%api%"
        AND tracks.event NOT LIKE "%adjust%"
        AND tracks.event NOT LIKE "%install_attributed%"
        --NOT (context_app_name = "Flink-Staging" OR context_app_name="Flink-Debug")
      UNION ALL
      SELECT
      paymentfail.meta_data,
      NULL AS payment_method,
      tracks.anonymous_id,
      tracks.context_app_build,
      tracks.context_app_namespace,
      tracks.context_app_version,
      tracks.context_device_ad_tracking_enabled,
      tracks.context_device_id,
      tracks.context_device_manufacturer,
      tracks.context_device_model,
      tracks.context_device_name,
      tracks.context_device_type,
      tracks.context_ip,
      tracks.context_library_name,
      tracks.context_library_version,
      tracks.context_locale,
      tracks.context_network_bluetooth,
      tracks.context_network_carrier,
      tracks.context_network_cellular,
      tracks.context_network_wifi,
      tracks.context_os_name,
      tracks.context_os_version,
      tracks.context_protocols_source_id,
      tracks.context_timezone,
      tracks.context_traits_anonymous_id,
      tracks.context_user_agent,
      tracks.event,
      tracks.event_text,
      tracks.id,
      tracks.loaded_at,
      tracks.original_timestamp,
      tracks.received_at,
      tracks.sent_at,
      tracks.timestamp,
      tracks.uuid_ts,
      FROM
        `flink-backend.flink_android_production.tracks_view` tracks
      LEFT JOIN
        `flink-backend.flink_android_production.payment_failed_view` paymentfail
      ON
        tracks.id=paymentfail.id
      LEFT JOIN
        `flink-backend.flink_android_production.payment_method_added` paymentcomplete
      ON
        tracks.id=paymentcomplete.id
      LEFT JOIN
        `flink-backend.flink_android_production.purchase_confirmed_view` paymentstart
      ON
        tracks.id=paymentstart.id
        AND tracks.event NOT LIKE "%api%"
        AND tracks.event NOT LIKE "%adjust%"
        AND tracks.event NOT LIKE "%install_attributed%"
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  ### custom measures
  measure: cnt_cartviewed {
    type: count
    filters: [event: "cart_viewed"]
  }

  measure: cnt_checkoutstarted {
    type: count
    filters: [event: "checkout_started"]
  }

  measure: cnt_paymentfailure {
    type: count
    filters: [event: "payment_failed"]
  }

  measure: cnt_paymentstarted {
    type: count
    filters: [event: "purchase_confirmed"]
  }

  measure: cnt_paymentcomplete {
    type: count
    filters: [event: "payment_method_added"]
  }

  measure: cnt_orderplaced {
    type: count
    filters: [event: "order_placed"]
  }

  measure: cnt_payment_otheroutcome {
    type: number
    sql: ${cnt_paymentstarted}-${cnt_paymentcomplete}-${cnt_paymentfailure} ;;
  }



  measure: checkoutstarted_per_paymentstarted  {
    type: number
    sql: ${monitoring_metrics.cnt_checkoutstarted}/NULLIF(${monitoring_metrics.cnt_paymentstarted},0) ;;
    value_format_name: decimal_1
    drill_fields: [timestamp_date, checkoutstarted_per_paymentstarted]
    link: {
      label: "Checkout Started to Payment Started Times Series"
      url: "/looks/681"
    }
  }

  measure: unique_checkoutstarted_per_paymentstarted_perc  {
    type: number
    sql: ${monitoring_metrics.cnt_unique_paymentstarted}/NULLIF(${monitoring_metrics.cnt_unique_checkoutstarted},0) ;;
    value_format_name: percent_1
    drill_fields: [timestamp_date, unique_checkoutstarted_per_paymentstarted_perc]
    link: {
      label: "Checkout Started to Payment Started Percentage Times Series"
      url: "/looks/681"
    }
  }

  measure: paymentstarted_per_orderplaced  {
    type: number
    sql: ${monitoring_metrics.cnt_paymentstarted}/NULLIF(${monitoring_metrics.cnt_orderplaced},0) ;;
    value_format_name: decimal_1
    drill_fields: [timestamp_date, paymentstarted_per_orderplaced]
    link: {
      label: "Payment Started to Order Placed Times Series"
      url: "/looks/679"
    }
  }

  measure: unique_paymentstarted_per_orderplaced_perc  {
    type: number
    sql: ${monitoring_metrics.cnt_unique_orderplaced}/NULLIF(${monitoring_metrics.cnt_unique_paymentstarted},0) ;;
    value_format_name: percent_1
    drill_fields: [timestamp_date, unique_paymentstarted_per_orderplaced_perc]
    link: {
      label: "Payment Started to Order Placed Percentage Times Series"
      url: "/looks/679"
    }
  }

  measure: cnt_unique_anonymousid {
    label: "cnt Unique Users"
    description: "Number of Unique Users as per Segment Aonymous ID"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  measure: cnt_unique_cartviewed {
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "cart_viewed"]
  }

  measure: cnt_unique_checkoutstarted {
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "checkout_started"]
  }

  measure: cnt_unique_paymentfailure {
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "payment_failed"]
  }

  measure: perc_unique_paymentfailure {
    type: percent_of_total
    sql: ${cnt_unique_anonymousid};;
    value_format: "0.0\%"
    drill_fields: [timestamp_date, perc_unique_paymentfailure]
    link: {
      label: "Payment Failed to Payment Started Percentage Times Series"
      url: "/looks/721"
    }
  }

  measure: cnt_unique_paymentstarted {
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "purchase_confirmed"]
  }

  measure: cnt_unique_paymentcomplete {
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "payment_method_added"]
  }

  measure: cnt_unique_orderplaced {
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "order_placed"]
  }

  measure: cnt_unique_payment_otheroutcome {
    type: number
    sql: ${cnt_unique_paymentstarted}-${cnt_unique_paymentcomplete}-${cnt_unique_paymentfailure} ;;
  }

  measure: latest_app_version {
    type:  string
    sql: MAX(${context_app_version});;
  }

  # measure: payment_failure2started_ratio {
  #   type: number
  #   description: "Number of payment failure events compared to payment started events"
  #   value_format_name: percent_1
  #   sql: ${paymentfailure_count}/NULLIF(${paymentstarted_count},0) ;;
  # }

  ### custom dimensions
  dimension: full_app_version {
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }

  dimension: payment_status {
    type: string
    case: {
      when: {
        sql: ${TABLE}.event = "purchase_confirmed" ;;
        label: "Payment Started"
      }
      when: {
        sql: ${TABLE}.event = "payment_method_added" ;;
        label: "Payment Succeeded"
      }
      when: {
        sql: ${TABLE}.event = "payment_failed" ;;
        label: "Payment Failed"
      }
      else: "Other"
    }
  }

  ### automatically generated dimensions
  dimension: metadata {
    type: string
    sql: ${TABLE}.metadata ;;
  }

  dimension: payment_method {
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: context_app_build {
    type: string
    sql: ${TABLE}.context_app_build ;;
  }

  dimension: context_app_namespace {
    type: string
    sql: ${TABLE}.context_app_namespace ;;
  }

  dimension: context_app_version {
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_ad_tracking_enabled {
    type: string
    sql: ${TABLE}.context_device_ad_tracking_enabled ;;
  }

  dimension: context_device_id {
    type: string
    sql: ${TABLE}.context_device_id ;;
  }

  dimension: context_device_manufacturer {
    type: string
    sql: ${TABLE}.context_device_manufacturer ;;
  }

  dimension: context_device_model {
    type: string
    sql: ${TABLE}.context_device_model ;;
  }

  dimension: context_device_name {
    type: string
    sql: ${TABLE}.context_device_name ;;
  }

  dimension: context_device_type {
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: context_ip {
    type: string
    sql: ${TABLE}.context_ip ;;
  }

  dimension: context_library_name {
    type: string
    sql: ${TABLE}.context_library_name ;;
  }

  dimension: context_library_version {
    type: string
    sql: ${TABLE}.context_library_version ;;
  }

  dimension: context_locale {
    type: string
    sql: ${TABLE}.context_locale ;;
  }

  dimension: context_network_bluetooth {
    type: string
    sql: ${TABLE}.context_network_bluetooth ;;
  }

  dimension: context_network_carrier {
    type: string
    sql: ${TABLE}.context_network_carrier ;;
  }

  dimension: context_network_cellular {
    type: string
    sql: ${TABLE}.context_network_cellular ;;
  }

  dimension: context_network_wifi {
    type: string
    sql: ${TABLE}.context_network_wifi ;;
  }

  dimension: context_os_name {
    type: string
    sql: ${TABLE}.context_os_name ;;
  }

  dimension: context_os_version {
    type: string
    sql: ${TABLE}.context_os_version ;;
  }

  dimension: context_protocols_source_id {
    type: string
    sql: ${TABLE}.context_protocols_source_id ;;
  }

  dimension: context_timezone {
    type: string
    sql: ${TABLE}.context_timezone ;;
  }

  dimension: context_traits_anonymous_id {
    type: string
    sql: ${TABLE}.context_traits_anonymous_id ;;
  }

  dimension: context_user_agent {
    type: string
    sql: ${TABLE}.context_user_agent ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: event_text {
    type: string
    sql: ${TABLE}.event_text ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension_group: loaded_at {
    type: time
    sql: ${TABLE}.loaded_at ;;
  }

  dimension_group: original_timestamp {
    type: time
    sql: ${TABLE}.original_timestamp ;;
  }

  dimension_group: received_at {
    type: time
    sql: ${TABLE}.received_at ;;
  }

  dimension_group: sent_at {
    type: time
    sql: ${TABLE}.sent_at ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension_group: uuid_ts {
    type: time
    sql: ${TABLE}.uuid_ts ;;
  }

  set: detail {
    fields: [
      metadata,
      payment_method,
      anonymous_id,
      context_app_build,
      context_app_namespace,
      context_app_version,
      context_device_ad_tracking_enabled,
      context_device_id,
      context_device_manufacturer,
      context_device_model,
      context_device_name,
      context_device_type,
      context_ip,
      context_library_name,
      context_library_version,
      context_locale,
      context_network_bluetooth,
      context_network_carrier,
      context_network_cellular,
      context_network_wifi,
      context_os_name,
      context_os_version,
      context_protocols_source_id,
      context_timezone,
      context_traits_anonymous_id,
      context_user_agent,
      event,
      event_text,
      id,
      loaded_at_time,
      original_timestamp_time,
      received_at_time,
      sent_at_time,
      timestamp_time,
      uuid_ts_time
    ]
  }
}
