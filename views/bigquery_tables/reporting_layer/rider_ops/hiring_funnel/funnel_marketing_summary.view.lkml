view: funnel_marketing_summary {
  sql_table_name: `flink-data-prod.reporting.funnel_marketing_summary`
    ;;

  dimension: channel {
    hidden: yes
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: city {
    hidden: yes
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: applicants {
    hidden: yes
    type: number
    sql: ${TABLE}.cnt_applicants ;;
  }

  dimension: country {
    hidden: yes
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: source {
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
    sql: ${TABLE}.date ;;
  }

  dimension: unique_id {
    type: string
    primary_key: yes
    hidden: yes
    sql: concat(ifnull(${country}, ''), ifnull(${city}, ''), ifnull(${position}, ''), ifnull(${channel}, ''), ifnull(${source_date}, cast('1900-01-01' as date)), ifnull(${days_to_hire}, 0)) ;;
  }

  dimension: days_to_hire {
    hidden: yes
    type: number
    sql: ${TABLE}.days_to_hire ;;
  }

  dimension: position {
    hidden: yes
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: channel_label{
    hidden: yes
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

######## Dynamic Dimensions

  dimension: date {
    hidden: yes
    group_label: "* Dates & Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Week' %}
      ${source_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${source_month}
    {% endif %};;
  }

######## Parameters

  parameter: date_granularity {
    hidden: yes
    group_label: "* Dates & Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Week"
  }

  ################## Measures

  measure: avg_days_to_hire {
    group_label: "* Averages *"
    label: "AVG Time to Hire (Days)"
    type: average
    sql: ${days_to_hire} ;;
    value_format_name: decimal_1
  }

  measure: cnt_applicants {
    group_label: "* Basic Counts *"
    label: "# Hired Applicants"
    type: sum
    sql: ${applicants} ;;
    value_format_name: decimal_0
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
