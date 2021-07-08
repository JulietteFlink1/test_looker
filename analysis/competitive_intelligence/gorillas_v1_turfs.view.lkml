

view: gorillas_v1_turfs {
  sql_table_name: `flink-data-dev.gorillas_v1.turfs`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: color {
    type: string
    sql: ${TABLE}.color ;;
  }

  dimension: gorillas_hub_ids {
    hidden: yes
    sql: ${TABLE}.gorillas_hub_ids ;;
  }

  dimension: has_time_schedule {
    type: yesno
    sql: ${TABLE}.hasTimeSchedule ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: points {
    hidden: yes
    sql: ${TABLE}.points ;;
  }

  dimension: schedule__from_time {
    type: number
    sql: ${TABLE}.schedule.fromTime ;;
    group_label: "Schedule"
    group_item_label: "From Time"
  }

  dimension: schedule__to_time {
    type: number
    sql: ${TABLE}.schedule.toTime ;;
    group_label: "Schedule"
    group_item_label: "To Time"
  }

  dimension: scrape_id {
    type: string
    sql: ${TABLE}.scrape_id ;;
  }

  dimension_group: time_scraped {
    type: time
    description: "bq-datetime"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.time_scraped ;;
  }

  dimension: usage_count {
    type: number
    sql: ${TABLE}.usageCount ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

view: turfs__points {
  dimension: empty {
    type: yesno
    sql: ${TABLE}.empty ;;
  }

  dimension: lat {
    type: number
    sql: ${TABLE}.lat ;;
  }

  dimension: lon {
    type: number
    sql: ${TABLE}.lon ;;
  }
}

view: turfs__gorillas_hub_ids {
  dimension: turfs__gorillas_hub_ids {
    type: string
    sql: turfs__gorillas_hub_ids ;;
  }
}
