view: hub_closure_rate {
  derived_table: {
    sql: with c as (
        select closed_date_utc
        , closed_datetime
        , opened_datetime
        , warehouse
        from `flink-data-prod.order_forecast.forced_hub_closures`
      ),

      o as (select date(start_datetime) as date
      , warehouse
      , country_iso
      , city
      , sum(case when is_open = 1 then 0.5 end) as open_hours
      , min(case when is_open = 1 then start_datetime end) as start_hour
      , max(case when is_open = 1 then end_datetime end) as stop_hour

      from `flink-data-prod.order_forecast.hub_opening_hours`
      group by 1, 2, 3, 4)
      , cleaned_hours as (
      select c.closed_datetime
        , c.opened_datetime
        , c.warehouse
        , o.date
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

      from c
      left join o on o.date = c.closed_date_utc
      and o.warehouse = c.warehouse
      where open_hours is not null
      ),
      final as (
        select date
          , country_iso
          , city
          , warehouse
          , open_hours
          , TIMESTAMP_DIFF(cleaned_opened_datetime, cleaned_closed_datetime, MINUTE) as closure_mins
          , round(TIMESTAMP_DIFF(cleaned_opened_datetime, cleaned_closed_datetime, MINUTE)/60, 2) as closure_hours
          from cleaned_hours)

      select date
        , country_iso
        , city
        , warehouse as hub_code
        , open_hours
        , sum(closure_mins) as total_closure_mins
        , sum(closure_hours) as total_closure_hours
      from final
      group by 1, 2, 3, 4, 5
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: date {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
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

  dimension: total_closure_mins {
    type: number
    sql: ${TABLE}.total_closure_mins ;;
  }

  dimension: total_closure_hours {
    type: number
    sql: ${TABLE}.total_closure_hours ;;
  }

  measure: hub_closure_rate {
    label: "% Hub Closure Rate"
    hidden:  no
    type: average
    sql: ${total_closure_hours}/${open_hours};;
    value_format: "0.00%"
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

  set: detail {
    fields: [
      date,
      country_iso,
      city,
      hub_code,
      open_hours,
      total_closure_mins,
      total_closure_hours
    ]
  }
}
