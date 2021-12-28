view: hub_closure_rate {
  derived_table: {
    sql: with dates as (
            select * from unnest( generate_date_array('2021-07-01', current_date)) as date
),
closed_events_raw as (
        select closed_date_utc
        , closed_datetime
        , opened_datetime
        , warehouse
        , closure_reason_clean
        , closure_reason
        from `flink-data-prod.order_forecast.forced_hub_closures`
),
closed_events as (
        select d.date as closed_date_utc
             ,c.closed_datetime
             ,c.opened_datetime
             ,c.warehouse
             ,c.closure_reason_clean
             ,c.closure_reason
        from dates d
        join closed_events_raw c on date >= date(closed_datetime) and date <= date(opened_datetime)
),
open_hours_ as (
          select date(start_datetime) as date
        , warehouse
        , country_iso
        , city
        , sum(case when is_open = 1 then 0.5 end) as open_hours
        , min(case when is_open = 1 then start_datetime end) as start_hour
        , max(case when is_open = 1 then end_datetime end) as stop_hour
      from `flink-data-prod.order_forecast.hub_opening_hours`
      where date(start_datetime) <= current_date
      group by 1, 2, 3, 4
),
cleaned_hours as (
      select c.closed_datetime
        , c.opened_datetime
        , c.closure_reason_clean
        , c.closure_reason
        , o.warehouse
        , o.date
        , DATE_TRUNC( o.date, week) as week
        , DATE_TRUNC( o.date, month) as month
        , o.country_iso
        , o.city
        , o.open_hours
        , case when closed_datetime < start_hour then start_hour
               when closed_datetime > stop_hour then stop_hour
               else closed_datetime end as cleaned_closed_datetime
        , case when opened_datetime > stop_hour then stop_hour
               when opened_datetime < start_hour then start_hour
               when opened_datetime is null then stop_hour
               else opened_datetime end as cleaned_opened_datetime

      from open_hours_ as o
      left join closed_events  as c on o.date = c.closed_date_utc
      and o.warehouse = c.warehouse
      where open_hours is not null
      and o.date >= "2021-07-01" --no available data before this date
      and o.warehouse != "de_ham_alto"
),
final as (
        select date
          , week
          , month
          , country_iso
          , city
          , warehouse
          , open_hours
          , round(TIMESTAMP_DIFF(cleaned_opened_datetime, cleaned_closed_datetime, MINUTE)/60, 2) as closure_hours
          , case when closure_reason_clean = "External factor" then "External_factor"
                when closure_reason_clean = "Property issue" then "Property_issue"
                else closure_reason_clean end as closure_reason_clean
          from cleaned_hours
),


missed_orders as (
        select date
         , warehouse
         , sum(missed_orders) as total_missed_orders
        from `flink-data-prod.order_forecast.historical_missed_orders`
        group by 1, 2
),

aov as (
    select order_date
    , hub_code
    , avg(amt_gmv_gross) as aov
from `flink-data-prod.curated.orders` o
group by 1, 2
)

select f.date
, week
, month
, country_iso
, city
, f.warehouse as hub_code
, open_hours
, mo.total_missed_orders
, a.aov
, coalesce(sum(case when closure_reason_clean = 'Understaffing' then mo.total_missed_orders end),0) as missed_orders_understaffing
, coalesce(sum(case when closure_reason_clean = 'Weather' then mo.total_missed_orders end),0) as missed_orders_weather
, coalesce(sum(case when closure_reason_clean = 'Remodelling' then mo.total_missed_orders end),0) as missed_orders_remodelling
, coalesce(sum(case when closure_reason_clean = 'External_factor' then mo.total_missed_orders end),0) as missed_orders_external_factor
, coalesce(sum(case when closure_reason_clean = 'Property_issue' then mo.total_missed_orders end),0) as missed_orders_property_issue
, coalesce(sum(case when closure_reason_clean = 'Other' then mo.total_missed_orders end),0) as missed_orders_other
, coalesce(sum(case when closure_reason_clean = 'Equipment' then mo.total_missed_orders end),0) as missed_orders_equipment
, coalesce(sum(case when closure_reason_clean = 'Understaffing' then a.aov end),0) as lost_gmv_understaffing
, coalesce(sum(case when closure_reason_clean = 'Weather' then a.aov end),0) as lost_gmv_weather
, coalesce(sum(case when closure_reason_clean = 'Remodelling' then a.aov end),0) as lost_gmv_remodelling
, coalesce(sum(case when closure_reason_clean = 'External_factor' then a.aov end),0) as lost_gmv_external_factor
, coalesce(sum(case when closure_reason_clean = 'Property_issue' then a.aov end),0) as lost_gmv_property_issue
, coalesce(sum(case when closure_reason_clean = 'Other' then a.aov end),0) as lost_gmv_other
, coalesce(sum(case when closure_reason_clean = 'Equipment' then a.aov end),0) as lost_gmv_equipment
, coalesce(sum(case when closure_reason_clean = 'Understaffing' then closure_hours end),0) as total_closure_hours_understaffing
, coalesce(sum(case when closure_reason_clean = 'Weather' then closure_hours end),0) as total_closure_hours_weather
, coalesce(sum(case when closure_reason_clean = 'Remodelling' then closure_hours end),0) as total_closure_hours_remodelling
, coalesce(sum(case when closure_reason_clean = 'External_factor' then closure_hours end),0) as total_closure_hours_external_factor
, coalesce(sum(case when closure_reason_clean = 'Property_issue' then closure_hours end),0) as total_closure_hours_property_issue
, coalesce(sum(case when closure_reason_clean = 'Other' then closure_hours end),0) as total_closure_hours_other
, coalesce(sum(case when closure_reason_clean = 'Equipment' then closure_hours end),0) as total_closure_hours_equipment
, ifnull(sum(closure_hours), 0) as total_closure_hours
from final f
left join aov a on f.date = a.order_date
and f.warehouse = a.hub_code
left join missed_orders mo
on f.date = mo.date
and f.warehouse = mo.warehouse
group by 1, 2, 3, 4, 5, 6, 7, 8, 9
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.hub_code, '_', ${TABLE}.day) ;;
  }

  dimension: day {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: week {
    type: date
    datatype: date
    sql: ${TABLE}.week ;;
  }

  dimension: month {
    type: date
    datatype: date
    sql: ${TABLE}.month ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: open_hours {
    type: number
    sql: ${TABLE}.open_hours ;;
  }

  dimension: total_missed_orders {
    type: number
    sql: ${TABLE}.total_missed_orders ;;
  }

  dimension: aov {
    type: number
    sql: ${TABLE}.aov ;;
  }

### Dimensions for Missed Orders ###
  dimension: missed_orders_understaffing {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_understaffing ;;
  }

  dimension: missed_orders_weather {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_weather ;;
  }

  dimension: missed_orders_remodelling {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_remodelling ;;
  }

  dimension: missed_orders_external_factor {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_external_factor ;;
  }

  dimension: missed_orders_property_issue {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_property_issue ;;
  }

  dimension: missed_orders_other {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_other ;;
  }

  dimension: missed_orders_equipment {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_equipment ;;
  }


  ### Dimensions for Lost GMV ###

  dimension: lost_gmv_understaffing  {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_understaffing  ;;
  }

  dimension: lost_gmv_weather {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_weather ;;
  }

  dimension: lost_gmv_remodelling {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_remodelling ;;
  }

  dimension: lost_gmv_external_factor {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_external_factor ;;
  }

  dimension: lost_gmv_property_issue {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_property_issue ;;
  }

  dimension: lost_gmv_other {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_other ;;
  }

  dimension: lost_gmv_equipment {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_equipment ;;
  }

### Dimension for Closure Hours ###
  dimension: total_closure_hours_understaffing {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_understaffing ;;
  }

  dimension: total_closure_hours_weather {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_weather ;;
  }

  dimension: total_closure_hours_remodelling {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_remodelling ;;
  }

  dimension: total_closure_hours_external_factor {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_external_factor ;;
  }

  dimension: total_closure_hours_property_issue {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_property_issue ;;
  }

  dimension: total_closure_hours_other {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_other ;;
  }

  dimension: total_closure_hours_equipment {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_equipment ;;
  }

  dimension: total_closure_hours {
    type: number
    sql: ${TABLE}.total_closure_hours ;;
  }

  dimension: closure_reason_clean {
    label: "Closure Reason"
    type: string
    hidden:  yes
    sql: ${TABLE}.closure_reason_clean ;;
  }

  dimension: closure_reason {
    type: string
    sql: ${TABLE}.closure_reason ;;
    hidden:  yes
  }

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

    dimension: date {
      group_label: "* Dates and Timestamps *"
      label: "Date (Dynamic)"
      label_from_parameter: date_granularity
      sql:
      {% if date_granularity._parameter_value == 'Day' %}
      ${day}
      {% elsif date_granularity._parameter_value == 'Week' %}
      ${week}
      {% elsif date_granularity._parameter_value == 'Month' %}
      ${month}
      {% endif %};;
  }




  parameter: closure_reason_parameter {
  type: unquoted
    allowed_value: { value: "Understaffing" }
    allowed_value: { value: "Weather" }
    allowed_value: { value: "Remodelling" }
    allowed_value: { label: "External factor"
                     value: "External_factor" }
    allowed_value: { label: "Property issue"
                     value: "Property_issue" }
    allowed_value: { value: "Other" }
    allowed_value: { value: "Equipment" }
    allowed_value: { value: "All" }
    default_value: "All"
  }

  measure: sum_missed_orders_parameter {
    label: "Sum Missed Orders"
    hidden:  no
    type: number
    sql:
      {% if closure_reason_parameter._parameter_value == 'Understaffing' %}
      ${sum_missed_orders_understaffing}
      {% elsif closure_reason_parameter._parameter_value == 'Weather' %}
      ${sum_missed_orders_weather}
      {% elsif closure_reason_parameter._parameter_value == 'Remodelling' %}
      ${sum_missed_orders_remodelling}
      {% elsif closure_reason_parameter._parameter_value == 'External_factor' %}
      ${sum_missed_orders_external_factor}
      {% elsif closure_reason_parameter._parameter_value == 'Property_issue' %}
      ${sum_missed_orders_property_issue}
      {% elsif closure_reason_parameter._parameter_value == 'Other' %}
      ${sum_missed_orders_other}
      {% elsif closure_reason_parameter._parameter_value == 'Equipment' %}
      ${sum_missed_orders_equipment}
      {% elsif closure_reason_parameter._parameter_value == 'All' %}
      ${sum_missed_orders}
      {% endif %};;
    value_format: "0.0"
  }

  measure: lost_gmv_parameter {
    label: "Lost GMV"
    hidden:  no
    type: number
    sql:
      {% if closure_reason_parameter._parameter_value == 'Understaffing' %}
      ${sum_lost_gmv_understaffing}
      {% elsif closure_reason_parameter._parameter_value == 'Weather' %}
      ${sum_lost_gmv_weather}
      {% elsif closure_reason_parameter._parameter_value == 'Remodelling' %}
      ${sum_lost_gmv_remodelling}
      {% elsif closure_reason_parameter._parameter_value == 'External_factor' %}
      ${sum_lost_gmv_external_factor}
      {% elsif closure_reason_parameter._parameter_value == 'Property_issue' %}
      ${sum_lost_gmv_property_issue}
      {% elsif closure_reason_parameter._parameter_value == 'Other' %}
      ${sum_lost_gmv_other}
      {% elsif closure_reason_parameter._parameter_value == 'Equipment' %}
      ${sum_lost_gmv_equipment}
      {% elsif closure_reason_parameter._parameter_value == 'All' %}
      ${lost_gmv}
      {% endif %};;
    value_format_name: eur_0
  }

  measure: hub_closure_rate {
    label: "% Hub Closure Rate"
    hidden:  no
    type: number
    sql:
      {% if closure_reason_parameter._parameter_value == 'Understaffing' %}
      ${sum_closure_hours_understaffing}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'Weather' %}
      ${sum_closure_hours_weather}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'Remodelling' %}
      ${sum_closure_hours_remodelling}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'External_factor' %}
      ${sum_closure_hours_external_factor}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'Property_issue' %}
      ${sum_closure_hours_property_issue}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'Other' %}
      ${sum_closure_hours_other}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'Equipment' %}
      ${sum_closure_hours_equipment}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'All' %}
      ${sum_closed_hours}/${sum_opened_hours}
      {% endif %};;
    value_format: "0.0%"
  }

  measure: understaffing_closure_rate {
    label: "% Understaffing"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_understaffing}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: weather_closure_rate {
    label: "% Weather"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_weather}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: remodelling_closure_rate {
    label: "% Remodelling"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_remodelling}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: external_factor_closure_rate {
    label: "% External Factor"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_external_factor}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: property_issue_closure_rate {
    label: "% Property Issue"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_property_issue}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: other_closure_rate {
    label: "% Other"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_other}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: equipment_closure_rate {
    label: "% Equipment"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_equipment}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: sum_opened_hours {
    label: "Sum Open Hours"
    hidden:  no
    type: sum
    sql: ${open_hours};;
    value_format: "0.0"
  }

  measure: sum_closed_hours {
    label: "Sum Closed Hours"
    hidden:  no
    type: sum
    sql: ${total_closure_hours};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_understaffing {
    label: "Sum Closed Hours Understaffing"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_understaffing};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_weather {
    label: "Sum Closed Hours Weather"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_weather};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_remodelling {
    label: "Sum Closed Hours Remodelling"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_remodelling};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_external_factor {
    label: "Sum Closed Hours External factor"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_external_factor};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_property_issue {
    label: "Sum Closed Hours Property issue"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_property_issue};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_other {
    label: "Sum Closed Hours Other"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_other};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_equipment {
    label: "Sum Closed Hours Equipment"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_equipment};;
    value_format: "0.0"
  }

