view: product_search_executed {
  derived_table: {
    sql: WITH search_events as (
  select
      id
    , search_query_id
    , search_query
    , search_results_total_count
    , search_results_available_count
    , search_results_unavailable_count
  from `flink-data-prod.flink_android_production.product_search_executed`
  where date(_PARTITIONTIME) >= "2022-01-13"

  union all

   select
      id
    , search_query_id
    , search_query
    , search_results_total_count
    , search_results_available_count
    , search_results_unavailable_count
  from `flink-data-prod.flink_ios_production.product_search_executed`
  where date(_PARTITIONTIME) >= "2022-01-13"
)

, search_sessions as (
  SELECT  e.event_uuid
    , e.session_id
    , e.anonymous_id
    , e.event_name
    , e.device_type
    , e.event_timestamp
    , s.app_version
    , s.country_iso
    , s.hub_code
    , s.city
    , case when ca.search_query_id is not null
           then safe_convert_bytes_to_string(from_base64(ca.search_query_id))
           else null end                                                             as search_query_id_decoded
    , INITCAP(TRIM(ca.search_query)) AS search_query_clean
    , ca.search_query_id
    , ca.search_query
    , ca.search_results_total_count
    , ca.search_results_available_count
    , ca.search_results_unavailable_count

    FROM `flink-data-prod.curated.app_session_events_full_load` e
    LEFT JOIN search_events ca ON ca.id = e.event_uuid
    left join `flink-data-prod.curated.app_sessions_full_load` s on s.session_uuid = e.session_id
    WHERE DATE(e.event_timestamp) >= "2022-01-13"
    and date(s.session_start_at) >= "2022-01-13"
    )

  , labeled_data AS(
    SELECT *
    , left(search_query_id_decoded, instr(search_query_id_decoded, ":") -1)         as search_engine
    , LEAD(search_sessions.search_query) OVER(PARTITION BY search_sessions.anonymous_id
        ORDER BY search_sessions.event_timestamp ASC) NOT LIKE CONCAT('%', search_sessions.search_query,'%')       as is_not_subquery
    , CASE WHEN search_sessions.event_name = 'product_search_executed'
           AND LEAD(search_sessions.event_name) OVER(PARTITION BY search_sessions.anonymous_id
             ORDER BY search_sessions.event_timestamp ASC) IN('product_added_to_cart', 'product_details_viewed') THEN TRUE
           ELSE FALSE END AS has_search_and_consecutive_add_to_cart_or_view_item,
    FROM search_sessions
    )

  , filtered_tracking_data AS (
    SELECT *
    , LEAD(labeled_data.event_name) OVER(PARTITION BY labeled_data.anonymous_id
         ORDER BY labeled_data.event_timestamp ASC) AS next_event
    FROM labeled_data
    )

    SELECT *
    FROM filtered_tracking_data
    WHERE is_not_subquery IS NOT FALSE
    AND search_query_clean IS NOT NULL
                ;;
  }
  ######### IDs ##########

  dimension: anonymous_id {
    group_label: "IDs"
    description: "Anonymous ID generated by Segment as user identifier"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }
  dimension: id {
    group_label: "IDs"
    label: "Event ID"
    description: "Event ID generated by Segment, unique for every tracked event"
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  ########## Device attributes #########

  dimension: context_app_version {
    group_label: "Device Dimensions"
    label: "App version"
    description: "App version used in the session"
    type: string
    sql: ${TABLE}.app_version ;;
  }
  dimension: context_device_type {
    group_label: "Device Dimensions"
    label: "Device Type"
    description: "iOS or Android"
    type: string
    sql: ${TABLE}.device_type ;;
  }
  dimension: full_app_version {
    group_label: "Device Dimensions"
    description: "Device type and app version combined in one dimension"
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }

  ########## Location attributes #########
  dimension: derived_hub {
    group_label: "Location Dimensions"
    label: "Hub code"
    description: "Hub associated with the last address the user selected"
    type: string
    hidden: no
    sql: ${TABLE}.hub_code ;;
  }
  dimension: derived_country_iso {
    hidden: no
    type: string
    sql: ${TABLE}.country_iso ;;
  }
  dimension: city_clean {
    hidden: no
    type: string
    sql: ${TABLE}.city ;;
  }

dimension: country_clean {
  group_label: "Location Dimensions"
  label: "Country ISO"
  description: "Country associated with the user's selected address or device locale"
  type: string
  case: {
    when: {
      sql: ${derived_country_iso} = "DE" ;;
      label: "Germany"
    }
    when: {
      sql: ${derived_country_iso} = "FR" ;;
      label: "France"
    }
    when: {
      sql: ${derived_country_iso} = "NL" ;;
      label: "Netherlands"
    }
    when: {
      sql: ${derived_country_iso} = "AT" ;;
      label: "Austria"
    }
    else: "Other / Unknown"
  }
}

########## Search dimensions #########
dimension: search_query {
  group_label: "Search Dimensions"
  hidden: yes
  type: string
  sql: ${TABLE}.search_query ;;
}
dimension: search_engine {
  group_label: "Search Dimensions"
  description: "Search Engine"
  hidden: no
  type: string
  sql: ${TABLE}.search_engine ;;
}
dimension: search_query_clean {
  group_label: "Search Dimensions"
  description: "String that was searched for (cast to Capitalized form)"
  type: string
  sql: ${TABLE}.search_query_clean ;;
}
dimension: search_results_total_count {
  group_label: "Search Dimensions"
  description: "# total products returned from search"
  type: number
  sql: ${TABLE}.search_results_total_count ;;
}
dimension: search_results_available_count {
  group_label: "Search Dimensions"
  description: "# products in stock returned from search"
  type: number
  sql: ${TABLE}.search_results_available_count ;;
}
dimension: search_results_unavailable_count {
  group_label: "Search Dimensions"
  description: "# products out of stock returned from search"
  type: number
  sql: ${TABLE}.search_results_unavailable_count ;;
}
dimension: has_search_and_consecutive_add_to_cart_or_view_item {
  group_label: "Search Dimensions"
  description: "Whether the search was followed by an Add To Cart of View Item Details event"
  type: string
  sql: ${TABLE}.has_search_and_consecutive_add_to_cart_or_view_item ;;
}
dimension: is_not_subquery {
  type: yesno
  hidden: yes
  sql: ${TABLE}.is_not_subquery ;;
}

########## Event Dimensions #########

dimension: event {
  group_label: "Event Dimensions"
  description: "Tracking event triggered by user"
  type: string
  sql: ${TABLE}.event_name ;;
}
dimension_group: timestamp {
  group_label: "Event Dimensions"
  description: "Time at which event was triggered"
  type: time
  sql: ${TABLE}.event_timestamp ;;
}
dimension: next_event {
  group_label: "Event Dimensions"
  description: "Given a certain event, what is the next event triggered by the user"
  type: string
  sql: ${TABLE}.next_event ;;
}
measure: count {
  description: "Counts the number of occurrences of the selected dimension(s)"
  type: count
  drill_fields: [detail*]
}

########## Search Measures #########

# measure: successful_searches {
#   group_label: "Search Measures"
#   type: sum
#   label: "Cnt Successful Searches"
#   description: "# of searches that were followed by productAddedToCart or productDetailsViewed"
#   sql:
#       CASE
#         WHEN ${next_event}="product_added_to_cart" OR ${next_event}="product_details_viewed"
#     THEN 1
#     ELSE 0
#     END;;
# }
measure: cnt_unique_anonymousid {
  group_label: "Search Measures"
  label: "# Users"
  description: "# Unique Users as identified via Anonymous ID from Segment"
  type: count_distinct
  sql: ${anonymous_id};;
  value_format_name: decimal_0
}
measure: cnt_nonzero_total_results {
  group_label: "Search Measures"
  label: "# Searches With Nonzero Results"
  description: "# searches that returned at least one product"
  type: sum
  sql: if(${search_results_total_count}>0,1,0) ;;
}
measure: cnt_zero_total_results {
  group_label: "Search Measures"
  label: "# Searches With Zero Results"
  description: "# searches that returned zero products"
  type: sum
  sql: if(${search_results_total_count}=0,1,0) ;;
}
measure: cnt_nonzero_available_results {
  group_label: "Search Measures"
  label: "# Searches With Nonzero In-Stock Results"
  description: "# searches that returned at least one available product"
  type: sum
  sql: if(${search_results_available_count}>0,1,0) ;;
}
measure: cnt_zero_available_results {
  group_label: "Search Measures"
  label: "# Searches With Zero In-Stock Results"
  description: "# searches that returned no available products"
  type: sum
  sql: if(${search_results_available_count}=0,1,0) ;;
}
measure: cnt_nonzero_only_unavailable_results {
  group_label: "Search Measures"
  label: "# Searches With Only OOS Results"
  description: "# searches that returned products, but all products were unavailable (OOS)"
  type: sum
  sql: if(${search_results_available_count}=0 AND ${search_results_total_count}>0,1,0) ;;
}

set: detail {
  fields: [
    anonymous_id,
    event,
    context_app_version,
    context_device_type,
    country_clean,
    city_clean,
    derived_hub,
    search_query_clean,
    search_results_total_count,
    search_results_available_count,
    search_results_unavailable_count,
    has_search_and_consecutive_add_to_cart_or_view_item,
    next_event
  ]
}
}
