# If necessary, uncomment the line below to include explore_source.

# include: "logistics_report.explore.lkml"

view: idle_time{
  derived_table: {
    explore_source: logistics_report {
      column: hub_code { field: hubs.hub_code }
      column: order_date { field: orders_cl.order_date }
      column: order_hour { field: orders_cl.order_hour }
      column: rider_id {field: orders_cl.rider_id}
      column: id { field: orders_cl.id }
      column: rider_returned_to_hub_timestamp { field: orders_cl.rider_returned_to_hub_timestamp }
      column: order_rider_claimed_timestamp { field: orders_cl.order_rider_claimed_timestamp }
      filters: {
        field: orders_cl.is_successful_order
        value: "yes"
      }
      derived_column: on_duty_time {
        sql:timestamp_diff(rider_returned_to_hub_timestamp, order_rider_claimed_timestamp, minute)
          ;;
      }
      derived_column: hourly_avg_on_duty_time {
        sql:avg(timestamp_diff(rider_returned_to_hub_timestamp, order_rider_claimed_timestamp, minute)) over (partition by hub_code,order_date,order_hour)
          ;;
      }
      derived_column:daily_avg_on_duty_time {
        sql:avg(timestamp_diff(rider_returned_to_hub_timestamp, order_rider_claimed_timestamp, minute)) over (partition by hub_code,order_date)
          ;;
      }
    }
  }




  dimension: hub_code {
    label: "Hub Code"
  }
  dimension: order_date {
    label: "Order Date"
    description: "Order Placement Time/Date"
    type: date
  }
  dimension: order_hour {
    label: "Order Hour"
    type: number
  }
  dimension: id {
    primary_key: yes
    label: "Order ID"
  }

  dimension: rider_id {
    label: "Rider ID"
    type: string
  }




  dimension: rider_returned_to_hub_timestamp {
    label: "Rider Returned to Hub Timestamp"
    description: "The time, when a rider arrives back at the hub after delivering an order"
    type: date_time
  }
  dimension: order_rider_claimed_timestamp {
    label: "Rider Claimed Timestamp"
    type: date_time
  }

  dimension: on_duty_time {
    hidden: yes
    label: "on_duty_time"
    type: number
  }

  dimension: hourly_avg_on_duty_time {
    label: "hourly_avg_on_duty_time"
    hidden: yes
    type: number
  }

  dimension: daily_avg_on_duty_time {
    label: "Avg Daily on Duty Time"
    hidden: yes
    type: number
  }


  dimension: clean_on_duty_time {
    label: "Rider on Duty time (min)"
    description: "Time when a rider claim the order until returning to the hub"
    type: number
    sql: case when (on_duty_time < 4 or on_duty_time is null or on_duty_time > 50)
         then
              case when (hourly_avg_on_duty_time < 4 or hourly_avg_on_duty_time is null or hourly_avg_on_duty_time > 50)
                   then daily_avg_on_duty_time
              else
                  hourly_avg_on_duty_time end
        else  on_duty_time end;;
  }

  measure: rider_on_duty_time_minute {
    label: "Rider On Duty Time minutes"
    group_label: ">> Operational KPIs"
    type: sum
    sql:${clean_on_duty_time};;
    value_format_name: decimal_2
  }


  measure: cnt_rider {
    label: "# Riders Delivering Orders"
    type: number
    group_label: ">> Operational KPIs"
    sql:count (distinct ${rider_id});;
    value_format_name: decimal_0
  }

}
