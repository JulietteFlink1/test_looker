# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: discounts {
  hidden: yes

  join: discounts__discount_group {
    view_label: "Discounts: Discount Group"
    sql: LEFT JOIN UNNEST(${discounts.discount_group}) as discounts__discount_group ;;
    relationship: one_to_many
  }
}

view: discounts {
  sql_table_name: `flink-data-prod.curated.discounts`
    ;;
  drill_fields: [discount_id]

  dimension: discount_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.discount_id ;;
  }

  dimension: cart_discount_id {
    type: string
    sql: ${TABLE}.cart_discount_id ;;
  }

  dimension: cart_discount_type {
    type: string
    sql: ${TABLE}.cart_discount_type ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: discount_code {
    type: string
    sql: ${TABLE}.discount_code ;;
  }

  dimension: discount_description {
    type: string
    sql: ${TABLE}.discount_description ;;
  }

  dimension: discount_group {
    hidden: yes
    sql: ${TABLE}.discount_group ;;
  }

  dimension: discount_name {
    type: string
    sql: ${TABLE}.discount_name ;;
  }

  dimension: discount_uuid {
    type: string
    sql: ${TABLE}.discount_uuid ;;
  }

  dimension: is_active {
    type: yesno
    sql: ${TABLE}.is_active ;;
  }

  dimension_group: last_modified {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_modified_at ;;
  }

  dimension: max_applications {
    type: number
    sql: ${TABLE}.max_applications ;;
  }

  dimension: max_applications_per_customer {
    type: number
    sql: ${TABLE}.max_applications_per_customer ;;
  }

  dimension_group: partition_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.partition_timestamp ;;
  }

  dimension_group: valid_from {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.valid_from ;;
  }

  dimension_group: valid_until {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.valid_until ;;
  }

  measure: count {
    type: count
    drill_fields: [discount_id, discount_name]
  }
}

view: discounts__discount_group {
  dimension: discounts__discount_group {
    type: string
    sql: discounts__discount_group ;;
  }
}
