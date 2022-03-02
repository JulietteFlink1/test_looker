view: monitoring_metrics {
  derived_table: {
    sql:WITH events AS (
    SELECT
        tracks.anonymous_id,
        tracks.context_app_version,
        CAST(NULL AS BOOL) AS context_device_ad_tracking_enabled,
        tracks.context_device_id,
        tracks.context_device_type,
        tracks.context_ip,
        tracks.context_locale,
        tracks.context_protocols_source_id,
        tracks.event,
        tracks.id,
        tracks.timestamp
      FROM
        `flink-data-prod.flink_ios_production.tracks` tracks
        where {% condition filter_event_date %} date(_partitiontime) {% endcondition %}
        and {% condition filter_event_date %} date(timestamp) {% endcondition %}
        QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY timestamp DESC) = 1
    AND event not like 'api%'
      and event not in ('application_opened', 'application_updated', 'application_backgrounded')

        -- correct app_version contains only numbers (format 2.17.0), no letters
      and (regexp_contains(context_app_version, '[a-zA-Z]') is false
            or context_app_version is null)

        -- test traffic based on QA email
      and (lower(context_traits_email) != "qa@goflink.com"
           or context_traits_email is null)

        -- test traffic based on hubs with test suffix, and hub 'erp_spitzbergen'
      and (context_traits_hub_slug != 'erp_spitzbergen' or context_traits_hub_slug is null)

      and (context_traits_hub_slug not like "%test%" or context_traits_hub_slug is null)
    UNION ALL
    SELECT
    tracks.anonymous_id,
    tracks.context_app_version,
    tracks.context_device_ad_tracking_enabled,
    tracks.context_device_id,
    tracks.context_device_type,
    tracks.context_ip,
    tracks.context_locale,
    tracks.context_protocols_source_id,
    tracks.event,
    tracks.id,
    tracks.timestamp
    FROM
      `flink-data-prod.flink_android_production.tracks` tracks
      where {% condition filter_event_date %} date(_partitiontime) {% endcondition %}
        and {% condition filter_event_date %} date(timestamp) {% endcondition %}
        QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY timestamp DESC) = 1
    AND event not like 'api%'
      and event not in ('application_opened', 'application_updated', 'application_backgrounded')

        -- correct app_version contains only numbers (format 2.17.0), no letters
      and (regexp_contains(context_app_version, '[a-zA-Z]') is false
            or context_app_version is null)

        -- test traffic based on QA email
      and (lower(context_traits_email) != "qa@goflink.com"
           or context_traits_email is null)

        -- test traffic based on hubs with test suffix, and hub 'erp_spitzbergen'
      and (context_traits_hub_slug != 'erp_spitzbergen' or context_traits_hub_slug is null)

      and (context_traits_hub_slug not like "%test%" or context_traits_hub_slug is null)
),

paymentfailed_tb AS (
    SELECT
      paymentfail.id,
      paymentfail.metadata AS metadata,
      paymentfail.payment_method,
    FROM `flink-data-prod.flink_ios_production.payment_failed_view` paymentfail
    UNION ALL
    SELECT
      paymentfail.id,
      paymentfail.meta_data AS metadata,
      paymentfail.payment_method,
    FROM `flink-data-prod.flink_android_production.payment_failed_view` paymentfail
)

