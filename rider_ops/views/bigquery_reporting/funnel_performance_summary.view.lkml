view: funnel_performance_summary {
  sql_table_name: `flink-data-prod.reporting.funnel_performance_summary`
    ;;

  dimension: spend {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_spend ;;
  }

  dimension: days_to_first_shift {
    hidden: yes
    type: number
    sql: ${TABLE}.avg_days_to_first_shift ;;
  }

  dimension: days_to_hire {
    hidden: yes
    type: number
    sql: ${TABLE}.avg_days_to_hire ;;
  }

  dimension: channel {
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: city {
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: hires {
    hidden: yes
    type: number
    sql: ${TABLE}.cnt_hires ;;
  }

  dimension: leads {
    hidden: yes
    type: number
    sql: ${TABLE}.cnt_leads ;;
  }

  dimension: country {
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: report {
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
    sql: concat(${country}, ${city}, ${channel}, ${position}, ${report_date}) ;;
  }

  dimension: hires_with_account_created {
    hidden: yes
    type: number
    sql: ${TABLE}.hires_with_account_created ;;
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

  dimension: position {
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: week_number {
    hidden: no
    type: number
    sql: extract(week from date_TRUNC(${TABLE}.date, WEEK(MONDAY))) ;;
  }


  dimension: year_number {
    hidden: no
    type: number
    sql: ${report_year};;
  }


  dimension: year_cw {
    type: string
    label: "Year_CW"
    sql: concat (${year_number},'_',${week_number}) ;;
  }

  dimension_group: updated {
    type: time
    group_label: "* Dates & Timestamps *"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at ;;
  }

  dimension: channel_label{
    label: "Channel label"
    group_label: "* Funnel Dimensions *"
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
    group_label: "* Dates & Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Week' %}
      ${report_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${report_month}
    {% endif %};;
  }


######## Parameters

  parameter: date_granularity {
    group_label: "* Dates & Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Week"
  }

  ################### Measures

  measure: amt_spend {
    group_label: "* Monetary *"
    label: "Marketing Spend"
    type: sum
    sql: ${spend} ;;
    value_format_name: eur_0
  }

  measure: avg_days_to_hire {
    group_label: "* Averages *"
    label: "AVG Time to Hire (Days)"
    type: average
    sql: ${days_to_hire} ;;
    value_format_name: decimal_1
  }

  measure: avg_days_to_first_shift {
    group_label: "* Averages *"
    label: "AVG Time to First Shift (Days)"
    type: average
    sql: ${days_to_first_shift} ;;
    value_format_name: decimal_1
  }

  measure: cnt_hires {
    group_label: "* Basic Counts *"
    label: "# Hires"
    type: sum
    sql: ${hires} ;;
    value_format_name: decimal_0
  }

  measure: cnt_leads {
    group_label: "* Basic Counts *"
    label: "# Leads"
    type: sum
    sql: ${leads} ;;
    value_format_name: decimal_0
  }

  measure: cnt_hires_with_account_created {
    group_label: "* Basic Counts *"
    label: "# Hires With Account Created"
    type: sum
    sql: ${hires_with_account_created} ;;
    value_format_name: decimal_0
  }

  measure: cnt_hires_with_first_shift_scheduled {
    group_label: "* Basic Counts *"
    label: "# Hires With First Shift Scheduled"
    type: sum
    sql: ${hires_with_first_shift_scheduled} ;;
    value_format_name: decimal_0
  }

  measure: cnt_hires_with_first_shift_completed {
    group_label: "* Basic Counts *"
    label: "# Hires With First Shift Completed"
    type: sum
    sql: ${hires_with_first_shift_completed} ;;
    value_format_name: decimal_0
  }

  measure: last_updated_at {
    group_label: "* Dates & Timestamps *"
    type: max
    sql: ${updated_raw}  ;;
  }

  measure: pct_hires_with_first_shift_completed {
    label:       "% Hires with first shift completed"
    description: "% Hires with first shift completed"
    type:        number
    sql:case when NULLIF(${hires}, 0) > 0 then ${hires_with_first_shift_completed} / ${hires}
      else null end;;
    value_format_name:  percent_1
  }

  measure: pct_hires_with_first_shift_scheduled{
    label:       "% Hires with first shift scheduled"
    description: "% Hires with first shift scheduled"
    type:        number
    sql:case when NULLIF(${hires}, 0) > 0 then ${hires_with_first_shift_scheduled} / ${hires}
             else null end
            ;;
    value_format_name:  percent_1
  }

  measure: pct_hires_with_account_created {
    label:       "% Hires with account created"
    description: "% Hires with account created"
    type:        number
    sql:case when NULLIF(${hires}, 0) > 0 then ${hires_with_account_created} / ${hires}
      else null end;;
    value_format_name:  percent_1
  }

  measure: CVR {
    type: number
    sql: ${cnt_hires} / NULLIF(${cnt_leads}, 0) ;;
    description: "Pct. of Leads that Converted into Approved Applicants"
    value_format_name: percent_0
  }
}
