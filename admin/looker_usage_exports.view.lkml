view: looker_usage_exports {
  sql_table_name: `flink-data-dev.looker_exports.looker_usage_exports`
    ;;



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Main
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: connection_name {
    type: string
    sql: ${TABLE}.connection_name ;;
  }


  dimension: dashboard_id {
    label: "ID (Dashboard)"
    type: number
    sql: ${TABLE}.dashboard_id ;;
  }

  dimension: dashboard_link {
    label: "Link (Dashboard)"
    type: string
    sql: ${TABLE}.dashboard_link ;;
  }

  dimension: dashboard_title {
    label: "Title (Dashboard)"
    type: string
    sql: ${TABLE}.dashboard_title ;;
  }

  dimension: explore {
    label: "Explore"
    description: "The Looker Explore, that triggered BigQuery jobs"
    type: string
    sql: ${TABLE}.explore ;;
  }

  dimension: is_user_developer {
    label: "Is User Developer"
    type: yesno
    sql: ${TABLE}.is_user_developer ;;
  }

  dimension: is_user_explorer {
    label: "Is User Explorer"
    type: yesno
    sql: ${TABLE}.is_user_explorer ;;
  }

  dimension: is_user_viewer {
    label: "Is User Viewer"
    type: yesno
    sql: ${TABLE}.is_user_viewer ;;
  }

  dimension: look_id {
    label: "ID (Looks)"
    type: string
    sql: ${TABLE}.look_id ;;
  }

  dimension: look_link {
    label: "Link (Look)"
    type: string
    sql: ${TABLE}.look_link ;;
  }

  dimension: look_title {
    label: "Title (Look)"
    type: string
    sql: ${TABLE}.look_title ;;
  }

  dimension: model {
    label: "Model"
    description: "The Looker model, that is related to the query"
    type: string
    sql: ${TABLE}.model ;;
  }

  dimension: user_email {
    label: "User Email"
    type: string
    sql: ${TABLE}.user_email ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Dates & Timestamps
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dimension_group: created {

    label: "Query"

    type: time
    timeframes: [
      time,
      date,
      week
    ]
    sql: ${TABLE}.created_time ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    IDs
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: history_id {
    type: number
    sql: ${TABLE}.history_id ;;
    hidden: yes
  }

  dimension: history_slug {
    type: string
    sql: ${TABLE}.history_slug ;;
    hidden: yes
    primary_key: yes
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Hidden Measure-Dims
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: runtime_in_seconds {
    type: number
    sql: ${TABLE}.average_runtime_in_seconds ;;
    hidden: yes
  }

  dimension: number_of_approximate_web_usage_in_minutes {
    type: number
    sql: ${TABLE}.number_of_approximate_web_usage_in_minutes ;;
    hidden: yes
  }

  dimension: number_of_dashboard_users {
    type: number
    sql: ${TABLE}.number_of_dashboard_users ;;
    hidden: yes
  }

  dimension: number_of_dashboards_run {
    type: number
    sql: ${TABLE}.number_of_dashboards_run ;;
    hidden: yes
  }

  dimension: number_of_explore_users {
    type: number
    sql: ${TABLE}.number_of_explore_users ;;
    hidden: yes
  }

  dimension: number_of_queries {
    type: number
    sql: ${TABLE}.number_of_queries ;;
    hidden: yes
  }

  dimension: number_of_queries_under_10s {
    type: number
    sql: ${TABLE}.number_of_queries_under_10s ;;
    hidden: yes
  }

  dimension: number_of_results_from_cache {
    type: number
    sql: ${TABLE}.number_of_results_from_cache ;;
    hidden: yes
  }

  dimension: number_of_results_from_database {
    type: number
    sql: ${TABLE}.number_of_results_from_database ;;
    hidden: yes
  }

  dimension: query_runtime_in_seconds {
    type: number
    sql: ${TABLE}.query_runtime_in_seconds ;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: avg_runtime_seconds {
    label: "AVG Query Runtime"
    description: "The average amount of seconds it took to execute a query"

    type: average
    sql: ${runtime_in_seconds} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_approximate_web_usage_in_minutes {

    label: "# Web Usage Minutes"

    type: sum
    sql: ${number_of_approximate_web_usage_in_minutes} ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_queries {

    label: "# Queries"

    type: sum
    sql: ${number_of_queries} ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_queries_under_10s {

    label: "# Queries < 10 seconds"

    type: sum
    sql: ${number_of_queries_under_10s} ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_results_from_cache {

    label: "# Queries from Cache"

    type: sum
    sql: ${number_of_results_from_cache} ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_results_from_database {

    label: "# Queries to Database"

    type: sum
    sql: ${number_of_results_from_database} ;;
    value_format_name: decimal_0
  }






  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

















  measure: count {
    type: count
    drill_fields: [connection_name, created_time]
  }
}
