view: hired_applicants {
  sql_table_name: `flink-data-prod.reporting.hired_applicants`
    ;;

  dimension: days_to_hire {
    hidden: yes
    type: number
    sql: ${TABLE}.avg_days_to_hire ;;
  }

  dimension: channel {
    hidden: no
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: city {
    hidden: no
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: type_of_contract {
    hidden: no
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.type_of_contract ;;
  }

  dimension: hires {
    hidden: yes
    type: number
    sql: ${TABLE}.cnt_hires ;;
  }

  dimension: country {
    hidden: no
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: hire {
    type: time
    group_label: "* Dates & Timestamps *"
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

  dimension_group: applied {
    type: time
    group_label: "* Dates & Timestamps *"
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
    sql: ${TABLE}.applied_date ;;
  }

  dimension: position {
    hidden: no
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: unique_id {
    hidden: yes
    type: string
    primary_key: yes
    sql: concat(coalesce(${country}, ''),
          coalesce(${city}, ''),
          coalesce(${position}, ''), coalesce(${channel}. ''),
          coalesce(${type_of_contract}, ''),
          coalesce(${hire_date}, cast('1900-01-01' as date))),
          coalesce(${applied_date}, cast('1900-01-01' as date)));;
  }

  dimension: contract_label{
    label: "Contract Type label"
    group_label: "* Funnel Dimensions *"
    type: string
    sql: case
              -- DE/AT Contract Type
              when REGEXP_CONTAINS(lower (${type_of_contract}),'mini') then 'Minijob'
              when REGEXP_CONTAINS(lower (${type_of_contract}),'student') then 'Working Student'
              when REGEXP_CONTAINS(lower (${type_of_contract}),'full') OR REGEXP_CONTAINS(lower (${type_of_contract}),'voll') then 'Full-Time'
              when REGEXP_CONTAINS(lower (${type_of_contract}),'part') OR REGEXP_CONTAINS(lower (${type_of_contract}),'teil') then 'Part-Time'


              -- NL Contract Type
              when REGEXP_CONTAINS(lower (${type_of_contract}),'0-hours') then '0-Hours'
              when REGEXP_CONTAINS(lower (${type_of_contract}),'min/max') then 'Min/Max'


              -- FR Contract Type
              when REGEXP_CONTAINS(lower (${type_of_contract}),'15') then '15 Hours'
              when REGEXP_CONTAINS(lower (${type_of_contract}),'20') then '20 Hours'
              when REGEXP_CONTAINS(lower (${type_of_contract}),'35') then '35 Hours'



              else 'Others' end;;

    }

  ####### Dynamic Dimensions

  dimension: date {
    hidden: no
    group_label: "* Dates & Timestamps *"
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
    hidden: no
    group_label: "* Dates & Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Week"
  }

  ###################### Measures

  measure: avg_days_to_hire {
    group_label: "* Averages *"
    type: average
    label: "AVG Time to Hire (Days)"
    sql: ${days_to_hire} ;;
  }

  measure: cnt_hires {
    hidden: no
    group_label: "* Basic Counts *"
    type: sum
    label: "# Hires"
    sql: ${hires} ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
