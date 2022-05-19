view: hub_closure_rate {
  sql_table_name: flink-data-prod.reporting.hub_closures ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: created {
    group_label: "* Dates and Timestamps *"
    label: "Closure"
    description: "Closure Date"
    type: time
    timeframes: [
      date,
      week,
      month
    ]
    sql: ${TABLE}.date_current ;;
    datatype: date
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.hub_closure_uuid ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: open_hours {
    type: number
    sql: ${TABLE}.open_hours ;;
  }

  dimension: total_missed_orders {
    type: number
    sql: ${TABLE}.total_missed_orders ;;
  }

  dimension: aov {
    type: number
    sql: ${TABLE}.aov ;;
  }

### Dimensions for Missed Orders ###
  dimension: missed_orders_understaffing {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_understaffing ;;
  }

  dimension: missed_orders_weather {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_weather ;;
  }

  dimension: missed_orders_remodelling {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_remodelling ;;
  }

  dimension: missed_orders_external_factor {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_external_factor ;;
  }

  dimension: missed_orders_property_issue {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_property_issue ;;
  }

  dimension: missed_orders_other {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_other ;;
  }

  dimension: missed_orders_equipment {
    type: number
    hidden:  yes
    sql: ${TABLE}.missed_orders_equipment ;;
  }


  ### Dimensions for Lost GMV ###

  dimension: lost_gmv_understaffing  {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_understaffing  ;;
  }

  dimension: lost_gmv_weather {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_weather ;;
  }

  dimension: lost_gmv_remodelling {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_remodelling ;;
  }

  dimension: lost_gmv_external_factor {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_external_factor ;;
  }

  dimension: lost_gmv_property_issue {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_property_issue ;;
  }

  dimension: lost_gmv_other {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_other ;;
  }

  dimension: lost_gmv_equipment {
    type: number
    hidden:  yes
    sql: ${TABLE}.lost_gmv_equipment ;;
  }

### Dimension for Closure Hours ###
  dimension: total_closure_hours_understaffing {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_understaffing ;;
  }

  dimension: total_closure_hours_weather {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_weather ;;
  }

  dimension: total_closure_hours_remodelling {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_remodelling ;;
  }

  dimension: total_closure_hours_external_factor {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_external_factor ;;
  }

  dimension: total_closure_hours_property_issue {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_property_issue ;;
  }

  dimension: total_closure_hours_other {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_other ;;
  }

  dimension: total_closure_hours_equipment {
    type: number
    hidden:  yes
    sql: ${TABLE}.total_closure_hours_equipment ;;
  }

  dimension: total_closure_hours {
    type: number
    sql: ${TABLE}.total_closure_hours ;;
  }

  dimension: closure_reason_overall {
    label: "Closure Reason"
    type: string
    hidden:  no
    sql: ${TABLE}.closure_reason_overall ;;
  }

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

    dimension: date {
      group_label: "* Dates and Timestamps *"
      label: "Date (Dynamic)"
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




  parameter: closure_reason_parameter {
  type: unquoted
    allowed_value: { value: "Understaffing" }
    allowed_value: { value: "Weather" }
    allowed_value: { value: "Remodelling" }
    allowed_value: { label: "External factor"
                     value: "External_factor" }
    allowed_value: { label: "Property issue"
                     value: "Property_issue" }
    allowed_value: { value: "Other" }
    allowed_value: { value: "Equipment" }
    allowed_value: { value: "All" }
    default_value: "All"
  }

  measure: sum_missed_orders_parameter {
    label: "Sum Missed Orders"
    hidden:  no
    type: number
    sql:
      {% if closure_reason_parameter._parameter_value == 'Understaffing' %}
      ${sum_missed_orders_understaffing}
      {% elsif closure_reason_parameter._parameter_value == 'Weather' %}
      ${sum_missed_orders_weather}
      {% elsif closure_reason_parameter._parameter_value == 'Remodelling' %}
      ${sum_missed_orders_remodelling}
      {% elsif closure_reason_parameter._parameter_value == 'External_factor' %}
      ${sum_missed_orders_external_factor}
      {% elsif closure_reason_parameter._parameter_value == 'Property_issue' %}
      ${sum_missed_orders_property_issue}
      {% elsif closure_reason_parameter._parameter_value == 'Other' %}
      ${sum_missed_orders_other}
      {% elsif closure_reason_parameter._parameter_value == 'Equipment' %}
      ${sum_missed_orders_equipment}
      {% elsif closure_reason_parameter._parameter_value == 'All' %}
      ${sum_missed_orders}
      {% endif %};;
    value_format: "0.0"
  }

  measure: lost_gmv_parameter {
    label: "Lost GMV"
    hidden:  no
    type: number
    sql:
      {% if closure_reason_parameter._parameter_value == 'Understaffing' %}
      ${sum_lost_gmv_understaffing}
      {% elsif closure_reason_parameter._parameter_value == 'Weather' %}
      ${sum_lost_gmv_weather}
      {% elsif closure_reason_parameter._parameter_value == 'Remodelling' %}
      ${sum_lost_gmv_remodelling}
      {% elsif closure_reason_parameter._parameter_value == 'External_factor' %}
      ${sum_lost_gmv_external_factor}
      {% elsif closure_reason_parameter._parameter_value == 'Property_issue' %}
      ${sum_lost_gmv_property_issue}
      {% elsif closure_reason_parameter._parameter_value == 'Other' %}
      ${sum_lost_gmv_other}
      {% elsif closure_reason_parameter._parameter_value == 'Equipment' %}
      ${sum_lost_gmv_equipment}
      {% elsif closure_reason_parameter._parameter_value == 'All' %}
      ${lost_gmv}
      {% endif %};;
    value_format_name: eur_0
  }

  measure: hub_closure_rate {
    label: "% Hub Closure Rate"
    hidden:  no
    type: number
    sql:
      {% if closure_reason_parameter._parameter_value == 'Understaffing' %}
      ${sum_closure_hours_understaffing}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'Weather' %}
      ${sum_closure_hours_weather}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'Remodelling' %}
      ${sum_closure_hours_remodelling}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'External_factor' %}
      ${sum_closure_hours_external_factor}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'Property_issue' %}
      ${sum_closure_hours_property_issue}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'Other' %}
      ${sum_closure_hours_other}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'Equipment' %}
      ${sum_closure_hours_equipment}/${sum_opened_hours}
      {% elsif closure_reason_parameter._parameter_value == 'All' %}
      ${sum_closed_hours}/${sum_opened_hours}
      {% endif %};;
    value_format: "0.0%"
  }

  measure: understaffing_closure_rate {
    label: "% Understaffing"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_understaffing}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: weather_closure_rate {
    label: "% Weather"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_weather}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: remodelling_closure_rate {
    label: "% Remodelling"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_remodelling}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: external_factor_closure_rate {
    label: "% External Factor"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_external_factor}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: property_issue_closure_rate {
    label: "% Property Issue"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_property_issue}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: other_closure_rate {
    label: "% Other"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_other}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: equipment_closure_rate {
    label: "% Equipment"
    hidden:  no
    type: number
    sql: ${sum_closure_hours_equipment}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: all_closure_rate {
    label: "% All Closure Rate"
    hidden:  no
    type: number
    sql: ${sum_closed_hours}/${sum_opened_hours};;
    value_format: "0.0%"
  }

  measure: sum_opened_hours {
    label: "Sum Open Hours"
    hidden:  no
    type: sum
    sql: ${open_hours};;
    value_format: "0.0"
  }

  measure: sum_closed_hours {
    label: "Sum Closed Hours"
    hidden:  no
    type: sum
    sql: ${total_closure_hours};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_understaffing {
    label: "Sum Closed Hours Understaffing"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_understaffing};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_weather {
    label: "Sum Closed Hours Weather"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_weather};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_remodelling {
    label: "Sum Closed Hours Remodelling"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_remodelling};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_external_factor {
    label: "Sum Closed Hours External factor"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_external_factor};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_property_issue {
    label: "Sum Closed Hours Property issue"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_property_issue};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_other {
    label: "Sum Closed Hours Other"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_other};;
    value_format: "0.0"
  }

  measure: sum_closure_hours_equipment {
    label: "Sum Closed Hours Equipment"
    hidden:  yes
    type: sum
    sql: ${total_closure_hours_equipment};;
    value_format: "0.0"
  }

### Measure for Missed Orders ###

  measure: sum_missed_orders_understaffing {
    label: "Sum Missed Orders Understaffing"
    hidden:  yes
    type: sum
    sql: ${missed_orders_understaffing};;
    value_format: "0.0"
  }

  measure: sum_missed_orders_weather {
    label: "Sum Missed Orders Weather"
    hidden:  yes
    type: sum
    sql: ${missed_orders_weather};;
    value_format: "0.0"
  }

  measure: sum_missed_orders_remodelling {
    label: "Sum Missed Orders Remodelling"
    hidden:  yes
    type: sum
    sql: ${missed_orders_remodelling};;
    value_format: "0.0"
  }

  measure: sum_missed_orders_external_factor {
    label: "Sum Missed Orders External factor"
    hidden:  yes
    type: sum
    sql: ${missed_orders_external_factor};;
    value_format: "0.0"
  }

  measure: sum_missed_orders_property_issue {
    label: "Sum Missed Orders Property issue"
    hidden:  yes
    type: sum
    sql: ${missed_orders_property_issue};;
    value_format: "0.0"
  }

  measure: sum_missed_orders_other {
    label: "Sum Missed Orders Other"
    hidden:  yes
    type: sum
    sql: ${missed_orders_other};;
    value_format: "0.0"
  }

  measure: sum_missed_orders_equipment {
    label: "Sum Missed Orders Equipment"
    hidden:  yes
    type: sum
    sql: ${missed_orders_equipment};;
    value_format: "0.0"
  }


### Measures for Lost GMV ###
  measure: sum_lost_gmv_understaffing  {
    label: "Sum Lost GMV Understaffing"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_understaffing};;
    value_format: "0.0"
  }

  measure: sum_lost_gmv_weather {
    label: "Sum Lost GMV Weather"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_weather};;
    value_format: "0.0"
  }

  measure: sum_lost_gmv_remodelling {
    label: "Sum Lost GMV Remodelling"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_remodelling};;
    value_format: "0.0"
  }

  measure: sum_lost_gmv_external_factor {
    label: "Sum Lost GMV External factor"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_external_factor};;
    value_format: "0.0"
  }

  measure: sum_lost_gmv_property_issue {
    label: "Sum Lost GMV Property issue"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_property_issue};;
    value_format: "0.0"
  }

  measure: sum_lost_gmv_other {
    label: "Sum Lost GMV Other"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_other};;
    value_format: "0.0"
  }

  measure: sum_lost_gmv_equipment {
    label: "Sum Lost GMV Equipment"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_equipment};;
    value_format: "0.0"
  }

  measure: sum_missed_orders {
    label: "Total Missed Orders"
    hidden:  yes
    type: sum
    sql: ifnull(${total_missed_orders},0);;
    value_format: "0"
  }

  measure: lost_gmv {
    label: "Total GMV Lost"
    hidden:  yes
    type: sum
    sql: ${lost_gmv_equipment} +
         ${lost_gmv_other} +
        ${lost_gmv_property_issue} +
        ${lost_gmv_external_factor} +
        ${lost_gmv_remodelling} +
        ${lost_gmv_weather} +
        ${lost_gmv_understaffing} ;;
    value_format_name: eur_0
  }

  set: detail {
    fields: [
      # day,
      # week,
      # month,
      country_iso,
      city,
      hub_code,
      open_hours,
      total_missed_orders,
      total_closure_hours_understaffing,
      total_closure_hours_weather,
      total_closure_hours_remodelling,
      total_closure_hours_external_factor,
      total_closure_hours_property_issue,
      total_closure_hours_other,
      total_closure_hours_equipment,
      total_closure_hours
    ]
  }
}
