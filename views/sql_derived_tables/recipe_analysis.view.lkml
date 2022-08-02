view: recipe_analysis {
  sql_table_name: `flink-data-dev.dbt_nwierzbowska.user_recipe_journey_aggregates`
      ;;


  ######## Dates ########

  dimension_group: event_date_at {
    group_label: "Date Dimensions"
    label: ""
    type: time
    datatype: date
    timeframes: [
      day_of_week,
      date,
      week,
      month
    ]
    sql: ${TABLE}.visit_date ;;
  }
  dimension: event_date_granularity {
    group_label: "Date Dimensions"
    label: "Event Date (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    # hidden:  yes
    sql:
      {% if timeframe_picker._parameter_value == 'Day' %}
        ${event_date_at_date}
      {% elsif timeframe_picker._parameter_value == 'Week' %}
        ${event_date_at_week}
      {% elsif timeframe_picker._parameter_value == 'Month' %}
        ${event_date_at_month}
      {% endif %};;
  }

  parameter: timeframe_picker {
    group_label: "Date Dimensions"
    label: "Event Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  dimension: anonymous_id {
    hidden: yes
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }


  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension: device_category {
    type: string
    description: "Device is either web for desktop based users or mobile for ios or android users."
    sql: ${TABLE}.device_category ;;
  }

  dimension: utm_source {
    type: string
    sql: ${TABLE}.utm_source ;;
  }

  dimension: utm_medium {
    type: string
    sql: ${TABLE}.utm_medium ;;
  }

  dimension: utm_campaign {
    type: string
    sql: ${TABLE}.utm_campaign ;;
  }

  dimension: recipe_name {
    type: string
    sql: ${TABLE}.recipe_name ;;
  }

  dimension: recipe_id {
    type: string
    sql: ${TABLE}.recipe_id ;;
  }

  dimension: recipe_page_visited {
    type: yesno
    sql: ${TABLE}.recipe_page_visited ;;
  }

  dimension: is_bounce {
    type: yesno
    sql: ${TABLE}.is_bounce ;;
  }

  dimension: is_user_logged_in {
    type: yesno
    sql: ${TABLE}.is_user_logged_in ;;
  }

  dimension: is_active_user {
    type: yesno
    sql: ${TABLE}.is_active_user ;;
  }

  dimension: address_confirmed {
    type: yesno
    sql: ${TABLE}.address_confirmed ;;
  }

  dimension: address_existing_confirmed {
    type: yesno
    sql: ${TABLE}.address_existing_confirmed ;;
  }

  dimension: address_search_viewed {
    type: yesno
    sql: ${TABLE}.address_search_viewed ;;
  }

  # Dimensions for recipe interactions

  dimension: num_of_unique_visits {
    type: number
    sql: ${TABLE}.num_of_unique_visits ;;
  }

  dimension: entered_webshop_cart_cta_click {
    type: yesno
    sql: ${TABLE}.entered_webshop_cart_cta_click ;;
  }

  dimension: recipe_recommendation_click {
    type: yesno
    sql: ${TABLE}.recipe_recommendation_click ;;
  }

  dimension: product_recommendation_click {
    type: yesno
    sql: ${TABLE}.product_recommendation_click ;;
  }

  dimension: recipe_details_click {
    type: yesno
    sql: ${TABLE}.recipe_details_click ;;
  }

  dimension: order_ingredients_click {
    type: yesno
    sql: ${TABLE}.order_ingredients_click ;;
  }

  dimension: address_book_modal_viewed {
    type: yesno
    sql: ${TABLE}.address_book_modal_viewed ;;
  }

  dimension: visited_webshop {
    type: yesno
    sql: ${TABLE}.visited_webshop ;;
  }

  dimension: product_added_to_cart {
    type: yesno
    sql: ${TABLE}.product_added_to_cart ;;
  }

  dimension: cart_viewed {
    type: yesno
    sql: ${TABLE}.cart_viewed ;;
  }

  dimension: checkout_started {
    type: yesno
    sql: ${TABLE}.checkout_started ;;
  }

  dimension: checkout_started_on_recipes {
    type: yesno
    sql: ${TABLE}.checkout_started_on_recipes ;;
  }

  dimension: cart_viewed_on_recipes {
    type: yesno
    sql: ${TABLE}.cart_viewed_on_recipes ;;
  }

  dimension: product_added_to_cart_on_recipes {
    type: yesno
    sql: ${TABLE}.product_added_to_cart_on_recipes ;;
  }

  dimension: order_completed {
    type: yesno
    sql: ${TABLE}.order_completed ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: user_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
  }

  measure: recipe_page_visited_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [recipe_page_visited: "yes"]
  }

  measure: is_bounce_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_bounce: "yes"]
  }

  measure: order_ingredients_click_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [order_ingredients_click: "yes"]
  }

  measure: entered_webshop_cart_cta_click_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [entered_webshop_cart_cta_click: "yes"]
  }

  measure: recipe_recommendation_click_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [recipe_recommendation_click: "yes"]
  }

  measure: product_recommendation_click_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [product_recommendation_click: "yes"]
  }

  measure: recipe_details_click_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [recipe_details_click: "yes"]
  }

  measure: address_book_modal_viewed_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [address_book_modal_viewed: "yes"]
  }

  measure: address_search_viewed_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [address_search_viewed: "yes"]
  }

  measure: address_confirmed_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [address_confirmed: "yes"]
  }

  measure: address_existing_confirmed_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [address_existing_confirmed: "yes"]
  }

  measure: visited_webshop_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [visited_webshop: "yes"]
  }

  measure: product_added_to_cart_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [product_added_to_cart: "yes"]
  }

  measure: product_added_to_cart_on_recipes_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [product_added_to_cart_on_recipes: "yes"]
  }


  measure: cart_viewed_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [cart_viewed: "yes"]
  }

  measure: cart_viewed_on_recipes_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [cart_viewed_on_recipes: "yes"]
  }

  measure: checkout_started_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [checkout_started: "yes"]
  }

  measure: checkout_started_on_recipes_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [checkout_started_on_recipes: "yes"]
  }

  measure: order_completed_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [order_completed: "yes"]
  }




}
