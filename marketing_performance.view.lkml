view: marketing_performance {
  derived_table: {
    sql: with marketing_vouchers as
      (
          select distinct vouchers.code from `flink-backend.saleor_db_global.discount_voucher` vouchers
          where UPPER(vouchers.code) NOT LIKE '%EMP%' and
          LENGTH(REGEXP_REPLACE(vouchers.code, r'[\d.]', '')) != 0 and
          UPPER(vouchers.code) NOT LIKE 'AP%' and
          UPPER(vouchers.code) NOT LIKE '%SORRY%' and
          vouchers.type != 'shipping' and
          UPPER(vouchers.code) NOT LIKE '%EMP%' and
          UPPER(vouchers.code) NOT LIKE '%UXR%'
      ),


      fo as
       (
           select
           date(TIMESTAMP_SECONDS(adjust._created_at_), 'Europe/Berlin') as conversion_date,
                 case when adjust._country_ like '%de%' then 'DE'
                    when adjust._country_ like '%fr%' then 'FR'
                    when adjust._country_ like '%nl%' then 'NL'
                    else 'Other' end as country,
                  case when REGEXP_CONTAINS(lower(adjust._network_name_), 'facebook') then 'Facebook Ads'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'google') then 'Google Ads'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'instagram') then 'Facebook Ads'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'organic|flink') then 'Organic'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'apple') then 'Apple Search Ads'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'crm') then 'CRM'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'onefootball|nebenan|marktguru|daisycon') then 'Affiliate'
                    else 'Other' end as channel,
                  count( distinct adjust._adid_) as cnt_customers
                from `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
                where _activity_kind_='event' and _event_name_='FirstPurchase' and _environment_!="sandbox" and
                {% condition acquisition_date %} date(_PARTITIONTIME) {% endcondition %}
                --date(_PARTITIONTIME) >= '2021-06-20'
                group by 1, 2, 3
                order by 1 desc
       ),

       discounts as
       (
           select
           date(TIMESTAMP_SECONDS(adjust._created_at_), 'Europe/Berlin') as conversion_date,
                 case when adjust._country_ like '%de%' then 'DE'
                    when adjust._country_ like '%fr%' then 'FR'
                    when adjust._country_ like '%nl%' then 'NL'
                    else 'Other' end as country,
                  case when REGEXP_CONTAINS(lower(adjust._network_name_), 'facebook') then 'Facebook Ads'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'google') then 'Google Ads'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'instagram') then 'Facebook Ads'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'organic|flink') then 'Organic'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'apple') then 'Apple Search Ads'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'crm') then 'CRM'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'onefootball|nebenan|marktguru|daisycon') then 'Affiliate'
                    else 'Other' end as channel,
                  sum(vouchers.discount_value) as sum_discounts
                from `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
                left join `flink-backend.saleor_db_global.warehouse_warehouse` warehouse
                on split(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(JSON_EXTRACT_SCALAR(adjust._publisher_parameters_, '$.hub_code'))),':')[OFFSET(1)] = warehouse.id
                left join `flink-backend.gsheet_store_metadata.hubs` hubs
                on lower(hubs.hub_code) = warehouse.slug
                left join `flink-backend.saleor_db_global.order_order` orders
                on orders.id = cast(JSON_EXTRACT_SCALAR(_publisher_parameters_, '$.order_number') as int64) and orders.country_iso = hubs.country_iso
                left join `flink-backend.saleor_db_global.discount_voucher` vouchers
                on orders.voucher_id = vouchers.id and orders.country_iso=vouchers.country_iso
                where _activity_kind_='event' and _event_name_='FirstPurchase' and _environment_!="sandbox" and
                (vouchers.code in (select code from marketing_vouchers)) and
                {% condition acquisition_date %} date(_PARTITIONTIME) {% endcondition %}
                --date(_PARTITIONTIME) >= '2021-06-20'
                group by 1, 2, 3
                order by 1
       ),

       installs as
       (
           SELECT date(TIMESTAMP_SECONDS(adjust._created_at_), 'Europe/Berlin') as install_date,
                case when adjust._country_ like '%de%' then 'DE'
                    when adjust._country_ like '%fr%' then 'FR'
                    when adjust._country_ like '%nl%' then 'NL'
                    else 'Other' end as country,
                case when REGEXP_CONTAINS(lower(adjust._network_name_), 'facebook') then 'Facebook Ads'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'google') then 'Google Ads'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'instagram') then 'Facebook Ads'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'organic|flink') then 'Organic'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'apple') then 'Apple Search Ads'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'crm') then 'CRM'
                    when REGEXP_CONTAINS(lower(adjust._network_name_), 'onefootball|nebenan|marktguru|daisycon') then 'Affiliate'
                    else 'Other' end as channel,
                count(distinct adjust._adid_) as cnt_installs
                FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
                where adjust._activity_kind_ in ('install') and adjust._environment_!="sandbox"
                and {% condition acquisition_date %} date(_PARTITIONTIME) {% endcondition %}
                --and date(_PARTITIONTIME) >= '2021-06-20'
                group by 1, 2, 3
       ),

       unique_accounts as
       (
           select distinct case when REGEXP_CONTAINS(lower(adjust._network_name_), 'facebook') then adjust._fb_account_id_
                  when REGEXP_CONTAINS(lower(adjust._network_name_), 'google') then g_campaigns.adwords_customer_id
                  else null end as account_id
                  from `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
                  left join `flink-backend.google_ads.campaign_performance_reports_view` g_campaigns
                  on adjust._google_ads_campaign_id_= g_campaigns.campaign_id
                  where {% condition acquisition_date %} date(_PARTITIONTIME) {% endcondition %}
       ),


      installs_first_orders as
      (
          select installs.install_date as date,
          installs.country,
          installs.channel,
          installs.cnt_installs,
          fo.cnt_customers,
          discounts.sum_discounts
          from installs
          left join fo
          on installs.install_date  = fo.conversion_date  and installs.country=fo.country and installs.channel=fo.channel
          left join discounts
          on installs.install_date  = discounts.conversion_date  and installs.country=discounts.country and installs.channel=discounts.channel
          order by 1 desc
      ),

      facebook_costs as
      (
          select 'Facebook Ads' as channel,
          ads.account_id,
          case when REGEXP_CONTAINS(campaigns.name, 'DE') or REGEXP_CONTAINS(ad_sets.name, 'DE') then 'DE'
              when REGEXP_CONTAINS(campaigns.name, 'FR') or REGEXP_CONTAINS(ad_sets.name, 'FR') then 'FR'
              when REGEXP_CONTAINS(campaigns.name, 'NL') or REGEXP_CONTAINS(ad_sets.name, 'NL') then 'NL'
              else 'DE' end as country,
          date(insights.date_start, 'Europe/Berlin') as date,
          sum(spend) as spend
          from `flink-backend.facebook_ads.insights_view` insights
          left join `flink-backend.facebook_ads.ads_view` ads
          on insights.ad_id = ads.id
          left join `flink-backend.facebook_ads.ad_sets_view` ad_sets
          on ads.adset_id = ad_sets.id
          left join `flink-backend.facebook_ads.campaigns_view` campaigns
          on ads.campaign_id = campaigns.id
          group by 1, 2, 3, 4
      ),

      google_ads_costs as
      (
          select 'Google Ads' as channel,
          adwords_customer_id as account_id,
          case when adwords_customer_id in ('9060460045', '8613454842', '3713562074') then 'NL'
              when adwords_customer_id in ('2579239713', '8843684684', '8009692215') then 'FR' else 'DE' end as country,
          date(date_start, 'Europe/Berlin') as date,
          sum(cost) / 1000000 as spend
          from `flink-backend.google_ads.campaign_performance_reports_view`
          group by 1, 2, 3, 4
      ),

      spend as
      (
          select *
          from
              (
                  select channel, date, country, sum(spend) as spend from facebook_costs where account_id in (select account_id from unique_accounts) group by 1, 2, 3
                  union all
                  select channel, date, country, sum(spend) as spend from google_ads_costs where account_id in (select account_id from unique_accounts) group by 1, 2, 3
              )
      )


      select  installs_first_orders.date,
      installs_first_orders.country,
      installs_first_orders.channel,
      installs_first_orders.cnt_installs,
      installs_first_orders.cnt_customers,
      installs_first_orders.sum_discounts,
      spend.spend,
      row_number() OVER() AS prim_key
      from installs_first_orders
      left join spend
      on installs_first_orders.country = spend.country and installs_first_orders.channel = spend.channel and installs_first_orders.date=spend.date
       ;;
  }

  dimension_group: acquisition {
    label: "Acquisition"
    group_label: "* Dates and Timestamps *"
    description: "Acqusition Date"
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

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: cnt_installs {
    group_label: "* Basic Counts *"
    type: number
    hidden: yes
    sql: ${TABLE}.cnt_installs ;;
  }

  dimension: cnt_customers {
    group_label: "* Basic Counts *"
    type: number
    hidden: yes
    sql: ${TABLE}.cnt_customers ;;
  }

  dimension: sum_discounts {
    group_label: "* Monetary Values *"
    type: number
    hidden: yes
    sql: ${TABLE}.sum_discounts ;;
  }

  dimension: sum_spend {
    group_label: "* Monetary Values *"
    type: number
    hidden: yes
    sql: ${TABLE}.spend ;;
  }

  dimension: prim_key {
    type: number
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.prim_key ;;
  }

  dimension: date {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${acquisition_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${acquisition_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${acquisition_month}
    {% endif %};;
  }

  dimension: date_granularity_pass_through {
    description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
    type: string
    #hidden: yes
    sql:
            {% if date_granularity._parameter_value == 'Day' %}
              "Day"
            {% elsif date_granularity._parameter_value == 'Week' %}
              "Week"
            {% elsif date_granularity._parameter_value == 'Month' %}
              "Month"
            {% endif %};;
  }
  ##### Parameters

  parameter: date_granularity {
    group_label: "* Parameters *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  parameter: KPI_parameter {
    label: "* KPI Parameter *"
    group_label: "* Parameters *"
    type: unquoted
    allowed_value: { value: "orders" label: "# New Customers"}
    allowed_value: { value: "installs" label: "# Installs" }
    allowed_value: { value: "spend" label: "Sum of Spend" }
    allowed_value: { value: "discounts" label: "Sum of Discounts" }
    allowed_value: { value: "cpi" label: "CPI" }
    allowed_value: { value: "cac" label: "CAC" }
    default_value: "orders"
  }

  parameter: include_discounts_in_spend {
    label: "Include discounts in spend?"
    group_label: "* Parameters *"
    type: unquoted
    allowed_value: { value: "yes" label: "Yes"}
    allowed_value: { value: "no" label: "No" }
    default_value: "no"
  }

  ###### Measures

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: installs {
    type: sum
    group_label: "* Basic Counts *"
    sql: ${cnt_installs} ;;
    value_format_name: decimal_0
  }

  measure: customers {
    type: sum
    group_label: "* Basic Counts *"
    sql: ${cnt_customers} ;;
    value_format_name: decimal_0
  }

  measure: discounts {
    type: sum
    group_label: "* Monetary Values *"
    sql: ${sum_discounts} ;;
    hidden: yes
    value_format_name: euro_accounting_0_precision
  }

  measure: spend {
    type: sum
    group_label: "* Monetary Values *"
    sql: ${sum_spend} ;;
    hidden: yes
    value_format_name: euro_accounting_0_precision
  }

  measure: spend_cond {
    label: "Spend"
    group_label: "* Monetary Values *"
    type: number
    sql: {% if include_discounts_in_spend._parameter_value == 'no' %}
            ${spend}
         {% elsif include_discounts_in_spend._parameter_value == 'yes' %}
            (${spend} + ${discounts})
         {% endif %};;
    value_format_name: euro_accounting_0_precision
  }

  measure: CPI {
    label: "CPI"
    description: "Cost per Install"
    group_label: "* Monetary Values *"
    type: number
    sql: ${spend_cond} / nullif(${installs},0) ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: CAC {
    label: "CAC"
    group_label: "* Monetary Values *"
    description: "Cost of Acquisition: Marketing spend  / first orders"
    type: number
    sql: ${spend_cond} / nullif(${customers},0) ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: KPI {
    group_label: "* Dynamic KPI Fields *"
    label: "KPI - Dynamic"
    label_from_parameter: KPI_parameter
    value_format: "#,##0.00"
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'orders' %}
      ${customers}
    {% elsif KPI_parameter._parameter_value == 'installs' %}
      ${installs}
    {% elsif KPI_parameter._parameter_value == 'spend' %}
      ${spend_cond}
    {% elsif KPI_parameter._parameter_value == 'discounts' %}
      ${discounts}
    {% elsif KPI_parameter._parameter_value == 'cpi' %}
      ${CPI}
    {% elsif KPI_parameter._parameter_value == 'cac' %}
      ${CAC}
    {% endif %};;

      html:
        {% if KPI_parameter._parameter_value == 'spend' %}
          €{{ value | round }}
        {% elsif KPI_parameter._parameter_value == 'discounts' %}
          €{{ value | round }}
        {% elsif KPI_parameter._parameter_value == 'cpi' %}
          €{{ rendered_value | round: 2 }}
        {% elsif KPI_parameter._parameter_value == 'cac' %}
          €{{ rendered_value | round: 2 }}
        {% else %}
          {{ value }}
        {% endif %};;

      }

  set: detail {
    fields: [
      acquisition_date,
      country,
      channel,
      cnt_installs,
      cnt_customers,
      sum_discounts,
      sum_spend,
      prim_key
    ]
  }
}
