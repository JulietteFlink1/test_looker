view: braze_crm_data {
  derived_table: {
    sql: with
      emails_sent as (
          select
              user_id                             as user_id
            , safe_cast(dispatch_id as string)         as dispatch_id
            , campaign_name                       as campaign_name
            , campaign_id                         as campaign_id
            , message_variation_id                as message_variation_id
            , canvas_name                         as canvas_name
            , canvas_id                           as canvas_id
            , canvas_step_name                    as canvas_step_name
            , canvas_variation_name               as canvas_variation_name
            , canvas_variation_id                 as canvas_variation_id
            , COALESCE(split(campaign_name,'_')[OFFSET(1)],split(canvas_name,'_')[OFFSET(1)]) as country
            , min(timestamp)                      as sent_at_first
            , max(timestamp)                      as sent_at_last
            , count(*)                            as all_sends
          from
            `flink-backend.braze.email_sent`
          group by
            user_id, dispatch_id, campaign_id, campaign_name, message_variation_id, canvas_name, canvas_id, canvas_step_name, canvas_variation_name, canvas_variation_id, country
      ),


      campaign_control_group_entered as (
          select
              user_id                             as user_id
            , campaign_id                         as campaign_id
            , campaign_name                       as campaign_name
            , message_variation_id                as message_variation_id
            , safe_cast(MD5(CONCAT(user_id, campaign_id, message_variation_id, safe_cast(timestamp as string))) as string)    as dispatch_id
            , true                                as in_control_group_campaign
            , min(timestamp)                      as sent_at_first
            , max(timestamp)                      as sent_at_last
          from
            `flink-backend.braze.campaign_control_group_entered`
          group by
            user_id, campaign_id, campaign_name, message_variation_id, dispatch_id, in_control_group_campaign
     ),

      canvas_entered as (
          select
              user_id                             as user_id
            , canvas_id                           as canvas_id
            , canvas_name                         as canvas_name
            , canvas_variation_id                 as canvas_variation_id
            , canvas_variation_name               as canvas_variation_name
            , safe_cast(MD5(CONCAT(user_id, canvas_id, canvas_variation_id, safe_cast(timestamp as string))) as string)     as dispatch_id
            , true                                as in_control_group_canvas
            , min(timestamp)                      as sent_at_first
            , max(timestamp)                      as sent_at_last
          from
            `flink-backend.braze.canvas_entered`
          where in_control_group is true
          group by
            user_id, canvas_id, canvas_name, canvas_variation_id, canvas_variation_name,  dispatch_id, in_control_group_canvas
    ),

      emails_sent_all as (  -- includes campaigns and canvases from both variant AND control group
          select
              COALESCE(es.user_id, ce.user_id, cm.user_id)                       as user_id
            , COALESCE(es.dispatch_id, ce.dispatch_id, cm.dispatch_id)           as dispatch_id
            , COALESCE(es.campaign_name, cm.campaign_name)                       as campaign_name
            , COALESCE(es.campaign_id, cm.campaign_id)                           as campaign_id
            , COALESCE(es.canvas_name, ce.canvas_name)                           as canvas_name
            , COALESCE(es.canvas_id, ce.canvas_id)                               as canvas_id
            , COALESCE(es.canvas_step_name)                                      as canvas_step_name
            , COALESCE(es.canvas_variation_name, ce.canvas_variation_name)               as canvas_variation_name
            , COALESCE(es.canvas_variation_id, ce.canvas_variation_id)                 as canvas_variation_id
            , COALESCE(es.message_variation_id, cm.message_variation_id)             as message_variation_id
            , case when (es.canvas_id is not null AND ce.in_control_group_canvas is null) THEN false
                   when (es.canvas_id is not null AND ce.in_control_group_canvas is true) THEN true
                   else null end                  as in_control_group_canvas
            , case when (es.campaign_id is not null AND cm.in_control_group_campaign is true) THEN true
                   when (es.campaign_id is not null AND cm.in_control_group_campaign is null) THEN false
                   else null end                  as in_control_group_campaign
            , min(COALESCE(es.sent_at_first, ce.sent_at_first, cm.sent_at_first))              as sent_at_first
            , max(COALESCE(es.sent_at_last, ce.sent_at_last, cm.sent_at_last))                 as sent_at_last
            , count(*)                            as all_sends
          from
               emails_sent                        as es
          full outer join canvas_entered          as ce
             on es.user_id = ce.user_id
            and es.canvas_id = ce.canvas_id
          full outer join campaign_control_group_entered as cm
             on cm.campaign_id = es.campaign_id
            and cm.user_id = es.user_id
          group by
            user_id, dispatch_id, campaign_id, campaign_name, canvas_name, canvas_id, canvas_step_name, canvas_variation_name, canvas_variation_id, message_variation_id, in_control_group_canvas, in_control_group_campaign
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
            , max(timestamp)                      as opened_at_last
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
            , max(timestamp)                      as clicked_at_last
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
              ,CASE WHEN voucher_id IS NULL THEN 0 ELSE 1 END as has_voucher
              ,discount_amount
              ,(total_gross_amount+discount_amount) as gmv_gross
              ,(total_net_amount+discount_amount) as gmv_net
          from
            `flink-data-prod.saleor_prod_global.order_order`
          where
            status in ('fulfilled', 'partially fulfilled')
      ),

      orders_opened as ( --attribute the order to the last email opened if the order happened within the next 12h
          select distinct
             user_id
             ,LAST_VALUE(dispatch_id) OVER (partition by order_id order by opened_at_first ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as dispatch_id
             ,LAST_VALUE(opened_at_first) OVER (partition by order_id order by opened_at_first  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as opened_at
             ,order_id
             ,order_created_at
             ,gmv_gross
             ,discount_amount
             ,has_voucher
             ,case when has_voucher = 1 then order_id end as order_id_with_voucher
          from
            emails_opened
          join
            orders_raw
            on user_email = user_id
            and timestamp_diff(order_created_at, opened_at_first, hour) BETWEEN 0 and 12
      ),

      orders_sent as ( --attribute the order to the email sent if the order happened within the next 12h
          select distinct
             user_id
             ,LAST_VALUE(dispatch_id) OVER (partition by order_id order by sent_at_first ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as dispatch_id
             ,LAST_VALUE(sent_at_first) OVER (partition by order_id order by sent_at_first  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as sent_at_first
             ,order_id
             ,order_created_at
             ,gmv_gross
             ,discount_amount
             ,has_voucher
             ,case when has_voucher = 1 then order_id end as order_id_with_voucher
          from
            emails_sent_all
          join
            orders_raw
            on user_email = user_id
            and timestamp_diff(order_created_at, sent_at_first, hour) BETWEEN 0 and 12
      ),

      orders_aggregated as (--aggregates orders per user
        select
               COALESCE(oo.user_id,os.user_id)          as user_id
              ,COALESCE(oo.dispatch_id,os.dispatch_id)  as dispatch_id
              ,SUM(oo.has_voucher)                         as num_vouchers_opened
              ,COUNT(oo.order_id_with_voucher)             as num_orders_with_vouchers_opened
              ,COUNT(oo.order_id)                          as num_orders_opened
              ,SUM(oo.discount_amount)                     as discount_amount_opened
              ,SUM(oo.gmv_gross)                  as gmv_gross_opened
              ,SUM(os.has_voucher)             as num_vouchers_sent
              ,COUNT(os.order_id_with_voucher) as num_orders_with_vouchers_sent
              ,COUNT(os.order_id)              as num_orders_sent
              ,SUM(os.discount_amount)         as discount_amount_sent
              ,SUM(os.gmv_gross)               as gmv_gross_sent
        from
          orders_opened oo
        left join
          orders_sent os
        on oo.user_id = os.user_id and oo.dispatch_id = os.dispatch_id
        group by 1,2
      )

      select
        -- DIMENSIONS
          es.campaign_id                                        as campaign_id
        , es.campaign_name                                      as campaign_name
        , es.canvas_name                                        as canvas_name
        , es.canvas_step_name                                   as canvas_step_name
        , es.canvas_variation_name                              as canvas_variation_name
        , es.in_control_group_canvas                            as in_control_group_canvas
        , es.in_control_group_campaign                          as in_control_group_campaign
        , COALESCE(split(es.campaign_name,'_')[OFFSET(1)],split(es.canvas_name,'_')[OFFSET(1)]) as country
        , date(es.sent_at_first, "Europe/Berlin")               as email_sent_at
        , date_diff(eo.opened_at_first, es.sent_at_first, day)        as days_sent_to_open
        , date_diff(ec.clicked_at_first, es.sent_at_first, day)       as days_sent_to_click
        -- MEASURES
        , count(distinct concat(es.user_id , es.dispatch_id))   as num_emails_sent
        , sum(es.all_sends)                                     as num_all_sents

        , count(distinct concat(eb.user_id , eb.dispatch_id))   as num_unique_emails_bounced
        , sum(eb.num_bounced )                                  as num_emails_bounced
        , count(distinct concat(esb.user_id , esb.dispatch_id)) as num_unique_emails_soft_bounced
        , sum(esb.num_soft_bounced )                            as num_emails_soft_bounced

        , count(distinct concat(ed.user_id , ed.dispatch_id))   as num_emails_delivered

        , count(distinct concat(eo.user_id , eo.dispatch_id))   as num_unique_emails_opened
        , sum(eo.num_opening  )                                 as num_emails_opened

        , count(distinct concat(ec.user_id , ec.dispatch_id))   as num_unique_emails_clicked
        , sum(ec.num_clicks)                                    as num_emails_clicked

        , count(distinct concat(uns.user_id , uns.dispatch_id)) as num_unique_unsubscribed

        , sum(num_orders_opened)                                as num_orders_opened
        , sum(num_orders_sent)                                  as num_orders_sent
        , count(distinct concat(oa.user_id , oa.dispatch_id))   as num_unique_orders

        , sum(num_orders_with_vouchers_opened)                  as num_orders_with_vouchers_opened
        , sum(num_orders_with_vouchers_sent)                    as num_orders_with_vouchers_sent

        , sum(num_vouchers_opened)                              as num_vouchers_opened
        , sum(num_vouchers_sent)                                as num_vouchers_sent

        , sum(discount_amount_opened)                           as discount_amount_opened
        , sum(discount_amount_sent)                             as discount_amount_sent

        , sum(gmv_gross_opened)                                 as gmv_gross_opened
        , sum(gmv_gross_sent)                                   as gmv_gross_sent

      from
                emails_sent_all                 as es
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
      left join orders_aggregated               as oa
             on es.user_id     = oa.user_id
            and es.dispatch_id = oa.dispatch_id

      group by
        campaign_id, campaign_name, canvas_name, country, email_sent_at, days_sent_to_open, days_sent_to_click,canvas_step_name, canvas_variation_name, in_control_group_canvas, in_control_group_campaign;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Dimensions
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: campaign_id {
    label: "Campaign ID"
    description: "The email campaign ID defined in Braze"
    type: string
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: campaign_name {
    label: "Campaign Name"
    description: "The email campaign name defined in Braze"
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: canvas_name {
    label: "Canvas Name"
    description: "The email canvas name defined in Braze"
    type: string
    sql: ${TABLE}.canvas_name ;;
  }

  dimension: in_control_group_canvas {
    label: "Control Group for Canvas"
    description: "Canvas group name defined in Braze"
    type: yesno
    sql: ${TABLE}.in_control_group_canvas ;;
  }

  dimension: in_control_group_campaign {
    label: "Control Group for Campaign"
    description: "Campaign group name defined in Braze"
    type: yesno
    sql: ${TABLE}.in_control_group_campaign ;;
  }

  dimension: canvas_step_name {
    label: "Canvas Step Name"
    description: "The email canvas step name defined in Braze"
    type: string
    sql: ${TABLE}.canvas_step_name ;;
  }

  dimension: canvas_variation_name {
    label: "Canvas Variation Step Name"
    description: "The email canvas variation name defined in Braze"
    type: string
    sql: ${TABLE}.canvas_variation_name ;;
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
    sql: CONCAT(${TABLE}.campaign_name,${TABLE}.canvas_name,${TABLE}.canvas_step_name, ${TABLE}.canvas_variation_name, ${TABLE}.country, ${TABLE}.email_sent_at) ;;
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

  dimension: num_emails_sent_count_all {
    type: number
    sql: ${TABLE}.num_emails_sent_count_all ;;
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

  dimension: num_orders_opened {
    type: number
    sql: ${TABLE}.num_orders_opened ;;
    hidden: yes
  }

  dimension: num_orders_sent {
    type: number
    sql: ${TABLE}.num_orders_sent ;;
    hidden: yes
  }

  dimension: num_unique_orders {
    type: number
    sql: ${TABLE}.num_unique_orders ;;
    hidden: yes
  }

  dimension: num_orders_with_vouchers_opened {
    type: number
    sql: ${TABLE}.num_orders_with_vouchers_opened ;;
    hidden: yes
  }

  dimension: num_orders_with_vouchers_sent {
    type: number
    sql: ${TABLE}.num_orders_with_vouchers_sent ;;
    hidden: yes
  }

  dimension: discount_amount_opened {
    type: number
    sql: ${TABLE}.discount_amount_opened ;;
    hidden: yes
  }

  dimension: discount_amount_sent {
    type: number
    sql: ${TABLE}.discount_amount_sent ;;
    hidden: yes
  }

  dimension: gmv_gross_opened {
    type: number
    sql: ${TABLE}.gmv_gross_opened ;;
    hidden: yes
  }

  dimension: gmv_gross_sent {
    type: number
    sql: ${TABLE}.gmv_gross_sent ;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Measures
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: total_recipients {
    type: sum
    label: "Unique Recipients"
    description: "The number of unique recipients of an email campaign"
    group_label: "Numbers"
    sql: ${num_emails_sent} ;;
    value_format_name: decimal_0
  }

  measure: total_all_sent {
    type: sum
    label: "Total Emails Sent"
    description: "The number of unique recipients of an email campaign"
    group_label: "Numbers"
    sql: ${num_all_sents} ;;
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

  measure: total_orders_opened {
    type: sum
    label: "Total Orders opened "
    description: "Number of Orders that happened in the 24h after the last email open"
    group_label: "Numbers"
    sql: ${num_orders_opened};;
    value_format_name: decimal_0
  }

  measure: total_orders_sent {
    type: sum
    label: "Total Orders sent"
    description: "Number of Orders that happened in the 24h after the last email open"
    group_label: "Numbers"
    sql: ${num_orders_sent};;
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

  measure: total_orders_with_vouchers_opened {
    type: sum
    label: "Total Orders with Vouchers opened"
    description: "Number of Orders with Vouchers that happened in the 24h after the last email open"
    group_label: "Numbers"
    sql: ${num_orders_with_vouchers_opened};;
    value_format_name: decimal_0
  }

  measure: total_orders_with_vouchers_sent {
    type: sum
    label: "Total Orders with Vouchers sent"
    description: "Number of Orders with Vouchers that happened in the 24h after the last email open"
    group_label: "Numbers"
    sql: ${num_orders_with_vouchers_sent};;
    value_format_name: decimal_0
  }

  measure: total_discount_opened {
    type: sum
    label: "Total Discount opened"
    description: "Total Value of discount vouchers"
    group_label: "Numbers"
    sql: ${discount_amount_opened};;
    value_format_name: decimal_0
  }

  measure: total_discount_sent {
    type: sum
    label: "Total Discount sent"
    description: "Total Value of discount vouchers"
    group_label: "Numbers"
    sql: ${discount_amount_sent};;
    value_format_name: decimal_0
  }

  measure: total_gmv_gross_opened {
    type: sum
    label: "Total GMV (gross) opened"
    description: "Total GMV (gross) of orders"
    group_label: "Numbers"
    sql: ${gmv_gross_opened};;
    value_format_name: decimal_0
  }

  measure: total_gmv_gross_sent {
    type: sum
    label: "Total GMV (gross) sent"
    description: "Total GMV (gross) of orders"
    group_label: "Numbers"
    sql: ${gmv_gross_sent};;
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
    sql: ${total_emails_bounced_unique} / NULLIF(${total_all_sent}, 0);;
    value_format_name: percent_2
  }

  measure: delivered_emails_per_total_emails_sent {
    type: number
    label: "Deliveries Rate"
    description: "Percentage: how many emails have been delivered based on all emails sent"
    group_label: "Ratios"
    sql: ${total_emails_delivered} / NULLIF(${total_all_sent}, 0);;
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

  measure: total_order_rate_opened {
    type: number
    label: "Total Order Rate (opened)"
    description: "Percentage: number of orders made in the 12h after the last opening of the email divided by the number of emails opened"
    group_label: "Ratios"
    sql: ${total_orders_opened} / NULLIF(${total_emails_opened}, 0);;
    value_format_name: percent_2
  }

  measure: total_order_rate_sent {
    type: number
    label: "Total Order Rate (sent)"
    description: "Percentage: number of orders made in the 12h after email being sent divided by the number of emails opened"
    group_label: "Ratios"
    sql: ${total_orders_sent} / NULLIF(${total_all_sent}, 0);;
    value_format_name: percent_2
  }

  measure: unique_order_rate_opened {
    type: number
    label: "Unique Order Rate (opened)"
    description: "Percentage: number of unique orders made in the 24h after the last opening of the email divided by the number of unique emails opened"
    group_label: "Ratios"
    sql: ${unique_orders} / NULLIF(${total_emails_opened_unique}, 0);;
    value_format_name: percent_2
  }

  measure: unique_order_rate_sent {
    type: number
    label: "Unique Order Rate (sent)"
    description: "Percentage: number of unique orders made in the 12h after sending an email divided by the number of unique emails opened"
    group_label: "Ratios"
    sql: ${unique_orders} / NULLIF(${total_recipients}, 0);;
    value_format_name: percent_2
  }

  measure: total_order_rate_with_vouchers_opened {
    type: number
    label: "Total Order Rate with Vouchers (opened)"
    description: "Percentage: number of orders made in the 12h after the last opening of the email divided by the number of emails opened"
    group_label: "Ratios"
    sql: ${total_orders_with_vouchers_opened} / NULLIF(${total_emails_opened}, 0);;
    value_format_name: percent_2
  }

  measure: total_order_rate_with_vouchers_sent {
    type: number
    label: "Total Order Rate with Vouchers (sent)"
    description: "Percentage: number of orders made in the 12h after sending an email divided by the number of emails opened"
    group_label: "Ratios"
    sql: ${total_orders_with_vouchers_sent} / NULLIF(${total_all_sent}, 0);;
    value_format_name: percent_2
  }

  measure: discount_order_share_opened {
    type: number
    label: "Discount Order Share (opened)"
    description: "Percentage: number of orders with voucher discounts divided by the total number of ordres made in the 12h after the last opening of the email"
    group_label: "Ratios"
    sql: ${total_orders_with_vouchers_opened} / NULLIF(${total_orders_opened}, 0);;
    value_format_name: percent_2
  }

  measure: discount_order_share_sent {
    type: number
    label: "Discount Order Share (sent)"
    description: "Percentage: number of orders with voucher discounts divided by the total number of ordres made in the 12h after sending an email"
    group_label: "Ratios"
    sql: ${total_order_rate_with_vouchers_sent} / NULLIF(${total_orders_sent}, 0);;
    value_format_name: percent_2
  }

  measure: discount_value_share_opened {
    type: number
    label: "Discount Value Share (opened) "
    description: "Percentage: total of voucher discounts divided by the total gmv (gross) of ordres made in the 12h after the last opening of the email"
    group_label: "Ratios"
    sql: ${total_discount_opened} / NULLIF(${total_gmv_gross_opened}, 0);;
    value_format_name: percent_2
  }

  measure: discount_value_share_sent {
    type: number
    label: "Discount Value Share (sent) "
    description: "Percentage: total of voucher discounts divided by the total gmv (gross) of ordres made in the 12h after sending an email"
    group_label: "Ratios"
    sql: ${total_discount_sent} / NULLIF(${total_gmv_gross_sent}, 0);;
    value_format_name: percent_2
  }

  measure: average_order_value_opened {
    type: number
    label: "Average Order Value (opened)"
    description: "Average GMV (gross) based on Total Orders"
    group_label: "Ratios"
    sql: ${total_gmv_gross_opened} / NULLIF(${total_orders_opened}, 0);;
    value_format_name: decimal_2
  }

  measure: average_order_value_sent {
    type: number
    label: "Average Order Value (sent)"
    description: "Average GMV (gross) based on Total Orders"
    group_label: "Ratios"
    sql: ${total_gmv_gross_sent} / NULLIF(${total_orders_sent}, 0);;
    value_format_name: decimal_2
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
    # orders
    allowed_value: { value: "total_orders_opened"           label: "Total Orders (opened)"}
    allowed_value: { value: "total_orders_sent"           label: "Total Orders (sent)"}

    allowed_value: { value: "total_order_rate_opened"       label: "Total Order Rate (opened)"}
    allowed_value: { value: "total_order_rate_sent"       label: "Total Order Rate (sent)"}

    allowed_value: { value: "unique_order_rate_opened"      label: "Unique Order Rate (opened)"}
    allowed_value: { value: "unique_order_rate_sent"      label: "Unique Order Rate (sent)"}

    allowed_value: { value: "unique_orders"          label: "Unique Orders"}

    allowed_value: { value: "total_orders_with_vouchers_opened"        label: "Total Orders with Voucher (opened)"}
    allowed_value: { value: "total_orders_with_vouchers_sent"        label: "Total Orders with Voucher (sent)"}

    allowed_value: { value: "total_order_rate_with_vouchers_opened"    label: "Total Order Rate with Voucher (opened)"}
    allowed_value: { value: "total_order_rate_with_vouchers_sent"    label: "Total Order Rate with Voucher (sent)"}


    allowed_value: { value: "total_discount_opened"           label: "Total Discount Value (opened)"}
    allowed_value: { value: "total_discount_sent"           label: "Total Discount Value (sent)"}


    allowed_value: { value: "total_gmv_gross_opened"           label: "Total GMV (gross) (opened)"}
    allowed_value: { value: "total_gmv_gross_sent"           label: "Total GMV (gross) (sent)"}

    allowed_value: { value: "average_order_value_opened"           label: "Average Order Value (opened)"}
    allowed_value: { value: "average_order_value_sent"           label: "Average Order Value (sent)"}

    allowed_value: { value: "discount_order_share_opened"           label: "Discount Order Share (opened)"}
    allowed_value: { value: "discount_order_share_sent"           label: "Discount Order Share (sent)"}

    allowed_value: { value: "discount_value_share_opened"           label: "Discount Value Share (opened)"}
    allowed_value: { value: "discount_value_share_sent"           label: "Discount Value Share (sent)"}


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
      ${total_all_sent}
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


    {% elsif KPI_parameter._parameter_value == 'total_orders_opened' %}
      ${total_orders_opened}
    {% elsif KPI_parameter._parameter_value == 'total_orders_sent' %}
      ${total_orders_sent}

    {% elsif KPI_parameter._parameter_value == 'total_order_rate_opened' %}
      ${total_order_rate_opened}
    {% elsif KPI_parameter._parameter_value == 'total_order_rate_sent' %}
      ${total_order_rate_sent}

    {% elsif KPI_parameter._parameter_value == 'unique_orders' %}
      ${unique_orders}

    {% elsif KPI_parameter._parameter_value == 'unique_order_rate_opened' %}
      ${unique_order_rate_opened}
    {% elsif KPI_parameter._parameter_value == 'unique_order_rate_sent' %}
      ${unique_order_rate_sent}

    {% elsif KPI_parameter._parameter_value == 'total_orders_with_vouchers_opened' %}
      ${total_orders_with_vouchers_opened}
    {% elsif KPI_parameter._parameter_value == 'total_orders_with_vouchers_sent' %}
      ${total_orders_with_vouchers_sent}

    {% elsif KPI_parameter._parameter_value == 'total_order_rate_with_vouchers_opened' %}
      ${total_order_rate_with_vouchers_opened}
    {% elsif KPI_parameter._parameter_value == 'total_order_rate_with_vouchers_sent' %}
      ${total_order_rate_with_vouchers_sent}

    {% elsif KPI_parameter._parameter_value == 'discount_order_share_opened' %}
      ${discount_order_share_opened}
    {% elsif KPI_parameter._parameter_value == 'discount_order_share_sent' %}
      ${discount_order_share_sent}

    {% elsif KPI_parameter._parameter_value == 'discount_value_share_opened' %}
      ${discount_value_share_opened}
    {% elsif KPI_parameter._parameter_value == 'discount_value_share_sent' %}
      ${discount_value_share_sent}

    {% elsif KPI_parameter._parameter_value == 'total_gmv_gross_opened' %}
      ${total_gmv_gross_opened}
    {% elsif KPI_parameter._parameter_value == 'total_gmv_gross_sent' %}
      ${total_gmv_gross_sent}

    {% elsif KPI_parameter._parameter_value == 'total_discount_opened' %}
      ${total_discount_opened}
    {% elsif KPI_parameter._parameter_value == 'total_discount_sent' %}
      ${total_discount_sent}

    {% elsif KPI_parameter._parameter_value == 'average_order_value_opened' %}
      ${average_order_value_opened}
    {% elsif KPI_parameter._parameter_value == 'average_order_value_sent' %}
      ${average_order_value_sent}

    {% endif %}
    ;;
  }


  # parameter: funnel_type_parameter {
  #   label: "Funnel KPI Type"
  #   group_label: "Funnel KPI Dynamic"
  #   type: unquoted
  #   # initial sends
  #   allowed_value: { value: "unique"                  label: "Unique"}
  #   allowed_value: { value: "totals"                  label: "Totals"}

  #   default_value: "unique"
  # # }

  # measure: recipients_parameter {
  #   label: "Recipients"
  #   group_label: "Funnel KPI Dynamic"
  #   # label_from_parameter: funnel_type_parameter
  #   type: number
  #   sql:
  #   {% if funnel_type_parameter._parameter_value == 'unique' %}
  #     ${total_recipients}
  #   {% elsif funnel_type_parameter._parameter_value == 'totals' %}
  #     ${total_all_sent}
  #     {% endif %}
  #   ;;
  # }

  # measure: deliveries_parameter {
  #   label: "Deliveries"
  #   group_label: "Funnel KPI Dynamic"
  #   # label_from_parameter: funnel_type_parameter
  #   type: number
  #   sql:
  #   {% if funnel_type_parameter._parameter_value == 'unique' %}
  #     ${total_emails_delivered}
  #   {% elsif funnel_type_parameter._parameter_value == 'totals' %}
  #     ${total_emails_delivered}
  #     {% endif %}
  #   ;;
  # }

  # measure: opens_parameter {
  #   label: "Opens"
  #   group_label: "Funnel KPI Dynamic"
  #   # label_from_parameter: funnel_type_parameter
  #   type: number
  #   sql:
  #   {% if funnel_type_parameter._parameter_value == 'unique' %}
  #     ${total_emails_opened_unique}
  #   {% elsif funnel_type_parameter._parameter_value == 'totals' %}
  #     ${total_emails_opened}
  #     {% endif %}
  #   ;;
  # }

  # measure: cta_clicks_parameter {
  #   label: "CTA Clicks"
  #   group_label: "Funnel KPI Dynamic"
  #   # label_from_parameter: funnel_type_parameter
  #   type: number
  #   sql:
  #   {% if funnel_type_parameter._parameter_value == 'unique' %}
  #     ${unique_cta_clicks}
  #   {% elsif funnel_type_parameter._parameter_value == 'totals' %}
  #     ${total_cta_clicks}
  #     {% endif %}
  #   ;;
  # }

  # measure: orders_parameter {
  #   label: "Orders"
  #   group_label: "Funnel KPI Dynamic"
  #   # label_from_parameter: funnel_type_parameter
  #   type: number
  #   sql:
  #   {% if funnel_type_parameter._parameter_value == 'unique' %}
  #     ${unique_orders}
  #   {% elsif funnel_type_parameter._parameter_value == 'totals' %}
  #     ${total_orders_opened}
  #     {% endif %}
  #   ;;
  # }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #           Detail
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  set: detail {
    fields: [
      campaign_name,
      canvas_name,
      in_control_group_canvas,
      in_control_group_campaign,
      canvas_step_name,
      canvas_variation_name,
      country,
      email_sent_at,
      days_sent_to_open,
      days_sent_to_click,
      num_emails_sent,
      total_all_sent,
      num_unique_emails_bounced,
      num_emails_bounced,
      num_unique_emails_soft_bounced,
      num_emails_soft_bounced,
      num_emails_delivered,
      num_unique_emails_opened,
      num_emails_opened,
      num_unique_emails_clicked,
      num_emails_clicked,
      num_orders_opened,
      num_orders_sent,
      num_orders_with_vouchers_opened,
      num_orders_with_vouchers_sent,
      discount_amount_opened,
      discount_amount_sent,
      gmv_gross_opened,
      gmv_gross_sent

    ]
  }
}
