view: nps_comments_words_count {
  sql_table_name: `flink-data-prod.reporting.nps_comments_words_count`
    ;;

  dimension: column {
    type: number
    sql: ${TABLE}.column ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: response_uuid {
    primary_key: yes
    type: string
    sql: ${TABLE}.response_uuid  ;;
  }

  dimension: nps_driver {
    type: string
    sql: ${TABLE}.nps_driver ;;
  }

  dimension: nps_score {
    type: number
    sql: ${TABLE}.nps_score ;;
  }

  dimension_group: submitted {
    group_label: "* Dates & Timestamps *"
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
    sql: ${TABLE}.submitted_date ;;
  }

  parameter: date_granularity {
    group_label: "* Dates & Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Month"
  }

  dimension: date {
    group_label: "* Dates & Timestamps *"
    label: "Submitted Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${submitted_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${submitted_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${submitted_month}
    {% endif %};;
  }

  dimension: date_granularity_pass_through {
    group_label: "* Parameters *"
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

  dimension: is_bigram {
    type: number
    sql: case when length(REGEXP_REPLACE(${word},' ',''))=length(${word}) then 0 else 1 end ;;
  }

  measure: num_occurrences {
    type: count
  }

  dimension: word {
    type: string
    sql: ${TABLE}.word ;;
  }

  measure: count {
    type: count
    drill_fields: [word]
  }
}
