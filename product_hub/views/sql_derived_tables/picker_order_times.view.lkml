# If necessary, uncomment the line below to include explore_source.
include: "/product_hub/explores/picker_app_events.explore.lkml"

view: picker_order_times {
  derived_table: {
  sql:WITH global_filters_and_parameters AS (select TRUE as generic_join_dim)
    SELECT
    daily_picker_events.order_id  AS order_id,
    MAX(IF( daily_picker_events.event_name   in ('order_state', 'order_state_updated') and  daily_picker_events.action  ='accepted', daily_picker_events.event_timestamp,null))  AS order_accepted,
    MAX(IF( daily_picker_events.event_name   in ('order_state', 'order_state_updated') and  daily_picker_events.action  ='finished', daily_picker_events.event_timestamp,null))  AS order_finished,
    MIN(IF( daily_picker_events.event_name   in ('order_state', 'order_state_updated') and  daily_picker_events.action  ='received', daily_picker_events.event_timestamp,null))  AS order_received
  FROM `flink-data-prod.curated.daily_picker_events`
     AS daily_picker_events
  LEFT JOIN global_filters_and_parameters ON global_filters_and_parameters.generic_join_dim = TRUE
  WHERE {% condition global_filters_and_parameters.datasource_filter %} DATE(daily_picker_events.event_timestamp) {% endcondition %}
  GROUP BY
  1;;
  }
  dimension: order_id {
    hidden: yes
    description: ""
    primary_key: yes
  }
  dimension: order_accepted {
    description: "Order accepted timestamp"
  }
  dimension: order_finished {
    description: "Order finished timestamp"
  }
  dimension: order_received {
    description: "Order received timestamp"
  }

  dimension: received_to_accepted_seconds {
    description: "Difference in seconds between received and accepted timestamps"
    type: number
    sql: DATETIME_DIFF(order_accepted,order_received, SECOND) ;;
  }

  dimension: accepted_to_finished_seconds {
    description: "Difference in seconds between finished and accepted timestamps"
    type: number
    sql: DATETIME_DIFF(order_finished,order_accepted, SECOND) ;;
  }

}
