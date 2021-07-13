view: order_order {
  sql_table_name: `flink-backend.saleor_db_global.order_order`
    ;;
  drill_fields: [core_dimensions*]
  view_label: "* Orders *"

  set: core_dimensions {
    fields: [
      country_iso,
      id,
      warehouse_name,
      created_raw,
      customer_type,
      gmv_gross,
      discount_amount,
      delivery_eta_timestamp_raw,
      delivery_timestamp_raw
    ]
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: unique_id {
    group_label: "* IDs *"
    primary_key: yes
    hidden: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: id {
    group_label: "* IDs *"
    label: "Order ID"
    primary_key: no
    hidden: no
    type: number
    sql: ${TABLE}.id ;;
    value_format_name: id
  }

  dimension: billing_address_id {
    group_label: "* IDs *"
    hidden: yes
    type: number
    sql: ${TABLE}.billing_address_id ;;
  }

  dimension: checkout_token {
    hidden: yes
    type: string
    sql: ${TABLE}.checkout_token ;;
  }

  dimension_group: now {
    group_label: "* Dates and Timestamps *"
    label: "Now"
    description: "Current Date/Time"
    type: time
    timeframes: [
      raw,
      hour_of_day,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: current_timestamp;;
    datatype: timestamp
  }

  dimension_group: created {
    group_label: "* Dates and Timestamps *"
    label: "Order"
    description: "Order Placement Date/Time"
    type: time
    timeframes: [
      raw,
      minute15,
      minute30,
      hour_of_day,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created ;;
    datatype: timestamp
  }

  dimension_group: order_date_30_min_bins {
    group_label: "* Dates and Timestamps *"
    label: "Order Date - 30 min bins"
    sql:SUBSTRING(${created_minute30}, 12, 16);;
  }

  dimension_group: time_since_sign_up {
    group_label: "* User Dimensions *"
    type: duration
    sql_start: ${user_order_facts.first_order_raw} ;;
    sql_end: ${created_raw} ;;
  }

##### helping dimensions for hiding incomplete cohorts #####
  dimension_group: time_between_sign_up_month_and_now {
    group_label: "* User Dimensions *"
    hidden: yes
    type: duration
    sql_start: DATE_TRUNC(${user_order_facts.first_order_raw}, MONTH) ;;
    sql_end: ${now_raw} ;;
  }

  dimension_group: time_between_sign_up_week_and_now {
    group_label: "* User Dimensions *"
    hidden: yes
    type: duration
    sql_start: DATE_TRUNC(${user_order_facts.first_order_raw}, WEEK) ;;
    sql_end: ${now_raw} ;;
  }


##### helping dimensions for hiding incomplete cohorts #####


  dimension: time_since_sign_up_biweekly {
    group_label: "* User Dimensions *"
    type: number
    sql: floor((${days_time_since_sign_up} / 14)) ;;
    value_format: "0"
  }

  dimension_group: time_between_hub_launch_and_order {
    group_label: "* Hub Dimensions *"
    type: duration
    sql_start: ${hub_order_facts.first_order_raw} ;;
    sql_end: ${created_raw} ;;
  }

  ######## PARAMETERS

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  parameter: KPI_parameter {
    label: "* KPI Parameter *"
    type: unquoted
    allowed_value: { value: "orders" label: "# Orders"}
    allowed_value: { value: "unique_customers" label: "# Unique Customers" }
    allowed_value: { value: "orders_existing_customers" label: "# Orders Existing Customers" }
    allowed_value: { value: "orders_new_customers" label: "# Orders New Customers"}
    allowed_value: { value: "share_of_orders_delivered_in_time" label: "% Orders Delivered In Time"}
    allowed_value: { value: "share_of_orders_delayed_5min" label: "% Orders Delayed >5min"}
    allowed_value: { value: "share_of_orders_delayed_10min" label: "% Orders Delayed >10min"}
    allowed_value: { value: "share_of_orders_delayed_15min" label: "% Orders Delayed >15min"}
    #allowed_value: { value: "share_of_total_orders" label: "% Of Total Orders"}
    allowed_value: { value: "gmv_gross" label: "GMV (Gross)"}
    allowed_value: { value: "gmv_net" label: "GMV (Net)"}
    allowed_value: { value: "revenue_gross" label: "Revenue (Gross)"}
    allowed_value: { value: "revenue_net" label: "Revenue (Net)"}
    allowed_value: { value: "discount_amount" label: "Discount Amount"}
    allowed_value: { value: "AVG_fulfillment_time" label: "AVG Fulfillment Time"}
    allowed_value: { value: "AVG_order_value_gross" label: "AVG Order Value (Gross)"}
    allowed_value: { value: "AVG_order_value_net" label: "AVG Order Value (Net)"}
    allowed_value: { value: "rider_utr" label: "Rider UTR"}
    allowed_value: { value: "picker_utr" label: "Picker UTR"}
    allowed_value: { value: "picker_hours" label: "# Picker Hours"}
    allowed_value: { value: "rider_hours" label: "# Rider Hours"}
    allowed_value: { value: "pickers" label: "# Pickers"}
    allowed_value: { value: "riders" label: "# Riders"}
    default_value: "orders"
  }

  ######## DYNAMIC DIMENSIONS

  dimension: date {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${created_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${created_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${created_month}
    {% endif %};;
  }

  measure: KPI {
    group_label: "* Dynamic KPI Fields *"
    label: "KPI - Dynamic"
    label_from_parameter: KPI_parameter
    value_format: "#,##0.00"
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'orders' %}
      ${cnt_orders}
    {% elsif KPI_parameter._parameter_value == 'unique_customers' %}
      ${cnt_unique_customers}
    {% elsif KPI_parameter._parameter_value == 'orders_existing_customers' %}
      ${cnt_unique_orders_existing_customers}
    {% elsif KPI_parameter._parameter_value == 'orders_new_customers' %}
      ${cnt_unique_orders_new_customers}
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delivered_in_time' %}
      ${pct_delivery_in_time}*100
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_5min' %}
      ${pct_delivery_late_over_5_min}*100
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_10min' %}
      ${pct_delivery_late_over_10_min}*100
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_15min' %}
      ${pct_delivery_late_over_15_min}*100
    --{% elsif KPI_parameter._parameter_value == 'share_of_total_orders' %}
    --  ${percent_of_total_orders}*100
    {% elsif KPI_parameter._parameter_value == 'gmv_gross' %}
      ${sum_gmv_gross}
    {% elsif KPI_parameter._parameter_value == 'gmv_net' %}
      ${sum_gmv_net}
    {% elsif KPI_parameter._parameter_value == 'revenue_gross' %}
      ${sum_revenue_gross}
    {% elsif KPI_parameter._parameter_value == 'revenue_net' %}
      ${sum_revenue_net}
    {% elsif KPI_parameter._parameter_value == 'discount_amount' %}
      ${sum_discount_amt}
    {% elsif KPI_parameter._parameter_value == 'AVG_fulfillment_time' %}
      ${avg_fulfillment_time}
    {% elsif KPI_parameter._parameter_value == 'AVG_order_value_gross' %}
      ${avg_order_value_gross}
    {% elsif KPI_parameter._parameter_value == 'AVG_order_value_net' %}
      ${avg_order_value_net}
    {% elsif KPI_parameter._parameter_value == 'rider_utr' %}
      ${shyftplan_riders_pickers_hours.rider_utr}
    {% elsif KPI_parameter._parameter_value == 'picker_utr' %}
      ${shyftplan_riders_pickers_hours.picker_utr}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      ${shyftplan_riders_pickers_hours.picker_hours}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      ${shyftplan_riders_pickers_hours.rider_hours}
    {% elsif KPI_parameter._parameter_value == 'pickers' %}
      ${shyftplan_riders_pickers_hours.pickers}
    {% elsif KPI_parameter._parameter_value == 'riders' %}
      ${shyftplan_riders_pickers_hours.riders}
    {% endif %};;

    html:
    {% if KPI_parameter._parameter_value == 'share_of_orders_delivered_in_time' %}
      {{ rendered_value | round: 2  | append: "%" }}
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_5min' %}
      {{ rendered_value | round: 2  | append: "%" }}
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_10min' %}
      {{ rendered_value | round: 2  | append: "%" }}
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_15min' %}
      {{ rendered_value | round: 2  | append: "%" }}
    {% elsif KPI_parameter._parameter_value == 'share_of_total_orders' %}
      {{ rendered_value | round: 2  | append: "%" }}
    {% elsif KPI_parameter._parameter_value == 'gmv_gross' %}
      €{{ value | round }}
    {% elsif KPI_parameter._parameter_value == 'gmv_net' %}
      €{{ value | round }}
    {% elsif KPI_parameter._parameter_value == 'revenue_gross' %}
      €{{ value | round }}
    {% elsif KPI_parameter._parameter_value == 'revenue_net' %}
      €{{ value | round }}
    {% elsif KPI_parameter._parameter_value == 'discount_amount' %}
      €{{ value | round }}
    {% elsif KPI_parameter._parameter_value == 'AVG_fulfillment_time' %}
      {{ rendered_value }}
    {% elsif KPI_parameter._parameter_value == 'AVG_order_value_gross' %}
      €{{ rendered_value }}
    {% elsif KPI_parameter._parameter_value == 'AVG_order_value_net' %}
      €{{ rendered_value }}
    {% elsif KPI_parameter._parameter_value == 'rider_utr' %}
      {{ rendered_value }}
    {% elsif KPI_parameter._parameter_value == 'picker_utr' %}
      {{ rendered_value }}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      {{ value | round }}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      {{ value | round }}
    {% else %}
      {{ value }}
    {% endif %};;

  }

      ######## PASS-THROUGH DIMENSIONS

      dimension: date_granularity_pass_through {
        description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
        type: string
        hidden: no # yes
        sql:
            {% if date_granularity._parameter_value == 'Day' %}
              "Day"
            {% elsif date_granularity._parameter_value == 'Week' %}
              "Week"
            {% elsif date_granularity._parameter_value == 'Month' %}
              "Month"
            {% endif %};;
      }


      dimension: currency {
        hidden: yes
        type: string
        sql: ${TABLE}.currency ;;
      }

      dimension: customer_note {
        hidden: yes
        type: string
        sql: ${TABLE}.customer_note ;;
      }

      dimension: discount_amount {
        group_label: "* Monetary Values *"
        type: number
        sql: ${TABLE}.discount_amount ;;
      }

      dimension: discount_name {
        type: string
        sql: ${TABLE}.discount_name ;;
      }

      dimension: display_gross_prices {
        hidden: yes
        type: yesno
        sql: ${TABLE}.display_gross_prices ;;
      }

      dimension: language_code {
        hidden: yes
        type: string
        sql: ${TABLE}.language_code ;;
      }

      dimension: metadata {
        type: string
        sql: ${TABLE}.metadata ;;
      }

      dimension: private_metadata {
        hidden: yes
        type: string
        sql: ${TABLE}.private_metadata ;;
      }

      dimension: shipping_address_id {
        group_label: "* IDs *"
        hidden: yes
        type: number
        sql: ${TABLE}.shipping_address_id ;;
      }

      dimension: shipping_method_id {
        group_label: "* IDs *"
        hidden: yes
        type: number
        sql: ${TABLE}.shipping_method_id ;;
      }

      dimension: shipping_method_name {
        hidden: yes
        type: string
        sql: ${TABLE}.shipping_method_name ;;
      }

      dimension: shipping_price_gross_amount {
        group_label: "* Monetary Values *"
        type: number
        sql: ${TABLE}.shipping_price_gross_amount ;;
      }

      dimension: shipping_price_net_amount {
        group_label: "* Monetary Values *"
        type: number
        sql: ${TABLE}.shipping_price_net_amount ;;
      }

      dimension: status {
        type: string
        sql: ${TABLE}.status ;;
      }

      dimension: token {
        type: string
        sql: ${TABLE}.token ;;
      }

      dimension: total_gross_amount {
        group_label: "* Monetary Values *"
        type: number
        sql: ${TABLE}.total_gross_amount ;;
      }

      dimension: total_net_amount {
        group_label: "* Monetary Values *"
        type: number
        sql: ${TABLE}.total_net_amount ;;
      }

      dimension: gmv_gross {
        group_label: "* Monetary Values *"
        type: number
        sql: ${TABLE}.total_gross_amount + ${discount_amount} ;;
      }

      dimension: gmv_gross_tier {
        group_label: "* Monetary Values *"
        type: tier
        tiers: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70]
        style: relational
        sql: ${TABLE}.total_gross_amount + ${discount_amount} ;;
      }

      dimension: gmv_gross_tier_5 {
        group_label: "* Monetary Values *"
        type: tier
        tiers: [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70]
        style: relational
        sql: ${TABLE}.total_gross_amount + ${discount_amount} ;;
      }

      dimension: gmv_net {
        group_label: "* Monetary Values *"
        type: number
        sql: ${TABLE}.total_net_amount  + ${discount_amount};;
      }

      dimension: tracking_client_id {
        group_label: "* IDs *"
        hidden: yes
        type: string
        sql: ${TABLE}.tracking_client_id ;;
      }

      dimension: translated_discount_name {
        hidden: yes
        type: string
        sql: ${TABLE}.translated_discount_name ;;
      }

      dimension: user_email {
        group_label: "* User Dimensions *"
        type: string
        sql: ${TABLE}.user_email ;;
      }

      dimension: user_id {
        group_label: "* User Dimensions *"
        type: number
        hidden: yes
        sql: ${TABLE}.user_id ;;
      }

      dimension: voucher_id {
        group_label: "* IDs *"
        type: number
        hidden: yes
        sql: ${TABLE}.voucher_id ;;
      }

      dimension: weight {
        hidden: yes
        type: number
        sql: ${TABLE}.weight ;;
      }

      dimension: warehouse_name {
        group_label: "* Hub Dimensions *"
        type: string
        sql:  CASE WHEN JSON_EXTRACT_SCALAR(${metadata}, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
              WHEN JSON_EXTRACT_SCALAR(${metadata}, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
              ELSE JSON_EXTRACT_SCALAR(${metadata}, '$.warehouse')
          END ;;
      }

      dimension: customer_type {
        group_label: "* User Dimensions *"
        type: string
        sql: CASE WHEN ${TABLE}.id = ${user_order_facts.first_order_id} THEN 'New Customer' ELSE 'Existing Customer' END ;;
      }

      dimension: customer_location {
        group_label: "* User Dimensions *"
        type: location
        sql_latitude: ROUND( CAST( SPLIT((JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryCoordinates')), ',')[ORDINAL(1)] AS FLOAT64), 7);;
        sql_longitude: ROUND( CAST( SPLIT((JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryCoordinates')), ',')[ORDINAL(2)] AS FLOAT64), 7) ;;
      }

      dimension: hub_location  {
        group_label: "* Hub Dimensions *"
        type: location
        sql_latitude: ${hubs.latitude};;
        sql_longitude: ${hubs.longitude};;
      }

      dimension: delivery_distance_m {
        group_label: "* Operations / Logistics *"
        type: distance
        units: meters
        start_location_field: order_order.hub_location
        end_location_field: order_order.customer_location
      }

      dimension: delivery_distance_km {
        group_label: "* Operations / Logistics *"
        type: distance
        units: kilometers
        start_location_field: order_order.hub_location
        end_location_field: order_order.customer_location
      }

      dimension: delivery_distance_tier {
        group_label: "* Operations / Logistics *"
        type: tier
        tiers: [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 4.0]
        style: interval
        sql: ${delivery_distance_km} ;;
      }

      dimension: delivery_eta_minutes {
        group_label: "* Operations / Logistics *"
        label: "Delivery PDT (min)"
        type: number
        sql: CAST(REGEXP_REPLACE(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryETA'),'[^0-9 ]','') AS INT64) ;;
      }

      dimension_group: delivery_eta_timestamp {
        group_label: "* Dates and Timestamps *"
        label: "Delivery PDT Date/Timestamp"
        type: time
        timeframes: [
          raw,
          minute15,
          minute30,
          hour_of_day,
          time,
          date,
          week,
          month,
          quarter,
          year
        ]
        sql: TIMESTAMP_ADD(${created_raw}, INTERVAL CAST(REGEXP_REPLACE(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryETA'),'[^0-9 ]','') AS INT64) MINUTE) ;;
      }

      dimension: delivery_delay_tier {
        group_label: "* Operations / Logistics *"
        type: tier
        tiers: [-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        style: interval
        sql: ${delivery_delay_since_eta} ;;
      }

      dimension_group: delivery_timestamp {
        group_label: "* Dates and Timestamps *"
        label: "Delivery Date/Timestamp"
        type: time
        timeframes: [
          raw,
          hour_of_day,
          time,
          date,
          week,
          month,
          quarter,
          year
        ]
        sql: TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryTime')) ;;
      }

      dimension_group: tracking_timestamp {
        group_label: "* Dates and Timestamps *"
        label: "Tracking Date/Timestamp"
        type: time
        timeframes: [
          raw,
          hour_of_day,
          time,
          date,
          week,
          month,
          quarter,
          year
        ]
        sql: TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.trackingTimestamp')) ;;
      }

      dimension: delivery_delay_since_eta {
        group_label: "* Operations / Logistics *"
        label: "Delta to PDT (min)"
        type: duration_minute
        sql_start: ${delivery_eta_timestamp_raw};;
        sql_end: ${delivery_timestamp_raw};;
      }

      dimension: delivery_time {
        group_label: "* Operations / Logistics *"
        type: number
        hidden: yes
        sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryTime')), TIMESTAMP(JSON_EXTRACT_SCALAR(${TABLE}.metadata, '$.trackingTimestamp')), SECOND) / 60 ;;
      }

      dimension: reaction_time {
        group_label: "* Operations / Logistics *"
        type: number
        hidden: yes
        sql: TIMESTAMP_DIFF(${order_fulfillment.created_raw},${created_raw}, SECOND) / 60 ;;
      }

      dimension: acceptance_time {
        group_label: "* Operations / Logistics *"
        type: number
        hidden: yes
        sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.trackingTimestamp')),${order_fulfillment.created_raw}, SECOND) / 60 ;;
      }

      dimension: fulfillment_time {
        group_label: "* Operations / Logistics *"
        type: number
        value_format_name: decimal_1
        sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryTime')),${created_raw}, SECOND) / 60 ;;
      }

      dimension: fulfillment_time_tier {
        group_label: "* Operations / Logistics *"
        type: tier
        tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
        style: interval
        sql: ${fulfillment_time} ;;
      }

      dimension: time_diff_between_two_subsequent_fulfillments {
        group_label: "* Operations / Logistics *"
        type: number
        sql: TIMESTAMP_DIFF(TIMESTAMP(leading_order_fulfillment_created_time), ${order_fulfillment.created_raw}, SECOND) / 60 ;;
      }

      dimension: is_internal_order {
        group_label: "* Order Status / Type *"
        type: yesno
        sql: ${user_email} LIKE '%goflink%' OR ${user_email} LIKE '%pickery%' OR LOWER(${user_email}) IN ('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com', 'alenaschneck@gmx.de', 'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com', 'fabian.hardenberg@gmail.com', 'benjamin.zagel@gmail.com');;
      }

      dimension: is_voucher_order {
        group_label: "* Order Status / Type *"
        type: yesno
        sql: ${discount_amount} > 0 ;;
      }
      dimension: is_successful_order {
        group_label: "* Order Status / Type *"
        type: yesno
        sql: ${status} IN ('fulfilled', 'partially fulfilled');;
      }

      dimension: is_fulfillment_less_than_1_minute {
        hidden: yes
        group_label: "* Operations / Logistics *"
        type: yesno
        sql: ${fulfillment_time} < 1 ;;
      }

      dimension: is_fulfillment_more_than_30_minute {
        hidden: yes
        group_label: "* Operations / Logistics *"
        type: yesno
        sql: ${fulfillment_time} > 30 ;;
      }

      dimension: is_acceptance_less_than_0_minute {
        hidden: yes
        group_label: "* Operations / Logistics *"
        type: yesno
        sql: ${acceptance_time} < 0 ;;
      }

      dimension: is_acceptance_more_than_30_minute {
        hidden: yes
        group_label: "* Operations / Logistics *"
        type: yesno
        sql: ${acceptance_time} > 30 ;;
      }

      dimension: is_reaction_less_than_0_minute {
        hidden: yes
        group_label: "* Operations / Logistics *"
        type: yesno
        sql: ${reaction_time} < 0 ;;
      }

      dimension: is_reaction_more_than_30_minute {
        hidden: yes
        group_label: "* Operations / Logistics *"
        type: yesno
        sql: ${reaction_time} > 30 ;;
      }

      dimension: is_delivery_less_than_0_minute {
        hidden: yes
        group_label: "* Operations / Logistics *"
        type: yesno
        sql: ${delivery_time} < 0 ;;
      }

      dimension: is_delivery_more_than_30_minute {
        hidden: yes
        group_label: "* Operations / Logistics *"
        type: yesno
        sql: ${delivery_time} > 30 ;;
      }

      dimension: is_picking_less_than_0_minute {
        hidden: yes
        group_label: "* Operations / Logistics *"
        type: yesno
        sql: ${time_diff_between_two_subsequent_fulfillments} < 0 ;;
      }

      dimension: is_picking_more_than_30_minute {
        hidden: yes
        group_label: "* Operations / Logistics *"
        type: yesno
        sql: ${time_diff_between_two_subsequent_fulfillments} > 30 ;;
      }

      dimension: is_delivery_eta_available {
        group_label: "* Operations / Logistics *"
        type: yesno
        sql: IF(${delivery_eta_minutes} IS NULL, FALSE, TRUE)  ;;
      }

      dimension: is_customer_location_available {
        group_label: "* Operations / Logistics *"
        type: yesno
        sql: IF(${customer_location::latitude} IS NULL, FALSE, TRUE)  ;;
      }

      dimension: is_business_week_completed {
        group_label: "* Dates and Timestamps *"
        type: yesno
        sql:  CASE WHEN ${now_day_of_week} = 'Sunday'
              THEN IF (${created_week} <= ${now_week}, TRUE, FALSE)
              ELSE IF (${created_week} < ${now_week}, TRUE, FALSE)
          END
              ;;
      }

      dimension: is_delivery_distance_over_10km {
        group_label: "* Operations / Logistics *"
        type: yesno
        sql: IF(${delivery_distance_km} > 10, TRUE, FALSE);;
      }


##############
## AVERAGES ##
##############

      measure: avg_promised_eta {
        group_label: "* Operations / Logistics *"
        label: "AVG PDT"
        description: "Average Promised Fulfillment Time (PDT)"
        hidden:  no
        type: average
        sql: ${delivery_eta_minutes};;
        value_format: "0.0"
      }

      measure: avg_fulfillment_time {
        group_label: "* Operations / Logistics *"
        label: "AVG Fulfillment Time (decimal)"
        description: "Average Fulfillment Time (decimal minutes) considering order placement to delivery. Outliers excluded (<1min or >30min)"
        hidden:  no
        type: average
        sql: ${fulfillment_time};;
        value_format: "0.0"
        filters: [is_fulfillment_less_than_1_minute: "no", is_fulfillment_more_than_30_minute: "no"]
      }

      measure: avg_fulfillment_time_mm_ss {
        group_label: "* Operations / Logistics *"
        label: "AVG Fulfillment Time (MM:SS)"
        description: "Average Fulfillment Time considering order placement to delivery. Outliers excluded (<1min or >30min)"
        type: average
        sql: ${fulfillment_time} * 60 / 86400.0;;
        value_format: "mm:ss"
        filters: [is_fulfillment_less_than_1_minute: "no", is_fulfillment_more_than_30_minute: "no"]
      }

      measure: avg_delivery_time {
        group_label: "* Operations / Logistics *"
        label: "AVG Delivery Time"
        description: "Average Delivery Time considering delivery start to delivery completion. Outliers excluded (<0min or >30min)"
        hidden:  no
        type: average
        sql: ${delivery_time};;
        value_format: "0.0"
        filters: [is_delivery_less_than_0_minute: "no", is_delivery_more_than_30_minute: "no"]
      }

      measure: avg_reaction_time {
        group_label: "* Operations / Logistics *"
        label: "AVG Reaction Time"
        description: "Average Reaction Time of the Picker considering order placement to first fulfillment created. Outliers excluded (<0min or >30min)"
        hidden:  no
        type: average
        sql:${reaction_time};;
        value_format: "0.0"
        filters: [order_fulfillment_facts.is_first_fulfillment: "yes", is_reaction_less_than_0_minute: "no", is_reaction_more_than_30_minute: "no"]
      }

      measure: avg_picking_time {
        group_label: "* Operations / Logistics *"
        label: "AVG Picking Time"
        description: "Average Picking Time considering first fulfillment to second fulfillment created. Outliers excluded (<0min or >30min)"
        hidden:  no
        type: average
        sql:${time_diff_between_two_subsequent_fulfillments};;
        value_format: "0.0"
        filters: [order_fulfillment_facts.is_first_fulfillment: "yes", is_picking_less_than_0_minute: "no", is_picking_more_than_30_minute: "no"]
      }

      measure: avg_acceptance_time {
        group_label: "* Operations / Logistics *"
        label: "AVG Acceptance Time"
        description: "Average Acceptance Time of the Rider considering second fulfillment created until Tracking Timestamp. Outliers excluded (<0min or >30min)"
        hidden:  no
        type: average
        sql:${acceptance_time};;
        value_format: "0.0"
        filters: [order_fulfillment_facts.is_second_fulfillment: "yes", is_acceptance_less_than_0_minute: "no", is_acceptance_more_than_30_minute: "no"]
      }

      measure: avg_order_value_gross {
        group_label: "* Monetary Values *"
        label: "AVG Order Value (Gross)"
        description: "Average value of orders considering total gross order values. Includes fees (gross), before deducting discounts."
        hidden:  no
        type: average
        sql: ${gmv_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_order_value_net {
        group_label: "* Monetary Values *"
        label: "AVG Order Value (Net)"
        description: "Average value of orders considering total net order values. Includes fees (net), before deducting discounts."
        hidden:  no
        type: average
        sql: ${gmv_net};;
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_product_value_gross {
        group_label: "* Monetary Values *"
        label: "AVG Product Value (Gross)"
        description: "Average value of product items (incl. VAT). Excludes fees (gross), before deducting discounts."
        hidden:  no
        type: average
        sql: ${gmv_gross} - ${shipping_price_gross_amount};;
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_product_value_net {
        group_label: "* Monetary Values *"
        label: "AVG Product Value (Net)"
        description: "Average value of product items (excl. VAT). Excludes fees (net), before deducting discounts."
        hidden:  no
        type: average
        sql: ${gmv_net} - ${shipping_price_net_amount};;
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_delivery_fee_gross {
        group_label: "* Monetary Values *"
        label: "AVG Delivery Fee (Gross)"
        description: "Average value of Delivery Fees (Gross)"
        hidden:  no
        type: average
        sql: ${shipping_price_gross_amount};;
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_delivery_fee_net {
        group_label: "* Monetary Values *"
        label: "AVG Delivery Fee (Net)"
        description: "Average value of Delivery Fees (Net)"
        hidden:  no
        type: average
        sql: ${shipping_price_net_amount};;
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_delivery_distance_km {
        group_label: "* Operations / Logistics *"
        label: "AVG Delivery Distance (km)"
        description: "Average distance between hub and customer dropoff (most direct path / straight line)"
        hidden:  no
        type: average
        sql: ${delivery_distance_km};;
        value_format: "0.00"
        filters: [is_delivery_distance_over_10km: "no"]
      }

##########
## SUMS ##
##########

      measure: sum_gmv_gross {
        group_label: "* Monetary Values *"
        label: "SUM GMV (Gross)"
        description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (incl. VAT)"
        hidden:  no
        type: sum
        sql: ${gmv_gross};;
        value_format_name: euro_accounting_0_precision
      }

      measure: sum_gmv_net {
        group_label: "* Monetary Values *"
        label: "SUM GMV (Net)"
        description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (excl. VAT)"
        hidden:  no
        type: sum
        sql: ${gmv_net};;
        value_format_name: euro_accounting_0_precision
      }

      measure: sum_revenue_gross {
        group_label: "* Monetary Values *"
        label: "SUM Revenue (gross)"
        description: "Sum of Revenue (GMV after subsidies) incl. VAT"
        hidden:  no
        type: sum
        sql: ${total_gross_amount};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_revenue_net {
        group_label: "* Monetary Values *"
        label: "SUM Revenue (Net)"
        description: "Sum of Revenue (GMV after subsidies) excl. VAT"
        hidden:  no
        type: sum
        sql: ${total_net_amount};;
        value_format_name: euro_accounting_0_precision
      }

      measure: sum_discount_amt {
        group_label: "* Monetary Values *"
        label: "SUM Discount Amount"
        description: "Sum of Discount amount applied on orders"
        hidden:  no
        type: sum
        sql: ${discount_amount};;
        value_format_name: euro_accounting_0_precision
      }

      measure: sum_delivery_fee_gross {
        group_label: "* Monetary Values *"
        label: "SUM Delivery Fee (Gross)"
        description: "Sum of Delivery Fees (Gross) paid by Customers"
        hidden:  no
        type: sum
        sql: ${shipping_price_gross_amount};;
        value_format_name: euro_accounting_0_precision
      }

      measure: sum_delivery_fee_net {
        group_label: "* Monetary Values *"
        label: "SUM Delivery Fee (Net)"
        description: "Sum of Delivery Fees (Net) paid by Customers"
        hidden:  no
        type: sum
        sql: ${shipping_price_net_amount};;
        value_format_name: euro_accounting_0_precision
      }

############
## COUNTS ##
############

      measure: cnt_unique_customers {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Unique Customers"
        description: "Count of Unique Customers identified via their Email"
        hidden:  no
        type: count_distinct
        sql: ${user_email};;
        value_format: "0"
      }

      measure: cnt_unique_customers_with_voucher {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Unique Customers (with Voucher)"
        description: "Count of Unique Customers identified via their Email (only considering orders with a voucher)"
        hidden:  no
        type: count_distinct
        sql: ${user_email};;
        filters: [discount_amount: ">0"]
        value_format: "0"
      }

      measure: cnt_unique_customers_without_voucher {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Unique Customers (without Voucher)"
        description: "Count of Unique Customers identified via their Email (not considering orders with a voucher)"
        hidden:  no
        type: count_distinct
        sql: ${user_email};;
        filters: [discount_amount: "0 OR null"]
        value_format: "0"
      }

      measure: cnt_unique_hubs {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Unique Hubs"
        description: "Count of Unique Hubs which received orders"
        hidden:  no
        type: count_distinct
        sql: ${warehouse_name};;
        value_format: "0"
      }

      measure: cnt_orders {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Orders"
        description: "Count of successful Orders"
        hidden:  no
        type: count
        value_format: "0"
      }

      measure: cnt_orders_with_discount {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Orders with Discount"
        description: "Count of successful Orders with some Discount applied"
        hidden:  no
        type: count
        filters: [discount_amount: ">0"]
        value_format: "0"
      }

      measure: cnt_orders_without_discount {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Orders without Discount"
        description: "Count of successful Orders with no Discount applied"
        hidden:  no
        type: count
        filters: [discount_amount: "0 OR null"]
        value_format: "0"
      }

      measure: cnt_unique_orders_new_customers {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Orders New Customers"
        description: "Count of successful Orders placed by new customers (Acquisitions)"
        hidden:  no
        type: count
        value_format: "0"
        filters: [customer_type: "New Customer"]
      }

      measure: cnt_unique_orders_existing_customers {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Orders Existing Customers"
        description: "Count of successful Orders placed by returning customers"
        hidden:  no
        type: count
        value_format: "0"
        filters: [customer_type: "Existing Customer"]
      }

      measure: cnt_orders_with_delivery_eta_available {
        # group_label: "* Operations / Logistics *"
        view_label: "* Hubs *"
        group_label: "Hub Leaderboard - Order Metrics"
        label: "# Orders with Delivery ETA available"
        description: "Count of Orders where a promised ETA is available"
        hidden:  no
        type: count
        filters: [is_delivery_eta_available: "yes"]
        value_format: "0"
      }

      measure: cnt_orders_delayed_under_0_min {
        # group_label: "* Operations / Logistics *"
        view_label: "* Hubs *"
        group_label: "Hub Leaderboard - Order Metrics"
        label: "# Orders delivered in time"
        description: "Count of Orders delivered no later than promised ETA"
        hidden:  no
        type: count
        filters: [delivery_delay_since_eta:"<=0"]
        value_format: "0"
      }

      measure: cnt_orders_delayed_over_5_min {
        # group_label: "* Operations / Logistics *"
        view_label: "* Hubs *"
        group_label: "Hub Leaderboard - Order Metrics"
        label: "# Orders delivered late >5min"
        description: "Count of Orders delivered >5min later than promised ETA"
        hidden:  no
        type: count
        filters: [delivery_delay_since_eta:">=5"]
        value_format: "0"
      }

      measure: cnt_orders_delayed_over_10_min {
        group_label: "* Operations / Logistics *"
        label: "# Orders delivered late >10min"
        description: "Count of Orders delivered >10min later than promised ETA"
        hidden:  yes
        type: count
        filters: [delivery_delay_since_eta:">=10"]
        value_format: "0"
      }

      measure: cnt_orders_delayed_over_15_min {
        group_label: "* Operations / Logistics *"
        label: "# Orders delivered late >15min"
        description: "Count of Orders delivered >15min later than promised ETA"
        hidden:  yes
        type: count
        filters: [delivery_delay_since_eta:">=15"]
        value_format: "0"
      }

################
## PERCENTAGE ##
################

      measure: pct_acquisition_share {
        group_label: "* Marketing *"
        label: "% Acquisition Share"
        description: "Share of New Customer Acquisitions over Total Orders"
        hidden:  no
        type: number
        sql: ${cnt_unique_orders_new_customers} / NULLIF(${cnt_orders}, 0);;
        value_format: "0%"
      }

      measure: pct_discount_order_share {
        group_label: "* Marketing *"
        label: "% Discount Order Share"
        description: "Share of Orders which had some Discount applied"
        hidden:  no
        type: number
        sql: ${cnt_orders_with_discount} / NULLIF(${cnt_orders}, 0);;
        value_format: "0%"
      }

      measure: pct_discount_value_of_gross_total{
        group_label: "* Marketing *"
        label: "% Discount Value Share"
        description: "Dividing Total Discount amounts over GMV"
        hidden:  no
        type: number
        sql: ${sum_discount_amt} / NULLIF(${sum_gmv_gross}, 0);;
        value_format: "0%"
      }

      measure: pct_delivery_in_time{
        group_label: "* Operations / Logistics *"
        label: "% Orders delivered in time"
        description: "Share of orders delivered no later than promised ETA (only orders with valid ETA time considered)"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_under_0_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
        value_format: "0%"
      }

      measure: pct_delivery_late_over_5_min{
        group_label: "* Operations / Logistics *"
        label: "% Orders delayed >5min"
        description: "Share of orders delivered >5min later than promised ETA (only orders with valid ETA time considered)"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_over_5_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
        value_format: "0%"
      }

      measure: pct_delivery_late_over_10_min{
        group_label: "* Operations / Logistics *"
        label: "% Orders delayed >10min"
        description: "Share of orders delivered >10min later than promised ETA (only orders with valid ETA time considered)"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_over_10_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
        value_format: "0%"
      }

      measure: pct_delivery_late_over_15_min{
        group_label: "* Operations / Logistics *"
        label: "% Orders delayed >15min"
        description: "Share of orders delivered >15min later than promised ETA (only orders with valid ETA time considered)"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_over_15_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
        value_format: "0%"
      }

      measure: percent_of_total_orders {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "% Of Total Orders"
        direction: "column"
        type: percent_of_total
        sql: ${cnt_orders} ;;
      }

      set: exclude_dims_as_that_cross_reference {
        fields: [
          years_time_since_sign_up,
          quarters_time_since_sign_up,
          months_time_since_sign_up,
          weeks_time_since_sign_up,
          days_time_since_sign_up,
          hours_time_since_sign_up,
          minutes_time_since_sign_up,
          seconds_time_since_sign_up,
          years_time_between_sign_up_month_and_now,
          quarters_time_between_sign_up_month_and_now,
          months_time_between_sign_up_month_and_now,
          weeks_time_between_sign_up_month_and_now,
          days_time_between_sign_up_month_and_now,
          hours_time_between_sign_up_month_and_now,
          minutes_time_between_sign_up_month_and_now,
          years_time_between_sign_up_week_and_now,
          seconds_time_between_sign_up_month_and_now,
          quarters_time_between_sign_up_week_and_now,
          months_time_between_sign_up_week_and_now,
          weeks_time_between_sign_up_week_and_now,
          days_time_between_sign_up_week_and_now,
          hours_time_between_sign_up_week_and_now,
          minutes_time_between_sign_up_week_and_now,
          seconds_time_between_sign_up_week_and_now,
          years_time_between_hub_launch_and_order,
          quarters_time_between_hub_launch_and_order,
          months_time_between_hub_launch_and_order,
          weeks_time_between_hub_launch_and_order,
          days_time_between_hub_launch_and_order,
          hours_time_between_hub_launch_and_order,
          minutes_time_between_hub_launch_and_order,
          seconds_time_between_hub_launch_and_order,
          customer_type,
          KPI,
          reaction_time,
          acceptance_time,
          time_diff_between_two_subsequent_fulfillments,
          avg_picking_time,
          avg_acceptance_time,
          hub_location,
          cnt_unique_orders_existing_customers,
          cnt_unique_orders_new_customers,
          avg_reaction_time,
          delivery_distance_m,
          delivery_distance_km

        ]
      }
    }
