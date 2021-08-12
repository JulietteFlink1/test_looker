view: inventory {
  view_label: "* Inventory Data *"
  sql_table_name: `flink-data-prod.curated.inventory`
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
    sql: ${TABLE}.partition_timestamp ;;
    label: "Inventory Update"
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
  dimension: inventory_uuid {
    sql: ${TABLE}.inventory_uuid ;;
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

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: quantity_available {
    type: average
    sql: ${TABLE}.quantity_available ;;
    label: "AVG Quantity Available"
  }

  measure: quantity_on_stock {
    type: average
    sql: ${TABLE}.quantity_on_stock ;;
    label: "AVG Quantity on Stock"
  }

  measure: quantity_reserved {
    type: average
    sql: ${TABLE}.quantity_reserved ;;
    label: "AVG Quantity Reserved"
  }


  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
