view: inventory {
  view_label: "* Inventory Data *"
  sql_table_name: `flink-data-prod.curated.inventory_ct`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_most_recent_record {
    type: yesno
    sql: ${TABLE}.is_most_recent_record ;;
  }

  dimension: is_oos {
    type: yesno
    sql: ${TABLE}.is_oos ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: last_modified {
    type: time
    timeframes: [
      raw,
      time,
      time_of_day,
      minute,
      hour,
      day_of_week,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_modified_at ;;
    label: "Inventory Status"
  }

  dimension: shelf_number {
    type: string
    sql: ${TABLE}.shelf_number ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }


  # =========  hidden   =========


  # =========  IDs   =========
  dimension: unique_key {
    sql: concat(${TABLE}.inventory_id, CAST(${TABLE}.last_modified_at as string)) ;;
    primary_key: yes
    group_label: "> IDs"
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
    group_label: "> IDs"
  }

  dimension: inventory_id {
    type: string
    sql: ${TABLE}.inventory_id ;;
    group_label: "> IDs"
  }

  # =========  Admin Data   =========
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
    group_label: "> Admin Data"
  }

  dimension: number_of_items_reserved {
    # currently this field is always empty
    # is was a repeated field
    # once knowing, how the actual data looks like, this field needs to be modified (esp. in the dbt-model)
    type: number
    sql: ${TABLE}.number_of_items_reserved ;;
    group_label: "> Admin Data"
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: available_quantity {
    type: average
    sql: ${TABLE}.available_quantity ;;
  }

  measure: number_of_reservations {
    type: average
    sql: ${TABLE}.number_of_reservations ;;
  }

  measure: quantity_on_stock {
    type: average
    sql: ${TABLE}.quantity_on_stock ;;
  }


  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
