view: affected_by_impression_users {
  derived_table: {
    sql:WITH global_filters_and_parameters AS (select TRUE as generic_join_dim)
        SELECT
            (DATE(daily_events.event_timestamp , 'Europe/Berlin')) AS event_date,
            daily_events.anonymous_id  AS anonymous_id,
            TRUE as is_exposed_to_impressions
        FROM `flink-data-prod.curated.daily_events` AS daily_events
        LEFT JOIN global_filters_and_parameters ON global_filters_and_parameters.generic_join_dim = TRUE
        WHERE event_name in ('product_impression')
        AND ((UPPER(( daily_events.country_iso  )) LIKE UPPER('%') OR (( daily_events.country_iso  ) IS NULL)))
        AND {% condition global_filters_and_parameters.datasource_filter %} DATE(daily_events.event_timestamp) {% endcondition %}
        GROUP BY
            1,
            2,
            3;;
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
  dimension: is_exposed_to_impressions {
    label: "is exposed to impressions"
    type: yesno
    description: "True is user is exposed to product_impression events"
  }

}
