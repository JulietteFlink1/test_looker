view: order_placement_aggregates {

  sql_table_name: `flink-data-prod.reporting.order_placement_aggregates`
  ;;
  view_label: "Order Placement Aggregates"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# ======= Date Dimensions ======= #

  dimension_group: event {
    group_label: "Date Dimensions"
    label: "Event"
    description: "Date when an event happened"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter
    ]
    sql: ${TABLE}.event_date ;;
    datatype: date
  }

# ======= Device Dimensions ======= #

  dimension: platform {
    group_label: "Device Dimensions"
    description: "Platform of a device: app or web"
    type: string
    sql: ${TABLE}.platform ;;
  }
  dimension: app_version {
    group_label: "Device Dimensions"
    description: "Version of the app"
    type: string
    sql: ${TABLE}.app_version ;;
  }
  dimension: full_app_version {
    group_label: "Device Dimensions"
    description: "Concatenation of device_type and app_version"
    type: string
    sql: case when ${TABLE}.platform in ('ios','android') then (${TABLE}.platform || '-' || ${TABLE}.app_version ) end ;;
  }

# ======= Location Dimensions ======= #

  dimension: hub_code {
    group_label: "Location Dimensions"
    type: string
    sql: ${TABLE}.hub_code ;;
  }
  dimension: country_iso {
    group_label: "Location Dimensions"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

# ======= Hidden Dimensions ======= #

  dimension: order_placement_uuid {
    type: string
    sql: ${TABLE}.order_placement_uuid ;;
    hidden: yes
  }

# ======= BOOLEANS for order placement ======= #

  dimension: is_order_from_recommendation {
    group_label: "Placement Dimensions"
    description: "Where at least one item was added from m_recommendation."
    type: yesno
    sql: ${TABLE}.is_order_from_recommendation ;;
  }
  dimension: is_order_from_cart {
    group_label: "Placement Dimensions"
    description: "Where at least one item was added from cart."
    type: yesno
    sql: ${TABLE}.is_order_from_cart ;;
  }
  dimension: is_order_from_last_bought {
    group_label: "Placement Dimensions"
    description: "Where at least one item was added from last_bought."
    type: yesno
    sql: ${TABLE}.is_order_from_last_bought ;;
  }
  dimension: is_order_from_search {
    group_label: "Placement Dimensions"
    description: "Where at least one item was added from search."
    type: yesno
    sql: ${TABLE}.is_order_from_search ;;
  }
  dimension: is_order_from_category {
    group_label: "Placement Dimensions"
    description: "Where at least one item was added from category."
    type: yesno
    sql: ${TABLE}.is_order_from_category ;;
  }
  dimension: is_order_from_pdp {
    group_label: "Placement Dimensions"
    description: "Where at least one item was added from pdp."
    type: yesno
    sql: ${TABLE}.is_order_from_pdp ;;
  }
  dimension: is_order_from_favourites {
    group_label: "Placement Dimensions"
    description: "Where at least one item was added from favourites."
    type: yesno
    sql: ${TABLE}.is_order_from_favourites ;;
  }
  dimension: is_order_from_swimlane {
    group_label: "Placement Dimensions"
    description: "Where at least one item was added from swimlane."
    type: yesno
    sql: ${TABLE}.is_order_from_swimlane ;;
  }
  dimension: is_order_from_collection {
    group_label: "Placement Dimensions"
    description: "Where at least one item was added from collection."
    type: yesno
    sql: ${TABLE}.is_order_from_collection ;;
  }
  dimension: is_order_from_deep_link {
    group_label: "Placement Dimensions"
    description: "Where at least one item was added from deep_link."
    type: yesno
    sql: ${TABLE}.is_order_from_deep_link ;;
  }
  dimension: is_recommendation_on_cart {
    group_label: "Recommendation Placements"
    description: "Where at least one item was added from ion_on_cart."
    type: yesno
    sql: ${TABLE}.is_recommendation_on_cart ;;
  }
  dimension: is_recommendation_on_pdp {
    group_label: "Recommendation Placements"
    description: "Where at least one item was added from ion_on_pdp."
    type: yesno
    sql: ${TABLE}.is_recommendation_on_pdp ;;
  }
  dimension: is_recommendation_on_search {
    group_label: "Recommendation Placements"
    description: "Where at least one item was added from ion_on_search."
    type: yesno
    sql: ${TABLE}.is_recommendation_on_search ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Measures      ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: mes_order_placement_uuid {
    group_label: "Basic Counts"
    label: "Count"
    type: count_distinct
    sql: ${order_placement_uuid} ;;
  }
  measure: number_of_orders {
    group_label: "Basic Counts"
    label: "# Orders"
    type: sum
    sql: ${TABLE}.number_of_orders ;;
  }
  measure: number_of_users {
    group_label: "Basic Counts"
    label: "# Users"
    type: sum
    sql: ${TABLE}.number_of_users ;;
  }
  measure: amt_total_price_net {
    group_label: "Monetary Metrics"
    label: "SUM Total Item Price (net)"
    description: "Total value of all items (net) excluding fees. Calcuated as Unit Item Value * Quantity Purchased."
    type: sum
    value_format_name: decimal_2
    sql: ${TABLE}.amt_total_price_net ;;
  }
  measure: aiv {
    group_label: "Monetary Metrics"
    label: "AIV (net)"
    description: "Average Item Value (net) - excluding fees."
    type: number
    value_format_name: eur
    sql: ${amt_total_price_net} / ${number_of_orders} ;;
  }
}
