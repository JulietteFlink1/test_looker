view: testing__products_hub_assignment {
  sql_table_name: `flink-data-staging.curated.products_hub_assignment`
    ;;

  dimension: changing_status_session {
    label: "# of status changes"
    type: number
    sql: ${TABLE}.changing_status_session ;;
    hidden: yes
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
    sql: ${TABLE}.createdAt ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_most_recent_record {
    label: "Is most recent status"
    type: yesno
    sql: ${TABLE}.is_most_recent_record ;;
  }

  dimension: is_sku_assigned_to_hub {
    label: "Is SKU assigned to Hub"
    type: yesno
    sql: ${TABLE}.is_sku_assigned_to_hub ;;
  }

  dimension: max_num_status_changes {
    label: "# of status changes"
    description: "How often did the status changed from listed to de-listed (or unpublished) for a specific SKU"
    type: number
    sql: ${TABLE}.max_num_status_changes ;;
  }

  dimension: products_assignment_uuid {
    type: string
    sql: ${TABLE}.products_assignment_uuid ;;
    hidden: yes
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
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
    drill_fields: []
  }
}
