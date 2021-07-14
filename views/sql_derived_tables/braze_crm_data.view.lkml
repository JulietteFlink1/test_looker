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
),

orders_raw as ( --all valid orders
    select
        user_email
        ,created as order_created_at
        ,id as order_id
        ,country_iso
    from
      `flink-backend.saleor_db_global.order_order`
    where
      status in ('fulfilled', 'partially fulfilled')
),

orders as ( --attribute the order to the last enail opened if the order happened within the next 24h
    select distinct
       user_id
       ,LAST_VALUE(dispatch_id) OVER (partition by order_id order by opened_at_first ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as dispatch_id
       ,LAST_VALUE(opened_at_first) OVER (partition by order_id order by opened_at_first  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as opened_at
       ,order_id
       ,order_created_at
    from
      emails_opened
    join
      orders_raw
      on user_email = user_id
      and timestamp_diff(order_created_at, opened_at_first, hour) BETWEEN 0 and 12
),

orders_aggregated as (--aggregates orders per user
  select user_id,
        dispatch_id,
        COUNT(order_id) AS num_orders
  from
    orders
  group by 1,2
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
  , sum(num_orders)                                        as num_orders
  , count(distinct concat(oa.user_id , oa.dispatch_id))   as num_unique_orders

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
left join orders_aggregated oa
       on es.user_id     = oa.user_id
      and es.dispatch_id = oa.dispatch_id

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

  dimension: num_orders {
    type: number
    sql: ${TABLE}.num_orders ;;
    hidden: yes
  }

  dimension: num_unique_orders {
    type: number
    sql: ${TABLE}.num_unique_orders ;;
    hidden: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Measures
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: total_emails_sent {
    type: sum
    label: "Sends"
    description: "The number of emails sent to the customer"
    group_label: "Numbers"
    sql: ${num_all_sents} ;;
    value_format_name: decimal_0
  }

  measure: total_recipients {
    type: sum
    label: "Unique Recipients"
    description: "The number of unique recipients of an email campaign"
    group_label: "Numbers"
    sql: ${num_emails_sent} ;;
    value_format_name: decimal_0
  }

  measure: total_emails_bounced_unique {
    type: sum
    label: "Bounces"
    description: "The number of emails, that have been bounced by the customers email provider"
    group_label: "Numbers"
    sql: ${num_unique_emails_bounced};;
    value_format_name: decimal_0
  }

  measure: total_emails_soft_bounced_unique {
    type: sum
    label: "Soft Bounces"
    description: "The number of emails, that have been bounced by the customers email provider"
    group_label: "Numbers"
    sql: ${num_unique_emails_soft_bounced} ;;
    value_format_name: decimal_0
  }

  measure: total_emails_delivered {
    type: sum
    label: "Deliveries"
    description: "The number of emails, that have been delivered to the customer - aka they have been received"
    group_label: "Numbers"
    sql: ${num_emails_delivered} ;;
    value_format_name: decimal_0
  }

  measure: total_emails_opened_unique {
    type:  sum
    label: "Unique Opens"
    description: "The number of unique opens of an email - one customer can be counted only once per sent-put"
    group_label: "Numbers"
    sql: ${num_unique_emails_opened} ;;
    value_format_name: decimal_0
  }

  measure: total_emails_opened {
    type:  sum
    label: "Total Opens"
    description: "The number of unique opens of an email - one customer can be counted n-times per sent-put"
    group_label: "Numbers"
    sql: ${num_emails_opened} ;;
    value_format_name: decimal_0
  }

  measure: total_emails_clicked_unique {
    type: sum
    label: "Unique Clicks"
    description: "The number of unique clicks of an email - one customer can be counted only once per sent-put"
    group_label: "Numbers"
    sql: ${num_unique_emails_clicked} ;;
    value_format_name: decimal_0
  }

  measure: total_emails_clicked {
    type: sum
    label: "Total Clicks"
    description: "The number of unique clicks of an email - one customer can be counted n-times per sent-put"
    group_label: "Numbers"
    sql: ${num_emails_clicked} ;;
    value_format_name: decimal_0
  }

  measure: total_cta_clicks {
    type: number
    label: "Total CTA Clicks"
    description: "The total clicks, that are not clicks on the unsubscribe-link"
    group_label: "Numbers"
    sql:  ${total_emails_clicked} - ${total_emails_unsubscribed};;
    value_format_name: decimal_0
  }

  measure: unique_cta_clicks {
    type: number
    label: "Unique CTA Clicks"
    description: "The unique clicks, that are not clicks on the unsubscribe-link"
    group_label: "Numbers"
    sql: ${total_emails_clicked_unique} - ${total_emails_unsubscribed}  ;;
    value_format_name: decimal_0
  }

  measure: total_emails_unsubscribed {
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

  measure: total_orders {
    type: sum
    label: "Total Orders"
    description: "Number of Orders that happened in the 24h after the last email open"
    group_label: "Numbers"
    sql: ${num_orders};;
    value_format_name: decimal_0
  }

  measure: unique_orders {
    type: sum
    label: "Unique Orders"
    description: "Number of Orders that happened in the 24h after the last email open"
    group_label: "Numbers"
    sql: ${num_unique_orders};;
    value_format_name: decimal_0
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Ratios
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: bounced_emails_per_total_emails_sent {
    type: number
    label: "Bounce Rate"
    description: "Percentage: how many emails have been bounced based on all emails sent"
    group_label: "Ratios"
    sql: ${total_emails_bounced_unique} / NULLIF(${total_emails_sent}, 0);;
    value_format_name: percent_2
  }

  measure: delivered_emails_per_total_emails_sent {
    type: number
    label: "Deliveries Rate"
    description: "Percentage: how many emails have been delivered based on all emails sent"
    group_label: "Ratios"
    sql: ${total_emails_delivered} / NULLIF(${total_emails_sent}, 0);;
    value_format_name: percent_2
  }

  measure: total_opened_emails_per_emails_delivered {
    type: number
    label: "Total Opens Rate"
    description: "Percentage: number of emails opened divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_opened} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: unique_opened_emails_per_emails_delivered {
    type: number
    label: "Unique Opens Rate"
    description: "Percentage: number of unique emails opened divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_opened_unique} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: total_clicked_emails_per_emails_delivered {
    type: number
    label: "Total Clicks Rate"
    description: "Percentage: number of emails clicked divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_clicked} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: total_cta_clicked_emails_per_emails_delivered {
    type: number
    label: "Total CTA Clicks Rate"
    description: "Percentage: number of emails clicked on CTA (not the unsubscribe-link) divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_clicked} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: unique_clicked_emails_per_emails_delivered {
    type: number
    label: "Unique Clicks Rate"
    description: "Percentage: number of unique emails clicked divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_clicked_unique} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: unique_cta_clicked_emails_per_emails_delivered {
    type: number
    label: "Unique CTA Clicks Rate"
    description: "Percentage: number of unique emails clicked on CTA (not the unsubscribe-link) divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${unique_cta_clicks} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: unsubscribed_emails_per_emails_delivered {
    type: number
    label: "Unsubscribes Rate"
    description: "Percentage: number of emails clicked on unsubscribe-link divided by the number of emails delivered"
    group_label: "Ratios"
    sql: ${total_emails_unsubscribed} / NULLIF(${total_emails_delivered}, 0);;
    value_format_name: percent_2
  }

  measure: total_order_rate {
    type: number
    label: "Total Order Rate"
    description: "Percentage: number of orders made in the 24h after the last opening of the email divided by the number of emails opened"
    group_label: "Ratios"
    sql: ${total_orders} / NULLIF(${total_emails_opened}, 0);;
    value_format_name: percent_2
  }

  measure: unique_order_rate {
    type: number
    label: "Unique Order Rate"
    description: "Percentage: number of unique orders made in the 24h after the last opening of the email divided by the number of unique emails opened"
    group_label: "Ratios"
    sql: ${unique_orders} / NULLIF(${total_emails_opened_unique}, 0);;
    value_format_name: percent_2
  }




  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Parameter
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter: KPI_parameter {
    label: "* KPI Parameter *"
    group_label: "* Dynamic KPI Fields *"
    type: unquoted
    # initial sends
    allowed_value: { value: "sends"                  label: "Sends"}
    allowed_value: { value: "unique_recipients"      label: "Unique Recipients"}
    allowed_value: { value: "bounces"                label: "Bounces"}
    allowed_value: { value: "bounce_rate"            label: "Bounce Rate"}
    allowed_value: { value: "soft_bounces"           label: "Soft Bounces"}
    allowed_value: { value: "deliveries"             label: "Deliveries"}
    allowed_value: { value: "deliveries_rate"        label: "Deliveries Rate"}
    # opens
    allowed_value: { value: "total_opens"            label: "Total Opens"}
    allowed_value: { value: "total_opens_rate"       label: "Total Opens Rate"}
    allowed_value: { value: "unique_opens"           label: "Unique Opens"}
    allowed_value: { value: "unique_opens_rate"      label: "Unique Opens Rate"}
    allowed_value: { value: "avg_days_sent_to_open"  label: "ø Days Sent to Open"}
    #clicks
    allowed_value: { value: "total_clicks"           label: "Total Clicks"}
    allowed_value: { value: "total_clicks_rate"      label: "Total Clicks Rate"}
    allowed_value: { value: "total_cta_clicks"       label: "Total CTA Clicks"}
    allowed_value: { value: "total_cta_clicks_rate"  label: "Total CTA Clicks Rate"}
    allowed_value: { value: "unique_clicks"          label: "Unique Clicks"}
    allowed_value: { value: "unique_clicks_rate"     label: "Unique Clicks Rate"}
    allowed_value: { value: "unique_cta_clicks"      label: "Unique CTA Clicks"}
    allowed_value: { value: "unique_cta_clicks_rate" label: "Unique CTA Clicks Rate"}
    allowed_value: { value: "avg_days_sent_to_click" label: "ø Days Sent to Click"}
    # unsubscribes
    allowed_value: { value: "unsubscribes"           label: "Unsubscribes"}
    allowed_value: { value: "unsubscribes_rate"      label: "Unsubscribe Rate"}
    allowed_value: { value: "total_orders"           label: "Total Orders"}
    allowed_value: { value: "total_order_rate"       label: "Total Order Rate"}
    allowed_value: { value: "unique_order_rate"      label: "Unique Order Rate"}
    allowed_value: { value: "unique_orders"          label: "Unique Orders"}

    #
    default_value: "sends"
  }

  measure: KPI_crm {
    label: "CRM KPI (dynamic)"
    group_label: "* Dynamic KPI Fields *"
    label_from_parameter: KPI_parameter
    #value_format: "#,##0.00"
    # value_format_name: id
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'bounces' %}
      ${total_emails_bounced_unique}
    {% elsif KPI_parameter._parameter_value == 'deliveries' %}
      ${total_emails_delivered}
    {% elsif KPI_parameter._parameter_value == 'avg_days_sent_to_click' %}
      ${avg_days_sent_click}
    {% elsif KPI_parameter._parameter_value == 'avg_days_sent_to_open' %}
      ${avg_days_sent_open}
    {% elsif KPI_parameter._parameter_value == 'sends' %}
      ${total_emails_sent}
    {% elsif KPI_parameter._parameter_value == 'soft_bounces' %}
      ${total_emails_soft_bounced_unique}
    {% elsif KPI_parameter._parameter_value == 'total_clicks' %}
      ${total_emails_clicked}
    {% elsif KPI_parameter._parameter_value == 'total_opens' %}
      ${total_emails_opened}
    {% elsif KPI_parameter._parameter_value == 'unique_clicks' %}
      ${total_emails_clicked_unique}
    {% elsif KPI_parameter._parameter_value == 'unique_opens' %}
      ${total_emails_opened_unique}
    {% elsif KPI_parameter._parameter_value == 'unique_recipients' %}
      ${total_recipients}
    {% elsif KPI_parameter._parameter_value == 'unsubscribes' %}
      ${total_emails_unsubscribed}
    {% elsif KPI_parameter._parameter_value == 'bounce_rate' %}
      ${bounced_emails_per_total_emails_sent}
    {% elsif KPI_parameter._parameter_value == 'deliveries_rate' %}
      ${delivered_emails_per_total_emails_sent}
    {% elsif KPI_parameter._parameter_value == 'total_clicks_rate' %}
      ${total_clicked_emails_per_emails_delivered}
    {% elsif KPI_parameter._parameter_value == 'total_opens_rate' %}
      ${total_opened_emails_per_emails_delivered}
    {% elsif KPI_parameter._parameter_value == 'unique_clicks_rate' %}
      ${unique_clicked_emails_per_emails_delivered}
    {% elsif KPI_parameter._parameter_value == 'unique_opens_rate' %}
      ${unique_opened_emails_per_emails_delivered}
    {% elsif KPI_parameter._parameter_value == 'unsubscribes_rate' %}
      ${unsubscribed_emails_per_emails_delivered}

    {% elsif KPI_parameter._parameter_value == 'total_cta_clicks' %}
      ${total_cta_clicks}
    {% elsif KPI_parameter._parameter_value == 'total_cta_clicks_rate' %}
      ${total_cta_clicked_emails_per_emails_delivered}
    {% elsif KPI_parameter._parameter_value == 'unique_cta_clicks' %}
      ${unique_cta_clicks}
    {% elsif KPI_parameter._parameter_value == 'unique_cta_clicks_rate' %}
      ${unique_cta_clicked_emails_per_emails_delivered}
    {% elsif KPI_parameter._parameter_value == 'total_orders' %}
      ${total_orders}
    {% elsif KPI_parameter._parameter_value == 'total_order_rate' %}
      ${total_order_rate}
    {% elsif KPI_parameter._parameter_value == 'unique_orders' %}
      ${unique_orders}
    {% elsif KPI_parameter._parameter_value == 'unique_order_rate' %}
      ${unique_order_rate}
    {% endif %}
    ;;
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
      num_emails_clicked,
      num_orders
    ]
  }
}
