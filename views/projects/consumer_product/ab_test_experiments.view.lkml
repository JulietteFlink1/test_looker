    view: ab_test_experiments {
      derived_table: {
        persist_for: "1 hour"
        sql:
        SELECT anonymous_id,
               id,
               context_app_version                                                        AS app_version,
               context_device_type                                                        AS device_type,
               event                                                                      AS event_name,
               search_query,
               null                                                                       AS list_category,
               search_experiment_variant,
               CASE WHEN search_experiment_variant like '%variant_control%'
                    THEN true ELSE false END                                              AS control_group,
               CASE WHEN search_experiment_variant like '%variant_experiment%'
                    THEN true ELSE false END                                              AS experiment_group,
               DATE(timestamp)                                                            AS event_start_at,
               timestamp
        FROM (
              SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY loaded_at DESC)       AS row_id
              FROM `flink-data-prod.flink_ios_production.product_search_executed`
              WHERE DATE(_PARTITIONTIME) > "2021-09-30" and search_experiment_variant is not null
              )
        WHERE row_id = 1

  UNION ALL
        SELECT anonymous_id,
               id,
               context_app_version                                                        AS app_version,
               context_device_type                                                        AS device_type,
               event                                                                      AS event_name,
               null                                                                       AS search_query,
               list_category,
               search_experiment_variant,
               CASE WHEN search_experiment_variant like '%variant_control%'
                    THEN true ELSE false END                                              AS control_group,
               CASE WHEN search_experiment_variant like '%variant_experiment%'
                    THEN true ELSE false END                                              AS experiment_group,
               DATE(timestamp)                                                            AS event_start_at,
               timestamp
        FROM (
              SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY loaded_at DESC)       AS row_id
              FROM `flink-data-prod.flink_ios_production.product_added_to_cart`
              WHERE DATE(_PARTITIONTIME) > "2021-09-30" and search_experiment_variant is not null
              )
        WHERE row_id = 1

  UNION ALL
        SELECT anonymous_id,
               id,
               context_app_version                                                        AS app_version,
               context_device_type                                                        AS device_type,
               event                                                                      AS event_name,
               null                                                                       AS search_query,
               list_category,
               search_experiment_variant,
               CASE WHEN search_experiment_variant like '%variant_control%'
                    THEN true ELSE false END                                              AS control_group,
               CASE WHEN search_experiment_variant like '%variant_experiment%'
                    THEN true ELSE false END                                              AS experiment_group,
               DATE(timestamp)                                                            AS event_start_at,
               timestamp
        FROM (
              SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY loaded_at DESC)       AS row_id
              FROM `flink-data-prod.flink_ios_production.product_details_viewed`
              WHERE DATE(_PARTITIONTIME) > "2021-09-30" and search_experiment_variant is not null
              )
        WHERE row_id = 1
           ;;
      }

      ######### custom measures and dimensions

      measure: cnt_unique_anonymousid {
        label: "# Unique Users"
        description: "Number of Unique Users identified via Anonymous ID from Segment"
        hidden:  no
        type: count_distinct
        sql: ${anonymous_id};;
        value_format_name: decimal_0
      }

      measure: count {
        label: "# Events"
        type: count
        drill_fields: [detail*]
      }

      ## Measures based on other measures

      # measure: mcvr2 {
      #   type: number
      #   label: "mCVR2"
      #   description: "# sessions in which there was a Product Added To Cart, compared to the number of sessions in which there was a Home Viewed"
      #   value_format_name: percent_1
      #   sql: ${cnt_add_to_cart}/NULLIF(${cnt_has_address},0) ;;
      # }

      # measure: mcvr2_cart{
      #   type: number
      #   label: "mCVR2 Cart"
      #   description: "# sessions in which there was a Product Added To Cart from Cart, compared to the number of sessions in which there was a Home Viewed"
      #   value_format_name: percent_1
      #   sql: ${cnt_cart_cart}/NULLIF(${cnt_has_address},0) ;;
      # }
      # measure: mcvr2_favourites {
      #   type: number
      #   label: "mCVR2 Favourites "
      #   description: "# sessions in which there was a Product Added To Cart from Favourites, compared to the number of sessions in which there was a Home Viewed"
      #   value_format_name: percent_1
      #   sql: ${cnt_cart_favourites}/NULLIF(${cnt_has_address},0) ;;
      # }
      # measure: mcvr2_pdp {
      #   type: number
      #   label: "mCVR2 PDP"
      #   description: "# sessions in which there was a Product Added To Cart from PDP, compared to the number of sessions in which there was a Home Viewed"
      #   value_format_name: percent_1
      #   sql: ${cnt_cart_pdp}/NULLIF(${cnt_has_address},0) ;;
      # }
      # measure: mcvr2_last_bought {
      #   type: number
      #   label: "mCVR2 Last Bought"
      #   description: "# sessions in which there was a Product Added To Cart from Last Bought, compared to the number of sessions in which there was a Home Viewed"
      #   value_format_name: percent_1
      #   sql: ${cnt_cart_last_bought}/NULLIF(${cnt_has_address},0) ;;
      # }
      # measure: mcvr2_search {
      #   type: number
      #   label: "mCVR2 Search"
      #   description: "# sessions in which there was a Product Added To Cart from Search, compared to the number of sessions in which there was a Home Viewed"
      #   value_format_name: percent_1
      #   sql: ${cnt_cart_search}/NULLIF(${cnt_has_address},0) ;;
      # }

      # measure: mcvr2_swimlane {
      #   type: number
      #   label: "mCVR2 Swimlane"
      #   description: "# sessions in which there was a Product Added To Cart from Swimlane, compared to the number of sessions in which there was a Home Viewed"
      #   value_format_name: percent_1
      #   sql: ${cnt_cart_swimlane}/NULLIF(${cnt_has_address},0) ;;
      # }

      # measure: mcvr2_category {
      #   type: number
      #   label: "mCVR2 Category"
      #   description: "# sessions in which there was a Product Added To Cart from Category, compared to the number of sessions in which there was a Home Viewed"
      #   value_format_name: percent_1
      #   sql: ${cnt_cart_category}/NULLIF(${cnt_has_address},0) ;;
      # }

      ######### DIMENSIONS

      dimension_group: session_start_at {
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
        sql: ${TABLE}.timestamp ;;
      }

      dimension: session_start_date_granularity {
        label: "Session Start Date (Dynamic)"
        label_from_parameter: timeframe_picker
        type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
        sql:
            {% if timeframe_picker._parameter_value == 'Hour' %}
              ${session_start_at_hour}
            {% elsif timeframe_picker._parameter_value == 'Day' %}
              ${session_start_at_date}
            {% elsif timeframe_picker._parameter_value == 'Week' %}
              ${session_start_at_week}
            {% elsif timeframe_picker._parameter_value == 'Month' %}
              ${session_start_at_month}
            {% endif %};;
      }

      parameter: timeframe_picker {
        label: "Session Start Date Granular"
        type: unquoted
        allowed_value: { value: "Hour" }
        allowed_value: { value: "Day" }
        allowed_value: { value: "Week" }
        allowed_value: { value: "Month" }
        default_value: "Day"
      }

      dimension: anonymous_id {
        type: string
        sql: ${TABLE}.anonymous_id ;;
      }

      dimension: app_version {
        type: string
        sql: ${TABLE}.app_version ;;
      }

      dimension: device_type {
        type: string
        sql: ${TABLE}.device_type ;;
      }

      dimension: event_id {
        type: string
        sql: ${TABLE}.id ;;
      }

      dimension: event_name {
        type: string
        sql: ${TABLE}.event_name ;;
      }

      dimension: search_query {
        type: string
        sql: ${TABLE}.search_query ;;
      }

      dimension: list_position {
        type: string
        sql: ${TABLE}.list_category ;;
      }

      dimension: search_experiment_variant {
        type: string
        sql: ${TABLE}.search_experiment_variant ;;
      }

      dimension: control_group {
        type: yesno
        sql: ${TABLE}.control_group ;;
      }

      dimension: experiment_group {
        type: yesno
        sql: ${TABLE}.experiment_group ;;
      }

      dimension: event_start_at {
        type: date
        sql: ${TABLE}.event_start_at ;;
      }


      set: detail {
        fields: [
          anonymous_id,
          app_version,
          device_type,
          event_start_at,
          session_start_at_date,
          event_name,
          list_position,
          search_experiment_variant,
          control_group,
          experiment_group
        ]
      }
    }