### Measure for Missed Orders ###

  measure: sum_missed_orders_understaffing {
    label: "Sum Missed Orders Understaffing"
    hidden:  yes
    type: sum
    sql: ${missed_orders_understaffing};;
    value_format: "0.0"
  }

  measure: sum_missed_orders_weather {
    label: "Sum Missed Orders Weather"
    hidden:  yes
    type: sum
    sql: ${missed_orders_weather};;
    value_format: "0.0"
  }

  measure: sum_missed_orders_remodelling {
    label: "Sum Missed Orders Remodelling"
    hidden:  yes
    type: sum
    sql: ${missed_orders_remodelling};;
    value_format: "0.0"
  }

  measure: sum_missed_orders_external_factor {
    label: "Sum Missed Orders External factor"
    hidden:  yes
    type: sum
    sql: ${missed_orders_external_factor};;
    value_format: "0.0"
  }

  measure: sum_missed_orders_property_issue {
    label: "Sum Missed Orders Property issue"
    hidden:  yes
    type: sum
    sql: ${missed_orders_property_issue};;
    value_format: "0.0"
  }

  measure: sum_missed_orders_other {
    label: "Sum Missed Orders Other"
    hidden:  yes
    type: sum
    sql: ${missed_orders_other};;
    value_format: "0.0"
  }

  measure: sum_missed_orders_equipment {
    label: "Sum Missed Orders Equipment"
    hidden:  yes
    type: sum
    sql: ${missed_orders_equipment};;
    value_format: "0.0"
  }


