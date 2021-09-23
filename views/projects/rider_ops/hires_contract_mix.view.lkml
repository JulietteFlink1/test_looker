view: hires_contract_mix {
  sql_table_name: `flink-data-staging.curated.hires_contract_mix`
    ;;

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: hire {
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
    sql: ${TABLE}.hire_date ;;
  }

  dimension: hires {
    type: number
    sql: ${TABLE}.hires ;;
  }

  dimension: position {
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: type_of_contract {
    type: string
    sql: ${TABLE}.type_of_contract ;;
  }

  dimension: unique_id {
    type: string
    sql: concat(${country}, ${city}, ${channel}, ${position}, ${type_of_contract}, ${hire_date}) ;;
    hidden: yes
    primary_key: yes

  }

  dimension: date_ {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Week' %}
      ${hire_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${hire_month}
    {% endif %};;
  }

  ######## Parameters

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Week"
  }


  ########### Measures

  measure: number_of_hires {
    type: sum
    sql: ${hires} ;;
    value_format_name: decimal_0
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
