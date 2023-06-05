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

  dimension: customer_id {
    type: string
    hidden: yes
    group_label: "Default Identifers"
    sql: ${TABLE}.customer_id ;;
  }

  dimension: customer_uuid {
    type: string
    hidden: yes
    sql: ${TABLE}.customer_uuid ;;
  }

  dimension: days_since_last_breakfast_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_breakfast_order ;;
  }

  dimension: days_since_last_emergency_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_emergency_order ;;
  }

  dimension: days_since_last_household_shopping_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_household_shopping_order ;;
  }

  dimension: days_since_last_late_night_snack_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_late_night_snack_order ;;
  }

  dimension: days_since_last_party_time_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_party_time_order ;;
  }

  dimension: days_since_last_lunch_order {
    type: number
    hidden:  yes
    sql: ${TABLE}.days_since_last_lunch_order ;;
  }

  dimension: number_of_breakfast_orders {
    type: number
    label: "Number of Breakfast Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_breakfast_orders ;;
  }

  dimension: number_of_emergency_orders {
    type: number
    label: "Number of Emergency Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_emergency_orders ;;
  }

  dimension: number_of_household_shopping_orders {
    type: number
    label: "Number of Household Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_household_shopping_orders ;;
  }

  dimension: number_of_late_night_snack_orders {
    type: number
    label: "Number of Late Night Snack Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_late_night_snack_orders ;;
  }

  dimension: number_of_lunch_orders {
    type: number
    label: "Number of Lunch Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_lunch_orders ;;
  }

  dimension: number_of_orders {
    type: number
    label: "Number of Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: number_of_party_time_orders {
    type: number
    label: "Number of Party Time Orders"
    group_label: "User Activity"
    sql: ${TABLE}.number_of_party_time_orders ;;
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
    sql: CASE WHEN ${TABLE}.number_of_breakfast_orders > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_emergency_orders {
    type: yesno
    label: "Has Emergency Orders"
    group_label: "User Activity"
    description: "Yes if the user has emergency orders in the past 28 days"
    sql: CASE WHEN ${TABLE}.number_of_emergency_orders > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_household_shopping_orders {
    type: yesno
    label: "Has Household Shopping Orders"
    group_label: "User Activity"
    description: "Yes if the user has household shopping orders in the past 28 days"
    sql: CASE WHEN ${TABLE}.number_of_household_shopping_orders > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_late_night_snack_orders {
    type: yesno
    label: "Has Late Night Snack Orders"
    group_label: "User Activity"
    description: "Yes if the user has last night snack orders orders in the past 28 days"
    sql: CASE WHEN ${TABLE}.number_of_late_night_snack_orders > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_party_time_orders {
    type: yesno
    label: "Has Party Time Orders"
    group_label: "User Activity"
    description: "Yes if the user has party time orders in the past 28 days"
    sql: CASE WHEN ${TABLE}.number_of_party_time_orders > 0 THEN TRUE
      ELSE FALSE END ;;
  }

  dimension: has_lunch_orders {
    type: yesno
    label: "Has Lunch Orders"
    group_label: "User Activity"
    description: "Yes if the user has lunch orders in the past 28 days"
    sql: CASE WHEN ${TABLE}.number_of_lunch_orders > 0 THEN TRUE
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

  measure: household_orders {
    group_label: "Counts (#)"
    label: "# Household Orders"
    type: sum
    description: "Number of household orders"
    sql: ${number_of_household_shopping_orders};;
  }

  measure: lunch_orders {
    group_label: "Counts (#)"
    label: "# Lunch Orders"
    type: sum
    description: "Number of lunch orders"
    sql: ${number_of_lunch_orders};;
  }

  measure: unclassified_orders {
    group_label: "Counts (#)"
    label: "# Unclassified Orders"
    type: number
    description: "Number of household orders"
    sql: ${total_orders} - ${breakfast_orders} - ${party_orders} - ${emergency_orders} - ${late_night_snack_orders}
      - ${household_orders} - ${lunch_orders};;
  }

  measure: breakfast_order_rate {
    group_label: "Shares (%)"
    label: "Breakfast Order Rate"
    type: number
    description: "Number of breakfast orders, over total orders"
    value_format_name: percent_1
    sql: ${breakfast_orders} / nullif(${total_orders},0);;
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

  measure: household_rate {
    group_label: "Shares (%)"
    label: "Household Order Rate"
    type: number
    description: "Number of household shopping orders, over total orders"
    value_format_name: percent_1
    sql: ${household_orders} / nullif(${total_orders},0);;
  }

  measure: lunch_rate {
    group_label: "Shares (%)"
    label: "Lunch Order Rate"
    type: number
    description: "Number of lunch orders, over total orders"
    value_format_name: percent_1
    sql: ${lunch_orders} / nullif(${total_orders},0);;
  }

  measure: unclassified_rate {
    group_label: "Shares (%)"
    label: "Unclassified Order Rate"
    type: number
    description: "Number of unclassified orders, over total orders"
    value_format_name: percent_1
    sql: ${unclassified_orders} / nullif(${total_orders},0);;
  }




}
