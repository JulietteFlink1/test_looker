view: jtbd_analysis_part_2 {
    sql_table_name: `flink-data-dev.dbt_pmitterova_staging.jtbd_analysis_part_2`
      ;;
    view_label: "JTBD Collections Analysis"


  measure: count {
    type: count
    drill_fields: [detail*]
  }
  dimension: event_date {
    type: date
    datatype: date
    sql: ${TABLE}.event_date ;;
  }
  dimension: jtbd_time_window {
    type: string
    sql: ${TABLE}.jtbd_time_window ;;
  }
  dimension: is_new_user {
    type: yesno
    sql: ${TABLE}.is_new_user ;;
  }
  dimension: collection {
    type: string
    sql: ${TABLE}.collection ;;
  }


  ####### MEASURES #########

  measure: click_events {
    type: sum
    sql: ${TABLE}.click_events ;;
  }
  measure: home_events {
    type: sum
    sql: ${TABLE}.home_events ;;
  }
  measure: atc_events {
    type: sum
    sql: ${TABLE}.atc_events ;;
  }
  measure: pdp_events {
    type: sum
    sql: ${TABLE}.pdp_events ;;
  }
  measure: click_users {
    type: sum
    sql: ${TABLE}.click_users ;;
  }
  measure: home_users {
    type: sum
    sql: ${TABLE}.home_users ;;
  }
  measure: atc_users {
    type: sum
    sql: ${TABLE}.atc_users ;;
  }
  measure: pdp_users {
    type: sum
    sql: ${TABLE}.pdp_users ;;
  }

  ######## RATES #########

  measure: home_to_click_rate {
    group_label: "Rates (%)"
    label: "Home to Click Rate"
    type: number
    value_format_name: percent_2
    sql: ${click_events} / nullif(${home_events},0);;
  }
  measure: home_to_click_rate_users {
    group_label: "Rates (%)"
    label: "Home to Click Rate (Users)"
    type: number
    value_format_name: percent_2
    sql: ${click_users} / nullif(${home_users},0);;
  }

  measure: click_to_atc_rate {
    group_label: "Rates (%)"
    label: "Click to ATC Rate"
    type: number
    value_format_name: percent_2
    sql: ${atc_events} / nullif(${click_events},0);;
  }
  measure: click_to_atc_rate_users {
    group_label: "Rates (%)"
    label: "Click to ATC Rate (Users)"
    type: number
    value_format_name: percent_2
    sql: ${atc_users} / nullif(${click_users},0);;
  }

  measure: click_to_pdp_rate {
    group_label: "Rates (%)"
    label: "Click to PDP Rate"
    type: number
    value_format_name: percent_2
    sql: ${pdp_events} / nullif(${click_events},0);;
  }
  measure: click_to_pdp_rate_users {
    group_label: "Rates (%)"
    label: "Click to PDP Rate (Users)"
    type: number
    value_format_name: percent_2
    sql: ${pdp_users} / nullif(${click_users},0);;
  }

  set: detail {
    fields: [
      event_date,
      jtbd_time_window,
      is_new_user,
      collection,
      click_events,
      home_events,
      atc_events,
      pdp_events,
      click_users,
      home_users,
      atc_users,
      pdp_users
    ]
  }
}
