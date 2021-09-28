view: products_hub_assignment {
  sql_table_name: `flink-data-prod.curated.products_hub_assignment`
    ;;
  view_label: "* Product-Hub Assignment *"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: is_most_recent_record {
    type: yesno
    sql: ${TABLE}.is_most_recent_record ;;
  }

  dimension: is_sku_assigned_to_hub {
    type: yesno
    sql: ${TABLE}.is_sku_assigned_to_hub ;;
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

  dimension_group: valid_to {
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
    sql: ${TABLE}.valid_to ;;
  }


  # =========  hidden   =========

  dimension: products_assignment_uuid {
    type: string
    sql: ${TABLE}.products_assignment_uuid ;;
    hidden: yes
    primary_key: yes
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
    hidden: yes
  }

  dimension: current_status_change_count {
    type: number
    sql: ${TABLE}.current_status_change_count ;;
    hidden: yes
  }

  dimension: max_status_change_count {
    type: number
    sql: ${TABLE}.max_status_change_count ;;
    hidden: yes
  }


}
