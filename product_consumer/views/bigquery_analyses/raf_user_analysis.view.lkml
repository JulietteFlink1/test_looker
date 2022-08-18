view: raf_user_analysis {
  sql_table_name: `flink-data-dev.dbt_nwierzbowska.daily_user_raf_analysis`;;
  view_label: "RAF (ios) user analysis"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# ======= IDs ======= #

  dimension: unique_row_id {
    group_label: "IDs"
    label: "Visit date + Anonymous_id UUID"
    description: "Unique identifier of daily user"
    type: string
    sql: ${TABLE}.unique_row_id ;;
  }

  dimension: anonymous_id {
    group_label: "IDs"
    label: "Anonymous ID"
    description: "User ID set by Segment"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  # ======= Generic Dimensions ======= #

  dimension: is_user_logged_in {
    group_label: "Generic Dimensions"
    label: "Is User Logged-in"
    description: "Whether a user was logged-in when an event was triggered"
    type: yesno
    sql: ${TABLE}.is_user_logged_in ;;
  }

  dimension: has_converted {
    group_label: "Generic Dimensions"
    label: "Is user a converter"
    description: "Whether a user has ever converted"
    type: yesno
    sql: ${TABLE}.has_converted ;;
  }

  dimension: country_iso {
    group_label: "Generic Dimensions"
    label: "Country ISO"
    description: "ISO country"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  # ======= RAF Attributes =======

  dimension: is_first_raf_sent {
    group_label: "RAF Attributes"
    label: "Is it the 1st visit when user send RAF invite"
    description: "Whether it's first visit sending RAF invite"
    type: yesno
    sql: ${TABLE}.is_first_raf_sent_date ;;
  }

  dimension: number_of_daily_orders {
    group_label: "Generic Dimensions"
    label: "how many orders user had that day "
    hidden: no
    type: number
    sql: ${TABLE}.number_of_daily_orders ;;
  }

  dimension: number_of_cumulative_orders_at_first_raf {
    group_label: "RAF Attributes"
    label: "# of orders user had at 1st RAF sent"
    description: "If user sent RAF, how many orders had at that point"
    type: number
    sql: ${TABLE}.number_of_cumulative_orders_at_first_raf ;;
  }

  dimension: num_days_from_order_to_raf_send {
    group_label: "RAF Attributes"
    label: "# of Days from order to RAF"
    description: "If user sent RAF, when was the 1st event comparing to order 1st date"
    type: number
    sql: ${TABLE}.num_days_from_order_to_raf_send ;;
  }

  dimension: number_of_days_to_first_order {
    group_label: "RAF Attributes"
    label: "# of Days to first order"
    description: "Number of days between 1st visit and 1st order"
    type: number
    sql: ${TABLE}.number_of_days_to_first_order ;;
  }

  # ======= Analysis Dimensions =======

  dimension: has_home_viewed {
    group_label: "Analysis Dimensions"
    label: "Visit Home"
    description: "Whether a user visited home screen"
    type: yesno
    sql: ${TABLE}.has_home_viewed ;;
  }

  dimension: has_profile_menu_viewed {
    group_label: "Analysis Dimensions"
    label: "Visit User Profile Menu"
    description: "Whether a user visited User Profile Menu"
    type: yesno
    sql: ${TABLE}.has_profile_menu_viewed ;;
  }

  dimension: has_invite_friends_clicked {
    group_label: "Analysis Dimensions"
    label: "Visit RAF screen"
    description: "Whether a user visited RAF screen"
    type: yesno
    sql: ${TABLE}.has_invite_friends_clicked ;;
  }

  dimension: has_raf_send_clicked {
    group_label: "Analysis Dimensions"
    label: "Sent RAF invite"
    description: "Whether a user sent a RAF invite"
    type: yesno
    sql: ${TABLE}.has_raf_send_clicked ;;
  }

  dimension: count_raf_send_clicked {
    group_label: "Analysis Dimensions"
    label: "# of RAF invites sent"
    description: "Number of RAF invites sent"
    type: number
    sql: ${TABLE}.count_raf_send_clicked ;;
  }

  dimension: social_share_option {
    group_label: "Analysis Dimensions"
    label: "Social Share Option"
    description: "Name of the ooption user used to share RAF code"
    type: string
    sql: ${TABLE}.social_share_option ;;
  }

  # ======= Dates / Timestamps =======


  dimension_group: event_date {
    group_label: "Date"
    label: "Event Date"
    description: "Date of when an event happened"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.event_date AS DATE) ;;
    datatype: date
  }

  dimension_group: first_visit_date {
    group_label: "Date"
    label: "First Visit Date"
    description: "Date of when an event happened"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.first_visit_date AS DATE) ;;
    datatype: date
  }

  dimension_group: first_order_date {
    group_label: "Date"
    label: "First Order Date"
    description: "Date of when an event happened"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.first_order_date AS DATE) ;;
    datatype: date
  }

  dimension: first_raf_sent_date {
    group_label: "Date"
    label: "First RAF sent Date"
    description: "Date of first raf sent"
    hidden: no
    type: date
    sql: ${TABLE}.first_raf_sent_date ;;
  }


  # ======= Hideen Dimensions =======

  dimension: number_of_orders_cumulative {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_orders_cumulative ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Measures      ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: count_users_has_home_viewed {
    group_label: "Measures"
    label: "# Users Home Viewed"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [has_home_viewed: "yes"]
  }

  measure: count_users_has_profile_menu_viewed {
    group_label: "Measures"
    label: "# Users Profile Menu Viewed"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [has_profile_menu_viewed: "yes"]
  }

  measure: count_users_has_invite_friends_clicked {
    group_label: "Measures"
    label: "# Users Clicked Invite Friends"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [has_invite_friends_clicked: "yes"]
  }

  measure: count_users_has_raf_send_clicked {
    group_label: "Measures"
    label: "# Users Sent RAF"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [has_raf_send_clicked: "yes"]
  }

  measure: count_users_is_first_raf_sent {
    group_label: "Measures"
    label: "# Users is first RAF Sent"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_first_raf_sent: "yes"]
  }
  measure: count_all_users {
    group_label: "Measures"
    label: "# Users"
    type: count_distinct
    sql: ${anonymous_id};;
  }



  # measure: number_of_all_zero_search_results {
  #   group_label: "Search Measures"
  #   label: "# No Results Searches"
  #   description: "Total number of searches which returned 0 results"
  #   type: sum
  #   hidden: no
  #   sql: if(${dim_number_of_available_results}= 0, 1, 0) ;;
  # }



  #### Rates ####

  # measure: ctr {
  #   group_label: "Rates (%)"
  #   label: "Click-Through Rate (CTR)"
  #   type: number
  #   description: "# searches with either PDP or Add-to-Cart / # total searches"
  #   value_format_name: percent_2
  #   sql: (${number_of_pdp_after_search} + ${number_of_add_to_cart_after_search}) / nullif(${number_of_all_searches},0);;
  # }


}
