view: riders_forecast_staffing_v2 {
  derived_table: {
    sql: with shifts as
        (
            select
            shifts.starts_at,
            shifts.ends_at,
            lower(locations_positions.location_name) as hub_name,
            shifts.workers
            from `flink-data-dev.shyftplan_v2.shifts` shifts
            left join `flink-data-dev.shyftplan_v2.locations_positions` locations_positions
            on shifts.locations_position_id = locations_positions.id
            where lower(locations_positions.position_name) like '%rider%'
            order by 3, 1 asc
        ),

        staffed_riders as
        (
            select shiftblocks_hubs.date,
            shiftblocks_hubs.block_starts_at,
            shiftblocks_hubs.block_ends_at,
            shiftblocks_hubs.hub_name,
            shiftblocks_hubs.city,
            sum(shifts.workers) as workers
            from `flink-data-dev.forecasting.shiftblocks_hubs` shiftblocks_hubs
            left join shifts
            on shiftblocks_hubs.hub_name = shifts.hub_name and
                (
                    (
                        (shifts.starts_at <= shiftblocks_hubs.block_starts_at)
                            or (shifts.starts_at > shiftblocks_hubs.block_starts_at and shifts.starts_at < shiftblocks_hubs.block_ends_at)
                    )

                    and
                    (
                        (shifts.ends_at >= shiftblocks_hubs.block_ends_at)
                            or (shifts.ends_at < shiftblocks_hubs.block_ends_at and shifts.ends_at > shiftblocks_hubs.block_starts_at)
                    )

                )
            group by 1, 2, 3, 4, 5
            order by 4, 2 asc
        ),

        hours as
        (
            select shiftblocks_hubs.date,
            shiftblocks_hubs.block_starts_at,
            shiftblocks_hubs.block_ends_at,
            shiftblocks_hubs.hub_name,
            shiftblocks_hubs.city,
            cast(date_diff(
                   LEAST(shiftblocks_hubs.block_ends_at,shifts.ends_at),
                   GREATEST(shiftblocks_hubs.block_starts_at,shifts.starts_at),
                   MINUTE
                  ) as FLOAT64) * shifts.workers as rider_hours
            from `flink-data-dev.forecasting.shiftblocks_hubs` shiftblocks_hubs
            left join shifts
            on shiftblocks_hubs.hub_name = shifts.hub_name and
                (
                    (
                        (shifts.starts_at <= shiftblocks_hubs.block_starts_at)
                            or (shifts.starts_at > shiftblocks_hubs.block_starts_at and shifts.starts_at < shiftblocks_hubs.block_ends_at)
                    )

                    and
                    (
                        (shifts.ends_at >= shiftblocks_hubs.block_ends_at)
                            or (shifts.ends_at < shiftblocks_hubs.block_ends_at and shifts.ends_at > shiftblocks_hubs.block_starts_at)
                    )

                )
            order by 4, 2 asc
        ),

        rider_hours as
        (
            select date,
            block_starts_at,
            block_ends_at,
            hub_name,
            city,
            sum(rider_hours) as rider_hours
            from hours
            group by 1, 2, 3, 4, 5

        ),

        evaluations as
            (
                select
                shift.starts_at,
                shift.ends_at,
                lower(location.name) as hub_name,
                count(distinct employment_id) as cnt_employees
                from `flink-data-dev.shyftplan_v2.evaluations` evaluations
                left join `flink-data-dev.shyftplan_v2.locations_positions` locations_positions
                on evaluations.locations_position_id = locations_positions.id
                where
                (lower(position.name) like '%rider%')
                group by 1, 2, 3
                order by 1 desc, 2, 3
            ),

        filled_riders as
        (
            select shiftblocks_hubs.date,
            shiftblocks_hubs.block_starts_at,
            shiftblocks_hubs.block_ends_at,
            shiftblocks_hubs.hub_name,
            shiftblocks_hubs.city,
            sum(cnt_employees) as filled_riders
            from `flink-data-dev.forecasting.shiftblocks_hubs` shiftblocks_hubs
            left join evaluations
            on shiftblocks_hubs.hub_name = evaluations.hub_name and
                (
                    (
                        (evaluations.starts_at <= shiftblocks_hubs.block_starts_at)
                            or (evaluations.starts_at > shiftblocks_hubs.block_starts_at and evaluations.starts_at < shiftblocks_hubs.block_ends_at)
                    )

                    and
                    (
                        (evaluations.ends_at >= shiftblocks_hubs.block_ends_at)
                            or (evaluations.ends_at < shiftblocks_hubs.block_ends_at and evaluations.ends_at > shiftblocks_hubs.block_starts_at)
                    )

                )
            group by 1, 2, 3, 4, 5
            order by 4, 2 asc
        )

        select shiftblocks_hubs.date,
        shiftblocks_hubs.block_starts_at,
        shiftblocks_hubs.block_ends_at,
        shiftblocks_hubs.hub_name,
        shiftblocks_hubs.city,
        historical_forecasts.prediction as predicted_orders,
        historical_forecasts.lower_bound,
        historical_forecasts.upper_bound,
        staffed_riders.workers as planned_riders,
        filled_riders.filled_riders,
        cast(rider_hours.rider_hours as FLOAT64) / 60.0 as planned_rider_hours,
        (filled_riders.filled_riders * (cast(rider_hours.rider_hours as FLOAT64) / 60.0)) / staffed_riders.workers as filled_rider_hours
        from `flink-data-dev.forecasting.shiftblocks_hubs` shiftblocks_hubs
        left join `flink-backend.order_forecast.historical_forecasts` historical_forecasts
        on (shiftblocks_hubs.block_starts_at  = historical_forecasts.start_datetime and shiftblocks_hubs.block_ends_at = historical_forecasts.end_datetime)
            and shiftblocks_hubs.hub_name = historical_forecasts.warehouse
        left join staffed_riders
        on shiftblocks_hubs.block_starts_at = staffed_riders.block_starts_at and shiftblocks_hubs.block_ends_at = staffed_riders.block_ends_at and shiftblocks_hubs.hub_name = staffed_riders.hub_name
        left join rider_hours
        on shiftblocks_hubs.block_starts_at = rider_hours.block_starts_at and shiftblocks_hubs.block_ends_at = rider_hours.block_ends_at and shiftblocks_hubs.hub_name = rider_hours.hub_name
        left join filled_riders
        on shiftblocks_hubs.block_starts_at = filled_riders.block_starts_at and shiftblocks_hubs.block_ends_at = filled_riders.block_ends_at and shiftblocks_hubs.hub_name = filled_riders.hub_name
        order by 4, 2 asc
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
    label: "Block starts at pivot"
    type: date_time
    sql: TIMESTAMP(concat("2021-01-01", " ", extract(hour from ${TABLE}.block_starts_at AT TIME ZONE "Europe/Berlin"),
      ":",extract(minute from ${TABLE}.block_starts_at), ":","00"), "Europe/Berlin") ;;
  }

  dimension: block_ends_pivot {
    group_label: " * Dates * "
    label: "Block ends at pivot"
    type: date_time
    sql: TIMESTAMP(concat("2021-01-01", " ", extract(hour from ${TABLE}.block_ends_at AT TIME ZONE "Europe/Berlin"),
      ":",extract(minute from ${TABLE}.block_ends_at), ":","00"), "Europe/Berlin") ;;
  }

  dimension: hub_name {
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

  dimension: filled_riders {
    hidden: yes
    type: number
    sql: ${TABLE}.filled_riders ;;
  }

  dimension: planned_rider_hours {
    hidden: yes
    type: number
    sql: ${TABLE}.planned_rider_hours ;;
  }

  dimension: filled_rider_hours {
    hidden: yes
    type: number
    sql: ${TABLE}.filled_rider_hours ;;
  }

  dimension: forecasted_riders {
    type: number
    sql: CAST(CEIL(${upper_bound} / ({% parameter rider_UTR %}/2)) AS INT64) ;;
  }

  dimension: forecasted_rider_hours {
    type: number
    sql: CAST(CEIL(${upper_bound} / ({% parameter rider_UTR %}/2)) AS INT64) / 2;;
  }

  dimension: picker_utr {
    label: "Picker UTR"
    type: number
    sql: {% parameter rider_UTR %} * 5 ;;
  }

  dimension: forecasted_pickers {
    type: number
    sql: CAST(CEIL(${upper_bound} / (${picker_utr}/2)) AS INT64) ;;
  }

  dimension: forecasted_picker_hours {
    type: number
    sql: CAST(CEIL(${upper_bound} / (${picker_utr}/2)) AS INT64) / 2;;
  }

  ###### Parameters

  parameter: rider_UTR{
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

  ###### Measures

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: sum_predicted_orders {
    label: "# Predicted Orders"
    sql: ${predicted_orders} ;;
    type: sum
  }

  measure: sum_predicted_orders_lower_bound {
    label: "# Predicted Orders Lower Bound"
    sql: ${lower_bound} ;;
    type: sum
  }

  measure: sum_predicted_orders_upper_bound {
    label: "# Predicted Orders Upper Bound"
    sql: ${upper_bound} ;;
    type: sum
  }

  measure: sum_planned_riders {
    label: "# Planned Riders"
    sql: ${planned_riders} ;;
    type: sum
  }

  measure: sum_filled_riders {
    label: "# Filled Riders"
    sql: ${filled_riders} ;;
    type: sum
  }

  measure: sum_planned_rider_hours {
    label: "# Planned Rider Hours"
    sql: ${planned_rider_hours} ;;
    type: sum
  }

  measure: sum_filled_rider_hours {
    label: "# Filled Rider Hours"
    sql: ${filled_rider_hours} ;;
    type: sum
  }

  measure: sum_forecasted_riders {
    label: "# Forecasted Riders"
    type: sum
    sql: ${forecasted_riders} ;;
  }

  measure: sum_forecasted_rider_hours {
    label: "# Forecasted Rider Hours"
    type: sum
    sql: ${forecasted_rider_hours} ;;
  }

  measure: sum_forecasted_pickers {
    label: "# Forecasted Pickers"
    type: sum
    sql: ${forecasted_pickers} ;;
  }

  measure: sum_forecasted_picker_hours {
    label: "# Forecasted Picker Hours"
    type: sum
    sql: ${forecasted_picker_hours} ;;
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
