view: hires_contract_mix {
  sql_table_name: `flink-data-prod.reporting.hires_contract_mix`
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


  dimension: channel_label{
    label: "Contract Type label"
    case: {
      when: {
        sql: REGEXP_CONTAINS(lower (${type_of_contract}),'mini')
        ;;
        label: "Minijob"
      }

      when: {
        sql: REGEXP_CONTAINS(lower (${type_of_contract}),'student')
          ;;
        label: "Working Student"
      }

      when: {
        sql: REGEXP_CONTAINS(lower (${type_of_contract}),'full') OR REGEXP_CONTAINS(lower (${type_of_contract}),'voll')
          ;;
        label: "Full-Time"
      }

      when: {
        sql: REGEXP_CONTAINS(lower (${type_of_contract}),'part') OR REGEXP_CONTAINS(lower (${type_of_contract}),'teil')
          ;;
        label: "Part-Time"
      }

      when: {
        sql: REGEXP_CONTAINS(lower (${type_of_contract}),'min/max')
          ;;
        label: "Min/Max"
      }

      when: {
        sql: REGEXP_CONTAINS(lower (${type_of_contract}),'0-hours')
          ;;
        label: "0-hours"
      }

      when: {
        sql: REGEXP_CONTAINS(lower (${type_of_contract}),'15')
          ;;
        label: "15 Hours"
      }

      when: {
        sql: REGEXP_CONTAINS(lower (${type_of_contract}),'20')
          ;;
        label: "20 Hours"
      }

      when: {
        sql: REGEXP_CONTAINS(lower (${type_of_contract}),'35')
          ;;
        label: "35 Hours"
      }

      else:"Others"
    }
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
