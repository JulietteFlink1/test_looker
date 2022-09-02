view: vehicle_damages {
  sql_table_name: `flink-data-prod.curated.vehicle_damages`
    ;;

  dimension: country_iso {
    group_label: "> Geography"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: created_at {
    group_label: "> Dates"
    type: time
    timeframes: [
      date,
      week,
      month
    ]
    sql: ${TABLE}.created_at_timestamp ;;
  }

  dimension: damage_code {
    group_label: "> Damage Properties"
    description: "Identifier for the damage type, e.g. wheel, gear etc."
    type: string
    sql: ${TABLE}.damage_code ;;
  }

  dimension: damage_title {
    group_label: "> Damage Properties"
    description: "Manually entered damage title."
    type: string
    sql: ${TABLE}.damage_title ;;
  }

  dimension: damage_uuid {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.damage_uuid ;;
  }

  dimension_group: damaged_fixed_at {
    group_label: "> Dates"
    type: time
    timeframes: [
      date,
      week,
      month
    ]
    sql: ${TABLE}.damaged_fixed_at_timestamp ;;
  }

  dimension: description {
    group_label: "> Damage Properties"
    description: "Provides more information on the nature of the damage"
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: hub_code {
    group_label: "> Geography"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: number_of_damaged_days {
    group_label: "> Damage Properties"
    description: " Number of days between damage created and damage fixed."
    type: number
    sql: ${TABLE}.number_of_damaged_days ;;
  }

  dimension: status {
    group_label: "> Damage Properties"
    description: "Status of the damage. Possible values: fixed, reported, archived"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: supplier_id {
    hidden: yes
    type: string
    sql: ${TABLE}.supplier_id ;;
  }

  dimension: vehicle_id {
    hidden: yes
    type: string
    sql: ${TABLE}.vehicle_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
