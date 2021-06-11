view: riders_forecast_staffing {
  derived_table: {
    sql: with
    historical_orders as (
        select
            timestamp_seconds(30 * 60 * div(unix_seconds(created), 30 * 60)) as timekey
          , case
                when json_extract_scalar(metadata, '$.warehouse') in
                     ('hamburg-oellkersallee', 'hamburg-oelkersallee')                      then 'de_ham_alto'
                when json_extract_scalar(metadata, '$.warehouse') = 'münchen-leopoldstraße' then 'de_muc_schw'
                                                                                            else json_extract_scalar(metadata, '$.warehouse')
            end                                                              as warehouse
          , count(id)                                                        as orders
        from flink-backend.saleor_db_global.order_order
        where status in ('fulfilled', 'partially fulfilled') and
              user_email not like '%goflink%'
           or user_email not like '%pickery%'
           or lower(user_email) not in
              ('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com',
               'alenaschneck@gmx.de', 'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com',
               'fabian.hardenberg@gmail.com', 'benjamin.zagel@gmail.com')
        group by 1, 2
    )

  , shifts            as (
    select
        shifts.starts_at
      , shifts.ends_at
      , lower(locations_positions.location_name) as hub_name
      , shifts.workers
      , case
            when lower(locations_positions.position_name) like '%rider%'  then 'rider'
            when lower(locations_positions.position_name) like '%picker%' then 'picker'
        end                                      as position
    from flink-data-staging.shyftplan_v1.shifts                   as shifts
    left join flink-data-staging.shyftplan_v1.locations_positions as locations_positions
              on shifts.locations_position_id = locations_positions.id
    where lower(locations_positions.position_name) like '%rider%'
       or lower(locations_positions.position_name) like '%picker%'
    order by 3, 1 asc
)

    -- queried once, and re-used later
  , shiftblocks_hubs  as (
    select
        shiftblocks_hubs.date            as date
      , shiftblocks_hubs.block_starts_at as block_starts_at
      , shiftblocks_hubs.block_ends_at   as block_ends_at
      , shiftblocks_hubs.hub_name        as hub_name
      , shiftblocks_hubs.city            as city
    from flink-backend.rider_staffing.shiftblocks_hubs
)

  , shifts_scheduled  as (
    select
        shiftblocks_hubs.date
      , shiftblocks_hubs.block_starts_at
      , shiftblocks_hubs.block_ends_at
      , shiftblocks_hubs.hub_name
      , shiftblocks_hubs.city
      , nullif(sum(shifts.workers), 0)                         as workers
      , sum(if(shifts.position = 'rider', shifts.workers, null))  as planned_rider
      , sum(if(shifts.position = 'picker', shifts.workers, null)) as planned_picker
      , nullif(sum(cast(date_diff(
            least(shiftblocks_hubs.block_ends_at, shifts.ends_at),
            greatest(shiftblocks_hubs.block_starts_at, shifts.starts_at),
            minute
        ) as float64) * shifts.workers), 0)                        as worker_hours
      , sum(if(shifts.position = 'rider', cast(date_diff(
            least(shiftblocks_hubs.block_ends_at, shifts.ends_at),
            greatest(shiftblocks_hubs.block_starts_at, shifts.starts_at),
            minute
        ) as float64) * shifts.workers, null))                    as planned_rider_hours
      , sum(if(shifts.position = 'picker', cast(date_diff(
            least(shiftblocks_hubs.block_ends_at, shifts.ends_at),
            greatest(shiftblocks_hubs.block_starts_at, shifts.starts_at),
            minute
        ) as float64) * shifts.workers, null))                    as planned_picker_hours
    from shiftblocks_hubs
    left join shifts
              on shiftblocks_hubs.hub_name = shifts.hub_name and
                 (
                         (
                                 (shifts.starts_at <= shiftblocks_hubs.block_starts_at)
                                 or (shifts.starts_at > shiftblocks_hubs.block_starts_at and
                                     shifts.starts_at < shiftblocks_hubs.block_ends_at)
                             )
                         and
                         (
                                 (shifts.ends_at >= shiftblocks_hubs.block_ends_at)
                                 or (shifts.ends_at < shiftblocks_hubs.block_ends_at and
                                     shifts.ends_at > shiftblocks_hubs.block_starts_at)
                             )
                     )
    group by 1, 2, 3, 4, 5
    order by 4, 2 asc
)

  , evaluations_data  as
        (
            select
                shift.starts_at
              , shift.ends_at
              , lower(location.name)                      as hub_name
              , employment_id in (422284, 422285, 422016) as is_external
              , state in ('no_show')                      as is_no_show
              , case
                    when lower(position.name) like '%rider%'  then 'rider'
                    when lower(position.name) like '%picker%' then 'picker'
                end                                       as position
              , count(distinct evaluations.id)            as cnt_employees
            from flink-data-staging.shyftplan_v1.evaluations              as evaluations
            left join flink-data-staging.shyftplan_v1.locations_positions as locations_positions
                      on evaluations.locations_position_id = locations_positions.id
            where (lower(position.name) like '%rider%' or lower(position.name) like '%picker%')
            group by 1, 2, 3, 4, 5, 6
            order by 1 desc, 2, 3
        )

  , shifts_assigned   as (
    select
        shiftblocks_hubs.date
      , shiftblocks_hubs.block_starts_at
      , shiftblocks_hubs.block_ends_at
      , shiftblocks_hubs.hub_name
      , shiftblocks_hubs.city
      , sum(if(position = 'rider', cnt_employees, null))                  as filled_riders
      , sum(if(position = 'rider' and is_external, cnt_employees, null))  as filled_ext_riders
      , sum(if(position = 'rider' and is_no_show, cnt_employees, null))   as filled_no_show_riders
      , sum(if(position = 'picker', cnt_employees, null))                 as filled_pickers
      , sum(if(position = 'picker' and is_external, cnt_employees, null)) as filled_ext_pickers
      , sum(if(position = 'picker' and is_no_show, cnt_employees, null))  as filled_no_show_pickers
    from shiftblocks_hubs
    left join evaluations_data
              on shiftblocks_hubs.hub_name = evaluations_data.hub_name and (
                      (
                              (evaluations_data.starts_at <= shiftblocks_hubs.block_starts_at)
                              or (evaluations_data.starts_at > shiftblocks_hubs.block_starts_at and
                                  evaluations_data.starts_at < shiftblocks_hubs.block_ends_at)
                          )
                      and
                      (
                              (evaluations_data.ends_at >= shiftblocks_hubs.block_ends_at)
                              or (evaluations_data.ends_at < shiftblocks_hubs.block_ends_at and
                                  evaluations_data.ends_at > shiftblocks_hubs.block_starts_at)
                          )
                  )
    group by 1, 2, 3, 4, 5
    order by 4, 2 asc
)

select
    shiftblocks_hubs.date
   --, 'refactored' as source
  , shiftblocks_hubs.block_starts_at
  , shiftblocks_hubs.block_ends_at
  , shiftblocks_hubs.hub_name
  , shiftblocks_hubs.city
  , historical_orders.orders
  , historical_forecasts.prediction                                                   as predicted_orders
  , historical_forecasts.lower_bound
  , historical_forecasts.upper_bound
  , shifts_scheduled.planned_rider                                                    as planned_riders
  , shifts_scheduled.planned_picker                                                   as planned_pickers
  , shifts_assigned.filled_riders                                                     as filled_riders
  , shifts_assigned.filled_ext_riders                                                 as filled_ext_riders
  , shifts_assigned.filled_no_show_riders                                             as filled_no_show_riders
  , shifts_assigned.filled_pickers                                                    as filled_pickers
  , shifts_assigned.filled_ext_pickers                                                as filled_ext_pickers
  , shifts_assigned.filled_no_show_pickers                                            as filled_no_show_pickers

  , cast(shifts_scheduled.planned_rider_hours as float64) / 60.0                      as planned_rider_hours

  , (shifts_assigned.filled_riders * (cast(shifts_scheduled.planned_rider_hours as float64) / 60.0)) /
    nullif(shifts_scheduled.planned_rider, 0)                                         as filled_rider_hours

  , (shifts_assigned.filled_ext_riders * (cast(shifts_scheduled.planned_rider_hours as float64) / 60.0)) /
    nullif(shifts_scheduled.planned_rider, 0)                                         as filled_ext_rider_hours

  , (shifts_assigned.filled_no_show_riders * (cast(shifts_scheduled.planned_rider_hours as float64) / 60.0)) /
    nullif(shifts_scheduled.planned_rider, 0)                                         as filled_no_show_rider_hours

  , cast(shifts_scheduled.planned_picker_hours as float64) / 60.0                     as planned_picker_hours

  , (shifts_assigned.filled_pickers * (cast(shifts_scheduled.planned_picker_hours as float64) / 60.0)) /
    nullif(shifts_scheduled.planned_picker, 0)                                                as filled_picker_hours

  , (shifts_assigned.filled_ext_pickers * (cast(shifts_scheduled.planned_picker_hours as float64) / 60.0)) /
    nullif(shifts_scheduled.planned_picker, 0)                                                as filled_ext_picker_hours

  , (shifts_assigned.filled_no_show_pickers * (cast(shifts_scheduled.planned_picker_hours as float64) / 60.0)) /
    nullif(shifts_scheduled.planned_picker, 0)                                                as filled_no_show_picker_hours

from shiftblocks_hubs
left join flink-backend.order_forecast.historical_forecasts as historical_forecasts
          on (shiftblocks_hubs.block_starts_at = historical_forecasts.start_datetime
              and shiftblocks_hubs.block_ends_at = historical_forecasts.end_datetime)
              and shiftblocks_hubs.hub_name = historical_forecasts.warehouse
left join historical_orders
          on shiftblocks_hubs.block_starts_at = historical_orders.timekey
              and shiftblocks_hubs.hub_name = historical_orders.warehouse
left join shifts_scheduled
          on shiftblocks_hubs.block_starts_at = shifts_scheduled.block_starts_at
              and shiftblocks_hubs.block_ends_at = shifts_scheduled.block_ends_at
              and shiftblocks_hubs.hub_name = shifts_scheduled.hub_name
left join shifts_assigned
          on shiftblocks_hubs.block_starts_at = shifts_assigned.block_starts_at and
             shiftblocks_hubs.block_ends_at = shifts_assigned.block_ends_at and
             shiftblocks_hubs.hub_name = shifts_assigned.hub_name
order by shiftblocks_hubs.date, shiftblocks_hubs.hub_name, shiftblocks_hubs.block_starts_at, shiftblocks_hubs.block_ends_at asc
 ;;
  }


  dimension: date {
    group_label: " * Dates * "
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension_group: block_starts_at {
    group_label: " * Dates * "
    type: time
    timeframes: [
      time
    ]
    sql: ${TABLE}.block_starts_at ;;
  }

  dimension_group: block_ends_at {
    group_label: " * Dates * "
    type: time
    timeframes: [
      time
    ]
    sql: ${TABLE}.block_ends_at ;;
  }

  dimension: block_starts_pivot {
    group_label: " * Dates * "
    label: "Block"
    type: date_time
    sql: TIMESTAMP(concat("2021-01-01", " ", extract(hour from ${TABLE}.block_starts_at AT TIME ZONE "Europe/Berlin"),
      ":",extract(minute from ${TABLE}.block_starts_at), ":","00"), "Europe/Berlin") ;;
    html: {{ rendered_value | date: "%R" }};;
  }

  dimension: block_ends_pivot {
    group_label: " * Dates * "
    label: "Block ends at pivot"
    type: date_time
    sql: TIMESTAMP(concat("2021-01-01", " ", extract(hour from ${TABLE}.block_ends_at AT TIME ZONE "Europe/Berlin"),
      ":",extract(minute from ${TABLE}.block_ends_at), ":","00"), "Europe/Berlin") ;;
    html: {{ rendered_value | date: "%R" }};;
  }

  dimension: unique_id {
    type: string
    hidden: yes
    sql: concat(${block_starts_at_time}, ${block_ends_at_time}, ${hub_name}) ;;
    primary_key: yes
  }

  dimension: hub_name {
    hidden: yes
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: predicted_orders {
    hidden: yes
    type: number
    sql: ${TABLE}.predicted_orders ;;
  }

  dimension: null_filter {
    hidden: no
    type: yesno
    sql: CASE when ${predicted_orders} is null then True else False end ;;
  }

  dimension: orders {
    hidden: yes
    type: number
    sql: ${TABLE}.orders ;;
  }

  dimension: lower_bound {
    hidden: yes
    type: number
    sql: ${TABLE}.lower_bound ;;
  }

  dimension: upper_bound {
    hidden: yes
    type: number
    sql: ${TABLE}.upper_bound ;;
  }

  dimension: planned_riders {
    hidden: yes
    type: number
    sql: ${TABLE}.planned_riders ;;
  }

  dimension: planned_pickers {
    hidden: yes
    type: number
    sql: ${TABLE}.planned_pickers ;;
  }

  dimension: filled_riders {
    hidden: yes
    type: number
    sql: ${TABLE}.filled_riders ;;
  }

  dimension: filled_pickers {
    hidden: yes
    type: number
    sql: ${TABLE}.filled_pickers ;;
  }

  dimension: planned_rider_hours {
    hidden: yes
    type: number
    sql: ${TABLE}.planned_rider_hours ;;
  }

  dimension: planned_picker_hours {
    hidden: yes
    type: number
    sql: ${TABLE}.planned_picker_hours ;;
  }

  dimension: filled_rider_hours {
    hidden: yes
    type: number
    sql: ${TABLE}.filled_rider_hours ;;
  }

  dimension: filled_picker_hours {
    hidden: yes
    type: number
    sql: ${TABLE}.filled_picker_hours ;;
  }

  dimension: forecasted_riders {
    hidden: yes
    type: number
    sql: CAST(CEIL(${upper_bound} / ({% parameter rider_UTR %}/2)) AS INT64) ;;
  }

  dimension: forecasted_pickers {
    hidden: yes
    type: number
    sql: CAST(CEIL(${upper_bound} / (${picker_utr}/2)) AS INT64) ;;
  }

  dimension: forecasted_rider_hours {
    hidden: yes
    type: number
    sql: CAST(CEIL(${upper_bound} / ({% parameter rider_UTR %}/2)) AS INT64) / 2;;
  }

  dimension: forecasted_picker_hours {
    hidden: yes
    type: number
    sql: CAST(CEIL(${upper_bound} / (${picker_utr}/2)) AS INT64) / 2;;
  }

  dimension: dynamic_timeline_base {
    label_from_parameter: timeline_base
    sql:
    {% if timeline_base._parameter_value == 'Date' %}
      ${date}
    {% elsif timeline_base._parameter_value == 'Hub' %}
      ${hubs.hub_name}
    {% endif %};;
  }


  ###### Parameters

  parameter: rider_UTR{
    group_label: " * Parameters * "
    label: "Rider UTR"
    type: unquoted
    allowed_value: { value: "1" }
    allowed_value: { value: "1.5" }
    allowed_value: { value: "2" }
    allowed_value: { value: "2.5" }
    allowed_value: { value: "3" }
    allowed_value: { value: "3.5" }
    allowed_value: { value: "4" }
    default_value: "2.5"
  }

  parameter: timeline_base {
    group_label: " * Parameters * "
    label: "Timeline Base"
    type: unquoted
    allowed_value: { value: "Date" }
    allowed_value: { value: "Hub" }
    default_value: "Date"
  }

  parameter: KPI_parameter {
    label: "* KPI Parameter *"
    type: unquoted
    allowed_value: { value: "rider_hours" label: "# Rider Hours"}
    allowed_value: { value: "riders" label: "# Riders"}
    allowed_value: { value: "picker_hours" label: "# Picker Hours"}
    allowed_value: { value: "pickers" label: "# Pickers"}
    allowed_value: { value: "orders" label: "# Orders"}
    default_value: "riders"
  }

  dimension: picker_utr {
    group_label: " * Parameters * "
    label: "Picker UTR"
    type: number
    sql: {% parameter rider_UTR %} * 5 ;;
  }

  ###### Measures

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: sum_predicted_orders {
    group_label: " * Orders * "
    label: "# Forecasted Orders"
    sql: ${predicted_orders} ;;
    type: sum
  }

  measure: sum_orders {
    group_label: " * Orders * "
    label: "# Orders"
    sql: ${orders} ;;
    type: sum
  }

  measure: sum_predicted_orders_lower_bound {
    group_label: " * Orders * "
    label: "# Predicted Orders Lower Bound"
    sql: ${lower_bound} ;;
    type: sum
  }

  measure: sum_predicted_orders_upper_bound {
    group_label: " * Orders * "
    label: "# Predicted Orders Upper Bound"
    sql: ${upper_bound} ;;
    type: sum
  }

  measure: sum_planned_riders {
    group_label: " * Riders * "
    label: "# Planned Riders"
    sql: ${planned_riders} ;;
    type: sum
  }

  measure: sum_planned_pickers {
    group_label: " * Pickers * "
    label: "# Planned Pickers"
    sql: ${planned_pickers} ;;
    type: sum
  }

  measure: sum_filled_riders {
    group_label: " * Riders * "
    label: "# Filled Riders"
    sql: ${filled_riders} ;;
    type: sum
  }

  measure: sum_filled_pickers {
    group_label: " * Pickers * "
    label: "# Filled Pickers"
    sql: ${filled_pickers} ;;
    type: sum
  }

  measure: sum_planned_rider_hours {
    group_label: " * Rider Hours * "
    label: "# Planned Rider Hours"
    sql: ${planned_rider_hours} ;;
    type: sum
  }

  measure: sum_planned_picker_hours {
    group_label: " * Picker Hours * "
    label: "# Planned Picker Hours"
    sql: ${planned_picker_hours} ;;
    type: sum
  }

  measure: sum_filled_rider_hours {
    group_label: " * Rider Hours * "
    label: "# Filled Rider Hours"
    sql: ${filled_rider_hours} ;;
    type: sum
  }


  measure: sum_filled_picker_hours {
    group_label: " * Picker Hours * "
    label: "# Filled Picker Hours"
    sql: ${filled_picker_hours} ;;
    type: sum
  }


  measure: sum_forecasted_riders {
    group_label: " * Riders * "
    label: "# Forecasted Riders"
    type: sum
    sql: ${forecasted_riders} ;;
  }

  measure: sum_forecasted_pickers {
    group_label: " * Pickers * "
    label: "# Forecasted Pickers"
    type: sum
    sql: ${forecasted_pickers} ;;
  }

  measure: sum_forecasted_rider_hours {
    group_label: " * Rider Hours * "
    label: "# Forecasted Rider Hours"
    type: sum
    sql: ${forecasted_rider_hours} ;;
  }

  measure: sum_forecasted_picker_hours {
    group_label: " * Picker Hours * "
    label: "# Forecasted Picker Hours"
    type: sum
    sql: ${forecasted_picker_hours} ;;
  }

  ####### Dynamic Measures

  measure: KPI_forecasted {
    group_label: "* Dynamic KPI Fields *"
    label: "Forecasted"
    #label_from_parameter: KPI_parameter
    #value_format: "#,##0.00"
    value_format_name: id
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'riders' %}
      ${sum_forecasted_riders}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      ${sum_forecasted_rider_hours}
    {% elsif KPI_parameter._parameter_value == 'pickers' %}
      ${sum_forecasted_pickers}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      ${sum_forecasted_picker_hours}
    {% elsif KPI_parameter._parameter_value == 'orders' %}
      ${sum_predicted_orders}
    {% endif %}
    ;;
  }

  measure: KPI_planned {
    group_label: "* Dynamic KPI Fields *"
    label: "Planned"
    #label_from_parameter: KPI_parameter
    #value_format: "#,##0.00"
    value_format_name: id
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'riders' %}
      ${sum_planned_riders}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      ${sum_planned_rider_hours}
    {% elsif KPI_parameter._parameter_value == 'pickers' %}
      ${sum_planned_pickers}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      ${sum_planned_picker_hours}
    {% elsif KPI_parameter._parameter_value == 'orders' %}
      ${sum_predicted_orders}
    {% endif %}
    ;;
  }

  measure: KPI_filled {
    group_label: "* Dynamic KPI Fields *"
    label: "Filled"
    #label_from_parameter: KPI_parameter
    #value_format: "#,##0.00"
    value_format_name: id
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'riders' %}
      ${sum_filled_riders}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      ${sum_filled_rider_hours}
    {% elsif KPI_parameter._parameter_value == 'pickers' %}
      ${sum_filled_pickers}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      ${sum_filled_picker_hours}
    {% elsif KPI_parameter._parameter_value == 'orders' %}
      ${sum_orders}
    {% endif %}
    ;;
  }




  ####### Measures Hub-Leaderboard
  measure: sum_filled_ext_rider_hours {
    view_label: "Hub Leaderboard"
    group_label: "Hub Leaderboard - Shift Metrics"
    label: "Hours: Filled Ext. Rider"
    sql: ${TABLE}.filled_ext_rider_hours ;;
    hidden: no
    type: sum
    value_format_name: decimal_1
  }
  measure: sum_filled_no_show_rider_hours {
    view_label: "Hub Leaderboard"
    group_label: "Hub Leaderboard - Shift Metrics"
    label: "Hours: No Show Rider"
    sql: ${TABLE}.filled_no_show_rider_hours ;;
    hidden: no
    type: sum
    value_format_name: decimal_1
  }

  measure: sum_filled_ext_picker_hours {
    view_label: "Hub Leaderboard"
    group_label: "Hub Leaderboard - Shift Metrics"
    label: "Hours: Filled Ext. Pickers"
    sql: ${TABLE}.filled_ext_picker_hours ;;
    hidden: no
    type: sum
    value_format_name: decimal_1
  }
  measure: sum_filled_no_show_picker_hours {
    view_label: "Hub Leaderboard"
    group_label: "Hub Leaderboard - Shift Metrics"
    label: "Hours: No Show Pickers"
    sql: ${TABLE}.filled_no_show_picker_hours ;;
    hidden: no
    type: sum
    value_format_name: decimal_1
  }

  measure: sum_unfilled_picker_hours {
    view_label: "Hub Leaderboard"
    group_label: "Hub Leaderboard - Shift Metrics"
    label: "Hours: Unfilled Pickers"
    type: number
    value_format_name: decimal_1
    sql: if(
              (${sum_planned_picker_hours} - ${sum_filled_picker_hours}) < 0
            , 0
            , (${sum_planned_picker_hours} - ${sum_filled_picker_hours})
    );;
  }

  measure: sum_unfilled_rider_hours {
    view_label: "Hub Leaderboard"
    group_label: "Hub Leaderboard - Shift Metrics"
    label: "Hours: Unfilled Riders"
    type: number
    value_format_name: decimal_1
    sql: if(
              (${sum_planned_rider_hours} - ${sum_filled_rider_hours}) < 0
            , 0
            , (${sum_planned_rider_hours} - ${sum_filled_rider_hours})
    ) ;;
  }



  set: detail {
    fields: [
      date,
      block_starts_at_time,
      block_ends_at_time,
      hub_name,
      city,
      predicted_orders,
      lower_bound,
      upper_bound,
      planned_riders,
      filled_riders,
      planned_rider_hours,
      filled_rider_hours
    ]
  }
}
