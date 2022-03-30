view: discovery_event_categories {
    derived_table: {
      sql: WITH categories as (
              select id, anonymous_id, category_id, category_name, sub_category_id, sub_category_name,
              context_traits_hub_slug, context_device_type, context_app_version, timestamp,
              lead(timestamp) over (partition by anonymous_id order by timestamp) as next_timestamp
              from `flink-data-prod.flink_android_production.category_selected`
              where {% condition filter_event_date %} date(_PARTITIONTIME) {% endcondition %}
              qualify row_number() over(partition by id order by timestamp desc) =1

            union all
              select id, anonymous_id, category_id, category_name, sub_category_id, sub_category_name,
              context_traits_hub_slug, context_device_type, context_app_version, timestamp,
              lead(timestamp) over (partition by anonymous_id order by timestamp) as next_timestamp
              from `flink-data-prod.flink_ios_production.category_selected`
              where {% condition filter_event_date %} date(_PARTITIONTIME) {% endcondition %}
              qualify row_number() over(partition by id order by timestamp desc) =1
            )

        select *,
               left (context_traits_hub_slug, 2)             as country_iso,
               timestamp_diff(next_timestamp, timestamp, second) as timestamp_diff
        from categories
        where {% condition filter_event_date %} date(timestamp) {% endcondition %}

          ;;
    }

    ###### FILTER #####
    filter: filter_event_date {
      label: "Filter: Event Date"
      type: date
      datatype: date
    }
    dimension: event_uuid {
      primary_key: yes
      type: string
      sql: ${TABLE}.id ;;
    }
    dimension: anonymous_id {
      group_label: "IDs"
      type: string
      sql: ${TABLE}.anonymous_id ;;
    }
    dimension: category_id {
      group_label: "IDs"
      type: string
      sql: ${TABLE}.category_id ;;
    }
    dimension: sub_category_id {
      group_label: "IDs"
      type: string
      sql: ${TABLE}.sub_category_id ;;
    }
    dimension: country_iso {
      group_label: "Hub Dimensions"
      label: "Country ISO"
      type: string
      sql: ${TABLE}.country_iso ;;
    }
    dimension: hub_code {
      group_label: "Hub Dimensions"
      label: "Hub Code"
      type: string
      sql: ${TABLE}.context_traits_hub_slug ;;
    }
    dimension: device_type {
      group_label: "Device Dimensions"
      label: "Device Type"
      type: string
      sql: ${TABLE}.context_device_type ;;
    }
    dimension: app_version {
      group_label: "Device Dimensions"
      label: "App Version"
      type: string
      sql: ${TABLE}.context_app_version ;;
    }
    dimension: category_name {
      group_label: "Category Dimensions"
      type: string
      label: "Category Name"
      sql: ${TABLE}.category_name ;;
    }
    dimension: sub_category_name {
      group_label: "Category Dimensions"
      label: "Sub-Category Name"
      type: string
      sql: ${TABLE}.sub_category_name ;;
    }
    dimension: dim_timestamp_diff {
      group_label: "Category Dimensions"
      label: "#Seconds between 2 category events"
      type: number
      sql: ${TABLE}.timestamp_diff ;;
      hidden: yes
    }
    dimension_group: timestamp {
      group_label: "Timestamp Dimensions"
      type: time
      datatype: timestamp
      timeframes: [
        second,
        minute,
        hour
      ]
      sql: ${TABLE}.timestamp ;;
    }
    dimension_group: next_timestamp {
      group_label: "Timestamp Dimensions"
      type: time
      datatype: timestamp
      timeframes: [
        second,
        minute,
        hour
      ]
      sql: ${TABLE}.next_timestamp ;;
    }
    dimension_group: event_timestamp {
      group_label: "Timestamp Dimensions"
      label: "Event"
      type: time
      datatype: timestamp
      timeframes: [
        date,
        day_of_week,
        week,
        month,
        quarter,
        year
      ]
      sql: ${TABLE}.timestamp ;;
    }


    ### MEASURES

    measure: count {
      type: count
      label: "Count All"
      drill_fields: [detail*]
      hidden: yes
    }
    measure: events {
      label: "# Events"
      description: "Number of total events"
      hidden: no
      type: count_distinct
      sql: ${event_uuid} ;;
    }
    measure: cnt_unique_anonymousid {
      label: "# Unique Users"
      description: "Number of Unique Users identified via Anonymous ID from Segment"
      hidden:  no
      type: count_distinct
      sql: ${anonymous_id};;
    }
    measure: avg_event_per_user {
      label: "# Events per User (AVG)"
      description: "On average how many time a user clicks on a sub/category"
      hidden: no
      type: number
      sql: ${events}/${cnt_unique_anonymousid} ;;
      value_format_name: decimal_1
    }
    measure: timestamp_diff {
      label: "# Seconds between 2 category events"
      type: average
      sql: ${TABLE}.timestamp_diff ;;
    }

    set: detail {
      fields: [
        event_uuid,
        anonymous_id,
        country_iso,
        hub_code,
        device_type,
        app_version,
        category_name,
        sub_category_name
      ]
    }
  }
