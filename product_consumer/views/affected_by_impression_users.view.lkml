# view: affected_by_impression_users {
#     derived_table: {
#       explore_source: daily_events {
#         column: event_date {}
#         column: anonymous_id {}
#         filters: {
#           field: daily_events.event_name
#           value: "\"product_impression\""
#         }
#       }
#     }
#     dimension: event_date {
#       label: "Event Date"
#       hidden: yes
#       description: "Timestamp of when an event happened"
#       type: date
#     }
#     dimension: anonymous_id {
#       label: "Anonymous ID"
#       hidden: yes
#       description: "User ID set by Segment"
#     }
#   }

view: affected_by_impression_users {
  derived_table: {
    sql: SELECT
            (DATE(daily_events.event_timestamp , 'Europe/Berlin')) AS event_date,
            daily_events.anonymous_id  AS anonymous_id
        FROM `flink-data-prod.curated.daily_events` AS daily_events
        LEFT JOIN global_filters_and_parameters ON global_filters_and_parameters.generic_join_dim = TRUE
        WHERE event_name in ('product_impression')
        AND ((UPPER(( daily_events.country_iso  )) LIKE UPPER('%') OR (( daily_events.country_iso  ) IS NULL)))
        AND {% condition global_filters_and_parameters.datasource_filter %} DATE(daily_events.event_timestamp) {% endcondition %}
        GROUP BY
            1,
            2 ;;
  }

    dimension: event_date {
      label: "Event Date"
      hidden: yes
      description: "Timestamp of when an event happened"
      #type: date
    }
    dimension: anonymous_id {
      label: "Anonymous ID"
      hidden: yes
      description: "User ID set by Segment"
    }

}
