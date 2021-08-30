# If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"

view: cvr {
  derived_table: {
    explore_source: segment_tracking_sessions30 {
      column: country {}
      column: cnt_add_to_cart {}
      column: sum_add_to_cart {}
      column: count {}
      column: cnt_purchase {}
      column: session_start_at_week {}
      column: mcvr1 {}
      column: mcvr2 {}
      column: overall_conversion_rate {}
    }
  }
  dimension: country {
    label: "Tracking events sessions 30 min. Country"
  }

  dimension: unique_id {
    primary_key: yes
    sql:  concat(country,cast(session_start_at_week as string)) ;;
  }
  dimension: cnt_add_to_cart {
    label: "Tracking events sessions 30 min. Add to cart count"
    description: "Number of sessions in which at least one Product Added To Cart event happened"
    type: number
  }
  dimension: sum_add_to_cart {
    label: "Tracking events sessions 30 min. Add to cart sum of events"
    type: number
  }
  dimension: count {
    label: "Tracking events sessions 30 min. Count"
    type: number
  }
  dimension: cnt_purchase {
    label: "Tracking events sessions 30 min. Order placed count"
    description: "Number of sessions in which at least one Order Placed event happened"
    type: number
  }
  dimension: session_start_at_week {
    label: "Tracking events sessions 30 min. Session Start At Date"
    type: date
  }
  dimension: mcvr1 {
    label: "Tracking events sessions 30 min. Mcvr1"
    description: "Number of sessions in which an Addres Confirmed event happened, compared to the total number of Session Started"
    value_format: "#,##0.0%"
    type: number
  }
  dimension: mcvr2 {
    label: "Tracking events sessions 30 min. Mcvr2"
    description: "Number of sessions in which an Add to Basket event happened, compared to the total number of Session Started"
    value_format: "#,##0.0%"
    type: number
  }
  dimension: overall_conversion_rate {
    label: "Tracking events sessions 30 min. Overall Conversion Rate"
    description: "Number of sessions in which an Order Placed event happened, compared to the total number of Session Started"
    value_format: "#,##0.0%"
    type: number
  }

}
