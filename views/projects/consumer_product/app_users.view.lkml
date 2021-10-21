view: app_users {
  derived_table: {
    persist_for: "2 hour"
    sql:
    SELECT DISTINCT
            context_traits_anonymous_id                                                     AS anonymous_id
          , context_app_version                                                             AS app_version
          , context_device_type                                                             AS device_type
          , city_name                                                                       AS city
          , received_at                                                                     AS event_date
          , LAST_VALUE(backend_search_enabled)
                 OVER ( PARTITION BY context_traits_anonymous_id ORDER BY received_at)      AS backend_search_enabled
          , LAST_VALUE(search_experiment_variant)
                 OVER ( PARTITION BY context_traits_anonymous_id ORDER BY received_at)      AS search_experiment_variant
 FROM `flink-data-prod.flink_ios_production.users`
 WHERE search_experiment_variant is not null
 ;;
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }
  # dimension: app_version {
  #   type: string
  #   sql: ${TABLE}.app_version ;;
  # }
  # dimension: device_type {
  #   type: string
  #   sql: ${TABLE}.device_type ;;
  # }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }
  dimension: backend_search_enabled {
    type: yesno
    sql: ${TABLE}.backend_search_enabled ;;
  }
  dimension: search_experiment_variant {
    type: string
    sql: ${TABLE}.search_experiment_variant ;;
  }
  dimension_group: event_date {
    type: time
    datatype: datetime
    timeframes: [
      hour,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.event_date ;;
   }
  }
