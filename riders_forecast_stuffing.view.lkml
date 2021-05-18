view: riders_forecast_stuffing {
  derived_table: {
    sql: with historical_orders as
        (
            select TIMESTAMP_SECONDS(30*60 * DIV(UNIX_SECONDS(created), 30*60)) timekey,
            CASE WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
            WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
            ELSE JSON_EXTRACT_SCALAR(metadata, '$.warehouse') end as warehouse,
            count(id) as orders
            from `flink-backend.saleor_db_global.order_order`
            where status in ('fulfilled', 'partially fulfilled') and
            user_email not LIKE '%goflink%' OR user_email not LIKE '%pickery%'
            OR LOWER(user_email) not IN ('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com',
                                                'alenaschneck@gmx.de', 'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com',
                                                'fabian.hardenberg@gmail.com', 'benjamin.zagel@gmail.com')
            group by 1, 2
        ),

        shifts as
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

        stuffed_riders as
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
        historical_orders.orders,
        historical_forecasts.prediction as predicted_orders,
        historical_forecasts.lower_bound,
        historical_forecasts.upper_bound,
        CAST(CEIL(historical_forecasts.upper_bound / (target_orders_per_rider_per_hour/2)) AS INT64) AS forecasted_riders,
        CAST(CEIL(historical_forecasts.upper_bound / (target_orders_per_rider_per_hour/2)) AS INT64) / 2 as forecasted_rider_hours,
        stuffed_riders.workers as planned_riders,
        filled_riders.filled_riders,
        cast(rider_hours.rider_hours as FLOAT64) / 60.0 as planned_rider_hours,
        (filled_riders.filled_riders * (cast(rider_hours.rider_hours as FLOAT64) / 60.0)) / stuffed_riders.workers as filled_rider_hours
        from `flink-data-dev.forecasting.shiftblocks_hubs` shiftblocks_hubs
        left join historical_orders
        on (shiftblocks_hubs.block_starts_at = historical_orders.timekey
            and shiftblocks_hubs.hub_name = historical_orders.warehouse)
        left join `flink-backend.order_forecast.historical_forecasts` historical_forecasts
        on (shiftblocks_hubs.block_starts_at  = historical_forecasts.start_datetime and shiftblocks_hubs.block_ends_at = historical_forecasts.end_datetime)
            and shiftblocks_hubs.hub_name = historical_forecasts.warehouse
        left join stuffed_riders
        on shiftblocks_hubs.block_starts_at = stuffed_riders.block_starts_at and shiftblocks_hubs.block_ends_at = stuffed_riders.block_ends_at and shiftblocks_hubs.hub_name = stuffed_riders.hub_name
        left join rider_hours
        on shiftblocks_hubs.block_starts_at = rider_hours.block_starts_at and shiftblocks_hubs.block_ends_at = rider_hours.block_ends_at and shiftblocks_hubs.hub_name = rider_hours.hub_name
        left join filled_riders
        on shiftblocks_hubs.block_starts_at = filled_riders.block_starts_at and shiftblocks_hubs.block_ends_at = filled_riders.block_ends_at and shiftblocks_hubs.hub_name = filled_riders.hub_name
        --where prediction is not null
        --and shiftblocks_hubs.hub_name = 'de_ber_kreu' and shiftblocks_hubs.date = '2021-05-06'
        order by 4, 2 asc
       ;;
  }

  dimension: date {
    group_label: " * Dates * "
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: block_starts_at {
    group_label: " * Dates * "
    label: "Block starts at"
    #timeframes: [
    #  raw
    #]
    type: date_time
    sql: ${TABLE}.block_starts_at ;;
  }

  dimension: block_ends_at {
    group_label: " * Dates * "
    label: "Block ends at"
    #timeframes: [
    #  raw
    #]
    type: date_time
    sql: ${TABLE}.block_ends_at ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: unique_id {
    type: string
    hidden: yes
    sql: concat(${block_starts_at}, ${block_ends_at}, ${hub_name}) ;;
    primary_key: yes
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: orders {
    hidden: yes
    type: number
    sql: ${TABLE}.orders ;;
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

  dimension: forecasted_riders {
    hidden: yes
    type: number
    sql: ${TABLE}.forecasted_riders ;;
  }

  dimension: forecasted_rider_hours {
    hidden: yes
    type: number
    sql: ${TABLE}.forecasted_rider_hours ;;
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

  ############### Measures

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: sum_orders {
    group_label: " * Orders * "
    label: "# Orders"
    type: sum
    sql: ${orders} ;;
  }

  measure: sum_predicted_orders {
    group_label: " * Orders * "
    label: "# Forecasted Orders"
    type: sum
    sql: ${predicted_orders} ;;
  }

  measure: sum_predicted_orders_lower_bound {
    group_label: " * Orders * "
    label: "# Forecasted Orders Lower Bound"
    type: sum
    sql: ${lower_bound} ;;
  }

  measure: sum_predicted_orders_upper_bound {
    group_label: " * Orders * "
    label: "# Forecasted Orders Upper Bound"
    type: sum
    sql: ${upper_bound} ;;
  }

  measure: sum_predicted_riders {
    group_label: " * Riders * "
    label: "# Forecasted Riders"
    type: sum
    sql: ${forecasted_riders} ;;
  }

  measure: sum_planned_riders {
    group_label: " * Riders * "
    label: "# Planned Riders"
    type: sum
    sql: ${planned_riders} ;;
  }

  measure: sum_filled_riders {
    group_label: " * Riders * "
    label: "# Filled Riders"
    type: sum
    sql: ${filled_riders} ;;
  }

  measure: sum_forecasted_rider_hours {
    group_label: " * Rider Hours * "
    label: "# Forecasted Rider Hours"
    type: sum
    sql: ${forecasted_rider_hours} ;;
  }

  measure: sum_planned_rider_hours {
    group_label: " * Rider Hours * "
    label: "# Planned Rider Hours"
    type: sum
    sql: ${planned_rider_hours} ;;
  }

  measure: sum_filled_rider_hours {
    group_label: " * Rider Hours * "
    label: "# Filled Rider Hours"
    type: sum
    sql: ${filled_rider_hours} ;;
    value_format_name: decimal_2
  }

  set: detail {
    fields: [
      date,
      block_starts_at,
      block_ends_at,
      hub_name,
      city,
      orders,
      predicted_orders,
      lower_bound,
      upper_bound,
      forecasted_riders,
      forecasted_rider_hours,
      planned_riders,
      filled_riders,
      planned_rider_hours,
      filled_rider_hours
    ]
  }
}
