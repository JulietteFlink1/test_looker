view: rider_marketing_spend {
  sql_table_name: `flink-data-prod.curated.rider_marketing_spend`
    ;;

  dimension: channel {
    group_label: "* Channel Dimensions *"
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: city {
    group_label: "* Channel Dimensions *"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    group_label: "* Channel Dimensions *"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: report {
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
    sql: ${TABLE}.date ;;
  }

  dimension: position {
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: unique_id {
    hidden: yes
    primary_key: yes
    type: string
    sql: concat(${country}, ${city}, ${channel}, ${position}, ${report_date}) ;;
  }

  dimension: spend {
    hidden: yes
    type: number
    sql: ${TABLE}.spend ;;
  }

  ################ Measures

  measure: amt_spend {
    group_label: "* Monetary *"
    type: number
    label: "Marketing Spend"
    sql: ${spend} ;;
    value_format_name: eur_0
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
