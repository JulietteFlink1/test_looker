view: marketing_spend_installs_orders {
  derived_table: {
    sql: with facebook_costs as
      (
          select 'Facebook Ads' as channel,
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
          group by 1, 2, 3
      ),

      google_ads_costs as
      (
          select 'Google Ads' as channel,
              case when adwords_customer_id in ('9060460045', '8613454842', '3713562074') then 'NL'
              when adwords_customer_id in ('2579239713', '8843684684', '8009692215') then 'FR' else 'DE' end as country,
          date(date_start, 'Europe/Berlin') as date,
          sum(cost) / 1000000 as spend
          from `flink-backend.google_ads.campaign_performance_reports_view`
          group by 1, 2, 3
      ),

      first_orders as
      (
          select distinct _adid_,
          vouchers.code,
          vouchers.discount_value,
           hubs.hub_name,
           hubs.city as city
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
          {% condition acquisition_date %} date(_PARTITIONTIME) {% endcondition %}
          order by 1
      ),


      installs as
      (
          SELECT adjust._adid_,
          case when adjust._country_ like '%de%' then 'DE'
              when adjust._country_ like '%fr%' then 'FR'
              when adjust._country_ like '%nl%' then 'NL'
              else 'Other' end as country,
          first_orders.city,
          case when REGEXP_CONTAINS(lower(adjust._network_name_), 'facebook') then 'Facebook Ads'
              when REGEXP_CONTAINS(lower(adjust._network_name_), 'google') then 'Google Ads'
              when REGEXP_CONTAINS(lower(adjust._network_name_), 'instagram') then 'Facebook Ads'
              when REGEXP_CONTAINS(lower(adjust._network_name_), 'organic|flink') then 'Organic'
              when REGEXP_CONTAINS(lower(adjust._network_name_), 'apple') then 'Apple Search Ads'
              when REGEXP_CONTAINS(lower(adjust._network_name_), 'crm') then 'CRM'
              else 'Other' end as channel,
          adjust._os_name_,
          case when adjust._adid_ in (select distinct _adid_ FROM `flink-backend.customlytics_adjust.adjust_raw_imports`
              where _activity_kind_='event' and _event_name_='FirstPurchase' and _environment_!="sandbox" and {% condition acquisition_date %} date(_PARTITIONTIME) {% endcondition %}) then 1 else 0 end as converted,
          first_orders.code as first_order_voucher_code,
          first_orders.discount_value as first_order_discount_value,
          first_orders.hub_name as first_order_hub,
          MIN(date(TIMESTAMP_SECONDS(adjust._created_at_), 'Europe/Berlin')) as install_time
          FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
          left join first_orders
          on adjust._adid_ = first_orders._adid_
          where adjust._activity_kind_ in ('install') and adjust._environment_!="sandbox"
          and {% condition acquisition_date %} date(_PARTITIONTIME) {% endcondition %}
          group by 1, 2, 3, 4, 5, 6, 7, 8, 9
      ),

      installs_conversions as
      (
          select country,
          city,
          channel,
          _os_name_,
          install_time,
          first_order_voucher_code,
          first_order_discount_value,
          first_order_hub,
          count(distinct _adid_) as installs,
          sum(converted) as conversions
              from (
                  select _adid_,
                  country,
                  city,
                  channel,
                  _os_name_,
                  install_time,
                  converted,
                  first_order_voucher_code,
                  first_order_discount_value,
                  first_order_hub,
                  ROW_NUMBER() OVER (PARTITION BY _adid_, install_time) as row_number
                  from installs
                  )
          where row_number = 1
          group by 1, 2, 3, 4, 5, 6, 7, 8
      ),

      spend as
      (
          select * from facebook_costs
          union all
          select * from google_ads_costs
      )

      select installs_conversions.country,
      case when city is null then 'Other' else city end as city,
      installs_conversions.channel,
      _os_name_,
      install_time,
      first_order_voucher_code,
      first_order_discount_value,
      first_order_hub,
      installs,
      conversions,
      installs / sum(installs) over (partition by install_time, installs_conversions.country, installs_conversions.channel) * spend.spend as spend,
      row_number() OVER() AS prim_key
      from installs_conversions
      left join spend
      on installs_conversions.country = spend.country and installs_conversions.channel = spend.channel and installs_conversions.install_time=spend.date
      order by prim_key asc
       ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: channel {
    label: "Marketing Channel"
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: _os_name_ {
    label: "OS"
    type: string
    sql: ${TABLE}._os_name_ ;;
  }

  #dimension: install_time {
  #  label: "Install Date"
  #  type: date
  #  datatype: date
  #  sql: ${TABLE}.install_time ;;
  #}

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
    sql: ${TABLE}.install_time ;;
    datatype: date
  }

  dimension: first_order_voucher_code {
    type: string
    sql: ${TABLE}.first_order_voucher_code ;;
  }

  dimension: first_order_discount_value {
    hidden: yes
    type: number
    sql: ${TABLE}.first_order_discount_value ;;
  }

  dimension: first_order_hub {
    type: string
    sql: ${TABLE}.first_order_hub ;;
  }

  dimension: installs {
    hidden: yes
    type: number
    sql: ${TABLE}.installs ;;
  }

  dimension: conversions {
    hidden: yes
    type: number
    sql: ${TABLE}.conversions ;;
  }

  dimension: spend {
    hidden: yes
    type: number
    sql: ${TABLE}.spend ;;
  }

  dimension: prim_key {
    type: number
    hidden: yes
    sql: ${TABLE}.prim_key ;;
    primary_key: yes
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

  #### Parameters ####

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  parameter: KPI_parameter {
    label: "* KPI Parameter *"
    type: unquoted
    allowed_value: { value: "orders" label: "# First Orders"}
    allowed_value: { value: "installs" label: "# Installs" }
    allowed_value: { value: "spend" label: "Sum of Spend" }
    allowed_value: { value: "discounts" label: "Sum of Discounts" }
    allowed_value: { value: "cpi" label: "CPI" }
    allowed_value: { value: "cac" label: "CAC" }
    default_value: "spend"
  }

  #### Measures ####

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: sum_installs {
    label: "# Installs"
    type: sum
    sql: ${installs} ;;
    value_format: "0"
  }

  measure: sum_conversions {
    label: "# Conversions"
    type: sum
    sql: ${conversions} ;;
    value_format: "0"
  }

  measure: sum_discounts {
    label: "Sum of Discounts"
    type: sum
    sql: ${first_order_discount_value} ;;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_spend {
    label: "Sum of spend"
    type: sum
    sql: ${spend} ;;
    value_format_name: euro_accounting_0_precision
  }

  measure: CPI {
    label: "CPI"
    description: "Cost per Install"
    type: number
    sql: ${sum_spend} / nullif(${sum_installs},0) ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: CAC {
    label: "CAC"
    description: "Cost of Acquisition: Marketing spend  / first orders"
    type: number
    sql: ${sum_spend} / nullif(${sum_conversions},0) ;;
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
      ${sum_conversions}
    {% elsif KPI_parameter._parameter_value == 'installs' %}
      ${sum_installs}
    {% elsif KPI_parameter._parameter_value == 'spend' %}
      ${sum_spend}
    {% elsif KPI_parameter._parameter_value == 'discounts' %}
      ${sum_discounts}
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
      country,
      city,
      channel,
      _os_name_,
      acquisition_date,
      first_order_voucher_code,
      first_order_discount_value,
      first_order_hub,
      installs,
      conversions,
      spend,
      prim_key
    ]
  }
}
