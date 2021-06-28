view: facebook_ads_performance {
  derived_table: {
    sql: with facebook_performance as
      (
          select date(insights.date_start, 'Europe/Berlin') as date,
          'Facebook Ads' as channel,
          case when REGEXP_CONTAINS(campaigns.name, '_DE_') or REGEXP_CONTAINS(ad_sets.name, '_DE_') then 'DE'
              when REGEXP_CONTAINS(campaigns.name, '_FR_') or REGEXP_CONTAINS(ad_sets.name, '_FR_') then 'FR'
              when REGEXP_CONTAINS(campaigns.name, '_NL_') or REGEXP_CONTAINS(ad_sets.name, '_NL_') then 'NL'
              else 'DE' end as country,
          substr(ad_accounts.id,5) account_id,
          ad_accounts.name as account_name,
          campaigns.name as campaign_name,
          ad_sets.name as ad_set_name,
          ads.name as ad_name,
          sum(spend) as spend,
          sum(clicks) as clicks,
          sum(impressions) as impressions,
          sum(reach) as reach
          from `flink-backend.facebook_ads.insights_view` insights
          left join `flink-backend.facebook_ads.ads_view` ads
          on insights.ad_id = ads.id
          left join `flink-backend.facebook_ads.ad_accounts_view` ad_accounts
          on ads.account_id = substr(ad_accounts.id,5)
          left join `flink-backend.facebook_ads.ad_sets_view` ad_sets
          on ads.adset_id = ad_sets.id
          left join `flink-backend.facebook_ads.campaigns_view` campaigns
          on ads.campaign_id = campaigns.id
          group by 1, 2, 3, 4, 5, 6, 7, 8
          order by 1 desc, 2, 3, 4, 5
      ),

      facebook_app_orders_array as
      (
          select _fb_account_id_,
          date(timestamp_seconds(_created_at_), 'Europe/Berlin') as date,
          split(_tracker_name_, "::") as tracker_array,
          count(_adid_) as cnt_unique_orders
          from `flink-backend.customlytics_adjust.adjust_raw_imports`
          where _activity_kind_ = 'event' and lower(_event_name_) = 'firstpurchase'
          and REGEXP_CONTAINS(lower(_network_name_), 'facebook')
          and {% condition event_date %} date(_PARTITIONTIME) {% endcondition %}
          group by 1, 2, _tracker_name_
      ),

      facebook_app_installs_array as
      (
          select _fb_account_id_,
          date(timestamp_seconds(_created_at_), 'Europe/Berlin') as date,
          split(_tracker_name_, "::") as tracker_array,
          count(_adid_) as installs
          from `flink-backend.customlytics_adjust.adjust_raw_imports`
          where _activity_kind_ = 'install'
          and REGEXP_CONTAINS(lower(_network_name_), 'facebook')
          and {% condition event_date %} date(_PARTITIONTIME) {% endcondition %}
          group by 1, 2, _tracker_name_
      ),

      facebook_app_orders_events as
      (
          select _fb_account_id_ as account_id,
          date,
              trim(left(tracker_array[offset(1)], strpos(tracker_array[offset(1)], "(")-1)) as campaign_name,
              trim(left(tracker_array[offset(2)], strpos(tracker_array[offset(2)], "(")-1)) as ad_set_name,
              trim(left(tracker_array[offset(3)], strpos(tracker_array[offset(3)], "(")-1)) as ad_name,
              sum(cnt_unique_orders) as orders
          from facebook_app_orders_array
          group by 1, 2, 3, 4, 5
      ),

      facebook_app_installs_events as
      (
          select _fb_account_id_ as account_id,
          date,
              trim(left(tracker_array[offset(1)], strpos(tracker_array[offset(1)], "(")-1)) as campaign_name,
              trim(left(tracker_array[offset(2)], strpos(tracker_array[offset(2)], "(")-1)) as ad_set_name,
              trim(left(tracker_array[offset(3)], strpos(tracker_array[offset(3)], "(")-1)) as ad_name,
              sum(installs) as installs
          from facebook_app_installs_array
          group by 1, 2, 3, 4, 5
      )


          select distinct fb.date,
              fb.channel,
              fb.country,
              fb.account_name,
              fb.campaign_name,
              fb.ad_set_name,
              fb.ad_name,
              fb.spend,
              fb.clicks,
              fb.impressions,
              fb.reach,
              fa.orders,
              fi.installs
      from facebook_performance fb
      left join facebook_app_orders_events fa
      on fb.date=fa.date and fb.account_id=fa.account_id and fb.campaign_name=fa.campaign_name and fb.ad_set_name=fa.ad_set_name and fb.ad_name=fa.ad_name
      left join facebook_app_installs_events fi
      on fb.date=fi.date and fb.account_id=fi.account_id and fb.campaign_name=fi.campaign_name and fb.ad_set_name=fi.ad_set_name and fb.ad_name=fi.ad_name
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: event {
    label: "Event Date"
    group_label: "* Dates and Timestamps *"
    description: "Event Date"
    type: time
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date ;;
    datatype: date
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: account_name {
    type: string
    sql: ${TABLE}.account_name ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: ad_set_name {
    type: string
    sql: ${TABLE}.ad_set_name ;;
  }

  dimension: ad_name {
    type: string
    sql: ${TABLE}.ad_name ;;
  }

  dimension: spend {
    type: number
    hidden: yes
    sql: ${TABLE}.spend ;;
  }

  dimension: clicks {
    type: number
    hidden: yes
    sql: ${TABLE}.clicks ;;
  }

  dimension: impressions {
    type: number
    hidden: yes
    sql: ${TABLE}.impressions ;;
  }

  dimension: reach {
    type: number
    hidden: yes
    sql: ${TABLE}.reach ;;
  }

  dimension: orders {
    type: number
    hidden: yes
    sql: ${TABLE}.orders ;;
  }

  dimension: installs {
    type: number
    hidden: yes
    sql: ${TABLE}.installs ;;
  }

  ###### Measures

  measure: total_spend {
    label: "Total Spend"
    type: sum
    sql: ${spend} ;;
  }

  measure: total_clicks {
    label: "Total Clicks"
    type: sum
    sql: ${clicks} ;;
  }

  measure: total_impressions {
    label: "Total Impressions"
    type: sum
    sql: ${impressions} ;;
  }

  measure: total_reach {
    label: "Total Reach"
    type: sum
    sql: ${reach} ;;
  }

  measure: total_orders {
    label: "Total Orders"
    type: sum
    sql: ${orders} ;;
  }

  measure: total_installs {
    label: "Total Installs"
    type: sum
    sql: ${installs} ;;
  }


  set: detail {
    fields: [
      event_date,
      channel,
      country,
      account_name,
      campaign_name,
      ad_set_name,
      ad_name,
      spend,
      clicks,
      impressions,
      reach,
      orders,
      installs
    ]
  }
}
