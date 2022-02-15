view: cc_conversations {
  sql_table_name: `flink-data-dev.curated.cc_conversations`
    ;;

  dimension: agent_email {
    group_label: "* Agent & Team *"
    description: "Email of the last agent who took part in the conversation"
    type: string
    sql: ${TABLE}.agent_email ;;
  }

  dimension: agent_id {
    group_label: "* Agent & Team *"
    description: "ID of the last agent who took part in the conversation"
    type: string
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
    type: string
    description: "ID of the user who created the conversation"
    sql: ${TABLE}.contact_id ;;
  }

  dimension: contact_name {
    group_label: "* Contact *"
    type: string
    description: "Name of the user who created the conversation"
    sql: ${TABLE}.contact_name ;;
  }

  dimension: contact_reason {
    group_label: "* Conversation Attributes *"
    type: string
    sql: ${TABLE}.contact_reason ;;
  }

  dimension: contact_reason_l3 {
    group_label: "* Conversation Attributes *"
    type: string
    sql: ${TABLE}.contact_reason_l3 ;;
  }

  dimension_group: conversation_date {
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
    sql: ${TABLE}.conversation_created_date ;;
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
    primary_key: yes
    value_format_name: id
    label: "Conversation ID"
    sql: ${TABLE}.conversation_uuid ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: conversation_created_day_of_week {
    type: string
    group_label: "* Dates & Timestamps *"
    sql: ${TABLE}.conversation_created_day_of_week ;;
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

  dimension: platform {
    group_label: "* Conversation Attributes *"
    type: string
    sql: ${TABLE}.platform ;;
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


################## Parameter and Dynamic Dates


  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Hour" }
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }


  ######## DYNAMIC DIMENSIONS

  dimension: date {
    group_label: "* Dates & Timestamps *"
    label: "Conversation Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${conversation_created_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${conversation_created_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${conversation_created_month}
    {% endif %};;
  }

  dimension: date_granularity_pass_through {
    group_label: "* Parameters *"
    description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
    type: string
    hidden: no # yes
    sql:
            {% if date_granularity._parameter_value == 'Day' %}
              "Day"
            {% elsif date_granularity._parameter_value == 'Week' %}
              "Week"
            {% elsif date_granularity._parameter_value == 'Month' %}
              "Month"
            {% endif %};;
  }



  measure: contact_rate {
    group_label: "* Contact Rates *"
    label: "Contact Rate (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${avg_number_of_conversations_daily}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${avg_number_of_conversations_weekly}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${avg_number_of_conversations_monthly}
    {% endif %};;
  }



################# Measures


######################################################################
################## Basic Counts Measures #############################
######################################################################

  measure: number_of_conversations {
    group_label: "* Basic Counts *"
    type: count_distinct
    sql: ${conversation_uuid} ;;
    label: "# Conversations"
  }

  measure: number_of_teams {
    group_label: "* Basic Counts *"
    type: count_distinct
    sql: ${team_id} ;;
    label: "# Teams"
  }

  measure: number_of_agents {
    group_label: "* Basic Counts *"
    type: count_distinct
    sql: ${agent_id} ;;
    label: "# Agents"
  }

  measure: number_of_contacts {
    group_label: "* Basic Counts *"
    type: count_distinct
    sql: ${contact_id} ;;
    label: "# Unique Contacts"
  }

  measure: number_of_conversation_per_agent {
    group_label: "* Basic Counts *"
    type: number
    value_format: "0.0"
    sql: ${number_of_conversations}/${number_of_agents} ;;
    label: "# Conversations per Agent"
  }



######################################################################
################## Contact Rates Measures ############################
######################################################################

  measure: number_of_unique_hours {
    type: count_distinct
    hidden: yes
    sql: concat(${conversation_created_date},${conversation_hour}) ;;
  }

  measure: number_of_unique_days {
    type: count_distinct
    hidden: yes
    sql: ${conversation_created_date} ;;
  }

  measure: number_of_unique_weeks {
    type: count_distinct
    hidden: yes
    sql: ${conversation_created_week} ;;
  }

  measure: number_of_unique_months {
    type: count_distinct
    hidden: yes
    sql: ${conversation_created_month} ;;
  }

  measure: avg_number_of_conversations_hourly {
    group_label: "* Contact Rates *"
    type: number
    value_format: "0.0"
    sql: ${number_of_conversations}/NULLIF(${number_of_unique_hours},0) ;;
    label: "Contact Rate - Hourly"
  }
  measure: avg_number_of_conversations_daily {
    group_label: "* Contact Rates *"
    type: number
    value_format: "0.0"
    sql: ${number_of_conversations}/NULLIF(${number_of_unique_days},0) ;;
    label: "Contact Rate - Daily"
  }

  measure: avg_number_of_conversations_weekly {
    group_label: "* Contact Rates *"
    type: number
    value_format: "0.0"
    sql: ${number_of_conversations}/NULLIF(${number_of_unique_weeks},0) ;;
    label: "Contact Rate - Weekly"
  }

  measure: avg_number_of_conversations_monthly {
    group_label: "* Contact Rates *"
    type: number
    value_format: "0.0"
    sql: ${number_of_conversations}/NULLIF(${number_of_unique_months},0) ;;
    label: "Contact Rate - Monthly"
  }


######################################################################
################## Conversation Statistics Measures ##################
######################################################################




  measure: avg_rating {
    group_label: "* Conversation Statistics *"
    type: average
    value_format: "0.0"
    sql: ${rating} ;;
    label: "AVG Rating"
  }

  measure: avg_time_first_close_minutes {
    group_label: "* Conversation Statistics *"
    type: average
    value_format: "hh:mm:ss"
    label: "AVG Time to First Close (Minutes)"
    sql: ${time_to_first_close_minutes}*60/86400.0 ;;
  }

  measure: avg_time_last_close_minutes {
    group_label: "* Conversation Statistics *"
    type: average
    value_format: "hh:mm:ss"
    label: "AVG Time to Last Close (Minutes)"
    sql: ${time_to_last_close_minutes}*60/86400.0;;
  }

  measure: avg_time_to_agent_reply_seconds {
    group_label: "* Conversation Statistics *"
    type: average
    value_format: "0.0"
    label: "AVG Time To First Admin Reply (Seconds)"
    sql:  ${time_to_agent_reply_seconds} ;;
  }

  measure: avg_time_to_agent_reply_minutes {
    group_label: "* Conversation Statistics *"
    type: average
    value_format: "mm:ss"
    label: "AVG Time To First Admin Reply (Minutes)"
    sql:  ${time_to_agent_reply_minutes}*60/86400.0 ;;
  }

  measure: avg_median_time_to_agent_reply_seconds {
    group_label: "* Conversation Statistics *"
    type: average
    label: "AVG Median Time To First Admin Reply (Seconds)"
    sql:  ${median_time_to_reply_seconds} ;;
  }

  measure: avg_median_time_to_agent_reply_minutes {
    group_label: "* Conversation Statistics *"
    type: average
    value_format: "0.0"
    label: "AVG Median  Time To First Admin Reply (Minutes)"
    sql:  ${median_time_to_reply_minutes} ;;
  }

  measure: avg_number_of_reopens {
    group_label: "* Conversation Statistics *"
    type: average
    value_format: "0.0"
    label: "AVG # Reopens"
    sql:  ${number_of_reopens} ;;
  }

  measure: number_of_deflected_by_bot {
    group_label: "* Basic Counts *"
    type: count_distinct
    value_format: "0.0"
    label: "# Conversations Deflected by Bot"
    sql:  conversation_uuid ;;
    filters: [is_deflected_by_bot: "yes"]
  }

  measure: number_of_abandoned_by_customer {
    group_label: "* Basic Counts *"
    type: count_distinct
    value_format: "0.0"
    label: "# Conversations Abandoned by Customer"
    sql:  conversation_uuid ;;
    filters: [is_abandoned_by_contact: "yes"]
  }

  measure: number_of_reply_other_day {
    group_label: "* Conversation Statistics *"
    type: count_distinct
    value_format: "0.0"
    sql:  conversation_uuid ;;
    filters: [is_first_reply_the_same_day: "no"]
  }

  measure: number_of_email_conversations {
    group_label: "* Basic Counts *"
    type: count_distinct
    value_format: "0"
    label: "# Email Conversations"
    sql:  conversation_uuid ;;
    filters: [source_type: "email"]
  }

  measure: share_deflected_by_bot {
    group_label: "* Conversation Statistics *"
    type: number
    value_format: "0.0%"
    label: "% Deflected by Bot"
    sql:  ${number_of_deflected_by_bot}/${number_of_conversations} ;;
  }

  measure: share_email_conversations {
    group_label: "* Conversation Statistics *"
    type: number
    value_format: "0.0%"
    label: "% Emails"
    sql:  ${number_of_email_conversations}/${number_of_conversations} ;;
  }

  measure: share_abandoned_conversations {
    group_label: "* Conversation Statistics *"
    type: number
    value_format: "0.0%"
    label: "% Abandoned Conversations"
    sql:  ${number_of_abandoned_by_customer}/${number_of_conversations} ;;
  }

  measure: share_reply_on_another_day {
    group_label: "* Conversation Statistics *"
    type: number
    value_format: "0.0%"
    label: "% First Reply on Another Day"
    description: "Share of conversations that were created on a given day but first agent reply was on a different day"
    sql:  ${number_of_reply_other_day}/${number_of_conversations} ;;
  }


  measure: count {
    type: count
    drill_fields: [agent_name, contact_name, team_name]
  }
}
