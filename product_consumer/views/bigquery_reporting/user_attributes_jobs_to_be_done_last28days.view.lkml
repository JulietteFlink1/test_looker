view: user_attributes_jobs_to_be_done_last28days {
  sql_table_name: `flink-data-prod.reporting.user_attributes_jobs_to_be_done_last28days`
    ;;

  dimension: customer_date_primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${customer_uuid}, ${TABLE}.execution_date) ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: customer_uuid {
    type: string
    hidden: yes
    sql: ${TABLE}.customer_uuid ;;
  }

  dimension: days_since_last_breakfast_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_breakfast_order_last28days ;;
  }

  dimension: days_since_last_lunch_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_lunch_order_last28days ;;
  }

  dimension: days_since_last_emergency_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_emergency_order_last28days ;;
  }

  dimension: days_since_last_food_household_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_food_household_order_last28days ;;
  }

  dimension: days_since_last_non_food_household_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_non_last_food_household_order_last28days ;;
  }

  dimension: days_since_last_late_night_snack_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_late_night_snack_order_last28days ;;
  }

  dimension: days_since_last_party_time_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_party_time_order_last28days ;;
  }

  dimension: days_since_last_vegetarian_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_vegetarian_order_last28days ;;
  }

  dimension: days_since_last_baby_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_baby_order_last28days ;;
  }

  dimension: days_since_last_pet_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_pet_order_last28days ;;
  }


  dimension: number_of_breakfast_orders {
    type: number
    label: "Number of Breakfast Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_breakfast_orders_last28days ;;
  }

  dimension: number_of_lunch_orders {
    type: number
    label: "Number of Lunch Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_lunch_orders_last28days ;;
  }

  dimension: number_of_emergency_orders {
    type: number
    label: "Number of Emergency Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_emergency_orders_last28days ;;
  }

  dimension: number_of_non_food_household_orders {
    type: number
    label: "Number of Non-Food Household Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_non_food_household_orders_last28days ;;
  }

  dimension: number_of_food_household_orders {
    type: number
    label: "Number of Food Household Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_food_household_orders_last28days ;;
  }

  dimension: number_of_late_night_snack_orders {
    type: number
    label: "Number of Late Night Snack Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_late_night_snack_orders_last28days ;;
  }

  dimension: number_of_party_time_orders {
    type: number
    label: "Number of Party Time Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_party_time_orders_last28days  ;;
  }

  dimension: number_of_vegetarian_orders {
    type: number
    label: "Number of vegetarian Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_vegetarian_orders_last28days ;;
  }

  dimension: number_of_baby_orders {
    type: number
    label: "Number of Baby Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_baby_orders_last28days ;;
  }

  dimension: number_of_pet_orders {
    type: number
    label: "Number of Pet Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_pet_orders_last28days ;;
  }

  dimension: number_of_orders {
    type: number
    label: "Number of Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_orders_last28days ;;
  }

  dimension_group: execution {
    type: time
    hidden:  no
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: (${TABLE}.execution_date) ;;
  }

