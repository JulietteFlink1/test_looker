view: rider_nps_de {
  sql_table_name: `flink-data-prod.google_sheets.rider_nps_de`
  ;;

  dimension: token {
    type: string
    primary_key: yes
    sql: ${TABLE}.token;;
  }

  dimension: based_on_your_experience_of_riding_with_flink_so_far_how_likely_are_you_to_recommend_joining_us_to_a_friend_or_a_family_member_ {
    type: number
    sql: ${TABLE}.based_on_your_experience_of_riding_with_flink_so_far_how_likely_are_you_to_recommend_joining_us_to_a_friend_or_a_family_member_;;
  }

  dimension: bikes {
    type: number
    sql: ${TABLE}.bikes;;
  }

  dimension: communication_support {
    type: number
    sql: ${TABLE}.communication_support;;
  }

  dimension: contract_type {
    type: string
    sql: ${TABLE}.contract_type;;
  }

  dimension: hub {
    type: string
    sql: ${TABLE}.hub;;
  }

  dimension: hub_infrastructure {
    type: number
    sql: ${TABLE}.hub_infrastructure;;
  }

  dimension: on_boarding_experience {
    type: number
    sql: ${TABLE}.on_boarding_experience;;
  }

  dimension: payments {
    type: number
    sql: ${TABLE}.payments;;
  }

  dimension: rider_app {
    type: number
    sql: ${TABLE}.rider_app;;
  }

  dimension: shift_planning {
    type: number
    sql: ${TABLE}.shift_planning;;
  }

  dimension_group: submitted_at {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.submitted_at ;;
  }

  dimension: what_can_flink_do_to_make_work_better_for_you_sharing_this_will_help_us_to_focus_on_specific_areas_to_improve_ {
    type: string
    sql: ${TABLE}.what_can_flink_do_to_make_work_better_for_you_sharing_this_will_help_us_to_focus_on_specific_areas_to_improve_;;
  }

  dimension: what_hub_are_you_based_in_ {
    type: string
    sql: ${TABLE}.what_hub_are_you_based_in_;;
  }

  dimension: work_duties_deliveries_other_tasks_ {
    type: number
    sql: ${TABLE}.work_duties_deliveries_other_tasks_;;
  }

  dimension: work_environment_atmosphere {
    type: number
    sql: ${TABLE}.work_environment_atmosphere;;
  }


  ############################### MEASURES ####################################

  measure: avg_bikes {
    label: "Equipment"
    type: average
    value_format: "0.0"
    sql: ${bikes};;
  }


  measure: avg_communication_support {
    label: "Rider Support"
    type: average
    value_format: "0.0"
    sql: ${communication_support};;
  }

  measure: avg_hub_infrastructure {
    label: "Hub Infrastructure"
    type: average
    value_format: "0.0"
    sql: ${hub_infrastructure};;
  }

  measure: avg_on_boarding_experience {
    label: "Rider Support"
    type: average
    value_format: "0.0"
    sql: ${on_boarding_experience};;
  }

  measure: avg_payments {
    label: "Payments"
    type: average
    value_format: "0.0"
    sql: ${payments};;
  }

  measure: avg_rider_app {
    label: "Equipment"
    type: average
    value_format: "0.0"
    sql: ${rider_app};;
  }

  measure: avg_shift_planning {
    label: "Shift Scheduling"
    type: average
    value_format: "0.0"
    sql: ${shift_planning};;
  }

  measure: avg_work_duties_deliveries_other_tasks_ {
    label: ""
    type: average
    value_format: "0.0"
    sql: ${work_duties_deliveries_other_tasks_};;
  }

  measure: avg_work_environment_atmosphere {
    label: ""
    type: average
    value_format: "0.0"
    sql: ${work_environment_atmosphere};;
  }

  measure: count {
    type: count
    drill_fields: []
  }
  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
}
