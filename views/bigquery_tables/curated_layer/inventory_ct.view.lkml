view: inventory_ct {
  view_label: "* Inventory Data *"
  sql_table_name: `flink-data-prod.curated.inventory_ct`
    ;;

  dimension: unique_key {
    sql: concat(${TABLE}.inventory_id, CAST(${TABLE}.last_modified_at as string)) ;;
  }

  dimension: available_quantity {
    type: number
    sql: ${TABLE}.available_quantity ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
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

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: inventory_id {
    type: string
    sql: ${TABLE}.inventory_id ;;
  }

  dimension: is_most_recent_record {
    type: yesno
    sql: ${TABLE}.is_most_recent_record ;;
  }

  dimension: is_oos {
    type: yesno
    sql: ${TABLE}.is_oos ;;
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

  dimension: number_of_items_reserved {
    type: number
    sql: ${TABLE}.number_of_items_reserved ;;
  }

  dimension: number_of_reservations {
    type: string
    sql: ${TABLE}.number_of_reservations ;;
  }

  dimension: quantity_on_stock {
    type: number
    sql: ${TABLE}.quantity_on_stock ;;
  }

  dimension: shelf_number {
    type: string
    sql: ${TABLE}.shelf_number ;;
  }

  dimension: sku {
    type: number
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
