view: app_ratings_android {
  sql_table_name: `flink-data-prod.google_sheets.investor_report_input_app_ratings_android`
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

  dimension: cajoo_app_rating {
    type: number
    sql: ${TABLE}.fr_cajoo_app_rating ;;
  }

  dimension: getir_app_rating {
    type: number
    sql: ${TABLE}.fr_getir_app_rating ;;
  }

  dimension: gorillas_app_rating {
    type: number
    sql: ${TABLE}.fr_gorillas_app_rating ;;
  }


  measure: avg_flink_app_rating {
    group_label: "App Ratings (android)"
    label: "Flink App Store Rating"
    type: average
    sql: ${TABLE}.flink_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_gorillas_app_rating {
    group_label: "App Ratings (android)"
    label: "Gorillas App Store Rating"
    type: average
    sql: ${TABLE}.gorillas_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_getir_app_rating {
    group_label: "App Ratings (android)"
    label: "Getir App Store Rating"
    type: average
    sql: ${TABLE}.getir_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_zapp_app_rating {
    group_label: "App Ratings (android)"
    label: "Zapp App Store Rating"
    type: average
    sql: ${TABLE}.zapp_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_dija_app_rating {
    group_label: "App Ratings (android)"
    label: "Dija App Store Rating"
    type: average
    sql: ${TABLE}.dija_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_cajoo_app_rating {
    group_label: "App Ratings (android)"
    label: "Cajoo App Store Rating)"
    type: average
    sql: ${TABLE}.cajoo_app_rating ;;
    value_format: "0.00"
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