SELECT *
FROM events
LEFT JOIN paymentfailed_tb
ON paymentfailed_tb.id=events.id
       ;;
  }

  filter: filter_event_date {
    label: "Filter: Event Date"
    type: date
    datatype: date
  }

  dimension: is_impression {
    type: yesno
    sql: ${TABLE}.event = 'product_impression' ;;
  }

  measure: product_impressions {
    type: count
    label: "# Product Impressions"
    filters: [event: "product_impression"]
  }

  measure: count {
    type: count
    label: "# All Events"
    drill_fields: [detail*]
  }

  ### custom measures
  measure: cnt_cartviewed {
    group_label: "Checkout Events"
    type: count
    filters: [event: "cart_viewed"]
  }

  measure: cnt_checkoutstarted {
    group_label: "Checkout Events"
    type: count
    filters: [event: "checkout_started"]
  }

  measure: cnt_paymentfailure {
    group_label: "Checkout Events"
    type: count
    filters: [event: "payment_failed"]
  }

  measure: cnt_paymentstarted {
    group_label: "Checkout Events"
    type: count
    filters: [event: "purchase_confirmed"]
  }

  measure: cnt_paymentcomplete {
    group_label: "Checkout Events"
    type: count
    filters: [event: "payment_method_added"]
  }

  measure: cnt_orderplaced {
    group_label: "Checkout Events"
    type: count
    filters: [event: "order_placed"]
  }

  measure: cnt_payment_otheroutcome {
    group_label: "Checkout Events"
    type: number
    sql: ${cnt_paymentstarted}-${cnt_paymentcomplete}-${cnt_paymentfailure} ;;
  }

  measure: cartviewed_per_checkoutstarted  {
    group_label: "Checkout Events"
    type: number
    sql: ${monitoring_metrics.cnt_cartviewed}/NULLIF(${monitoring_metrics.cnt_checkoutstarted},0) ;;
    value_format_name: decimal_1
    drill_fields: [timestamp_date, cartviewed_per_checkoutstarted]
    link: {
      label: "# Events CartViewed to CheckoutStarted Times Series"
      url: "/looks/726"
    }
  }

  measure: checkoutstarted_per_paymentstarted  {
    group_label: "Checkout Events"
    type: number
    sql: ${monitoring_metrics.cnt_checkoutstarted}/NULLIF(${monitoring_metrics.cnt_paymentstarted},0) ;;
    value_format_name: decimal_1
    drill_fields: [timestamp_date, checkoutstarted_per_paymentstarted]
    link: {
      label: "# Events CheckoutStarted To PaymentStarted Times Series"
      url: "/looks/681"
    }
  }

  measure: unique_checkoutstarted_per_paymentstarted_perc  {
    group_label: "Checkout Events"
    type: number
    sql: ${monitoring_metrics.cnt_unique_paymentstarted}/NULLIF(${monitoring_metrics.cnt_unique_checkoutstarted},0) ;;
    value_format_name: percent_1
    drill_fields: [timestamp_date, unique_checkoutstarted_per_paymentstarted_perc]
    link: {
      label: "% Unique IDs From CheckoutStarted To PaymentStarted Times Series"
      url: "/looks/724"
    }
  }

  measure: paymentstarted_per_orderplaced  {
    group_label: "Checkout Events"
    type: number
    sql: ${monitoring_metrics.cnt_paymentstarted}/NULLIF(${monitoring_metrics.cnt_orderplaced},0) ;;
    value_format_name: decimal_1
    drill_fields: [timestamp_date, paymentstarted_per_orderplaced]
    link: {
      label: "# Events PaymentStarted to OrderPlaced Times Series"
      url: "/looks/679"
    }
  }

  measure: unique_paymentstarted_per_orderplaced_perc  {
    group_label: "Checkout Events"
    type: number
    sql: ${monitoring_metrics.cnt_unique_orderplaced}/NULLIF(${monitoring_metrics.cnt_unique_paymentstarted},0) ;;
    value_format_name: percent_1
    drill_fields: [timestamp_date, unique_paymentstarted_per_orderplaced_perc]
    link: {
      label: "% Unique IDs From PaymentStarted to OrderPlaced Times Series"
      url: "/looks/725"
    }
  }

  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    description: "Number of Unique Users as per Segment Aonymous ID"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  measure: cnt_unique_cartviewed {
    group_label: "Checkout Events"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "cart_viewed"]
  }

  measure: cnt_unique_checkoutstarted {
    group_label: "Checkout Events"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "checkout_started"]
  }

  measure: cnt_unique_paymentfailure {
    group_label: "Checkout Events"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "payment_failed"]
  }

  measure: perc_unique_paymentfailure {
    group_label: "Checkout Events"
    type: percent_of_total
    sql: ${cnt_unique_anonymousid};;
    value_format: "0.0\%"
    drill_fields: [timestamp_date, perc_unique_paymentfailure]
    link: {
      label: "% Of PaymentStarted To PaymentFailed Times Series"
      url: "/looks/721"
    }
  }

  measure: cnt_unique_paymentstarted {
    group_label: "Checkout Events"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "purchase_confirmed"]
  }

  measure: cnt_unique_paymentcomplete {
    group_label: "Checkout Events"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "payment_method_added"]
  }

  measure: cnt_unique_orderplaced {
    group_label: "Checkout Events"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [event: "order_placed"]
  }

  measure: cnt_unique_payment_otheroutcome {
    group_label: "Checkout Events"
    type: number
    sql: ${cnt_unique_paymentstarted}-${cnt_unique_paymentcomplete}-${cnt_unique_paymentfailure} ;;
  }

  measure: latest_app_version {
    type:  string
    hidden: yes
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
    group_label: "Device Dimensions"
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }

  dimension: payment_status {
    group_label: "Checkout Dimensions"
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
    group_label: "Checkout Dimensions"
    type: string
    sql: ${TABLE}.metadata ;;
  }

  dimension: payment_method {
    group_label: "Checkout Dimensions"
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: anonymous_id {
    group_label: "IDs"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: context_app_version {
    group_label: "Device Dimensions"
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_ad_tracking_enabled {
    group_label: "Device Dimensions"
    type: string
    sql: ${TABLE}.context_device_ad_tracking_enabled ;;
  }

  dimension: context_device_id {
    group_label: "IDs"
    type: string
    sql: ${TABLE}.context_device_id ;;
  }

  dimension: context_device_type {
    group_label: "Device Dimensions"
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: context_ip {
    group_label: "Device Dimensions"
    type: string
    sql: ${TABLE}.context_ip ;;
  }

  dimension: context_locale {
    group_label: "Device Dimensions"
    type: string
    sql: ${TABLE}.context_locale ;;
  }

  dimension: context_protocols_source_id {
    group_label: "IDs"
    type: string
    sql: ${TABLE}.context_protocols_source_id ;;
  }

  dimension: event {
    label: "Event Name"
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: id {
    group_label: "IDs"
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension_group: timestamp {
    type: time
    timeframes: [
      date
    ]
    sql: ${TABLE}.timestamp
    ;;
  }

  set: detail {
    fields: [
      metadata,
      payment_method,
      anonymous_id,
      context_app_version,
      context_device_ad_tracking_enabled,
      context_device_id,
      context_device_type,
      context_ip,
      context_locale,
      context_protocols_source_id,
      event,
      id,
      timestamp_date
    ]
  }
}
