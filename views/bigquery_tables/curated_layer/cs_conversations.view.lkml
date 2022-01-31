view: cs_conversations {
  sql_table_name: `flink-data-dev.sandbox.cs_conversations`
    ;;

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: main_contact_reason {
    type: string
    sql: REGEXP_EXTRACT(${contact_reason}, r'(.+?) -') ;;
  }

  dimension_group: contact_created_timestamp {
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
    sql: ${TABLE}.contact_created_timestamp ;;
  }

  dimension: contact_email {
    type: string
    sql: ${TABLE}.contact_email ;;
  }

  dimension: contact_id {
    type: string
    sql: ${TABLE}.contact_id ;;
  }

  dimension: contact_reason {
    type: string
    sql: ${TABLE}.contact_reason ;;
  }

  dimension: contact_reason_l3 {
    type: string
    sql: ${TABLE}.contact_reason_l3 ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: conv_email {
    type: string
    sql: ${TABLE}.conv_email ;;
  }

  dimension_group: conv_ingestion_timestamp {
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
    sql: ${TABLE}.conv_ingestion_timestamp ;;
  }

  dimension_group: conversation_created_timestamp {
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
    sql: ${TABLE}.conversation_created_timestamp ;;
  }

  dimension: conversation_type {
    type: string
    sql: ${TABLE}.conversation_type ;;
  }

  dimension_group: conversation_updated_timestamp {
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
    sql: ${TABLE}.conversation_updated_timestamp ;;
  }

  dimension: conversation_uuid {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.conversation_uuid ;;
  }

  dimension: count_assignments {
    type: number
    sql: ${TABLE}.count_assignments ;;
  }

  dimension: count_conversation_parts {
    type: number
    sql: ${TABLE}.count_conversation_parts ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.Country ;;
  }

  dimension: country_code {
    type: string
    sql: ${TABLE}.country_code ;;
  }

  dimension: deflected_by_bot {
    type: yesno
    sql: ${TABLE}.deflected_by_bot ;;
  }

  dimension_group: first_close_timestamp {
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
    sql: ${TABLE}.first_close_timestamp ;;
  }

  dimension_group: first_contact_reply_timestamp {
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
    sql: ${TABLE}.first_contact_reply_timestamp ;;
  }

  dimension: first_order {
    type: yesno
    sql: ${TABLE}.first_order ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_whatsapp_contact {
    type: yesno
    sql: ${TABLE}.is_whatsapp_contact ;;
  }

  dimension_group: last_close_timestamp {
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
    sql: ${TABLE}.last_close_timestamp ;;
  }

  dimension_group: last_contact_reply_timestamp {
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
    sql: ${TABLE}.last_contact_reply_timestamp ;;
  }

  dimension_group: last_contact_updated_timestamp {
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
    sql: ${TABLE}.last_contact_updated_timestamp ;;
  }

  dimension: median_time_to_reply {
    type: number
    sql: ${TABLE}.median_time_to_reply ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: rating {
    type: number
    sql: ${TABLE}.rating ;;
  }

  dimension_group: rating_created_timestamp {
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
    sql: ${TABLE}.rating_created_timestamp ;;
  }

  dimension: rating_remark {
    type: string
    sql: ${TABLE}.rating_remark ;;
  }

  dimension: tag_names {
    hidden: yes
    sql: ${TABLE}.tag_names ;;
  }

  dimension: time_to_assignment {
    type: number
    sql: ${TABLE}.time_to_assignment ;;
  }

  dimension: time_to_first_close {
    type: number
    sql: ${TABLE}.time_to_first_close ;;
  }

  dimension: time_to_last_close {
    type: number
    sql: ${TABLE}.time_to_last_close ;;
  }

  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: voucher_code {
    type: string
    sql: ${TABLE}.voucher_code ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}

view: cs_conversations__tag_names {
  dimension: cs_conversations__tag_names {
    type: string
    sql: cs_conversations__tag_names ;;
  }
}
