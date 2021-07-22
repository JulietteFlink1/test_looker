view: app_ratings {
  sql_table_name: `flink-backend.gsheet_investor_reporting_input.app_ratings`
    ;;

  dimension: date {
    type: string
    sql: ${TABLE}.date ;;
  }

  dimension: tracking_date {
    type: date
    convert_tz: no
    sql: ${TABLE}.date ;;
  }

  dimension: de_flink_app_rating {
    type: number
    sql: ${TABLE}.de_flink_app_rating ;;
  }

  dimension: de_getir_app_rating {
    type: number
    sql: ${TABLE}.de_getir_app_rating ;;
  }

  dimension: de_gorillas_app_rating {
    type: number
    sql: ${TABLE}.de_gorillas_app_rating ;;
  }

  dimension: fr_cajoo_app_rating {
    type: number
    sql: ${TABLE}.fr_cajoo_app_rating ;;
  }

  dimension: fr_frichti_app_rating {
    type: number
    sql: ${TABLE}.fr_frichti_app_rating ;;
  }

  dimension: fr_getir_app_rating {
    type: number
    sql: ${TABLE}.fr_getir_app_rating ;;
  }

  dimension: fr_gorillas_app_rating {
    type: number
    sql: ${TABLE}.fr_gorillas_app_rating ;;
  }

  dimension: nl_getir_app_rating {
    type: number
    sql: ${TABLE}.nl_getir_app_rating ;;
  }

  dimension: nl_gorillas_app_rating {
    type: number
    sql: ${TABLE}.nl_gorillas_app_rating ;;
  }

  dimension: nl_zapp_app_rating {
    type: number
    sql: ${TABLE}.nl_zapp_app_rating ;;
  }

  measure: sum_de_flink_app_rating {
    group_label: "App Ratings (DE)"
    label: "Flink App Store Rating (DE)"
    type: sum
    sql: ${TABLE}.de_flink_app_rating ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
