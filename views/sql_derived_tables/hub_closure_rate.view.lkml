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
          , TIMESTAMP_DIFF(cleaned_opened_datetime, cleaned_closed_datetime, MINUTE) as closure_mins
          , round(TIMESTAMP_DIFF(cleaned_opened_datetime, cleaned_closed_datetime, MINUTE)/60, 2) as closure_hours
          , closure_reason_clean
          , closure_reason
          from cleaned_hours
),


missed_orders as (
        select date
         , warehouse
         , sum(missed_orders) as total_missed_orders
        from `flink-data-prod.order_forecast.historical_missed_orders`
        group by 1, 2
),

l_gmv as (
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
, gmv.aov
, closure_reason_clean
, closure_reason
, sum(closure_mins) as total_closure_mins
, ifnull(sum(closure_hours), 0) as total_closure_hours
from final f
left join l_gmv gmv on f.date = gmv.order_date
and f.warehouse = gmv.hub_code
left join missed_orders mo
on f.date = mo.date
and f.warehouse = mo.warehouse
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
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


  dimension: total_closure_mins {
    type: number
    sql: ${TABLE}.total_closure_mins ;;
  }

  dimension: total_closure_hours {
    type: number
    sql: ${TABLE}.total_closure_hours ;;
  }

  dimension: closure_reason_clean {
    label: "Closure Reason"
    type: string
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
    sql: ifnull(${total_closure_hours},0);;
    value_format: "0.0"
  }

  measure: sum_missed_orders {
    label: "Sum Missed Orders"
    hidden:  no
    type: sum
    sql: ifnull(${total_missed_orders},0);;
    value_format: "0"
  }

  measure: lost_gmv {
    label: "Lost GMV"
    hidden:  no
    type: sum
    sql: ifnull(${total_missed_orders}*${aov},0);;
    value_format_name: eur_0
  }

  measure: hub_closure_rate {
    label: "% Hub Closure Rate"
    hidden:  no
    type: number
    sql: ${sum_closed_hours}/${sum_opened_hours};;
    value_format: "0.0%"
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
      total_closure_mins,
      total_closure_hours,
      closure_reason_clean,
      closure_reason
    ]
  }
}
