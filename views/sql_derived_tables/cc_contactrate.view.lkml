view: cc_contactrate__tag_names {
  dimension: cc_contactrate__tag_names {
    type: string
    sql: cc_contactrate__tag_names ;;
  }
}

view: cc_contactrate {
  derived_table: {
    sql:
      WITH cs_tb AS (
        SELECT
            c.* EXCEPT(platform),
            LOWER(platform) AS platform,
            TRIM(REGEXP_EXTRACT(contact_reason, r'(.+?) -')) AS contact_reason_l1,
            conversation_created_timestamp AS creation_timestamp,
            NULL AS order_timestamp,
            NULL AS order_number
        FROM flink-data-prod.curated.cc_conversations c

        UNION ALL

          SELECT
          NULL, NULL, NULL, NULL, NULL,
          NULL, NULL, NULL, NULL, NULL,
          NULL, NULL, NULL, NULL, NULL,
          NULL, NULL, NULL, NULL, NULL,
          NULL, NULL, NULL, NULL, NULL,
          NULL, NULL, NULL, NULL, NULL,
          NULL, NULL, NULL, NULL, NULL,
          NULL, NULL, NULL, country_iso, NULL,
          NULL, NULL, NULL, NULL, NULL,
          NULL, NULL, NULL, NULL,
          LOWER(platform) AS platform,
          NULL AS contact_reason_l1,
          order_timestamp AS creation_timestamp,
          order_timestamp,
          order_number
        FROM flink-data-prod.curated.orders
      )
      SELECT *
      FROM cs_tb
      WHERE ({% condition contact_reason_l1l2_filter %} contact_reason {% endcondition %} OR (contact_reason IS NULL AND conversation_uuid IS NULL))
      AND ({% condition contact_reason_l3_filter %} contact_reason_l3 {% endcondition %} OR (contact_reason IS NULL AND conversation_uuid IS NULL))
      AND ({% condition conversation_type_filter %} source_type {% endcondition %} OR (contact_reason IS NULL AND conversation_uuid IS NULL))
       ;;
  }

  dimension: date_granularity {
    label: "Event Time (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    sql:
    {% if timeframe_picker._parameter_value == 'Hour' %}
      ${creation_timestamp_hour}
    {% elsif timeframe_picker._parameter_value == 'Day' %}
      ${creation_timestamp_date}
    {% elsif timeframe_picker._parameter_value == 'Week' %}
      ${creation_timestamp_week}
    {% elsif timeframe_picker._parameter_value == 'Month' %}
      ${creation_timestamp_month}
    {% endif %};;
  }

  parameter: timeframe_picker {
    label: "Event Time Granularity"
    type: unquoted
    allowed_value: { value: "Hour" }
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  dimension: platform {
    description: "Platform from which order or conversation originated"
    type: string
    case: {
      when: {
        sql: ${TABLE}.platform = "android" ;;
        label: "Android"
      }
      when: {
        sql: ${TABLE}.platform = "ios" ;;
        label: "iOS"
      }
      else: "Unknown"
    }
  }

  filter: contact_reason_l3_filter {
    label: "Contact Reason L3 Filter"
    type: string
    suggest_dimension: contact_reason_l3
    sql: EXISTS (SELECT ${creation_timestamp_time} FROM ${TABLE} WHERE {% condition %} contact_reason_l3 {% endcondition %}) ;;
  }

  filter: contact_reason_l1l2_filter {
    label: "Contact Reason L1/L2 Filter"
    type: string
    suggest_dimension: contact_reason
    sql: EXISTS (SELECT ${creation_timestamp_time} FROM ${TABLE} WHERE {% condition %} contact_reason {% endcondition %}) ;;
  }

  filter: conversation_type_filter {
    label: "Conversation Type Filter"
    type: string
    suggest_dimension: conversation_type
    sql: EXISTS (SELECT ${creation_timestamp_time} FROM ${TABLE} WHERE {% condition %} source_type {% endcondition %}) ;;
  }

  measure: cnt_orders {
    label: "# unique orders"
    description: "cnt orders by order date"
    type: count_distinct
    sql: CASE WHEN ${conversation_uuid} IS NULL
         THEN ${order_number}
         ELSE NULL
         END ;;
  }

  measure: cnt_conversations {
    label: "# unique conversations"
    description: "cnt conversations by creation date"
    type: count_distinct
    sql: ${conversation_uuid} ;;
  }

  measure: cnt_agent_conversations {
    label: "# agent conversations"
    description: "cnt conversations in which a CC agent participated"
    type: count_distinct
    sql:  ${conversation_uuid} ;;
    filters: [is_deflected_by_bot: "no", agent_id: "NOT NULL"]
  }

  measure: perc_agent_conversations {
    label: "% conversations involving a CC agent"
    description: "percentage of conversations that were handled by a CC agent"
    type: number
    sql: SAFE_DIVIDE(${cnt_agent_conversations},${cnt_conversations}) ;;
    value_format_name: percent_1
  }

  measure: cnt_live_order_conversations {
    # have to include it as a separate measure here because orders are not linked to a contact reason, so if we filter by contact reason we cannot get a % compared to orders (because # orders will always be 0)
    label: "# conversations - live order"
    type: count_distinct
    sql: ${conversation_uuid} ;;
    filters: [contact_reason_l1: "Live Order"]
  }

  measure: cnt_cancellation_conversations {
    # have to include it as a separate measure here because orders are not linked to a contact reason, so if we filter by contact reason we cannot get a % compared to orders (because # orders will always be 0)
    label: "# conversations - cancellation"
    type: count_distinct
    sql: ${conversation_uuid} ;;
    filters: [secondary_contact_reason: "Cancellation"]
  }

  # measure: perc_cancellation_cr{
  #   label: "% cancellation contact rate"
  #   description: "percentage of conversations with cancellation contact reasion, compared to number of conversations"
  #   type: number
  #   sql: SAFE_DIVIDE(${cnt_cancellation_conversations},${cnt_conversations}) ;;
  #   value_format_name: percent_1
  # }

  measure: cnt_invoice_request_conversations {
    # have to include it as a separate measure here because orders are not linked to a contact reason, so if we filter by contact reason we cannot get a % compared to orders (because # orders will always be 0)
    label: "# conversations - invoice request"
    type: count_distinct
    sql: ${conversation_uuid} ;;
    filters: [contact_reason_l3: "invoice request"]
  }

  # measure: perc_invoice_request_cr{
  #   label: "% invoice requests compared to # conversations"
  #   description: "percentage of conversations with invoice request L3 compared to total conversations"
  #   type: number
  #   sql: SAFE_DIVIDE(${cnt_invoice_request_conversations},${cnt_conversations}) ;;
  #   value_format_name: percent_1
  # }

  measure: cnt_deflected_by_bot {
    label: "# unique conversations deflected by bot"
    description: "cnt conversations deflected by bot"
    type: count_distinct
    sql: ${conversation_uuid} ;;
    filters: [is_deflected_by_bot: "yes"]
  }

  measure: perc_deflected_by_bot {
    label: "% conversations deflected by bot"
    description: "percentage of conversations that were deflected by bot"
    type: number
    sql: SAFE_DIVIDE(${cnt_deflected_by_bot},${cnt_conversations}) ;;
    value_format_name: percent_1
  }

  dimension: secondary_contact_reason {
    label: "Contact Reason L2"
    type: string
    sql: TRIM(REGEXP_EXTRACT(contact_reason, r'[a-zA-Z]* - (.*)'));;
  }

  dimension: combined_l2l3_contact_reason {
    label: "Contact Reason L2/L3"
    type: string
    sql: IFNULL(${secondary_contact_reason},'') || IF(${contact_reason_l3} IS NULL, '', '/ ') || IFNULL(${contact_reason_l3},'');;
  }

  dimension: full_contact_reason {
    label: "Contact Reason L1/L2/L3"
    type: string
    sql: IFNULL(${contact_reason},'') || IF(${contact_reason_l3} IS NULL, '', '/ ') || IFNULL(${contact_reason_l3},'');;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: conversation_uuid {
    type: number
    sql: ${TABLE}.conversation_uuid ;;
  }

  dimension: conversation_type {
    type: string
    case: {
      when: {
        sql: ${TABLE}.source_type = "conversation" ;;
        label: "Conversation"
      }
      when: {
        sql: ${TABLE}.source_type = "email" ;;
        label: "Email"
      }
      else: "Other"
    }
  }

  dimension_group: conversation_updated_timestamp {
    type: time
    sql: ${TABLE}.conversation_updated_timestamp ;;
  }

  dimension_group: conversation_created_timestamp {
    type: time
    sql: ${TABLE}.conversation_created_timestamp ;;
  }

  dimension: contact_reason {
    label: "Contact Reason L1/L2"
    type: string
    sql: ${TABLE}.contact_reason ;;
  }

  dimension: contact_reason_l1 {
    label: "Contact Reason L1"
    type: string
    sql: ${TABLE}.contact_reason_l1 ;;
  }

  dimension: contact_reason_l3 {
    label: "Contact Reason L3"
    type: string
    sql: ${TABLE}.contact_reason_l3 ;;
  }

  dimension: agent_id {
    type: number
    sql: ${TABLE}.agent_id ;;
  }

  dimension: count_assignments {
    type: number
    sql: ${TABLE}.count_assignments ;;
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

  dimension: count_conversation_parts {
    type: number
    sql: ${TABLE}.count_conversation_parts ;;
  }

  dimension_group: last_close_timestamp {
    type: time
    sql: ${TABLE}.last_close_timestamp ;;
  }

  dimension_group: first_close_timestamp {
    type: time
    sql: ${TABLE}.first_close_timestamp ;;
  }

  dimension_group: first_contact_reply_timestamp {
    type: time
    sql: ${TABLE}.first_contact_reply_timestamp ;;
  }

  dimension_group: last_contact_reply_timestamp {
    type: time
    sql: ${TABLE}.last_contact_reply_timestamp ;;
  }

  dimension: median_time_to_reply {
    type: number
    sql: ${TABLE}.median_time_to_reply ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: tag_names {
    type: string
    sql: ${TABLE}.tag_names ;;
  }

  dimension: rating_remark {
    type: string
    sql: ${TABLE}.rating_remark ;;
  }

  dimension: rating {
    type: number
    sql: ${TABLE}.rating ;;
  }

  dimension_group: rating_created_timestamp {
    type: time
    sql: ${TABLE}.rating_created_timestamp ;;
  }

  dimension: conv_email {
    type: string
    sql: ${TABLE}.conv_email ;;
  }

  dimension_group: conv_ingestion_timestamp {
    type: time
    sql: ${TABLE}.conv_ingestion_timestamp ;;
  }

  dimension: contact_id {
    type: string
    sql: ${TABLE}.contact_id ;;
  }

  dimension_group: last_contact_updated_timestamp {
    type: time
    sql: ${TABLE}.last_contact_updated_timestamp ;;
  }

  dimension: is_deflected_by_bot {
    type: yesno
    sql: ${TABLE}.is_deflected_by_bot ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: contact_created_timestamp {
    type: time
    sql: ${TABLE}.contact_created_timestamp ;;
  }

  dimension: contact_email {
    type: string
    sql: ${TABLE}.contact_email ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: contact_country_iso {
    type: string
    sql: ${TABLE}.contact_country_iso ;;
  }

  dimension: first_order {
    type: yesno
    sql: ${TABLE}.first_order ;;
  }

  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
  }

  dimension: voucher_code {
    type: string
    sql: ${TABLE}.voucher_code ;;
  }

  dimension: is_whatsapp_contact {
    type: yesno
    sql: ${TABLE}.is_whatsapp_contact ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension_group: creation_timestamp {
    label: "Event Timestamp"
    type: time
    sql: ${TABLE}.creation_timestamp ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension_group: order_timestamp {
    type: time
    sql: ${TABLE}.order_timestamp ;;
  }

  set: detail {
    fields: [
      conversation_uuid,
      conversation_type,
      conversation_updated_timestamp_time,
      conversation_created_timestamp_time,
      contact_reason,
      contact_reason_l3,
      count_assignments,
      time_to_assignment,
      time_to_first_close,
      time_to_last_close,
      count_conversation_parts,
      last_close_timestamp_time,
      first_close_timestamp_time,
      first_contact_reply_timestamp_time,
      last_contact_reply_timestamp_time,
      median_time_to_reply,
      country_iso,
      tag_names,
      rating_remark,
      rating,
      rating_created_timestamp_time,
      conv_email,
      conv_ingestion_timestamp_time,
      contact_id,
      last_contact_updated_timestamp_time,
      is_deflected_by_bot,
      name,
      user_id,
      contact_created_timestamp_time,
      contact_email,
      hub_code,
      contact_country_iso,
      first_order,
      total_orders,
      voucher_code,
      is_whatsapp_contact,
      platform,
      app_version,
      creation_timestamp_time,
      order_number,
      order_timestamp_time
    ]
  }
}
