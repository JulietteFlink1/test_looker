view: facebook_campaigns_performance {
  derived_table: {
    sql: with facebook_campaigns_performance as
(
    select date(insights.date_start, 'Europe/Berlin') as date,
    'Facebook Ads' as channel,
    case when REGEXP_CONTAINS(campaigns.name, '_DE_')  then 'DE'
        when REGEXP_CONTAINS(campaigns.name, '_FR_')  then 'FR'
        when REGEXP_CONTAINS(campaigns.name, '_NL_')  then 'NL'
        else 'DE' end as country,
    case when campaigns.account_id in ('277023943913538',
                            '429404584773636',
                            '509478863527409',
                            '330280555434216',
                            '820710328555880') then 'Consumer' else 'Rider' end as app,
    campaigns.id as campaign_id,
    campaigns.name as campaign_name,
    ads.id as ad_id,
    ads.name as ad_name,
    sum(spend) as spend,
    sum(clicks) as clicks,
    sum(impressions) as impressions,
    sum(reach) as reach
    from `flink-backend.facebook_ads.insights_view` insights
    left join `flink-backend.facebook_ads.ads_view` ads
    on insights.ad_id = ads.id
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
    sum(orders.total_gross_amount + orders.discount_amount) as gmv_gross,
    count(_adid_) as cnt_unique_orders
    from `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join `flink-backend.saleor_db_global.warehouse_warehouse` warehouse
    on split(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(JSON_EXTRACT_SCALAR(adjust._publisher_parameters_, '$.hub_code'))),':')[OFFSET(1)] = warehouse.id
    left join `flink-backend.gsheet_store_metadata.hubs` hubs
    on lower(hubs.hub_code) = warehouse.slug
    left join `flink-backend.saleor_db_global.order_order` orders
    on orders.id = cast(JSON_EXTRACT_SCALAR(_publisher_parameters_, '$.order_number') as int64) and orders.country_iso = hubs.country_iso
    where _activity_kind_ = 'event' and lower(_event_name_) = 'firstpurchase'
    and REGEXP_CONTAINS(lower(_network_name_), 'facebook|instagram')
    and {% condition event_date %} date(_PARTITIONTIME) {% endcondition %}
    and _fb_account_id_ is not null
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
    and REGEXP_CONTAINS(lower(_network_name_), 'facebook|instagram')
    and {% condition event_date %} date(_PARTITIONTIME) {% endcondition %}
    and _fb_account_id_ is not null
    group by 1, 2, _tracker_name_
),

facebook_campaigns_orders_events as
(
    select
    date,
        substr(tracker_array[offset(1)], strpos(tracker_array[offset(1)], "(")+1,17) as campaign_id,
        substr(tracker_array[offset(3)], strpos(tracker_array[offset(3)], "(")+1,17) as ad_id,
        sum(cnt_unique_orders) as orders,
        sum(gmv_gross) as gmv_gross
    from facebook_app_orders_array
    group by 1, 2, 3
),

facebook_campaigns_installs_events as
(
    select
    date,
        substr(tracker_array[offset(1)], strpos(tracker_array[offset(1)], "(")+1,17) as campaign_id,
        substr(tracker_array[offset(3)], strpos(tracker_array[offset(3)], "(")+1,17) as ad_id,
        sum(installs) as installs
    from facebook_app_installs_array
    group by 1, 2, 3
)

    select fb.date,
        fb.channel,
        fb.country,
        fb.campaign_name,
        fb.app,
        fb.ad_name,
        fb.spend,
        fb.clicks,
        fb.impressions,
        fb.reach,
        fa.orders,
        fa.gmv_gross,
        fi.installs
from facebook_campaigns_performance fb
left join facebook_campaigns_orders_events fa
on fb.date=fa.date and fb.campaign_id=fa.campaign_id and fb.ad_id=fa.ad_id
left join facebook_campaigns_installs_events fi
on fa.date=fi.date and fa.campaign_id=fi.campaign_id and fa.ad_id=fi.ad_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: event {
    label: "Event"
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

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: app {
    description: "Specifies if the account belongs to the rider or consumer realm"
    type: string
    sql: ${TABLE}.app ;;
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

  dimension: gmv_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.gmv_gross ;;
  }

  dimension: installs {
    type: number
    hidden: yes
    sql: ${TABLE}.installs ;;
  }

  ###### Measures

  measure: total_spend {
    type: sum
    sql: ${spend} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: total_clicks {
    type: sum
    sql: ${clicks} ;;
    value_format_name: decimal_0
  }

  measure: total_impressions {
    type: sum
    sql: ${impressions} ;;
    value_format_name: decimal_0
  }

  measure: total_reach {
    type: sum
    sql: ${reach} ;;
    value_format_name: decimal_0
  }

  measure: total_orders {
    type: sum
    sql: ${orders} ;;
    value_format_name: decimal_0
  }

  measure: total_gmv_gross {
    type: sum
    sql: ${gmv_gross} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: total_installs {
    type: sum
    sql: ${installs} ;;
    value_format_name: decimal_0
  }

  measure: CPC {
    type: number
    description: "Cost per Click"
    sql: ${total_spend} / NULLIF(${total_clicks}, 0) ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: CPI {
    type: number
    description: "Cost per Install"
    sql: ${total_spend} / NULLIF(${total_installs}, 0) ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: CPM {
    type: number
    description: "Cost per 1K impressions"
    sql: ${total_spend} / NULLIF(${total_impressions}/1000, 0) ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: CTR {
    type: number
    description: "Click Through Rate"
    sql: ${total_clicks} / NULLIF(${total_impressions}, 0) ;;
    value_format_name: decimal_1
  }

  measure: AOV {
    type: number
    description: "Average Order Value"
    sql: ${total_gmv_gross} / NULLIF(${total_orders}, 0) ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: ROI {
    type: number
    description: "Return on Investment"
    sql: ${total_gmv_gross} / NULLIF(${total_spend}, 0) ;;
    value_format_name: percent_0
  }

  measure: frequency {
    type: number
    description: "The average frequency at which an ad is seen by unique users"
    sql: ${total_impressions} / NULLIF(${total_reach}, 0) ;;
    value_format_name: decimal_1
  }

  set: detail {
    fields: [
      event_date,
      channel,
      country,
      campaign_name,
      app,
      spend,
      clicks,
      impressions,
      reach,
      orders,
      gmv_gross,
      installs
    ]
  }
}
