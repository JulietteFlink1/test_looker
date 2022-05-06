view: user_attributes_jobs_to_be_done {
sql_table_name: `flink-data-prod.reporting.user_attributes_jobs_to_be_done`
  ;;

dimension: customer_date_primary_key {
  primary_key: yes
  hidden: yes
  sql: CONCAT(${customer_uuid}, ${TABLE}.partition_date) ;;
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

dimension: number_of_breakfast_orders_last_twelve_weeks {
  type: number
  label: "Number of Breakfast Orders Last 12 Weeks"
  group_label: "User Activity - Last 12 Weeks"
  sql: ${TABLE}.number_of_breakfast_orders_last_twelve_weeks ;;
}

dimension: number_of_emergency_orders_last_twelve_weeks {
  type: number
  label: "Number of Emergency Orders Last 12 Weeks"
  group_label: "User Activity - Last 12 Weeks"
  sql: ${TABLE}.number_of_emergency_orders_last_twelve_weeks ;;
}

dimension: number_of_household_shopping_orders_last_twelve_weeks {
  type: number
  label: "Number of Household Orders Last 12 Weeks"
  group_label: "User Activity - Last 12 Weeks"
  sql: ${TABLE}.number_of_household_shopping_orders_last_twelve_weeks ;;
}

dimension: number_of_late_night_snack_orders_last_twelve_weeks {
  type: number
  label: "Number of Late Night Snack Orders Last 12 Weeks"
  group_label: "User Activity - Last 12 Weeks"
  sql: ${TABLE}.number_of_late_night_snack_orders_last_twelve_weeks ;;
}

dimension: number_of_orders {
  type: number
  label: "Number of Orders Last 12 Weeks"
  group_label: "User Activity - Last 12 Weeks"
  sql: ${TABLE}.number_of_orders ;;
}

dimension: number_of_party_time_orders_last_twelve_weeks {
  type: number
  label: "Number of Party Time Orders Last 12 Weeks"
  group_label: "User Activity - Last 12 Weeks"
  sql: ${TABLE}.number_of_party_time_orders_last_twelve_weeks ;;
}

dimension_group: partition {
  type: time
  hidden:  yes
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
  sql: ${TABLE}.partition_date ;;
}

### Booleans

dimension: has_breakfast_orders {
  type: yesno
  label: "Has Breakfast Orders"
  group_label: "User Activity - Last 12 Weeks"
  sql: CASE WHEN ${TABLE}.number_of_breakfast_orders_last_twelve_weeks > 0 THEN TRUE
    ELSE FALSE END ;;
}

dimension: has_emergency_orders {
  type: yesno
  label: "Has Emergency Orders"
  group_label: "User Activity - Last 12 Weeks"
  sql: CASE WHEN ${TABLE}.number_of_emergency_orders_last_twelve_weeks > 0 THEN TRUE
    ELSE FALSE END ;;
}

dimension: has_household_shopping_orders {
  type: yesno
  label: "Has Household Shopping Orders"
  group_label: "User Activity - Last 12 Weeks"
  sql: CASE WHEN ${TABLE}.number_of_household_shopping_orders_last_twelve_weeks > 0 THEN TRUE
    ELSE FALSE END ;;
}

dimension: has_late_night_snack_orders {
  type: yesno
  label: "Has Late Night Snack Orders"
  group_label: "User Activity - Last 12 Weeks"
  sql: CASE WHEN ${TABLE}.number_of_late_night_snack_orders_last_twelve_weeks > 0 THEN TRUE
    ELSE FALSE END ;;
}

dimension: has_party_time_orders {
  type: yesno
  label: "Has Party Time Orders"
  group_label: "User Activity - Last 12 Weeks"
  sql: CASE WHEN ${TABLE}.number_of_party_time_orders_last_twelve_weeks > 0 THEN TRUE
    ELSE FALSE END ;;
}

### Measures

measure: count {
  type: count
  drill_fields: []
}

measure: users {
  group_label: "Counts (#) - Last 12 Weeks"
  label: "# Unique Users"
  description: "Number of unique users"
  type: count_distinct
  sql: ${customer_uuid} ;;
}

measure: total_orders {
  group_label: "Counts (#) - Last 12 Weeks"
  label: "# Total Orders"
  type: sum
  description: "Number of orders"
  sql: ${number_of_orders};;
}

measure: breakfast_orders {
  group_label: "Counts (#) - Last 12 Weeks"
  label: "# Breakfast Orders"
  type: sum
  description: "Number of breakfast orders"
  sql: ${number_of_breakfast_orders_last_twelve_weeks};;
}

measure: party_orders {
  group_label: "Counts (#) - Last 12 Weeks"
  label: "# Party Orders"
  type: sum
  description: "Number of party orders"
  sql: ${number_of_party_time_orders_last_twelve_weeks} ;;
}

measure: emergency_orders {
  group_label: "Counts (#) - Last 12 Weeks"
  label: "# Emergency Orders"
  type: sum
  description: "Number of emergency orders"
  sql: ${number_of_emergency_orders_last_twelve_weeks};;
}

measure: late_night_snack_orders {
  group_label: "Counts (#) - Last 12 Weeks"
  label: "# Late night snack orders"
  type: sum
  description: "Number of late night snack orders"
  sql: ${number_of_late_night_snack_orders_last_twelve_weeks};;
}

measure: household_orders {
  group_label: "Counts (#) - Last 12 Weeks"
  label: "# Household Orders"
  type: sum
  description: "Number of household orders"
  sql: ${number_of_household_shopping_orders_last_twelve_weeks};;
}

measure: unclassified_orders {
  group_label: "Counts (#) - Last 12 Weeks"
  label: "# Unclassified Orders"
  type: number
  description: "Number of household orders"
  sql: ${total_orders} - ${breakfast_orders} - ${party_orders} - ${emergency_orders} - ${late_night_snack_orders} - ${household_orders};;
}

measure: breakfast_order_rate {
  group_label: "Shares (%) - Last 12 Weeks"
  label: "Breakfast Order Rate"
  type: number
  description: "Number of breakfast orders, over total orders"
  value_format_name: percent_1
  sql: ${breakfast_orders} / nullif(${total_orders},0);;
}

measure: party_order_rate {
  group_label: "Shares (%) - Last 12 Weeks"
  label: "Party Order Rate"
  type: number
  description: "Number of party orders, over total orders"
  value_format_name: percent_1
  sql: ${party_orders} / nullif(${total_orders},0);;
}

measure: emergency_order_rate {
  group_label: "Shares (%) - Last 12 Weeks"
  label: "Emergency Order Rate"
  type: number
  description: "Number of emergency orders, over total orders"
  value_format_name: percent_1
  sql: ${party_orders} / nullif(${total_orders},0);;
}

measure: late_night_snack_order_rate {
  group_label: "Shares (%) - Last 12 Weeks"
  label: "Late Night Order Rate"
  type: number
  description: "Number of late night snack orders, over total orders"
  value_format_name: percent_1
  sql: ${late_night_snack_orders} / nullif(${total_orders},0);;
}

measure: household_rate {
  group_label: "Shares (%) - Last 12 Weeks"
  label: "Household Order Rate"
  type: number
  description: "Number of household shopping orders, over total orders"
  value_format_name: percent_1
  sql: ${household_orders} / nullif(${total_orders},0);;
}

measure: unclassified_rate {
  group_label: "Shares (%) - Last 12 Weeks"
  label: "Unclassified Order Rate"
  type: number
  description: "Number of unclassified orders, over total orders"
  value_format_name: percent_1
  sql: ${unclassified_orders} / nullif(${total_orders},0);;
}

}
