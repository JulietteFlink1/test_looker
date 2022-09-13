view: vehicle_suppliers {
  sql_table_name: `flink-data-prod.curated.vehicle_suppliers`
    ;;

  dimension_group: archived_at {
    group_label: "> Dates"
    type: time
    timeframes: [
      date,
      week,
      month
    ]
    sql: ${TABLE}.archived_at_timestamp ;;
  }

  dimension: booking_status {
    group_label: "> Vehicle Properties"
    description:"Flags if the vehicle is available or not."
    type: string
    sql: ${TABLE}.booking_status ;;
  }

  dimension: country_iso {
    group_label: "> Geography"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: created {
    group_label: "> Dates"
    type: time
    timeframes: [
      date,
      week,
      month,
    ]
    sql: ${TABLE}.created_at_timestamp ;;
  }

  dimension: hub_code {
    group_label: "> Geography"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: model_name {
    group_label: "> Vehicle Properties"
    description: "Name of the vehicle model. e.g. GetHenry e-bike"
    type: string
    sql: ${TABLE}.model_name ;;
  }

  dimension: operational_status {
    group_label: "> Vehicle Properties"
    description: "Flags if the vehicle is operational, in maintenance etc."
    type: string
    sql: ${TABLE}.operational_status ;;
  }

  dimension: supplier_code {
    group_label: "> Supplier Properties"
    description: "3 letter code to identify the supplier e.g. SWP for Swapfiets"
    type: string
    sql: ${TABLE}.supplier_code ;;
  }

  dimension: supplier_id {
    group_label: "> Supplier Properties"
    type: string
    sql: ${TABLE}.supplier_id ;;
  }

  dimension: supplier_name {
    group_label: "> Supplier Properties"
    description: "Full supplier name e.g. Swapfiets"
    type: string
    sql: ${TABLE}.supplier_name ;;
  }

  dimension_group: updated_at {
    group_label: "> Dates"
    type: time
    timeframes: [
      date,
      week,
      month
    ]
    sql: ${TABLE}.updated_at_timestamp ;;
  }

  dimension: vehicle_id {
    group_label: "> Vehicle Properties"
    type: string
    sql: ${TABLE}.vehicle_id ;;
  }

  dimension: is_archived_bike {
    group_label: "> Vehicle Properties"
    type: yesno
    sql:
        case
            when ${archived_at_date} is not null
                then
                    true
            else
                false
        end ;;
  }

  dimension: vehicle_kind {
    group_label: "> Vehicle Properties"
    description: "Vehicle kind e.g. bicycle"
    type: string
    sql: ${TABLE}.vehicle_kind ;;
  }

  dimension: vehicle_name {
    group_label: "> Vehicle Properties"
    description: "Name of the vehicle e.g. GetHenry Henry l"
    type: string
    sql: ${TABLE}.vehicle_name ;;
  }

  dimension: vehicle_supplier_uuid {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.vehicle_supplier_uuid ;;
  }

  measure: count {
    type: count
    drill_fields: [model_name, supplier_name, vehicle_name]
  }


  ########## Measures


  measure: number_of_vehicles {
    group_label: "> Vehicle Status"
    label: "# Offline and Online Bikes"
    description: "Number of bikes with any operational status."
    type: count_distinct
    sql: ${vehicle_id} ;;
  }

  measure: number_of_operational_vehicles {
    group_label: "> Vehicle Status"
    label: "# Operational Bikes"
    description: "Number of bikes currently operational."
    type: count_distinct
    sql: ${vehicle_id} ;;
    filters: [operational_status: "operational", is_archived_bike: "no"]
  }

  measure: number_of_in_maintenance_vehicles {
    group_label: "> Vehicle Status"
    label: "# In Maintenance Bikes"
    description: "Number of bikes currently in maintenance."
    type: count_distinct
    sql: ${vehicle_id} ;;
    filters: [operational_status: "in_maintenance",is_archived_bike: "no"]
  }

  measure: number_of_maintenance_required_vehicles {
    group_label: "> Vehicle Status"
    label: "# Maintenance Required Bikes"
    description: "Number of bikes for which maintenance is required."
    type: count_distinct
    sql: ${vehicle_id} ;;
    filters: [operational_status: "maintenance_required",is_archived_bike: "no"]
  }

  measure: number_of_offline_vehicles {
    group_label: "> Vehicle Status"
    label: "# Offline Bikes"
    description: "Number of offline bikes."
    type: count_distinct
    sql: ${vehicle_id} ;;
    filters: [operational_status: "offline",is_archived_bike: "no"]
  }

  measure: number_of_online_vehicles {
    group_label: "> Vehicle Status"
    label: "# Bikes"
    description: "Number of online bikes. (any operational status except offline)"
    type: count_distinct
    sql: ${vehicle_id} ;;
    filters: [operational_status: "-offline", is_archived_bike: "no"]
  }

  measure: share_of_operational_vehicles {
    type: number
    group_label: "> Vehicle Status"
    label: "% Operational Bikes"
    description: "Share of bikes that are currently operational out of all online bikes (excluding offline bikes)"
    sql: safe_divide(${number_of_operational_vehicles},${number_of_online_vehicles}) ;;
    value_format: "0.0%"
  }

  measure: share_of_in_maintenance_vehicles {
    type: number
    group_label: "> Vehicle Status"
    label: "% In Maintenance Bikes"
    description: "Share of bikes that are currently in maintenance out of all online bikes"
    sql: safe_divide(${number_of_in_maintenance_vehicles},${number_of_online_vehicles}) ;;
    value_format: "0.0%"
  }

  measure: share_of_maintenance_required_vehicles {
    type: number
    group_label: "> Vehicle Status"
    label: "% Maintenance Required Bikes"
    description: "Share of bikes with status 'maintenance_required' out of all online bikes"
    sql: safe_divide(${number_of_maintenance_required_vehicles},${number_of_online_vehicles}) ;;
    value_format: "0.0%"
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

  dimension: created_date_dynamic {
    group_label: "> Dates"
    label: "Created Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${created_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${created_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${created_month}
    {% endif %};;
  }

}
