# Owner: Galina Larina, Patricia Mitterova
# Created: 2023-03-01

# This view contains classification of each order based on a set of rules. It is used to understand what jobs customers are using Flink for.

view: user_attributes_order_classification {
  sql_table_name: `flink-data-prod.curated.user_attributes_order_classification`;;
  view_label: "JTBD Order Classification"


# ====================      Sets      ====================


  set: order_classifications {
    fields: [
      is_jtbd_breakfast_order,
      is_jtbd_lunch_order,
      is_jtbd_party_time_order,
      is_jtbd_late_night_snack_order,
      is_jtbd_non_food_household_order,
      is_jtbd_food_household_order,
      is_jtbd_emergency_order,
      is_jtbd_vegetarian_order,
      is_jtbd_baby_order,
      is_jtbd_pet_order
    ]
  }

  set: jtbd_orders {
    fields: [
      nb_jtbd_breakfast_orders,
      nb_jtbd_lunch_orders,
      nb_jtbd_party_time_orders,
      nb_jtbd_late_night_snack_orders,
      nb_jtbd_food_household_orders,
      nb_jtbd_non_food_household_orders,
      nb_jtbd_emergency_orders,
      nb_jtbd_vegetarian_orders,
      nb_jtbd_baby_orders,
      nb_jtbd_pet_orders
    ]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #


  dimension: order_uuid {
    type: string
    description: "Unique identifier generated by back-end when an order is placed. It consists of a 'country_iso' prefix and the actual 'order_id'.
    This field appears within product data under \"event_order_placed\" and \"daily_user_aggregates\" models as well as back-end based data models such as \"orders\" and \"order_lineitems\"."
    primary_key: yes
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: order_classification {
    type: string
    group_label: "* Order Dimensions *"
    label: "Order Classification - Job to be Done"
    description: "Order classification based upon customer use cases of Flink (Breakfast, Part time, etc.). Currently, classification is based on a set of rules"
    sql: ${TABLE}.order_classification ;;
  }

  dimension: is_jtbd_breakfast_order {
    group_label: "* Order Dimensions *"
    label: "Is JTBD Breakfast Order"
    description: "TRUE if an order was classified as breakfast (based on JobsToBeDone framework)."
    type: yesno
    sql: ${TABLE}.is_breakfast_order ;;
  }

  measure: nb_jtbd_breakfast_orders {
    group_label: "* Jobs To Be Done Classification *"
    label: "# Breakfast Orders"
    description: "Number of breakfast orders, classified according to JobsToBeDone framework."
    type: count_distinct
    sql: case when ${TABLE}.is_breakfast_order = true then ${order_uuid} end;;
    value_format: "0"
  }

  measure: nb_jtbd_lunch_orders {
    group_label: "* Jobs To Be Done Classification *"
    description: "Number of lunch orders, classified according to JobsToBeDone framework."
    label: "# Lunch Orders"
    type: count_distinct
    sql: case when ${TABLE}.is_lunch_order = true then ${order_uuid} end;;
    value_format: "0"
  }

  measure: nb_jtbd_party_time_orders {
    group_label: "* Jobs To Be Done Classification *"
    description: "Number of party orders, classified according to JobsToBeDone framework."
    label: "# Party Time Orders"
    type: count_distinct
    sql: case when ${TABLE}.is_party_time_order = true then ${order_uuid} end;;
    value_format: "0"
  }

  measure: nb_jtbd_late_night_snack_orders {
    group_label: "* Jobs To Be Done Classification *"
    description: "Number of late night snack orders, classified according to JobsToBeDone framework."
    label: "# Late Night Snack Orders"
    type: count_distinct
    sql: case when ${TABLE}.is_late_night_snack_order = true then ${order_uuid} end;;
    value_format: "0"
  }

  measure: nb_jtbd_food_household_orders {
    group_label: "* Jobs To Be Done Classification *"
    description: "Number of food household orders, classified according to JobsToBeDone framework."
    label: "# Food Household Orders"
    type: count_distinct
    sql: case when ${TABLE}.is_food_household_order = true then ${order_uuid} end;;
    value_format: "0"
  }

  measure: nb_jtbd_non_food_household_orders {
    group_label: "* Jobs To Be Done Classification *"
    description: "Number of non-food household orders, classified according to JobsToBeDone framework."
    label: "# Non-Food Household Orders"
    type: count_distinct
    sql: case when ${TABLE}.is_non_food_household_order = true then ${order_uuid} end;;
    value_format: "0"
  }

  measure: nb_jtbd_emergency_orders {
    group_label: "* Jobs To Be Done Classification *"
    description: "Number of emergency orders, classified according to JobsToBeDone framework."
    label: "# Emergency Orders"
    type: count_distinct
    sql: case when ${TABLE}.is_emergency_order = true then ${order_uuid} end;;
    value_format: "0"
  }

  measure: nb_jtbd_vegetarian_orders {
    group_label: "* Jobs To Be Done Classification *"
    description: "Number of vegetarian orders, classified according to JobsToBeDone framework."
    label: "# Vegetarian Orders"
    type: count_distinct
    sql: case when ${TABLE}.is_vegetariant_order = true then ${order_uuid} end;;
    value_format: "0"
  }

  measure: nb_jtbd_baby_orders {
    group_label: "* Jobs To Be Done Classification *"
    description: "Number of baby orders, classified according to JobsToBeDone framework."
    label: "# Baby Orders"
    type: count_distinct
    sql: case when ${TABLE}.is_baby_order = true then ${order_uuid} end;;
    value_format: "0"
  }

  measure: nb_jtbd_pet_orders {
    group_label: "* Jobs To Be Done Classification *"
    description: "Number of pet orders, classified according to JobsToBeDone framework."
    label: "# Pet Orders"
    type: count_distinct
    sql: case when ${TABLE}.is_pet_order = true then ${order_uuid} end;;
    value_format: "0"
  }


  dimension: is_jtbd_lunch_order {
    group_label: "* Order Dimensions *"
    label: "Is JTBD Lunch Order"
    description: "TRUE if an order was classified as lunch (based on JobsToBeDone framework)."
    type: yesno
    sql: ${TABLE}.is_lunch_order ;;
  }

  dimension: is_jtbd_party_time_order {
    group_label: "* Order Dimensions *"
    label: "Is JTBD Party Order"
    description: "TRUE if an order was classified as party (based on JobsToBeDone framework)."
    type: yesno
    sql: ${TABLE}.is_party_time_order ;;
  }

  dimension: is_jtbd_late_night_snack_order {
    group_label: "* Order Dimensions *"
    label: "Is JTBD Late Night Snack Order"
    description: "TRUE if an order was classified as laste night snack (based on JobsToBeDone framework)."
    type: yesno
    sql: ${TABLE}.is_late_night_snack_order ;;
  }

  dimension: is_jtbd_non_food_household_order {
    group_label: "* Order Dimensions *"
    label: "Is JTBD Non-Food Household Order"
    description: "TRUE if an order was classified as non-food household (based on JobsToBeDone framework)."
    type: yesno
    sql: ${TABLE}.is_non_food_household_order ;;
  }

  dimension: is_jtbd_food_household_order {
    group_label: "* Order Dimensions *"
    label: "Is JTBD Food Household Order"
    description: "TRUE if an order was classified as food household (based on JobsToBeDone framework)."
    type: yesno
    sql: ${TABLE}.is_food_household_order ;;
  }

  dimension: is_jtbd_emergency_order {
    group_label: "* Order Dimensions *"
    label: "Is JTBD Emergency Order"
    description: "TRUE if an order was classified as emergency (based on JobsToBeDone framework)."
    type: yesno
    sql: ${TABLE}.is_emergency_order ;;
  }

  dimension: is_jtbd_vegetarian_order {
    group_label: "* Order Dimensions *"
    label: "Is JTBD Vegetarian Order"
    description: "TRUE if an order was classified as vegetarian (based on JobsToBeDone framework)."
    type: yesno
    sql: ${TABLE}.is_vegetarian_order ;;
  }

  dimension: is_jtbd_baby_order {
    group_label: "* Order Dimensions *"
    label: "Is JTBD Baby Order"
    description: "TRUE if an order was classified as baby (based on JobsToBeDone framework)."
    type: yesno
    sql: ${TABLE}.is_baby_order ;;
  }

  dimension: is_jtbd_pet_order {
    group_label: "* Order Dimensions *"
    label: "Is JTBD Pet Order"
    description: "TRUE if an order was classified as pet (based on JobsToBeDone framework)."
    type: yesno
    sql: ${TABLE}.is_pet_order ;;
  }

 # ======= Dates / Timestamps ======= #
  dimension_group: order_timestamp {
    label: "Order Timestamp"
    description: "Timestamp of when an order was placed"
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      hour_of_day,
      quarter
    ]
    sql: ${TABLE}.order_timestamp ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Measures    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  measure: orders {
    label: "# Orders"
    description: "Number of placed orders"
    type: count_distinct
    sql: ${TABLE}.order_uuid ;;
  }

}
