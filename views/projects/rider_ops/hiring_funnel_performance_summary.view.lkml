view: hiring_funnel_performance_summary {
  sql_table_name: `flink-data-prod.reporting.hiring_funnel_performance_summary`
    ;;

  dimension: days_to_first_shift {
    type: number
    hidden: yes
    sql: ${TABLE}.avg_days_to_first_shift ;;
  }

  dimension: days_to_hire {
    type: number
    hidden: yes
    sql: ${TABLE}.avg_days_to_hire ;;
  }

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

  dimension_group: date {
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
    sql: ${TABLE}.date ;;
  }

  dimension: unique_id {
    hidden: yes
    sql: concat(${country}, ${city}, ${channel}, ${position}, ${date_raw}) ;;
    primary_key: yes
  }

  dimension: hires {
    hidden: yes
    type: number
    sql: ${TABLE}.hires ;;
  }

  dimension: hires_with_first_shift_completed {
    hidden: yes
    type: number
    sql: ${TABLE}.hires_with_first_shift_completed ;;
  }

  dimension: hires_with_first_shift_scheduled {
    hidden: yes
    type: number
    sql: ${TABLE}.hires_with_first_shift_scheduled ;;
  }

  dimension: hires_with_account_created {
    hidden: yes
    type: number
    sql: ${TABLE}.hires_with_account_created ;;
  }


  dimension: leads {
    hidden: yes
    type: number
    sql: ${TABLE}.leads ;;
  }

  dimension: position {
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: spend {
    hidden: yes
    type: number
    sql: ${TABLE}.spend ;;
    value_format_name: eur_0
  }

  dimension: date_ {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Week' %}
      ${date_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${date_month}
    {% endif %};;
  }


  dimension: channel_label{
    label: "Channel label"
    case: {
      when: {
        sql: ${channel} = '[utm_source]'
                  or   ${channel} = 'Iinternaltransfer'
                  or   ${channel} = 'InstaBio'
                  or   ${channel} = 'SR_Default Career Page'
                  or   ${channel} = 'internaltransfe'
                  or   ${channel} = 'internaltransfer'
                  or   ${channel} = 'master'
                  or   ${channel} = 'website';;
        label: "Organic"
      }

      when: {
        sql: ${channel} = 'mailbox'
          or  ${channel} = 'offline';;
        label: "Offline"
      }

      when: {
        sql: ${channel} = 'Appcast'
                  or  ${channel} = 'ARBEITSAMT'
                  or  ${channel} = 'Arbeitsagentur'
                  or  ${channel} = 'indeed'
                  or  ${channel} = 'Reach'
                  or  ${channel} = 'SR_Flink - Ebay Kleinanzeigen'
                  or  ${channel} = 'SR_Flink - Indeed'
                  or  ${channel} = 'SR_Flink - Joblift'
                  or  ${channel} = 'SR_Glassdoor'
                  or  ${channel} = 'SR_Indeed'
                  or  ${channel} = 'SR_Joblift'
                  or  ${channel} = 'SR_Neuvoo'
                  or  ${channel} = 'appjobs'
                  or  ${channel} = 'eBay'
                  or  ${channel} = 'ebay'
                  or  ${channel} = 'jobino'
                  or  ${channel} = 'joblift'
                  or  ${channel} = 'jobtome'
                  or  ${channel} = 'lieferjobs'
                  or  ${channel} = 'nvb'
                  or  ${channel} = 'recruitics_appcast';;
        label: "Job Platform"
      }

      when: {
        sql: ${channel} = 'Facebook'
                  or   ${channel} = 'Google'
                  or   ${channel} = 'tiktok';;
        label: "Social Media"
      }

      when: {
        sql: ${channel} = 'raf' ;;
        label: "Refer a Friend"
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

  ######## Measures

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }

  measure: number_of_leads {
    type: sum
    sql: ${leads} ;;
    value_format_name: decimal_0
  }

  measure: number_of_hires {
    type: sum
    sql: ${hires} ;;
    value_format_name: decimal_0
  }

  measure: number_of_hires_with_first_shift_completed {
    type: sum
    sql: ${hires_with_first_shift_completed} ;;
    value_format_name: decimal_0
  }

  measure: number_of_hires_with_first_shift_scheduled {
    type: sum
    sql: ${hires_with_first_shift_scheduled} ;;
    value_format_name: decimal_0
  }

  measure: number_of_hires_with_account_created {
    type: sum
    sql: ${hires_with_account_created} ;;
    value_format_name: decimal_0
  }

  measure: avg_days_to_hire {
    type: average
    sql: ${days_to_hire} ;;
    value_format_name: decimal_1
  }

  measure: avg_days_to_first_shift {
    type: average
    sql: ${days_to_first_shift} ;;
    value_format_name: decimal_1
  }

  measure: total_spend {
    type: sum
    sql: ${spend} ;;
    value_format_name: eur_0
  }


  measure: pct_hires_with_first_shift_completed {
    label:       "% Hires with first shift completed"
    description: "% Hires with first shift completed"
    type:        number
    sql:         ${number_of_hires_with_first_shift_completed} / ${number_of_hires} ;;
    value_format_name:  percent_2
  }

  measure: pct_hires_with_first_shift_scheduled{
    label:       "% Hires with first shift scheduled"
    description: "% Hires with first shift scheduled"
    type:        number
    sql:         ${number_of_hires_with_first_shift_scheduled} / ${number_of_hires} ;;
    value_format_name:  percent_2
  }

  measure: pct_hires_with_account_created {
    label:       "% Hires with account created"
    description: "% Hires with account created"
    type:        number
    sql:         ${number_of_hires_with_account_created} / ${number_of_hires} ;;
    value_format_name:  percent_2
  }

}