### Booleans

  dimension: has_breakfast_orders {
    type: yesno
    label: "Has Breakfast Orders"
    group_label: "User Activity"
    description: "Yes if the user has breakfast orders in the past 28 days"
    sql: CASE WHEN ${number_of_breakfast_orders} > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_lunch_orders {
    type: yesno
    label: "Has Lunch Orders"
    group_label: "User Activity"
    description: "Yes if the user has lunch orders in the past 28 days"
    sql: CASE WHEN ${number_of_lunch_orders} > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_emergency_orders {
    type: yesno
    label: "Has Emergency Orders"
    group_label: "User Activity"
    description: "Yes if the user has emergency orders in the past 28 days"
    sql: CASE WHEN ${number_of_emergency_orders} > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_non_food_household_orders {
    type: yesno
    label: "Has Non-Food Household Orders"
    group_label: "User Activity"
    description: "Yes if the user has non-food household orders in the past 28 days"
    sql: CASE WHEN ${number_of_non_food_household_orders} > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_food_household_orders {
    type: yesno
    label: "Has Food Household Orders"
    group_label: "User Activity"
    description: "Yes if the user has food household orders in the past 28 days"
    sql: CASE WHEN ${number_of_food_household_orders} > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_late_night_snack_orders {
    type: yesno
    label: "Has Late Night Snack Orders"
    group_label: "User Activity"
    description: "Yes if the user has last night snack orders orders in the past 28 days"
    sql: CASE WHEN ${number_of_late_night_snack_orders} > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_party_time_orders {
    type: yesno
    label: "Has Party Time Orders"
    group_label: "User Activity"
    description: "Yes if the user has party time orders in the past 28 days"
    sql: CASE WHEN ${number_of_party_time_orders} > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_vegetarian_orders {
    type: yesno
    label: "Has Vegetarian Orders"
    group_label: "User Activity"
    description: "Yes if the user has vegetarian orders in the past 28 days"
    sql: CASE WHEN ${number_of_vegetarian_orders} > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_baby_order {
    type: yesno
    label: "Has Baby Orders"
    group_label: "User Activity"
    description: "Yes if the user has baby orders in the past 28 days"
    sql: CASE WHEN ${number_of_baby_orders} > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_pet_orders {
    type: yesno
    label: "Has Pet Orders"
    group_label: "User Activity"
    description: "Yes if the user has pet orders in the past 28 days"
    sql: CASE WHEN ${number_of_party_time_orders} > 0 THEN TRUE
      ELSE FALSE END ;;
  }


### Measures

  measure: users {
    group_label: "Counts (#)"
    label: "# Unique Users"
    description: "Number of unique users"
    type: count_distinct
    sql: ${customer_uuid} ;;
  }

  measure: total_orders {
    group_label: "Counts (#)"
    label: "# Total Orders"
    type: sum
    description: "Number of orders"
    sql: ${number_of_orders};;
  }

  measure: breakfast_orders {
    group_label: "Counts (#)"
    label: "# Breakfast Orders"
    type: sum
    description: "Number of breakfast orders"
    sql: ${number_of_breakfast_orders};;
  }

  measure: lunch_orders {
    group_label: "Counts (#)"
    label: "# Lunch Orders"
    type: sum
    description: "Number of lunch orders"
    sql: ${number_of_lunch_orders};;
  }

  measure: party_orders {
    group_label: "Counts (#)"
    label: "# Party Orders"
    type: sum
    description: "Number of party orders"
    sql: ${number_of_party_time_orders} ;;
  }

  measure: emergency_orders {
    group_label: "Counts (#)"
    label: "# Emergency Orders"
    type: sum
    description: "Number of emergency orders"
    sql: ${number_of_emergency_orders};;
  }

  measure: late_night_snack_orders {
    group_label: "Counts (#)"
    label: "# Late night snack orders"
    type: sum
    description: "Number of late night snack orders"
    sql: ${number_of_late_night_snack_orders};;
  }

  measure: non_food_household_orders {
    group_label: "Counts (#)"
    label: "# Non-Food Household Orders"
    type: sum
    description: "Number of non-food household orders"
    sql: ${number_of_non_food_household_orders};;
  }

  measure: food_household_orders {
    group_label: "Counts (#)"
    label: "# Food Household Orders"
    type: sum
    description: "Number of food household orders"
    sql: ${number_of_food_household_orders};;
  }

  measure: vegetarian_orders {
    group_label: "Counts (#)"
    label: "# Lunch Orders"
    type: sum
    description: "Number of vegetarian orders"
    sql: ${number_of_vegetarian_orders};;
  }

  measure: baby_orders {
    group_label: "Counts (#)"
    label: "# Baby Orders"
    type: sum
    description: "Number of baby orders"
    sql: ${number_of_baby_orders};;
  }
  measure: pet_orders {
    group_label: "Counts (#)"
    label: "# Pet Orders"
    type: sum
    description: "Number of pet orders"
    sql: ${number_of_pet_orders};;
  }


  #### RATES ####

  measure: breakfast_order_rate {
    group_label: "Shares (%)"
    label: "Breakfast Order Rate"
    type: number
    description: "Number of breakfast orders, over total orders"
    value_format_name: percent_1
    sql: ${breakfast_orders} / nullif(${total_orders},0);;
  }

  measure: lunch_rate {
    group_label: "Shares (%)"
    label: "Lunch Order Rate"
    type: number
    description: "Number of lunch orders, over total orders"
    value_format_name: percent_1
    sql: ${lunch_orders} / nullif(${total_orders},0);;
  }

  measure: party_order_rate {
    group_label: "Shares (%)"
    label: "Party Order Rate"
    type: number
    description: "Number of party orders, over total orders"
    value_format_name: percent_1
    sql: ${party_orders} / nullif(${total_orders},0);;
  }

  measure: emergency_order_rate {
    group_label: "Shares (%)"
    label: "Emergency Order Rate"
    type: number
    description: "Number of emergency orders, over total orders"
    value_format_name: percent_1
    sql: ${party_orders} / nullif(${total_orders},0);;
  }

  measure: late_night_snack_order_rate {
    group_label: "Shares (%)"
    label: "Late Night Order Rate"
    type: number
    description: "Number of late night snack orders, over total orders"
    value_format_name: percent_1
    sql: ${late_night_snack_orders} / nullif(${total_orders},0);;
  }

  measure: non_food_household_rate {
    group_label: "Shares (%)"
    label: "Non-Food Household Order Rate"
    type: number
    description: "Number of non-food household orders, over total orders"
    value_format_name: percent_1
    sql: ${non_food_household_orders} / nullif(${total_orders},0);;
  }

  measure: food_household_rate {
    group_label: "Shares (%)"
    label: "Food Household Order Rate"
    type: number
    description: "Number of food household orders, over total orders"
    value_format_name: percent_1
    sql: ${food_household_orders} / nullif(${total_orders},0);;
  }

  measure: vegetarian_rate {
    group_label: "Shares (%)"
    label: "Vegetarian Order Rate"
    type: number
    description: "Number of vegetarian orders, over total orders"
    value_format_name: percent_1
    sql: ${vegetarian_orders} / nullif(${total_orders},0);;
  }

  measure: baby_rate {
    group_label: "Shares (%)"
    label: "Baby Order Rate"
    type: number
    description: "Number of baby orders, over total orders"
    value_format_name: percent_1
    sql: ${baby_orders} / nullif(${total_orders},0);;
  }

  measure: pet_rate {
    group_label: "Shares (%)"
    label: "Pet Order Rate"
    type: number
    description: "Number of pet orders, over total orders"
    value_format_name: percent_1
    sql: ${pet_orders} / nullif(${total_orders},0);;
  }
}
