view: tmp_adjust_installs {
  derived_table: {
    sql: select * from `flink-data-dev.sandbox_justine.adjust_installs`
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: install_date {
    type: date
    datatype: date
    sql: ${TABLE}.install_date ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: tracker {
    type: string
    sql: ${TABLE}.tracker ;;
  }

  dimension: marketing_channel {
    type: string
    sql: ${TABLE}.marketing_channel ;;
  }

  dimension: marketing_network {
    type: string
    sql: ${TABLE}.marketing_network ;;
  }

  dimension: tracking_enabled {
    type: number
    sql: ${TABLE}.tracking_enabled ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: num_unique_installs {
    type: number
    sql: ${TABLE}.num_unique_installs ;;
  }

  set: detail {
    fields: [
      install_date,
      country_iso,
      city,
      event,
      platform,
      tracker,
      marketing_channel,
      marketing_network,
      tracking_enabled,
      campaign_name,
      num_unique_installs
    ]
  }
}
