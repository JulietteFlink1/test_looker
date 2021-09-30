view: hubs_ct {
  view_label: "* Hub Data *"
  sql_table_name: `flink-data-prod.curated.hubs`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension_group: time_between_hub_launch_and_today {
    type: duration
    sql_start: timestamp(${TABLE}.start_date) ;;
    sql_end: current_timestamp ;;
  }

  # =========  Geographic Data   =========
  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
    group_label: "> Geographic Data"
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    group_label: "> Geographic Data"
  }

  dimension: city_tier {
    type: string
    sql: ${TABLE}.city_tier ;;
    group_label: "> Geographic Data"
  }

  dimension: cluster {
    type: string
    sql: ${TABLE}.cluster ;;
    group_label: "> Geographic Data"
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    group_label: "> Geographic Data"
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    group_label: "> Geographic Data"
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
    hidden: yes
    group_label: "> Geographic Data"
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
    hidden: yes
    group_label: "> Geographic Data"
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
    group_label: "> Geographic Data"
  }

  dimension: region_iso {
    type: string
    sql: ${TABLE}.region_iso ;;
    group_label: "> Geographic Data"
  }

  dimension: regional_cluster {
    type: string
    sql: ${TABLE}.regional_cluster ;;
    group_label: "> Geographic Data"
  }

  dimension: hub_location {
    type: location
    sql_latitude: ${latitude};;
    sql_longitude: ${longitude};;
    group_label: "> Geographic Data"
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
    group_label: "> Geographic Data"
  }



  # =========  Admin Data   =========
  dimension: city_manager {
    type: string
    sql: ${TABLE}.city_manager ;;
    group_label: "> Admin Data"
  }

  dimension: cost_center {
    type: string
    sql: ${TABLE}.cost_center ;;
    group_label: "> Admin Data"
  }

  dimension: email_list {
    type: string
    sql: ${TABLE}.email_list ;;
    group_label: "> Admin Data"
  }

  dimension: last_modified {
    label: "Last Modifed"
    type: date_time
    sql: ${TABLE}.last_modified_at ;;
    group_label: "> Admin Data"
  }

  dimension: languages {
    type: string
    sql: ${TABLE}.languages ;;
    group_label: "> Admin Data"
  }

  dimension: live {
    type: number
    sql: ${TABLE}.live ;;
    group_label: "> Admin Data"
  }

  dimension: start_date {
    label: "Hub Start Date"
    type: date
    datatype: date
    sql: ${TABLE}.start_date;;
    group_label: "> Admin Data"
  }

  dimension: is_hub_opened {
    label: "Hub is Live?"
    type: yesno
    sql: ${TABLE}.start_date <= current_date() ;;
    group_label: "> Admin Data"
  }


  # =========  ID Data   =========
  dimension: distribution_channel_id {
    type: string
    sql: ${TABLE}.distribution_channel_id ;;
    group_label: "> IDs"
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
    primary_key: yes
    group_label: "> IDs"
  }

  dimension: supply_channel_id {
    type: string
    sql: ${TABLE}.supply_channel_id ;;
    group_label: "> IDs"
  }

  dimension: hub_name_anonymized   {
    label: "Hub ID"
    description: "Identifier of a Hub"
    type: string
    sql: ${TABLE}.hub_name_anonymized  ;;
    group_label: "> IDs"
  }



  measure: count {
    type: count
    drill_fields: [hub_name]
    hidden: yes
  }
}
