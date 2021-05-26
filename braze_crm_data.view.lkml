view: braze_crm_data {
  derived_table: {
    sql: with
emails_sent as (
    select
        user_id                             as user_id
      , dispatch_id                         as dispatch_id
      , campaign_name                       as campaign_name
      , split(campaign_name,'_')[OFFSET(1)] as country
      , min(sent_at)                        as sent_at
      , min(received_at)                    as received_at
      , count(*)                            as all_sends
    from
      `flink-backend.braze.email_sent`
    group by
      user_id, dispatch_id, campaign_name, country
),

emails_delivered as (
    select
        user_id                             as user_id
      , dispatch_id                         as dispatch_id
      , min(timestamp)                      as delivered_at
    from
      `flink-backend.braze.email_delivered`
    group by
      user_id, dispatch_id
),

emails_bounced as (
    select
        user_id                             as user_id
      , dispatch_id                         as dispatch_id
      , min(timestamp)                      as bounced_at
      , count(*)                            as num_bounced
    from
      `flink-backend.braze.email_bounced`
    group by
      user_id, dispatch_id
),

emails_soft_bounced as (
    select
        user_id                             as user_id
      , dispatch_id                         as dispatch_id
      , min(timestamp)                      as soft_bounced_at
      , count(*)                            as num_soft_bounced
    from
      `flink-backend.braze.email_soft_bounced`
    group by
      user_id, dispatch_id
),

emails_opened as (
    select
        user_id                             as user_id
      , dispatch_id                         as dispatch_id
      , min(timestamp)                      as opened_at_first
      , min(timestamp)                      as opened_at_last
      , count(*)                            as num_opening
    from
      `flink-backend.braze.email_opened`
    group by
      user_id, dispatch_id
),

emails_clicked as (
    select
        user_id                             as user_id
      , dispatch_id                         as dispatch_id
      , min(timestamp)                      as clicked_at_first
      , min(timestamp)                      as clicked_at_last
      , count(*)                            as num_clicks
    from
      `flink-backend.braze.email_link_clicked`
    group by
      user_id, dispatch_id
),

emails_unsubscribed as (
    select
        user_id                             as user_id
      , dispatch_id                         as dispatch_id
      , min(timestamp)                      as unsubscribed_at
    from
      `flink-backend.braze.unsubscribed`
    group by
      user_id, dispatch_id
)

select
  -- DIMENSIONS
    es.campaign_name                                      as campaign_name
  , es.country                                            as country
  , date(es.sent_at, "Europe/Berlin")                    as email_sent_at
  , date_diff(eo.opened_at_first, es.sent_at, day)       as days_sent_to_open
  , date_diff(ec.clicked_at_first, es.sent_at, day)      as days_sent_to_click
  -- MEASURES
  , count(distinct concat(es.user_id , es.dispatch_id))   as num_emails_sent
  , sum(es.all_sends)                                     as num_all_sents
  , count(distinct concat(eb.user_id , eb.dispatch_id))   as num_unique_emails_bounced
  , sum(eb.num_bounced )                                  as num_emails_bounced
  , count(distinct concat(esb.user_id , esb.dispatch_id)) as num_unique_emails_soft_bounced
  , sum(esb.num_soft_bounced )                          as num_emails_soft_bounced
  , count(distinct concat(ed.user_id , ed.dispatch_id))   as num_emails_delivered
  , count(distinct concat(eo.user_id , eo.dispatch_id))   as num_unique_emails_opened
  , sum(eo.num_opening  )                               as num_emails_opened
  , count(distinct concat(ec.user_id , ec.dispatch_id))   as num_unique_emails_clicked
  , sum(ec.num_clicks)                                  as num_emails_clicked
  , count(distinct concat(uns.user_id , uns.dispatch_id)) as num_unique_unsubscribed

from
          emails_sent                     as es
left join emails_bounced                  as eb
       on es.user_id     = eb.user_id
      and es.dispatch_id = eb.dispatch_id
left join emails_soft_bounced             as esb
       on es.user_id     = esb.user_id
      and es.dispatch_id = esb.dispatch_id
left join emails_delivered                as ed
       on es.user_id     = ed.user_id
      and es.dispatch_id = ed.dispatch_id
left join emails_opened                   as eo
       on es.user_id     = eo.user_id
      and es.dispatch_id = eo.dispatch_id
left join emails_clicked                  as ec
       on es.user_id     = ec.user_id
      and es.dispatch_id = ec.dispatch_id
left join emails_unsubscribed             as uns
       on es.user_id     = uns.user_id
      and es.dispatch_id = uns.dispatch_id

group by
  campaign_name, country, email_sent_at, days_sent_to_open, days_sent_to_click;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Dimensions
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: campaign_name {
    label: "Campaign Name"
    description: "The email campaign name defined in Braze"
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: country {
    label: "Country"
    description: "The country code parsed from the email campaign name"
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: email_sent_at {
    label: "Date Email Sent"
    description: "The date, when the email was sent to the customer"
    type: date
    datatype: date
    sql: ${TABLE}.email_sent_at ;;
    hidden: yes
  }

  dimension_group: email_sent_at {
    label: "Date Email Sent"
    description: "The date, when the email was sent to the customer"
    type: time
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${email_sent_at} ;;
    datatype: date
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Hidden Fields
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.campaign_name, ${TABLE}.country, ${TABLE}.email_sent_at) ;;
  }

  dimension: days_sent_to_open {
    type: number
    sql: ${TABLE}.days_sent_to_open ;;
    hidden: yes
  }

  dimension: days_sent_to_click {
    type: number
    sql: ${TABLE}.days_sent_to_click ;;
    hidden: yes
  }

  dimension: num_emails_sent {
    type: number
    sql: ${TABLE}.num_emails_sent ;;
    hidden: yes
  }

  dimension: num_all_sents {
    type: number
    sql: ${TABLE}.num_all_sents ;;
    hidden: yes
  }

  dimension: num_unique_emails_bounced {
    type: number
    sql: ${TABLE}.num_unique_emails_bounced ;;
    hidden: yes
  }

  dimension: num_emails_bounced {
    type: number
    sql: ${TABLE}.num_emails_bounced ;;
    hidden: yes
  }

  dimension: num_unique_emails_soft_bounced {
    type: number
    sql: ${TABLE}.num_unique_emails_soft_bounced ;;
    hidden: yes
  }

  dimension: num_emails_soft_bounced {
    type: number
    sql: ${TABLE}.num_emails_soft_bounced ;;
    hidden: yes
  }

  dimension: num_emails_delivered {
    type: number
    sql: ${TABLE}.num_emails_delivered ;;
    hidden: yes
  }

  dimension: num_unique_emails_opened {
    type: number
    sql: ${TABLE}.num_unique_emails_opened ;;
    hidden: yes
  }

  dimension: num_emails_opened {
    type: number
    sql: ${TABLE}.num_emails_opened ;;
    hidden: yes
  }

  dimension: num_unique_emails_clicked {
    type: number
    sql: ${TABLE}.num_unique_emails_clicked ;;
    hidden: yes
  }

  dimension: num_emails_clicked {
    type: number
    sql: ${TABLE}.num_emails_clicked ;;
    hidden: yes
  }

  dimension: num_unique_unsubscribed {
    type: number
    sql: ${TABLE}.num_unique_unsubscribed ;;
    hidden: yes
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    value_format_name: decimal_0
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Measures
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: num_all_sent {
    type: sum
    label: "Sends"
    description: "The number of emails sent to the customer"
    group_label: "Numbers"
    sql: ${num_all_sents} ;;
    value_format_name: decimal_0
  }

  measure: num_sent {
    type: sum
    label: "Unique Recipients"
    description: "The number of unique recipients of an email campaign"
    group_label: "Numbers"
    sql: ${num_emails_sent} ;;
    value_format_name: decimal_0
  }

  measure: num_bounced_unique {
    type: sum
    label: "Bounces"
    description: "The number of emails, that have been bounced by the customers email provider"
    group_label: "Numbers"
    sql: ${num_unique_emails_bounced};;
    value_format_name: decimal_0
  }

  measure: num_soft_bounces_unique {
    type: sum
    label: "Soft Bounces"
    description: "The number of emails, that have been bounced by the customers email provider"
    group_label: "Numbers"
    sql: ${num_unique_emails_soft_bounced} ;;
    value_format_name: decimal_0
  }

  measure: num_delivered {
    type: sum
    label: "Deliveries"
    description: "The number of emails, that have been delivered to the customer - aka they have been received"
    group_label: "Numbers"
    sql: ${num_emails_delivered} ;;
    value_format_name: decimal_0
  }

  measure: num_opened_u {
    type:  sum
    label: "Unique Opens"
    description: "The number of unique opens of an email - one customer can be counted only once per sent-put"
    group_label: "Numbers"
    sql: ${num_unique_emails_opened} ;;
    value_format_name: decimal_0
  }

  measure: num_opened {
    type:  sum
    label: "Total Opens"
    description: "The number of unique opens of an email - one customer can be counted n-times per sent-put"
    group_label: "Numbers"
    sql: ${num_emails_opened} ;;
    value_format_name: decimal_0
  }

  measure: num_clicked_u {
    type: sum
    label: "Unique Clicks"
    description: "The number of unique clicks of an email - one customer can be counted only once per sent-put"
    group_label: "Numbers"
    sql: ${num_unique_emails_clicked} ;;
    value_format_name: decimal_0
  }

  measure: num_clicked {
    type: sum
    label: "Total Clicks"
    description: "The number of unique clicks of an email - one customer can be counted n-times per sent-put"
    group_label: "Numbers"
    sql: ${num_emails_clicked} ;;
    value_format_name: decimal_0
  }

  measure: num_unsub {
    type: sum
    label: "Unsubscribes"
    description: "The number of customers, that have clicked on the unsubscribe-link"
    group_label: "Numbers"
    sql: ${num_unique_unsubscribed} ;;
    value_format_name: decimal_0
  }

  measure: avg_days_sent_open {
    type: average
    label: "ø Days Sent to Open"
    description: "The days between the sent-out and the first opening of an email"
    group_label: "Numbers"
    sql:  ${days_sent_to_open};;
    value_format_name: decimal_2
  }

  measure: avg_days_sent_click {
    type: average
    label: "ø Days Sent to Click"
    description: "The days between the sent-out and the first click of an email"
    group_label: "Numbers"
    sql: ${days_sent_to_click} ;;
    value_format_name: decimal_2
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Ratios
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: bounces_rate {
    type: number
    label: "Bounce Rate"
    description: "Percentage: how many emails have been bounced based on all emails sent"
    group_label: "Ratios"
    sql: ${num_bounced_unique} / NULLIF(${num_sent}, 0);;
    value_format_name: percent_2
  }

  measure: deliveries_rate {
    type: number
    label: "Deliveries Rate"
    description: "Percentage: how many emails have been delivered based on all emails sent"
    group_label: "Ratios"
    sql: ${num_delivered} / NULLIF(${num_sent}, 0);;
    value_format_name: percent_2
  }

  measure: total_opens_rate {
    type: number
    label: "Total Opens Rate"
    description: "Percentage: number of emails opened divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${num_opened} / NULLIF(${num_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: unique_opens_rate {
    type: number
    label: "Unique Opens Rate"
    description: "Percentage: number of unique emails opened divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${num_opened_u} / NULLIF(${num_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: total_clicks_rate {
    type: number
    label: "Total Clicks Rate"
    description: "Percentage: number of emails clicked divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${num_clicked} / NULLIF(${num_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: unique_clicks_rate {
    type: number
    label: "Unique Clicks Rate"
    description: "Percentage: number of unique emails clicked divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${num_clicked_u} / NULLIF(${num_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: unsubscribes_rate {
    type: number
    label: "Unsubscribes Rate"
    description: "Percentage: number of emails clicked on unsubscribe-link divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${num_unsub} / NULLIF(${num_delivered}, 0);;
    value_format_name: percent_2
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Detail
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  set: detail {
    fields: [
      campaign_name,
      country,
      email_sent_at,
      days_sent_to_open,
      days_sent_to_click,
      num_emails_sent,
      num_unique_emails_bounced,
      num_emails_bounced,
      num_unique_emails_soft_bounced,
      num_emails_soft_bounced,
      num_emails_delivered,
      num_unique_emails_opened,
      num_emails_opened,
      num_unique_emails_clicked,
      num_emails_clicked
    ]
  }
}
