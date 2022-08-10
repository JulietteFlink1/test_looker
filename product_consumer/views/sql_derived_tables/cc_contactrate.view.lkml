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
            c.contact_uuid as conversation_uuid,
            c.intercom_user_id as contact_id,
            c.contact_created_timestamp as conversation_created_timestamp,
            c.contact_created_date as conversation_created_hour,
            c.contact_created_hour as conversation_created_hour,
            c.contact_created_day_of_week as conversation_created_day_of_week,
            c.timezone,
            c.contact_reason_l3 as contact_reason,
            c.contact_reason_l3,
            c.number_of_assignments,
            c.time_to_assignement_seconds,
            c.time_to_assignement_minutes,
            c.time_to_first_close_minutes,
            c.time_to_first_close_seconds,
            c.time_to_last_close_seconds,
            c.time_to_last_close_minutes,
            c.number_of_contact_parts as number_of_conversation_parts,
            c.number_of_reopens,
            c.last_close_timestamp,
            c.first_close_timestamp,
            c.first_user_reply_timestamp as first_contact_reply_timestamp,
            c.first_agent_reply_timestamp,
            c.last_user_reply_timestamp as last_contact_reply_timestamp,
            c.time_to_agent_reply_seconds,
            c.time_to_agent_reply_minutes,
            c.median_time_to_reply_seconds,
            c.median_time_to_reply_minutes,
            c.tag_names,
            c.rating_remark,
            c.rating,
            c.rating_created_timestamp,
            c.is_refunded,
            c.user_email as contact_email,
            c.source_type,
            c.source_author_type,
            c.is_closed,
            c.is_snoozed_contact as is_snoozed_conversation,
            c.is_abandoned_by_user as is_abandoned_by_contact,
            c.country_iso,
            c.team_id,
            c.team_name,
            c.agent_id,
            c.is_deflected_by_bot,
            c.agent_email,
            c.agent_name,
            c.user_name as contact_name,
            c.user_id,
            c.user_created_timestamp as contact_created_timestamp,
            c.is_whatsapp_user as is_whatsapp_contact,
            lower(c.platform) as platform,
            TRIM(REGEXP_EXTRACT(contact_reason_l3, r'(.+?) -')) AS contact_reason_l1,
            contact_created_timestamp AS creation_timestamp,
            NULL AS order_timestamp,
            NULL AS order_number,
            c.user_phone_number
        FROM flink-data-prod.curated.cc_contacts c

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
      order_number,
      NULL AS user_phone_number
      FROM flink-data-prod.curated.orders
      )
      SELECT *
      FROM cs_tb
      WHERE ({% condition contact_reason_l1l2_filter %} contact_reason_l3 {% endcondition %} OR (contact_reason_l3 IS NULL AND conversation_uuid IS NULL))
      AND ({% condition contact_reason_l3_filter %} contact_reason_l3 {% endcondition %} OR (contact_reason_l3 IS NULL AND conversation_uuid IS NULL))
      AND ({% condition conversation_type_filter %} source_type {% endcondition %} OR (contact_reason_l3 IS NULL AND conversation_uuid IS NULL))
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
    sql: EXISTS (SELECT ${creation_timestamp_time} FROM ${TABLE} WHERE {% condition %} contact_reason_l3 {% endcondition %}) ;;
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
    description: "cnt conversations"
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
    sql: IFNULL(${contact_reason_l3},'') || IF(${contact_reason_l3} IS NULL, '', '/ ') || IFNULL(${contact_reason_l3},'');;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: agent_email {
    group_label: "* Agent & Team *"
    description: "Email of the last agent who took part in the conversation"
    type: string
    sql: ${TABLE}.agent_email ;;
  }

  dimension: agent_id {
    group_label: "* Agent & Team *"
    description: "ID of the last agent who took part in the conversation"
    type: number
    sql: ${TABLE}.agent_id ;;
  }

  dimension: agent_name {
    group_label: "* Agent & Team *"
    description: "Name of the last agent who took part in the conversation"
    type: string
    sql: ${TABLE}.agent_name ;;
  }

  dimension_group: contact_created {
    group_label: "* Contact *"
    type: time
    timeframes: [
      date,
    ]
    sql: ${TABLE}.contact_created_timestamp ;;
  }

  dimension: contact_email {
    group_label: "* Contact *"
    type: string
    description: "Email of the user who created the conversation"
    sql: ${TABLE}.contact_email ;;
  }

  dimension: contact_id {
    group_label: "* Contact *"
    type: number
    description: "ID of the user who created the conversation"
    sql: ${TABLE}.contact_id ;;
  }

  dimension: contact_name {
    group_label: "* Contact *"
    type: string
    description: "Name of the user who created the conversation"
    sql: ${TABLE}.contact_name ;;
  }

  dimension_group: first_agent_reply {
    type: time
    group_label: "* Dates & Timestamps *"
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    hidden: yes
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_agent_reply_timestamp ;;
  }

  dimension_group: conversation_created {
    type: time
    group_label: "* Dates & Timestamps *"
    timeframes: [
      time,
      date,
      week,
      hour,
      month,
      year
    ]
    sql: ${TABLE}.conversation_created_timestamp ;;
  }

  dimension: conversation_uuid {
    type: number
    value_format_name: id
    label: "Conversation ID"
    sql: ${TABLE}.conversation_uuid ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: is_first_reply_the_same_day {
    type: yesno
    group_label: "* Dates & Timestamps *"
    sql: case when date(${conversation_created_date}) = date(${first_agent_reply_date}) then true else false end ;;
  }

  dimension_group: first_close_timestamp {
    type: time
    hidden: yes
    group_label: "* Dates & Timestamps *"
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

  dimension_group: first_contact_reply {
    type: time
    hidden: yes
    group_label: "* Dates & Timestamps *"
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

  dimension: is_deflected_by_bot {
    group_label: "* Conversation Attributes *"
    type: yesno
    sql: ${TABLE}.is_deflected_by_bot ;;
  }

  dimension: is_closed {
    group_label: "* Conversation Attributes *"
    type: yesno
    sql: ${TABLE}.is_closed ;;
  }

  dimension: is_abandoned_by_contact {
    group_label: "* Conversation Attributes *"
    type: yesno
    sql: ${TABLE}.is_abandoned_by_contact ;;
  }

  dimension: is_refunded {
    group_label: "* Conversation Attributes *"
    type: yesno
    sql: ${TABLE}.is_refunded ;;
  }

  dimension: is_whatsapp_contact {
    group_label: "* Contact *"
    type: yesno
    sql: ${TABLE}.is_whatsapp_contact ;;
  }

  dimension_group: last_close {
    type: time
    group_label: "* Dates & Timestamps *"
    timeframes: [
      time,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.last_close_timestamp ;;
  }

  dimension_group: last_contact_reply {
    type: time
    group_label: "* Dates & Timestamps *"
    timeframes: [
      time,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.last_contact_reply_timestamp ;;
  }

  dimension: median_time_to_reply_seconds {
    type: number
    hidden: yes
    group_label: "* Conversation Statistics *"
    sql: ${TABLE}.median_time_to_reply_seconds ;;
  }

  dimension: median_time_to_reply_minutes {
    type: number
    hidden: yes
    group_label: "* Conversation Statistics *"
    sql: ${TABLE}.median_time_to_reply_minutes ;;
  }

  dimension: conversation_hour {
    type: number
    group_label: "* Dates & Timestamps *"
    sql:  ${TABLE}.conversation_created_hour ;;
  }

  dimension: number_of_assignments {
    hidden: yes
    group_label: "* Conversation Statistics *"
    type: number
    sql: ${TABLE}.number_of_assignments ;;
  }

  dimension: number_of_conversation_parts {
    type: number
    hidden:yes
    group_label: "* Conversation Statistics *"
    sql: ${TABLE}.number_of_conversation_parts ;;
  }

  dimension: rating {
    group_label: "* Conversation Attributes *"
    type: number
    sql: ${TABLE}.rating ;;
  }

  dimension_group: rating_created {
    type: time
    group_label: "* Dates & Timestamps *"
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.rating_created_timestamp ;;
  }

  dimension: rating_remark {
    group_label: "* Conversation Attributes *"
    type: string
    sql: ${TABLE}.rating_remark ;;
  }

  dimension: source_author_type {
    group_label: "* Conversation Attributes *"
    type: string
    sql: ${TABLE}.source_author_type ;;
  }

  dimension: source_type {
    group_label: "* Conversation Attributes *"
    type: string
    sql: ${TABLE}.source_type ;;
  }

  dimension: tag_names {
    group_label: "* Conversation Attributes *"
    type: string
    sql: ${TABLE}.tag_names ;;
  }

  dimension: team_id {
    group_label: "* Agent & Team *"
    description: "ID of the last team who took part in the conversation"
    type: number
    sql: ${TABLE}.team_id ;;
  }

  dimension: team_name {
    group_label: "* Agent & Team *"
    description: "Team of the last team who took part in the conversation"
    type: string
    sql: ${TABLE}.team_name ;;
  }

  dimension: time_to_agent_reply_seconds {
    group_label: "* Conversation Statistics *"
    hidden: yes
    type: number
    sql: ${TABLE}.time_to_agent_reply_seconds ;;
  }

  dimension: time_to_agent_reply_minutes {
    hidden: yes
    group_label: "* Conversation Statistics *"
    type: number
    sql: ${TABLE}.time_to_agent_reply_minutes ;;
  }

  dimension: time_to_assignement_seconds {
    group_label: "* Conversation Statistics *"
    type: number
    hidden: yes
    sql: ${TABLE}.time_to_assignement_seconds ;;
  }

  dimension: time_to_first_close_seconds {
    group_label: "* Conversation Statistics *"
    type: number
    hidden: yes
    sql: ${TABLE}.time_to_first_close_seconds ;;
  }

  dimension: time_to_last_close_seconds {
    group_label: "* Conversation Statistics *"
    type: number
    hidden: yes
    sql: ${TABLE}.time_to_last_close_seconds ;;
  }

  dimension: time_to_first_close_minutes {
    group_label: "* Conversation Statistics *"
    type: number
    hidden: yes
    sql: ${TABLE}.time_to_first_close_minutes ;;
  }

  dimension: time_to_last_close_minutes {
    group_label: "* Conversation Statistics *"
    hidden: yes
    type: number
    sql: ${TABLE}.time_to_last_close_minutes ;;
  }

  dimension: number_of_reopens {
    group_label: "* Conversation Attributes *"
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_reopens ;;
  }

  dimension: is_closed_several_times {
    type: yesno
    sql: case when ${time_to_first_close_seconds} = ${time_to_last_close_seconds} then false else true end ;;
  }

  dimension: is_snoozed_conversation {
    group_label: "* Conversation Attributes *"
    type: yesno
    sql: ${TABLE}.is_snoozed_conversation ;;
  }

  dimension: timezone {
    group_label: "* Dates & Timestamps *"
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension: user_id {
    group_label: "* Contact *"
    type: string
    sql: ${TABLE}.user_id ;;
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
    group_label: "* Conversation Attributes *"
    type: string
    sql: ${TABLE}.contact_reason_l3 ;;
  }

  dimension: contact_reason_l1 {
    label: "Contact Reason L1"
    group_label: "* Conversation Attributes *"
    type: string
    sql: ${TABLE}.contact_reason_l1 ;;
  }

  dimension: contact_reason_l3 {
    label: "Contact Reason L3"
    group_label: "* Conversation Attributes *"
    type: string
    sql: ${TABLE}.contact_reason_l3 ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension_group: creation_timestamp {
    label: "Event Timestamp"
    description: "Timestamp that includes conversations and orders. Use this if orders should be included"
    group_label: "* Dates & Timestamps *"
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
      contact_reason_l3,
      first_close_timestamp_time,
      country_iso,
      tag_names,
      rating_remark,
      rating,
      contact_id,
      user_id,
      contact_email,
      is_whatsapp_contact,
      platform,
      app_version,
      creation_timestamp_time,
      order_number,
      order_timestamp_time
    ]
  }
}
