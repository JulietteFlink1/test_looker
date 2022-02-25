view: power_user_curves {
  sql_table_name: `flink-data-dev.sandbox_natalia.power_user_curves_28d` ;;

  dimension_group: first_visit_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.first_visit_date AS DATE) ;;
    datatype: date
  }

  dimension: anonymous_id {
    description: "Unique anonymous_id"
    type: string
    sql: ${TABLE}.anonymous_id ;;
    primary_key: yes
    hidden: yes
  }

  dimension: user_id {
    description: "Unique user_id"
    type: string
    sql: ${TABLE}.user_id ;;
    hidden: yes
  }

  dimension: has_first_order {
    description: "Flag on user first order (Y/N)"
    type: yesno
    sql: ${TABLE}.user_id ;;
  }

  dimension: days_to_first_order {
    description: "Amount of days (visits) until user made first order"
    type: number
    sql: ${TABLE}.days_to_first_order ;;
  }

  dimension: visits_in_28d {
    description: "Amount of days (visits) in 28 days since first visit"
    type: number
    sql: ${TABLE}.visits_in_28d  ;;
  }

  measure: count_users {
    description: "Unique count of visitors"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }

  measure: count_users_with_order {
    description: "Unique count of visitors who made a first order"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [has_first_order: "yes"]
  }

}
