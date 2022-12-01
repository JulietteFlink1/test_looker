view: favourites_analysis_part2 {
  sql_table_name:`flink-data-dev.dbt_famin.account_favourites_analysis_part2`;;

  view_label: "Favourites Analysis"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# ======= IDs ======= #

  dimension: anonymous_id {
    hidden: yes
    group_label: "IDs"
    label: "Anonymous ID"
    description: "Anonymous ID"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }


# ======= Date ======= #

  dimension_group: first_visit_date {
    group_label: "Date"
    label: "First Visit"
    description: "Date of first visit"
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.first_visit_date ;;
    datatype: date
  }

  dimension_group: first_order_date {
    group_label: "Date"
    label: "First Order"
    description: "Date of first order"
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.first_visit_date ;;
    datatype: date
  }


  dimension_group: first_interaction_date {
    group_label: "Date"
    label: "First Interaction"
    description: "Date of first interaction with favourites"
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.first_interaction_date ;;
    datatype: date
  }


# ======= Location Dimension ======= #

  dimension: country_iso {
    group_label: "Location Dimension"
    label: "Country ISO"
    description: "First visit country ISO"
    type: string
    sql: ${TABLE}.first_visit_country_iso ;;
  }

# ======= Device Dimension ======= #

  dimension: platform {
    group_label: "Device Dimension"
    label: "Platform"
    description: "First visit platform"
    type: string
    sql: ${TABLE}.first_visit_platform ;;
  }

# ======= Favourites ======= #

  dimension: total_num_of_interactions{
    group_label: "Favourites"
    label: "# Total Interactions"
    description: "Total number of interactions with favourites"
    type: number
    sql: ${TABLE}.total_num_of_interactions;;
  }

  dimension: number_interactions_within_28_days{
    group_label: "Favourites"
    label: "# Interactions within 28 Days"
    description: "Total number of interactions with favourites within 28 days since first visit"
    type: number
    sql: ${TABLE}.number_interactions_within_28_days;;
  }

  dimension: number_total_orders{
    group_label: "Favourites"
    label: "# Total Orders"
    description: "Total number of orders"
    type: number
    sql: ${TABLE}.number_total_orders;;
  }

  dimension: number_orders_during_interaction{
    group_label: "Favourites"
    label: "# Orders During Interaction"
    description: "Total number of orders at the time of first interaction"
    type: number
    sql: ${TABLE}.number_orders_during_interaction;;
  }

  dimension: aov_during_interaction{
    group_label: "Favourites"
    label: "AOV During Interaction"
    description: "AOV of orders placed before or at the time of first interaction"
    type: number
    sql: ${TABLE}.aov_during_interaction;;
  }

  dimension: number_incremental_orders{
    group_label: "Favourites"
    label: "Number of Incremental Orders"
    description: "Number of incremental orders after first interaction with favourites"
    type: number
    sql: ${TABLE}.number_incremental_orders;;
  }

  dimension: aov_of_incremental_orders{
    group_label: "Favourites"
    label: "AOV of Incremental Orders"
    description: "AOV of incremental orders placed after first interaction with favourites"
    type: number
    sql: ${TABLE}.aov_of_incremental_orders;;
  }

  dimension: order_count_in_four_weeks{
    group_label: "Favourites"
    label: "# Orders in Four Weeks"
    description: "Number of orders in four weeks from first order date including the first order"
    type: number
    sql: ${TABLE}.order_count_in_four_weeks;;
  }

  dimension: number_orders_within_28_days_of_interaction{
    group_label: "Favourites"
    label: "# Orders within 28 days of interaction"
    description: "Number of orders within 28 days of first interaction with favourites"
    type: number
    sql: ${TABLE}.number_orders_within_28_days_of_interaction;;
  }

  dimension: aov_of_orders_within_28_days{
    group_label: "Favourites"
    label: "AOV of orders within 28 days"
    description: "Number of orders within 28 days of first interaction with favourites"
    type: number
    sql: ${TABLE}.aov_of_orders_within_28_days;;
  }


  dimension: flag_early_interactor{
    group_label: "Favourites"
    label: "Has Interacted With Favourites Early"
    description: "Has customer interacted with favourites early in the order lifecycle. Here early is defined as 0-2 orders"
    type: yesno
    sql: ${TABLE}.flag_early_interactor;;
  }

  dimension: flag_four_in_four {
    group_label: "Favourites"
    label: "Has customer placed four orders in four weeks"
    description: "Has customer placed four orders in four weeks from first order date"
    type: yesno
    sql: ${TABLE}.flag_four_in_four;;
  }


# ======= Measures ======= #


  measure: count_users {
    group_label: "Measures"
    hidden: no
    label: "#All Interacting Users"
    description: "Number of all users who have interacted with favourites at least once and have at least one order"
    type: count_distinct
    sql: ${anonymous_id};;
  }

  measure: count_users_early_interactors {
    group_label: "Measures"
    hidden: no
    label: "#Early Interactors"
    description: "Number of all users who have interacted with favourites first time within placing 0-2 orders"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [flag_early_interactor: "yes"]
  }

  measure: count_users_late_interactors {
    group_label: "Measures"
    hidden: no
    label: "#Late Interactors"
    description: "Number of all users who have interacted with favourites first time after 2nd order"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [flag_early_interactor: "no"]
  }

  measure: count_users_four_in_four {
    group_label: "Measures"
    hidden: no
    label: "#Four in Four"
    description: "Number of all interacting users who have placed four orders in four weeks from first order date"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [flag_four_in_four: "yes"]
  }




}
