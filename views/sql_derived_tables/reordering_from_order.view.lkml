view: reordering_from_order {
  derived_table: {
    sql:
      with order_with_timestamps_tb as(
        select
          customer_uuid,
          order_uuid,
          is_stacked_order,
          amt_cancelled_gross,
          cancellation_category,
          cancellation_reason,
          order_timestamp,
          picking_started_timestamp,
          picking_completed_timestamp,
          rider_claimed_timestamp,
          rider_on_route_timestamp,
          rider_arrived_at_customer_timestamp,
          rider_completed_delivery_timestamp,
          lead(order_timestamp) over (partition by customer_uuid order by order_timestamp) as next_order_timestamp,
          status
        from `flink-data-prod.curated.orders`
      )

      , final as (
        select
          *,
          timestamp_diff(next_order_timestamp, order_timestamp, MINUTE) as time_to_next_order_minutes,
          case
            when picking_started_timestamp is null then "picking queue"
            when picking_completed_timestamp is null then "picking"
            when rider_claimed_timestamp is null then "rider queue"
            when rider_on_route_timestamp is null then "rider claimed"
            when rider_arrived_at_customer_timestamp is null then "riding"
            when rider_completed_delivery_timestamp is null then "rider arriving"
            else "completed"
          end as cancellation_at_state
        from order_with_timestamps_tb
        -- where amt_cancelled_gross>0
        -- and cancellation_category="Customer"
      )

      select *
      from final
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_uuid {
    type: string
    sql: ${TABLE}.order_uuid;;
    primary_key: yes
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: amt_cancelled_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_cancelled_gross;;
  }

  dimension: cancellation_at_state {
    label: "Order State At Cancellation"
    type: string
    sql: ${TABLE}.cancellation_at_state ;;
  }

######## DYNAMIC DIMENSIONS

  dimension: date {
    group_label: "* Dates and Timestamps *"
    label: "Order Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${order_timestamp_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${order_timestamp_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${order_timestamp_month}
    {% endif %};;
  }

  dimension: date_granularity_pass_through {
    group_label: "* Parameters *"
    description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
    type: string
    hidden: yes
    sql:
            {% if date_granularity._parameter_value == 'Day' %}
              "Day"
            {% elsif date_granularity._parameter_value == 'Week' %}
              "Week"
            {% elsif date_granularity._parameter_value == 'Month' %}
              "Month"
            {% endif %};;
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

  dimension_group: order_timestamp {
    group_label: "* Dates and Timestamps *"
    label: "Order"
    description: "Order Time/Date"
    type: time
    timeframes: [
      raw,
      hour,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_timestamp ;;
    datatype: timestamp
  }

  dimension_group: next_order_timestamp {
    group_label: "* Dates and Timestamps *"
    label: "Next Order"
    description: "Next Order Time/Date"
    type: time
    timeframes: [
      raw,
      hour,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_timestamp ;;
    datatype: timestamp
  }

  dimension: time_to_next_order_minutes {
    type: number
    sql: ${TABLE}.time_to_next_order_minutes ;;
  }

  dimension: cancellation_category {
    type: string
    sql: ${TABLE}.cancellation_category ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: cancellation_reason {
    label: "Cancellation Reason"
    type: string
    sql: ${TABLE}.cancellation_reason ;;
  }

  dimension: time_to_next_order_tiers {
    label: "Time to next order tiers (2 min.)"
    type: tier
    tiers: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28,30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80]
    style: integer
    sql: ${time_to_next_order_minutes} ;;
  }

  dimension: reordered_within_15_minutes {
    label: "Reordered Within 15 Minutes"
    type: yesno
    sql: ${time_to_next_order_minutes} <= 15 ;;
  }

  dimension: reordered_within_30_minutes {
    label: "Reordered Within 30 Minutes"
    type: yesno
    sql: ${time_to_next_order_minutes} <= 30 ;;
  }

  dimension: reordered_within_60_minutes {
    label: "Reordered Within 60 Minutes"
    type: yesno
    sql: ${time_to_next_order_minutes} <= 60 ;;
  }

  measure: cnt_orders {
    label: "# Orders"
    type: count_distinct
    sql: ${order_uuid} ;;
  }

  measure: cnt_reorders {
    label: "# Reorders"
    type: count
    # sql: ${order_uuid};;
    filters: [time_to_next_order_minutes: "not null"]
  }

  measure: cnt_reorders_within_15_minutes {
    label: "# Cancelled Orders With Reorders Within 15 Minutes"
    type: count
    filters: [time_to_next_order_minutes: "not null", reordered_within_15_minutes: "yes", amt_cancelled_gross: ">0"]
  }

  measure: cnt_reorders_within_30_minutes {
    label: "# Cancelled Orders With Reorders Within 30 Minutes"
    type: count
    filters: [time_to_next_order_minutes: "not null", reordered_within_30_minutes: "yes", amt_cancelled_gross: ">0"]
  }

  measure: cnt_reorders_within_60_minutes {
    label: "# Cancelled Orders With Reorders Within 30 Minutes"
    type: count
    filters: [time_to_next_order_minutes: "not null", reordered_within_60_minutes: "yes", amt_cancelled_gross: ">0"]
  }

  measure: cnt_cancelled_orders {
    label: "# Cancelled Orders"
    hidden:  no
    type: count
    filters: [amt_cancelled_gross: ">0"]
    value_format: "0"
  }

  # measure: cnt_cancelled_orders2 {
  #   group_label: "* Cancelled Orders *"
  #   label: "# Cancelled Orders According to status"
  #   hidden:  no
  #   type: count
  #   filters: [status: "Cancelled"]
  # }

  # measure: cnt_cancelled_orders {
  #   label: "# Cancelled Orders"
  #   type: count
  #   filters: [status: "Cancelled"]
  # }

  set: detail {
    fields: [country_iso, hub_code, cancellation_category, cancellation_reason]
  }
}
