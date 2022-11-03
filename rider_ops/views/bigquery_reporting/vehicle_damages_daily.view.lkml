# This view comes from a table that joins damages to a date array so that
# each damage is associated to each day during which it was ongoing
# ->This allows to calculate the number of ongoing damages on any date

# owner: Victor Breda - created: 2022-09-29

view: vehicle_damages_daily {
  sql_table_name: `flink-data-prod.reporting.vehicle_damages_daily` ;;

  dimension_group: report {
    group_label: "> Dates"
    type: time
    timeframes: [
      date,
      week,
      month,
    ]
    sql: timestamp(${TABLE}.report_date) ;;
  }

  dimension: damage_uuid {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.damage_uuid ;;
  }

  dimension: country_iso {
    group_label: "> Geography"
    hidden: yes
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    group_label: "> Geography"
    hidden: yes
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: vehicle_id {
    group_label: "> Vehicle Properties"
    label: "Vehicle Id"
    description: "Unique identifier of a bike"
    hidden:  yes
    type: string
    sql: ${TABLE}.vehicle_id ;;
  }

  dimension: supplier_id {
    group_label: "> Supplier Properties"
    label: "Supplier Id"
    description: "Unique bike supplier identifier"
    hidden:  yes
    type: string
    sql: ${TABLE}.supplier_id ;;
  }

  # Measures

  measure: number_of_ongoing_damages {
    label: "# Ongoing Damages"
    description: "# Ongoing damages, excluding the ones of bikes that have been archived"
    type: count_distinct
    filters: [vehicle_uptime_metrics.expected_uptime_minutes: "not null"]
    sql: ${damage_uuid} ;;
  }
}
