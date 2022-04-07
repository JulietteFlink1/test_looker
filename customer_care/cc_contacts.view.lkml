view: cc_contacts {
  sql_table_name: `flink-data-dev.curated.cc_contacts`
    ;;

  dimension: agent_email {
    group_label: "* Agent & Team *"
    description: "Email of the last agent who took part in the chat"
    type: string
    sql: ${TABLE}.agent_email ;;
  }

  dimension: agent_id {
    group_label: "* Agent & Team *"
    description: "ID of the last agent who took part in the chat"
    type: string
    sql: ${TABLE}.agent_id ;;
  }

  dimension: agent_name {
    group_label: "* Agent & Team *"
    description: "Name of the last agent who took part in the chat"
    type: string
    sql: ${TABLE}.agent_name ;;
  }

  dimension_group: user_created {
    group_label: "* User *"
    type: time
    timeframes: [
      date,
    ]
    sql: ${TABLE}.user_created_timestamp ;;
  }

  dimension: user_phone_number {
    group_label: "* User *"
    type: string
    description: "Phone number of the user who created the contact"
    sql: ${TABLE}.user_phone_number ;;
  }

  dimension: user_email {
    group_label: "* User *"
    type: string
    description: "Email of the user who created the contact"
    sql: ${TABLE}.user_email ;;
  }

  dimension: intercom_user_id {
    group_label: "* User *"
    type: string
    description: "ID of the user who created the contact"
    sql: ${TABLE}.intercom_user_id ;;
  }

  dimension: user_name {
    group_label: "* User *"
    type: string
    description: "Name of the user who created the contact"
    sql: ${TABLE}.user_name ;;
  }

  dimension: contact_reason {
    group_label: "* Contact Attributes *"
    type: string
    sql: ${TABLE}.contact_reason ;;
  }

  dimension: contact_reason_l3 {
    group_label: "* Contact Attributes *"
    type: string
    sql: ${TABLE}.contact_reason_l3 ;;
  }

  dimension_group: contact_date {
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
    sql: ${TABLE}.contact_created_date ;;
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
    hidden: no
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_agent_reply_timestamp ;;
  }

  dimension_group: contact_created {
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
    sql: ${TABLE}.contact_created_timestamp ;;
  }

  dimension: contact_uuid {
    type: number
    primary_key: yes
    value_format_name: id
    label: "Contact ID"
    sql: ${TABLE}.contact_uuid ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  # dimension: contact_created_day_of_week {
  #   type: string
  #   group_label: "* Dates & Timestamps *"
  #   sql: ${TABLE}.contact_created_day_of_week ;;
  # }

  dimension: contact_created_day_of_week {
    type:  string
    group_label: "* Dates & Timestamps *"
    # label: "test day of week"

    sql: case when extract(dayofweek from ${contact_created_date}) = 1 then  'Sunday'
              when extract(dayofweek from ${contact_created_date}) = 2 then  'Monday'
              when extract(dayofweek from ${contact_created_date}) = 3 then  'Tuesday'
              when extract(dayofweek from ${contact_created_date}) = 4 then  'Wednesday'
              when extract(dayofweek from ${contact_created_date}) = 5 then  'Thursday'
              when extract(dayofweek from ${contact_created_date}) = 6 then  'Friday'
              when extract(dayofweek from ${contact_created_date}) = 7 then 'Saturday'
         end ;;

  }


  dimension: contact_created_day_of_week_number {
    type: string
    group_label: "* Dates & Timestamps *"
    sql: case when ${contact_created_day_of_week} = 'Monday' then 1
              when ${contact_created_day_of_week} = 'Tuesday' then 2
              when ${contact_created_day_of_week} = 'Wednesday' then 3
              when ${contact_created_day_of_week} = 'Thursday' then 4
              when ${contact_created_day_of_week} = 'Friday' then 5
              when ${contact_created_day_of_week} = 'Saturday' then 6
              when ${contact_created_day_of_week} = 'Sunday' then 7
         end ;;
  }

  dimension: is_first_reply_the_same_day {
    type: yesno
    group_label: "* Dates & Timestamps *"
    sql: case when date(${contact_created_date}) = date(${first_agent_reply_date}) then true else false end ;;
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

  dimension_group: first_user_reply {
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
    sql: ${TABLE}.first_user_reply_timestamp ;;
  }

  dimension: is_deflected_by_bot {
    group_label: "* Contact Attributes *"
    type: yesno
    sql: ${TABLE}.is_deflected_by_bot ;;
  }

  dimension: is_closed {
    group_label: "* Contact Attributes *"
    type: yesno
    sql: ${TABLE}.is_closed ;;
  }

  dimension: is_abandoned_by_user {
    group_label: "* Contact Attributes *"
    type: yesno
    sql: ${TABLE}.is_abandoned_by_user ;;
  }

  dimension: is_refunded {
    group_label: "* Contact Attributes *"
    type: yesno
    sql: ${TABLE}.is_refunded ;;
  }

  dimension: is_whatsapp_user {
    group_label: "* User *"
    type: yesno
    sql: ${TABLE}.is_whatsapp_user ;;
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

  dimension_group: last_user_reply {
    type: time
    group_label: "* Dates & Timestamps *"
    timeframes: [
      time,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.last_user_reply_timestamp ;;
  }

  dimension: median_time_to_reply_seconds {
    type: number
    hidden: yes
    group_label: "* Contact Statistics *"
    sql: ${TABLE}.median_time_to_reply_seconds ;;
  }

  dimension: median_time_to_reply_minutes {
    type: number
    hidden: yes
    group_label: "* Contact Statistics *"
    sql: ${TABLE}.median_time_to_reply_minutes ;;
  }

  dimension: contact_hour {
    type: number
    group_label: "* Dates & Timestamps *"
    sql:  ${TABLE}.contact_created_hour ;;
  }

  dimension: number_of_assignments {
    hidden: yes
    group_label: "* Contact Statistics *"
    type: number
    sql: ${TABLE}.number_of_assignments ;;
  }

  dimension: number_of_contact_parts {
    type: number
    hidden:yes
    group_label: "* Contact Statistics *"
    sql: ${TABLE}.number_of_contact_parts ;;
  }

  dimension: platform {
    group_label: "* Contact Attributes *"
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: rating {
    group_label: "* Contact Attributes *"
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
    group_label: "* Contact Attributes *"
    type: string
    sql: ${TABLE}.rating_remark ;;
  }

  dimension: source_author_type {
    group_label: "* Contact Attributes *"
    type: string
    sql: ${TABLE}.source_author_type ;;
  }

  dimension: source_type {
    group_label: "* Contact Attributes *"
    type: string
    sql: ${TABLE}.source_type ;;
  }

  dimension: tag_names {
    group_label: "* Contact Attributes *"
    type: string
    sql: ${TABLE}.tag_names ;;
  }

  dimension: team_id {
    group_label: "* Agent & Team *"
    description: "ID of the last team who took part in the chat"
    type: number
    sql: ${TABLE}.team_id ;;
  }

  dimension: team_name {
    group_label: "* Agent & Team *"
    description: "Team of the last team who took part in the chat"
    type: string
    sql: ${TABLE}.team_name ;;
  }

  dimension: time_to_agent_reply_seconds {
    group_label: "* Contact Statistics *"
    hidden: yes
    type: number
    sql: ${TABLE}.time_to_agent_reply_seconds ;;
  }

  dimension: time_to_agent_reply_minutes {
    hidden: no
    label: "Time to Agent Reply"
    group_label: "* Contact Statistics *"
    type: number
    sql: ${TABLE}.time_to_agent_reply_minutes ;;
  }

  dimension: time_to_assignement_seconds {
    group_label: "* Contact Statistics *"
    type: number
    hidden: yes
    sql: ${TABLE}.time_to_assignement_seconds ;;
  }

  dimension: time_to_first_close_seconds {
    group_label: "* Contact Statistics *"
    type: number
    hidden: yes
    sql: ${TABLE}.time_to_first_close_seconds ;;
  }

  dimension: time_to_last_close_seconds {
    group_label: "* Contact Statistics *"
    type: number
    hidden: yes
    sql: ${TABLE}.time_to_last_close_seconds ;;
  }

  dimension: time_to_first_close_minutes {
    group_label: "* Contact Statistics *"
    type: number
    hidden: yes
    sql: ${TABLE}.time_to_first_close_minutes ;;
  }

  dimension: time_to_last_close_minutes {
    group_label: "* Contact Statistics *"
    hidden: yes
    type: number
    sql: ${TABLE}.time_to_last_close_minutes ;;
  }

  dimension: number_of_reopens {
    group_label: "* Contact Attributes *"
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_reopens ;;
  }

  dimension: is_closed_several_times {
    type: yesno
    sql: case when ${time_to_first_close_seconds} = ${time_to_last_close_seconds} then false else true end ;;
  }


  dimension: is_snoozed_contact {
    group_label: "* Contact Attributes *"
    type: yesno
    sql: ${TABLE}.is_snoozed_contact ;;
  }

  dimension: timezone {
    group_label: "* Dates & Timestamps *"
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension: user_id {
    group_label: "* User *"
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
    label: "Contact Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${contact_created_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${contact_created_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${contact_created_month}
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
      ${avg_number_of_contacts_daily}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${avg_number_of_contacts_weekly}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${avg_number_of_contacts_monthly}
    {% endif %};;
  }



################# Measures


######################################################################
################## Basic Counts Measures #############################
######################################################################

  measure: number_of_contacts {
    group_label: "* Basic Counts *"
    type: count_distinct
    sql: ${contact_uuid} ;;
    label: "# Contacts"
  }


  measure: number_of_closed_contacts {
    group_label: "* Basic Counts *"
    type: count_distinct
    sql: ${contact_uuid} ;;
    label: "# Closed Contacts"
    filters: [is_closed: "yes"]
  }

  measure: number_of_non_deflected_contacts {
    group_label: "* Basic Counts *"
    type: count_distinct
    sql: ${contact_uuid} ;;
    label: "# Contacts (Non Deflected)"
    filters: [is_deflected_by_bot: "no"]
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

  measure: number_of_users {
    group_label: "* Basic Counts *"
    type: count_distinct
    sql: ${intercom_user_id} ;;
    label: "# Unique Users"
  }

  measure: number_of_contact_per_agent {
    group_label: "* Basic Counts *"
    type: number
    value_format: "0.0"
    sql: safe_divide(${number_of_non_deflected_contacts},${number_of_agents}) ;;
    label: "# Contacts per Agent"
  }

  measure: share_of_closed_contacts{
    group_label: "* Basic Counts *"
    label: "% Closed Contacts"
    type: number
    sql: ${number_of_closed_contacts}/${number_of_contacts} ;;
  }



######################################################################
################## Contact Rates Measures ############################
######################################################################

  measure: number_of_unique_hours {
    type: count_distinct
    hidden: yes
    sql: concat(${contact_created_date},${contact_hour}) ;;
  }

  measure: number_of_unique_days {
    type: count_distinct
    hidden: yes
    sql: ${contact_created_date} ;;
  }

  measure: number_of_unique_weeks {
    type: count_distinct
    hidden: yes
    sql: ${contact_created_week} ;;
  }

  measure: number_of_unique_months {
    type: count_distinct
    hidden: yes
    sql: ${contact_created_month} ;;
  }

  measure: avg_number_of_contacts_hourly {
    group_label: "* Contact Rates *"
    type: number
    value_format: "0.0"
    sql: ${number_of_contacts}/NULLIF(${number_of_unique_hours},0) ;;
    label: "Contact Rate - Hourly"
  }
  measure: avg_number_of_contacts_daily {
    group_label: "* Contact Rates *"
    type: number
    value_format: "0.0"
    sql: ${number_of_contacts}/NULLIF(${number_of_unique_days},0) ;;
    label: "Contact Rate - Daily"
  }

  measure: avg_number_of_contacts_weekly {
    group_label: "* Contact Rates *"
    type: number
    value_format: "0.0"
    sql: ${number_of_contacts}/NULLIF(${number_of_unique_weeks},0) ;;
    label: "Contact Rate - Weekly"
  }

  measure: avg_number_of_contacts_monthly {
    group_label: "* Contact Rates *"
    type: number
    value_format: "0.0"
    sql: ${number_of_contacts}/NULLIF(${number_of_unique_months},0) ;;
    label: "Contact Rate - Monthly"
  }


######################################################################
################## contact Statistics Measures ##################
######################################################################




  measure: avg_rating {
    group_label: "* Contact Statistics *"
    type: average
    value_format: "0.0"
    sql: ${rating} ;;
    label: "AVG Rating"
  }

  measure: avg_csat {
    group_label: "* Contact Statistics *"
    type: average
    value_format: "0%"
    sql: ${rating}/5 ;;
    label: "AVG CSAT"
  }

  measure: avg_time_first_close_minutes {
    group_label: "* Contact Statistics *"
    type: average
    value_format: "hh:mm:ss"
    label: "AVG Time to First Close (Minutes)"
    sql: ${time_to_first_close_minutes}*60/86400.0 ;;
  }

  measure: avg_time_last_close_minutes {
    group_label: "* Contact Statistics *"
    type: average
    value_format: "hh:mm:ss"
    description: "AVG time to last close (minutes)"
    label: "AVG Closing Time (Minutes)"
    sql: ${time_to_last_close_minutes}*60/86400.0;;
  }

  measure: median_time_last_close_minutes {
    group_label: "* Contact Statistics *"
    type: median
    value_format: "hh:mm:ss"
    description: "Median time to last close (minutes)"
    label: "Median Closing Time (Minutes)"
    sql: ${time_to_last_close_minutes}*60/86400.0;;
  }

  measure: avg_time_to_agent_reply_seconds {
    group_label: "* Contact Statistics *"
    type: average
    hidden: yes
    value_format: "0"
    label: "AVG Response Time (Seconds)"
    sql:  ${time_to_agent_reply_seconds} ;;
  }

  measure: avg_time_to_agent_reply_minutes {
    group_label: "* Contact Statistics *"
    type: average
    value_format: "mm:ss"
    label: "AVG First Response Time (Minutes)"
    description: "AVG duration until first admin reply. Subtracts out of business hours."
    sql:  ${time_to_agent_reply_minutes}*60/86400.0 ;;
  }

  measure: median_time_to_agent_reply_minutes {
    group_label: "* Contact Statistics *"
    type: median
    value_format: "hh:mm:ss"
    label: "Median First Response Time (Minutes)"
    description: "Median Duration until first admin reply. Subtracts out of business hours."
    sql:${time_to_agent_reply_minutes}*60/86400.0 ;;
  }

  measure: avg_median_time_to_agent_reply_seconds {
    group_label: "* Contact Statistics *"
    type: average
    hidden: yes
    label: "AVG Median Response Time (Seconds)"
    sql:  ${median_time_to_reply_seconds} ;;
  }

  measure: median_median_time_to_agent_reply_minutes {
    group_label: "* Contact Statistics *"
    type: median
    value_format: "hh:mm:ss"
    description: "Median based on all admin replies after a user reply. Subtracts out of business hours. In seconds."
    label: "Median Response Time (Minutes)"
    sql:  ${median_time_to_reply_minutes}*60/86400.0 ;;
  }

  measure: avg_number_of_reopens {
    group_label: "* Contact Statistics *"
    type: average
    value_format: "0.0"
    label: "AVG # Reopens"
    sql:  ${number_of_reopens} ;;
  }

  measure: sum_number_of_reopens {
    group_label: "* Contact Statistics *"
    type: sum
    value_format: "0"
    label: "# Reopens"
    sql:  ${number_of_reopens} ;;
  }

  measure: number_of_deflected_by_bot {
    group_label: "* Basic Counts *"
    type: count_distinct
    value_format: "0.0"
    label: "# Contacts Deflected by Bot"
    sql:  contact_uuid ;;
    filters: [is_deflected_by_bot: "yes"]
  }

  measure: number_of_abandoned_by_customer {
    group_label: "* Basic Counts *"
    type: count_distinct
    value_format: "0.0"
    label: "# Contacts Abandoned by Customer"
    sql:  contact_uuid ;;
    filters: [is_abandoned_by_user: "yes"]
  }

  measure: number_of_rated_contacts {
    group_label: "* Basic Counts *"
    type: count_distinct
    value_format: "0"
    label: "# Contacts with CSAT"
    sql:  contact_uuid ;;
    filters: [rating: ">=0"]
  }


  measure: number_of_contacts_with_refund {
    group_label: "* Basic Counts *"
    type: count_distinct
    value_format: "0"
    label: "# Contacts with Refunds"
    sql:  contact_uuid ;;
    filters: [is_refunded: "yes"]
  }

  measure: number_of_reply_other_day {
    group_label: "* Contact Statistics *"
    type: count_distinct
    value_format: "0.0"
    sql:  contact_uuid ;;
    filters: [is_first_reply_the_same_day: "no"]
  }

  measure: number_of_email_contacts {
    group_label: "* Basic Counts *"
    type: count_distinct
    value_format: "0"
    label: "# Email Contacts"
    sql:  contact_uuid ;;
    filters: [source_type: "email"]
  }

  measure: share_deflected_by_bot {
    group_label: "* Contact Statistics *"
    type: number
    value_format: "0.0%"
    label: "% Deflected Rate"
    sql:  ${number_of_deflected_by_bot}/${number_of_contacts} ;;
  }

  measure: share_rated_contacts {
    group_label: "* Contact Statistics *"
    type: number
    value_format: "0.0%"
    label: "% Contacts with CSAT"
    sql:  ${number_of_rated_contacts}/${number_of_contacts} ;;
  }

  measure: share_contacts_with_refunds {
    group_label: "* Contact Statistics *"
    type: number
    value_format: "0.0%"
    label: "% Contacts with Refunds"
    sql:  ${number_of_contacts_with_refund}/${number_of_contacts} ;;
  }

  measure: share_email_contacts {
    group_label: "* Contact Statistics *"
    type: number
    value_format: "0.0%"
    label: "% Emails"
    sql:  ${number_of_email_contacts}/${number_of_contacts} ;;
  }

  measure: share_abandoned_contacts {
    group_label: "* Contact Statistics *"
    type: number
    value_format: "0.0%"
    label: "% Abandoned Contacts"
    sql:  ${number_of_abandoned_by_customer}/${number_of_contacts} ;;
  }

  measure: share_reply_on_another_day {
    group_label: "* Contact Statistics *"
    type: number
    value_format: "0.0%"
    label: "% First Reply on Another Day"
    description: "Share of contacts that were created on a given day but first agent reply was on a different day"
    sql:  ${number_of_reply_other_day}/${number_of_contacts} ;;
  }


  measure: count {
    type: count
    drill_fields: [agent_name, user_name, team_name]
  }
}
