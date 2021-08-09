view: app_downloads {
  sql_table_name: `flink-data-prod.google_sheets.investor_report_input_app_downloads`
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

  dimension: de_flink_app_downloads {
    type: number
    sql: ${TABLE}.de_flink_app_downloads ;;
  }

  dimension: de_getir_app_downloads {
    type: number
    sql: ${TABLE}.de_getir_app_downloads ;;
  }

  dimension: de_gorillas_app_downloads {
    type: number
    sql: ${TABLE}.de_gorillas_app_downloads ;;
  }

  dimension: fr_cajoo_app_downloads {
    type: number
    sql: ${TABLE}.fr_cajoo_app_downloads ;;
  }

  dimension: fr_dija_app_downloads {
    type: string
    sql: ${TABLE}.fr_dija_app_downloads ;;
  }

  dimension: fr_flink_app_downloads {
    type: string
    sql: ${TABLE}.fr_flink_app_downloads ;;
  }

  dimension: fr_frichti_app_downloads {
    type: number
    sql: ${TABLE}.fr_frichti_app_downloads ;;
  }

  dimension: fr_getir_app_downloads {
    type: number
    sql: ${TABLE}.fr_getir_app_downloads ;;
  }

  dimension: fr_gorillas_app_downloads {
    type: number
    sql: ${TABLE}.fr_gorillas_app_downloads ;;
  }

  dimension: fr_zapp_app_downloads {
    type: string
    sql: ${TABLE}.fr_zapp_app_downloads ;;
  }

  dimension: nl_flink_app_downloads {
    type: string
    sql: ${TABLE}.nl_flink_app_downloads ;;
  }

  dimension: nl_getir_app_downloads {
    type: number
    sql: ${TABLE}.nl_getir_app_downloads ;;
  }

  dimension: nl_gorillas_app_downloads {
    type: number
    sql: ${TABLE}.nl_gorillas_app_downloads ;;
  }

  dimension: nl_zapp_app_downloads {
    type: number
    sql: ${TABLE}.nl_zapp_app_downloads ;;
  }

  measure: sum_de_flink_app_downloads {
    group_label: "App Downloads (DE)"
    label: "Flink App Downloads (DE)"
    type: sum
    sql: ${TABLE}.de_flink_app_downloads ;;
  }

  measure: sum_de_getir_app_downloads {
    group_label: "App Downloads (DE)"
    label: "Getir App Downloads (DE)"
    type: sum
    sql: ${TABLE}.de_getir_app_downloads ;;
  }

  measure: sum_de_gorillas_app_downloads {
    group_label: "App Downloads (DE)"
    label: "Gorillas App Downloads (DE)"
    type: sum
    sql: ${TABLE}.de_gorillas_app_downloads ;;
  }

  measure: sum_fr_cajoo_app_downloads {
    group_label: "App Downloads (FR)"
    label: "Cajoo App Downloads (FR)"
    type: sum
    sql: ${TABLE}.fr_cajoo_app_downloads ;;
  }

  measure: sum_fr_dija_app_downloads {
    group_label: "App Downloads (FR)"
    label: "Dija App Downloads (FR)"
    type: sum
    sql: ${TABLE}.fr_dija_app_downloads ;;
  }

  measure: sum_fr_flink_app_downloads {
    group_label: "App Downloads (FR)"
    label: "Flink App Downloads (FR)"
    type: sum
    sql: ${TABLE}.fr_flink_app_downloads ;;
  }


  measure: sum_fr_gorillas_app_downloads {
    group_label: "App Downloads (FR)"
    label: "Gorillas App Downloads (FR)"
    type: sum
    sql: ${TABLE}.fr_gorillas_app_downloads ;;
  }

  measure: sum_fr_getir_app_downloads {
    group_label: "App Downloads (FR)"
    label: "Getir App Downloads (FR)"
    type: sum
    sql: ${TABLE}.fr_getir_app_downloads ;;
  }

  measure: sum_fr_zapp_app_downloads {
    group_label: "App Downloads (FR)"
    label: "Zapp App Downloads (FR)"
    type: sum
    sql: ${TABLE}.fr_zapp_app_downloads ;;
  }

  measure: sum_nl_flink_app_downloads {
    group_label: "App Downloads (NL)"
    label: "Flink App Downloads (NL)"
    type: sum
    sql: ${TABLE}.nl_flink_app_downloads ;;
  }

  measure: sum_nl_getir_app_downloads {
    group_label: "App Downloads (NL)"
    label: "Getir App Downloads (NL)"
    type: sum
    sql: ${TABLE}.nl_getir_app_downloads ;;
  }

  measure: sum_nl_gorillas_app_downloads {
    group_label: "App Downloads (NL)"
    label: "Gorillas App Downloads (NL)"
    type: sum
    sql: ${TABLE}.nl_gorillas_app_downloads ;;
  }

  measure: sum_nl_zapp_app_downloads {
    group_label: "App Downloads (NL)"
    label: "Zapp App Downloads (NL)"
    type: sum
    sql: ${TABLE}.nl_zapp_app_downloads ;;
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
