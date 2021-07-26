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
    sql: ${TABLE}.de_flink_app_rating;;
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

  measure: avg_de_flink_app_rating {
    group_label: "App Ratings (DE)"
    label: "Flink App Store Rating (DE)"
    type: average
    sql: ${TABLE}.de_flink_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_de_gorillas_app_rating {
    group_label: "App Ratings (DE)"
    label: "Gorillas App Store Rating (DE)"
    type: average
    sql: ${TABLE}.de_gorillas_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_de_getir_app_rating {
    group_label: "App Ratings (DE)"
    label: "Getir App Store Rating (DE)"
    type: average
    sql: ${TABLE}.de_getir_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_nl_flink_app_rating {
    group_label: "App Ratings (NL)"
    label: "Flink App Store Rating (NL)"
    type: average
    sql: ${TABLE}.nl_flink_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_nl_gorillas_app_rating {
    group_label: "App Ratings (NL)"
    label: "Gorillas App Store Rating (NL)"
    type: average
    sql: ${TABLE}.nl_gorillas_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_nl_getir_app_rating {
    group_label: "App Ratings (NL)"
    label: "Getir App Store Rating (NL)"
    type: average
    sql: ${TABLE}.nl_getir_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_nl_zapp_app_rating {
    group_label: "App Ratings (NL)"
    label: "Zapp App Store Rating (NL)"
    type: average
    sql: ${TABLE}.nl_zapp_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_fr_flink_app_rating {
    group_label: "App Ratings (FR)"
    label: "Flink App Store Rating (FR)"
    type: average
    sql: ${TABLE}.fr_flink_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_fr_gorillas_app_rating {
    group_label: "App Ratings (FR)"
    label: "Gorillas App Store Rating (FR)"
    type: average
    sql: ${TABLE}.fr_gorillas_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_fr_getir_app_rating {
    group_label: "App Ratings (FR)"
    label: "Getir App Store Rating (FR)"
    type: average
    sql: ${TABLE}.fr_getir_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_fr_zapp_app_rating {
    group_label: "App Ratings (FR)"
    label: "Zapp App Store Rating (FR)"
    type: average
    sql: ${TABLE}.fr_zapp_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_fr_dija_app_rating {
    group_label: "App Ratings (FR)"
    label: "Dija App Store Rating (FR)"
    type: average
    sql: ${TABLE}.fr_dija_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_fr_cajoo_app_rating {
    group_label: "App Ratings (FR)"
    label: "Cajoo App Store Rating (FR)"
    type: average
    sql: ${TABLE}.fr_cajoo_app_rating ;;
    value_format: "0.00"
  }

  measure: avg_fr_frichti_app_rating {
    group_label: "App Ratings (FR)"
    label: "Frichti App Store Rating (FR)"
    type: average
    sql: ${TABLE}.fr_frichti_app_rating ;;
    value_format: "0.00"
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