### Measures for Lost GMV ###
  measure: sum_lost_gmv_understaffing  {
    label: "Sum Lost GMV Understaffing"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_understaffing};;
    value_format: "0.0"
  }

  measure: sum_lost_gmv_weather {
    label: "Sum Lost GMV Weather"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_weather};;
    value_format: "0.0"
  }

  measure: sum_lost_gmv_remodelling {
    label: "Sum Lost GMV Remodelling"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_remodelling};;
    value_format: "0.0"
  }

  measure: sum_lost_gmv_external_factor {
    label: "Sum Lost GMV External factor"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_external_factor};;
    value_format: "0.0"
  }

  measure: sum_lost_gmv_property_issue {
    label: "Sum Lost GMV Property issue"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_property_issue};;
    value_format: "0.0"
  }

  measure: sum_lost_gmv_other {
    label: "Sum Lost GMV Other"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_other};;
    value_format: "0.0"
  }

  measure: sum_lost_gmv_equipment {
    label: "Sum Lost GMV Equipment"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_equipment};;
    value_format: "0.0"
  }

  measure: sum_missed_orders {
    label: "Total Missed Orders"
    hidden:  yes
    type: sum
    sql: ifnull(${total_missed_orders},0);;
    value_format: "0"
  }

  measure: lost_gmv {
    label: "Total GMV Lost"
    hidden:  yes
    type: sum
    sql: ifnull(${total_missed_orders}*${aov},0);;
    value_format_name: eur_0
  }

  set: detail {
    fields: [
      day,
      week,
      month,
      country_iso,
      city,
      hub_code,
      open_hours,
      total_missed_orders,
      total_closure_hours_understaffing,
      total_closure_hours_weather,
      total_closure_hours_remodelling,
      total_closure_hours_external_factor,
      total_closure_hours_property_issue,
      total_closure_hours_other,
      total_closure_hours_equipment,
      total_closure_hours
    ]
  }
}
