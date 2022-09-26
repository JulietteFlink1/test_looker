# Created by Victor Breda - 2022-09-19
# More documentation on Uptime calculation can be found here: https://goflink.atlassian.net/wiki/spaces/DATA/pages/436962307/Vehicle+Uptime+Calculation

view: vehicle_uptime_metrics {
  sql_table_name: `flink-data-prod.reporting.vehicle_uptime_metrics` ;;

  drill_fields: [vehicle_id]

  dimension: country_iso {
    group_label: "> Geography"
    label: "Country Iso"
    hidden: yes
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    group_label: "> Geography"
    label: "Hub Code"
    hidden:  yes
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: supplier_id {
    group_label: "> Supplier Properties"
    label: "Supplier Id"
    description: "Unique bike supplier identifier"
    hidden:  yes
    type: string
    sql: ${TABLE}.supplier_id ;;
  }

  dimension: supplier_name {
    group_label: "> Supplier Properties"
    label: "Supplier Name"
    description: "Full supplier name e.g. Swapfiets"
    hidden:  yes
    type: string
    sql: ${TABLE}.supplier_name ;;
  }

  dimension: vehicle_id {
    group_label: "> Vehicle Properties"
    label: "Vehicle Id"
    description: "Unique identifier of a bike"
    hidden:  yes
    type: string
    sql: ${TABLE}.vehicle_id ;;
  }

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

  dimension: downtime_minutes {
    hidden: yes
    description: "For a bike / date / hub: duration of damage within the opening hours of the hub. In minutes."
    type: number
    sql: ${TABLE}.downtime_minutes ;;
  }

  dimension: expected_uptime_minutes {
    description: "For a date / hub / bike (belonging to the hub): how long the hub was open on that date. In minutes."
    hidden: yes
    type: number
    sql: ${TABLE}.expected_uptime_minutes ;;
  }

  ### MEASURES ###

  measure: sum_downtime_minutes {
    hidden: yes
    description: "SUM of downtime in minutes"
    type: sum
    sql: ${downtime_minutes} ;;
  }

  measure: sum_expected_uptime_minutes {
    hidden: yes
    description: "SUM of expected uptime in minutes"
    type: sum
    sql: ${expected_uptime_minutes} ;;
  }

  measure: number_of_bikes {
    label: "# Bikes"
    description: "Number of bikes that should be available"
    type: count_distinct
    filters: [expected_uptime_minutes: "not null"]
    sql: ${vehicle_id}
    ;;
  }

  measure: number_of_non_damaged_bikes {
    label: "# Non Damaged Bikes"
    description: "Number of bikes that do not have a damage reported"
    type: count_distinct
    filters: [downtime_minutes : "=0", expected_uptime_minutes: "not null"]
    sql: ${vehicle_id} ;;
  }

  measure: number_of_damaged_bikes {
    label: "# Damaged Bikes"
    description: "Number of bikes that have a damage reported that prevents them to be used"
    type: count_distinct
    filters: [downtime_minutes : ">0"]
    sql: ${vehicle_id} ;;
  }

  measure: share_of_operational_bike_minutes {
    label: "% Operational Bike Time (Damages)"
    description: "Computed as 1 - (downtime / expected uptime). Based on damages.
                Downtime = sum of duration of damages on a certain day.
                Expected Uptime: # bikes * opening duration of hub on a certain day."
    type: number
    sql: 1 - (${sum_downtime_minutes} / NULLIF(${sum_expected_uptime_minutes},0)) ;;
    value_format_name: percent_2
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

  dimension: date_granularity_pass_through {
    group_label: "> Parameters"
    description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
    type: string
    hidden: no # yes
    sql:
            {% if date_granularity._parameter_value == 'Day' %}
              "Day"
            {% elsif date_granularity._parameter_value == 'Week' %}
              "Week"
            {% elsif date_granularity._parameter_value == 'Month' %}
              "Month"
            {% endif %};;
  }


  ######## Dynamic Dimensions

  dimension: report_date_dynamic {
    group_label: "> Dates"
    label: "Report Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${report_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${report_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${report_month}
    {% endif %};;
  }

}
