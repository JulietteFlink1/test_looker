view: hub_ops_inbounding_kpis {
  sql_table_name: `flink-data-dev.reporting.hub_ops_inbounding_kpis`;;


  dimension: dispatch_notification_id {
    hidden: yes
    primary_key: yes
  }

  dimension: percent_inbounded_fruit_and_veggy_in_3_hours_per_desadv { hidden: yes}
  dimension: percent_inbounded_fruit_and_veggy_in_2_hours_per_desadv { hidden: yes}
  dimension: hours_needed_to_inbound_90_percent_per_desadv { hidden: yes }

  measure: avg_percent_FaV_inbounded_in_3_h {

    label: "AVG F&V Inbounded in 3h"
    description: "This metric shows, how many items in the fruits and vegetables group are inbounded within the first 3 hours since delivery. The metric is an average across dispatch notifications (DESADVs)"
    group_label: "Inbounding Performance"

    type: average
    sql: ${percent_inbounded_fruit_and_veggy_in_3_hours_per_desadv} ;;
    value_format_name: percent_1
  }

  measure: avg_percent_FaV_inbounded_in_2_h {

    label: "AVG F&V Inbounded in 2h"
    description: "This metric shows, how many items in the fruits and vegetables group are inbounded within the first 2 hours since delivery. The metric is an average across dispatch notifications (DESADVs)"
    group_label: "Inbounding Performance"

    type: average
    sql: ${percent_inbounded_fruit_and_veggy_in_2_hours_per_desadv} ;;
    value_format_name: percent_1
  }

  measure: hours_needed_to_inbound_90_percent {

    label: "AVG Hours to Inbound 90% Delivery"
    description: "This metric shows, how many hours are needed to inbound 90% of a related dispatch notification. If the dispatch notification was not inbounded at least to a degree of 90%, this field is empty. The metric is an average across dispatch notifications (DESADVs)"
    group_label: "Inbounding Performance"

    type: average
    sql: ${hours_needed_to_inbound_90_percent_per_desadv} ;;
    value_format_name: decimal_1
  }



}
