view: hub_fleet_date_grid {
  sql_table_name: `flink-data-dev.dbt_omar.hub_fleet_date_grid`
    ;;

  dimension_group: account_creation {
    type: time
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
    sql: ${TABLE}.account_creation_date ;;
  }

  dimension_group: employment_ends {
    type: time
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
    sql: ${TABLE}.employment_ends_date ;;
  }

  dimension_group: employment_starts {
    type: time
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
    sql: ${TABLE}.employment_starts_date ;;
  }

  dimension_group: shift {
    type: time
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
    sql: ${TABLE}.shift_date ;;
  }

  dimension: staff_number {
    type: number
    sql: ${TABLE}.staff_number ;;
  }

  dimension: employment_id {
    type: number
    sql: ${TABLE}.employment_id ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: position_name {
    type: string
    sql: ${TABLE}.position_name ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
