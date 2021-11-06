include: "/views/bigquery_tables/curated_layer/orders.view.lkml"

view: order_comments {
  extends: [orders]

  dimension: has_customer_note {
    type: yesno
    sql: NOT(${customer_note} IS NULL OR ${customer_note}="" OR ${customer_note}=" ");;
  }

  dimension: is_early_delivery {
    type: yesno
    sql: TIME_DIFF(TIME(${delivery_eta_timestamp_raw}), TIME(${delivery_timestamp_raw}), MINUTE) > 0 ;;
  }

  dimension: is_late_delivery {
    type: yesno
    sql: TIME_DIFF(TIME(${delivery_eta_timestamp_raw}), TIME(${delivery_timestamp_raw}), MINUTE) < 0 ;;
  }

  dimension: is_on_time_delivery {
    type: yesno
    sql: TIME_DIFF(TIME(${delivery_eta_timestamp_raw}), TIME(${delivery_timestamp_raw}), MINUTE) = 0 ;;
  }

  dimension: picker_acceptance_time {
    type: duration_second
    sql_start: TIMESTAMP(${created_time});; # convert to UTC
    sql_end: TIMESTAMP(${order_picker_accepted_timestamp});; # convert from string to timestamp in UTC
  }

  dimension: packing_time {
    type: duration_second
    sql_start: TIMESTAMP(${order_picker_accepted_timestamp});; # convert from string to timestamp in UTC
    sql_end: TIMESTAMP(${order_packed_timestamp});; # convert from string to timestamp in UTC
  }

  dimension: rider_acceptance_time {
    type: duration_second
    sql_start: TIMESTAMP(${order_packed_timestamp});; # convert from string to timestamp in UTC
    sql_end: TIMESTAMP(${order_rider_claimed_timestamp});; # convert from string to timestamp in UTC
  }

  dimension: onroute_time {
    type: duration_second
    sql_start: TIMESTAMP(${order_rider_claimed_timestamp});;
    sql_end: TIMESTAMP(${delivery_timestamp_time});;
  }

  measure: avg_picker_acceptance_time {
    type: average
    sql: ${picker_acceptance_time} ;;
    value_format_name: decimal_1
  }
  measure: avg_packing_time {
    type: average
    sql: ${packing_time} ;;
    value_format_name: decimal_1
  }
  measure: avg_rider_acceptance_time {
    type: average
    sql: ${rider_acceptance_time} ;;
    value_format_name: decimal_1
  }
  measure: avg_onroute_time {
    type: average
    sql: ${onroute_time} ;;
    value_format_name: decimal_1
  }

  dimension: delivery_timeliness {
    type: string
    case: {
      when: {
        sql: TIME_DIFF(TIME(${delivery_eta_timestamp_raw}), TIME(${delivery_timestamp_raw}), MINUTE) > 0
             AND (${status}="Complete" OR ${status}="fulfilled" OR ${status}="partially fulfilled");;
        label: "Early"
      }
      when: {
        sql: TIME_DIFF(TIME(${delivery_eta_timestamp_raw}), TIME(${delivery_timestamp_raw}), MINUTE) = 0
             AND (${status}="Complete" OR ${status}="fulfilled" OR ${status}="partially fulfilled");;
        label: "On Time"
      }
      when: {
        sql: TIME_DIFF(TIME(${delivery_eta_timestamp_raw}), TIME(${delivery_timestamp_raw}), MINUTE) < 0
             AND (${status}="Complete" OR ${status}="fulfilled" OR ${status}="partially fulfilled");;
        label: "Late"
      }
      else: "Undelivered"
    }
  }

  measure: cnt_is_delivered_on_time {
    type: count
    filters: [is_order_on_time: "yes"]
  }

  measure: cnt_has_customer_notes {
    type: count
    filters: [has_customer_note: "yes"]
  }

  measure: cnt_unique_location_has_customer_notes {
    type: count_distinct
    sql: ${customer_location::latitude} || '-' || ${customer_location::longitude};;
    filters: [has_customer_note: "yes"]
  }

  measure: cnt_unique_location_no_customer_notes {
    type: count_distinct
    sql: ${customer_location::latitude} || '-' || ${customer_location::longitude};;
    filters: [has_customer_note: "no"]
  }

  measure: cnt_unique_order_locations {
    type: count_distinct
    sql: ${customer_location::latitude} || '-' || ${customer_location::longitude};;
  }

  ## these dimensions are automatically generated from orders dimensions and will trigger errors if not defined
  dimension: hubs.latitude {
    hidden: yes
  }

  dimension: hubs.longitude {
    hidden: yes
  }

  dimension: shyftplan_riders_pickers_hours.rider_utr {
    hidden: yes
  }

  dimension: shyftplan_riders_pickers_hours.picker_utr {
    hidden: yes
  }

  dimension: shyftplan_riders_pickers_hours.picker_hours {
    hidden: yes
  }

  dimension: shyftplan_riders_pickers_hours.rider_hours {
    hidden: yes
  }

  dimension: shyftplan_riders_pickers_hours.pickers {
    hidden: yes
  }

  dimension: shyftplan_riders_pickers_hours.riders {
    hidden: yes
  }
}
