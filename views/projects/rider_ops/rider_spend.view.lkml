view: rider_spend {
  derived_table: {
    sql: with facebook_spend as
      (
          select 'Facebook' as channel,
          date(insights.date_start, 'Europe/Berlin') as date,
          case when REGEXP_CONTAINS(campaigns.name, '-DE-') or REGEXP_CONTAINS(ad_sets.name, '-DE-') or REGEXP_CONTAINS(ads.name, '-DE-') then 'DE'
              when REGEXP_CONTAINS(campaigns.name, '-FR-') or REGEXP_CONTAINS(ad_sets.name, '-FR-') or REGEXP_CONTAINS(ads.name, '-FR-') then 'FR'
              when REGEXP_CONTAINS(campaigns.name, '-NL-') or REGEXP_CONTAINS(ad_sets.name, '-NL-') or REGEXP_CONTAINS(ads.name, '-NL-') then 'NL'
              else 'Other' end as country,
              sum(spend) as spend
              from `flink-backend.facebook_ads.insights_view` insights
              left join `flink-backend.facebook_ads.ads_view` ads
              on insights.ad_id = ads.id
              left join `flink-backend.facebook_ads.ad_sets_view` ad_sets
              on ads.adset_id = ad_sets.id
              left join `flink-backend.facebook_ads.campaigns_view` campaigns
              on ads.campaign_id = campaigns.id
              left join `flink-backend.facebook_ads.ad_accounts_view` accounts
              on ads.account_id = substr(accounts.id, 5)
              where REGEXP_CONTAINS(lower(accounts.name), 'rider')
              group by 1, 2, 3
      ),

      google_spend as
      (
          select 'Google' as channel,
          date(date_start, 'Europe/Berlin') as date,
          case when adwords_customer_id in ('9060460045', '8613454842', '3713562074') then 'NL'
          when adwords_customer_id in ('2579239713', '8843684684', '8009692215') then 'FR' else 'DE' end as country,
          sum(cost) / 1000000 as spend
          from `flink-backend.google_ads.campaign_performance_reports_view`
          where adwords_customer_id in ('3713562074', '8182265531', '6823073572', '8009692215')
          group by 1, 2, 3
      )

      select * from facebook_spend
      union all
      select * from google_spend
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: date {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: spend {
    type: number
    sql: ${TABLE}.spend ;;
  }

  set: detail {
    fields: [channel, date, country, spend]
  }
}
