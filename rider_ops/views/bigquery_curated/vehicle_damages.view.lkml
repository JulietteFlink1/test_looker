view: vehicle_damages {
  sql_table_name: `flink-data-prod.curated.vehicle_damages`
    ;;

  dimension: country_iso {
    group_label: "> Geography"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: damage_created {
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

  dimension_group: damaged_solved {
    group_label: "> Dates"
    type: time
    timeframes: [
      date,
      week,
      month
    ]
    sql: ${TABLE}.fixed_at_timestamp ;;
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

  ############ Measures

  measure: number_of_damages {
    group_label: "> Damage Statistics"
    label: " # Damages (Any Status)"
    description: "Number of Damages"
    type: count_distinct
    sql: ${damage_uuid} ;;
  }

  measure: number_of_bikes_with_damage {
    group_label: "> Damage Statistics"
    label: " # Bikes with Damage"
    description: "Number of Bikes with Damage"
    type: count_distinct
    sql: ${vehicle_id} ;;
  }

  measure: number_of_solved_damages {
    group_label: "> Damage Statistics"
    label: " # Solved Damages"
    description: "Number of Damages that are solved (status = fixed)"
    type: count_distinct
    sql: ${damage_uuid} ;;
    filters: [status: "fixed"]
  }

  measure: number_of_reported_damages {
    group_label: "> Damage Statistics"
    label: " # Reported Damages"
    description: "Number of Damages that are reported (status = reported)"
    type: count_distinct
    sql: ${damage_uuid} ;;
    filters: [status: "reported"]
  }

  measure: share_of_open_damages {
    group_label: "> Damage Statistics"
    label: " % Damages Reported "
    description: "# of Damages that have status reported (not fixed yet) / # Damages with any status (fixed and not fixed)"
    type: number
    sql: safe_divide(${number_of_reported_damages},${number_of_damages}) ;;
    value_format_name: percent_1
  }

  measure: avg_number_of_days_with_damage {
    group_label: "> Damage Statistics"
    label: " AVG Damage Duration (Days)"
    description: "AVG number of days between damage created date and damage fixed date. If the damage is not fixed number of days between damage created date and today."
    type: average
    value_format: "0.0"
    sql: ${number_of_damaged_days} ;;
  }

  ######### Parameters

  parameter: date_granularity {
    group_label: "> Dates"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }


  ######## Dynamic Dimensions

  dimension: damage_solved_date_dynamic {
    group_label: "> Dates"
    label: "Damage Solved Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${damaged_solved_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${damaged_solved_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${damaged_solved_month}
    {% endif %};;
  }

  dimension: damage_created_date_dynamic {
    group_label: "> Dates"
    label: "Damage Created Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${damage_created_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${damage_created_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${damage_created_month}
    {% endif %};;
  }
}
