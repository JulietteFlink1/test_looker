view: sms_verification_analysis {
  sql_table_name: `flink-data-dev.sandbox_natalia.sms_verification_flow` ;;

  view_label: "* SMS Verification *"
  drill_fields: [core_dimensions*]

  set: core_dimensions {
    fields: [
      platform,
      country_iso,
      user_flow,
      app_version,
      event_date_date
    ]
  }

## Dimensions

  dimension_group: event_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.event_date AS DATE) ;;
    datatype: date
  }

  dimension: platform {
    description: "Platform"
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: app_version {
    description: "App version"
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: country_iso {
    description: "Country"
    type: string
    sql: ${TABLE}.country_hub ;;
  }

  # dimension: user_flow {
  #   description: "User Flow: New registration vs Existing Loggedin/out"
  #   type: string
  #   sql: ${TABLE}.user_type_flow ;;
  # }

  dimension: user_flow {
    description: "User Flow: New registration vs Existing Loggedin/out"    type: string
    case: {
      when: {
        sql: ${TABLE}.user_type_flow = "is_registration_flow" ;;
        label: "New | Registration"
      }
      when: {
        sql: ${TABLE}.user_type_flow = "is_login_flow" ;;
        label: "Existing | Logged Out"
      }
      when: {
        sql: ${TABLE}.user_type_flow = "is_verification_only" ;;
        label: "Existing | Logged In"
      }
    }
  }


###### Measures

  measure: step_1_sms_verification_request_viewed {
    description: "step_1_sms_verification_request_viewed"
    type: sum
    sql: ${TABLE}.step_1_sms_verification_request_viewed ;;
  }

  measure: step_2_sms_verification_send_code_clicked {
    description: "step_2_sms_verification_send_code_clicked"
    type: sum
    sql: ${TABLE}.step_2_sms_verification_send_code_clicked ;;
  }

  measure: step_3_sms_verification_viewed {
    description: "step_3_sms_verification_viewed"
    type: sum
    sql: ${TABLE}.step_3_sms_verification_viewed ;;
  }

  measure: step_4_sms_verification_clicked   {
    description: "step_4_sms_verification_clicked "
    type: sum
    sql: ${TABLE}.step_4_sms_verification_clicked ;;
  }

  measure: step_5_sms_verification_confirmed {
    description: "step_5_sms_verification_confirmed"
    type: sum
    sql: ${TABLE}.step_5_sms_verification_confirmed ;;
  }

  measure: order_placed {
    description: "order_placed"
    type: sum
    sql: ${TABLE}.order_placed ;;
  }

  # measure: avg_pct_verification_success {
  #   description: "pct_verification_success"
  #   type: average
  #   sql: ${TABLE}.pct_verification_success ;;
  # }

  # measure: avg_pct_order_placed_vv {
  #   description: "pct_order_placed_from_verification_viewed"
  #   type: average
  #   sql: ${TABLE}.pct_order_placed_vv ;;
  # }

  # measure: avg_pct_order_placed_vs {
  #   description: "pct_order_placed_from_verification_success"
  #   type: average
  #   value_format_name: percent_1
  #   sql: ${TABLE}.pct_order_placed_vs ;;
  # }

  ## Percentages recalculated in Looker

  measure: rcc_pct_verification_success {
    description: "Recalculated SMS Verification success"
    type: number
    value_format_name: percent_1
    sql: ${step_5_sms_verification_confirmed}/NULLIF(${step_1_sms_verification_request_viewed},0) ;;
  }

  measure: rcc_pct_order_placed_vv {
    description: "Order Rate of users exposed to SMS Verification "
    type: number
    value_format_name: percent_1
    sql: ${order_placed}/NULLIF(${step_1_sms_verification_request_viewed},0) ;;
  }

  measure: rcc_pct_order_placed_vs {
    description: "Order Rate of users with succesfull SMS Verification "
    type: number
    value_format_name: percent_1
    sql: ${order_placed}/NULLIF(${step_5_sms_verification_confirmed},0) ;;
  }



}
