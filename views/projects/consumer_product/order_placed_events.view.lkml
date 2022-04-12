view: order_placed_events {
## all ios and android orders tracked from client side. includes country_iso by using hub_city to lookup country on hubs_metadata gsheet
  derived_table: {
    sql:
    WITH help_tb AS (
    SELECT *
    FROM (
      SELECT
          ios_orders.id,
          ios_orders.order_id, -- in curated layer orders.token used for CT orders to make order_uuid (country+token)
          ios_orders.order_number, -- in curated layer orders.view used for Saleor orders to make order_uuid (country+number)
          ios_orders.anonymous_id,
          ios_orders.context_app_version,
          ios_orders.context_app_name,
          ios_orders.context_device_type,
          ios_orders.hub_city,
          ios_orders.payment_method,
          ios_orders.revenue as revenue,
          ios_orders.flag_rider_tip as flag_rider_tip,
          ios_orders.rider_tip_value as rider_tip_value,
          ios_orders.timestamp,
          ROW_NUMBER() OVER(PARTITION BY order_number ORDER BY timestamp ASC) AS row_id
        FROM
          `flink-data-prod.flink_ios_production.order_placed_view` ios_orders
        WHERE
            NOT (LOWER(ios_orders.context_app_version) LIKE "%app-rating%" OR LOWER(ios_orders.context_app_version) LIKE "%debug%")
        AND NOT (LOWER(ios_orders.context_app_name) = "flink-staging" OR LOWER(ios_orders.context_app_name)="flink-debug")
        AND NOT (ios_orders.order_number IS NULL) -- we have some cases where this happens (13)
      )
      WHERE row_id=1
      UNION ALL

      SELECT *
      FROM (
        SELECT
          android_orders.id,
          android_orders.order_id, -- in curated layer orders.token used for CT orders to make order_uuid (country+token)
          android_orders.order_number, -- in curated layer orders.view used for Saleor orders to make order_uuid (country+number)
          android_orders.anonymous_id,
          android_orders.context_app_version,
          android_orders.context_app_name,
          android_orders.context_device_type,
          android_orders.hub_city,
          android_orders.payment_method,
          coalesce(android_orders.revenue, android_orders.order_revenue) as revenue,
          android_orders.flag_rider_tip as flag_rider_tip,
          android_orders.rider_tip_value as rider_tip_value,
          android_orders.timestamp,
          ROW_NUMBER() OVER(PARTITION BY order_number ORDER BY timestamp ASC) AS row_id
        FROM
          `flink-data-prod.flink_android_production.order_placed_view` android_orders
        WHERE
            NOT (LOWER(android_orders.context_app_version) LIKE "%app-rating%" OR LOWER(android_orders.context_app_version) LIKE "%debug%")
        AND NOT (LOWER(android_orders.context_app_name) = "flink-staging" OR LOWER(android_orders.context_app_name)="flink-debug")
        AND NOT (android_orders.order_number IS NULL) -- we have some cases where this happens (13)
      )
      WHERE row_id=1
      ),

    lookup_tb AS (
      SELECT
        country_iso
        , city
      FROM `flink-data-prod.google_sheets.hub_metadata`
      GROUP BY 1,2
    ),

    country_tb AS (
    SELECT help_tb.*
      , IF(LOWER(help_tb.hub_city) LIKE '%ludwigshafen%' OR LOWER(help_tb.hub_city) LIKE '%mülheim%', "DE", hubs.country_iso) AS country_iso
    FROM help_tb
    LEFT JOIN lookup_tb hubs ON hubs.city = help_tb.hub_city
    ),

    -- combine first_order_placed for ios and android for the relevant fields
    first_order_placed_tb AS (
      SELECT
        ios_order.order_number
      FROM
        `flink-data-prod.flink_ios_production.first_order_placed_view` ios_order
      UNION ALL
      SELECT
        android_order.order_number
      FROM
        `flink-data-prod.flink_android_production.first_order_placed_view` android_order
        )

    SELECT country_tb.*
      , LEAD(country_tb.order_number,1) OVER (PARTITION BY country_tb.anonymous_id ORDER BY timestamp) AS next_order_number
      , IF(first_order_placed_tb.order_number IS NULL, FALSE, TRUE) AS is_first_order
    FROM country_tb
      LEFT JOIN first_order_placed_tb
      ON first_order_placed_tb.order_number=country_tb.order_number
 ;;
  }

  dimension: is_ct_order {
    ## Can know whether is CT order by checking whether order_number is a number (Saleor: 11111) or a string (CT: de_muc_zue7y)
    hidden: yes
    type: yesno
    sql: (
          -- if safe_cast fails, returns null meaning order_number was not a number, meaning it was a CT order. Also ruling out NULL because with yesno, null turns into NO (FALSE).
          IF(SAFE_CAST(${order_number} AS INT64) is NULL,TRUE,FALSE) AND ${order_number} IS NOT NULL
          );;
  }

  dimension: order_uuid {
    ## This uuid is designed to follow the same format as order_uuid inside of orders.view (curated_layer).
    ## For saleor orders, it looks like this: DE_11111 (order_id is based on order_number)
    ## For CT orders, it looks like this: DE_c139c9c1-36b5-423b-97b2-79a94d116aea
    ## The way we can know from the client side whether order_number or order_id should be used, is by checking whether order_number is a number (Saleor: 11111) or a string (CT: de_muc_zue7y)
    type: string
    sql: (
      IF(${is_ct_order}, ${country_iso}|| '_' ||${order_id}, ${country_iso}|| '_' ||${order_number})
    );;
    hidden: yes
  }

  dimension: is_first_order {
    description: "Is first order for this user according to client (note: will count as first order if user deleted all their app data)"
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_first_order ;;
  }

  dimension: returning_customer {
    group_label: "* Order Dimensions *"
    description: "Whether the order was placed by a user that has placed a previous order (client-based tracking)"
    type: yesno
    sql: NOT(${is_first_order}) ;;
  }

  dimension: has_next_order {
    group_label: "* Order Dimensions *"
    description: "Whether the customer has placed an order after the current order"
    type: yesno
    sql: ${next_order_number} IS NOT NULL ;;
  }

  dimension: flag_rider_tip {
    group_label: "* Order Dimensions *"
    label: "Rider Tip Flag"
    type: yesno
    sql: ${TABLE}.flag_rider_tip ;;
  }

  dimension: rider_tip_value {
    group_label: "* Order Dimensions *"
    label: "Rider Tip Value"
    type: number
    sql: ${TABLE}.rider_tip_value ;;
  }

  dimension: full_app_version {
    group_label: "* Device Dimensions *"
    label: "Full App Version Detailed"
    description: "Combined device type and detailed app version"
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
    order_by_field: version_ordering_field
  }

  dimension: main_app_version {
    group_label: "* Device Dimensions *"
    label: "Full App Version Main"
    description: "Combined device type and main app version"
    type: string
    sql: ${context_device_type} || '-' || ${main_version_number} || '.' || ${secondary_version_number} ;;
    order_by_field: basic_version_field
  }

  dimension: context_device_type {
    group_label: "* Device Dimensions *"
    label: "Device Type"
    description: "Android or iOS"
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: basic_version_field {
    group_label: "* Device Dimensions *"
    hidden: yes
    type: number
    sql: CAST(CONCAT(${main_version_number},${secondary_version_number}) AS INT64) ;;
  }

  dimension: main_version_number {
    type: string
    sql: REGEXP_EXTRACT(${context_app_version}, r'(\d+)\.') ;;
    hidden: yes
  }

  dimension: secondary_version_number {
    type: string
    sql: REGEXP_EXTRACT(${context_app_version}, r'\.(\d+)\.') ;;
    value_format: "*0#"
    hidden: yes
  }

  dimension: tertiary_version_number {
    type: string
    sql: REGEXP_EXTRACT(${context_app_version}, r'(?:\d+)\.(?:\d+)\.(\d+)') ;;
    value_format: "*0#"
    hidden: yes
  }

  dimension: version_ordering_field {
    hidden: yes
    type: number
    sql: CONCAT(${main_version_number},${secondary_version_number},${tertiary_version_number}) ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
    hidden: yes
    primary_key: yes
  }

  dimension: order_id {
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_number {
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: next_order_number {
    group_label: "* IDs *"
    description: "Order Number for the order after the current order from the same user, NULL if user has no following order (yet)."
    type: string
    sql: ${TABLE}.next_order_number ;;
  }

  dimension: anonymous_id {
    group_label: "* IDs *"
    description: "User ID generated by Segment for users that are not logged in"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: revenue {
    group_label: "* Order Dimensions *"
    description: "Revenue from order"
    type: number
    sql: ${TABLE}.revenue ;;
  }

  measure: sum_revenue {
    description: "Sum over revenues"
    type: sum
    sql: ${revenue} ;;
  }

  dimension: payment_method_raw {
    group_label: "* Order Dimensions *"
    description: "Payment method used to place the order raw"
    type: string
    sql: ${TABLE}.payment_method ;;
}

  dimension: payment_method {
    group_label: "* Order Dimensions *"
    description: "Payment method used to place the order"
    type: string
    case: {
      when: {
        sql: ${TABLE}.payment_method = "Kreditkarte" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method = "directEbanking" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method LIKE "Carte%" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method = "Credit Card" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method = "CreditCard" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method = "MAESTRO" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method = "Maestro" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method = "VISA" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method = "MASTERCARD" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method = "MasterCard" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method = "American Express" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method = "AMERICAN_EXPRESS" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method = "Visa" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method = "CARTEBANCAIRE" ;;
        label: "CreditCard"
      }
      when: {
        sql: ${TABLE}.payment_method = "Apple Pay" ;;
        label: "ApplePay"
      }
      when: {
        sql: ${TABLE}.payment_method = "ApplePay" ;;
        label: "ApplePay"
      }
      when: {
        sql: ${TABLE}.payment_method = "ideal" ;;
        label: "iDEAL"
      }
      when: {
        sql: ${TABLE}.payment_method = "iDEAL" ;;
        label: "iDEAL"
      }
      when: {
        sql: ${TABLE}.payment_method = "Sofort." ;;
        label: "Sofort"
      }
      when: {
        sql: ${TABLE}.payment_method = "paypal" ;;
        label: "PayPal"
      }
      when: {
        sql: ${TABLE}.payment_method = "PayPal" ;;
        label: "PayPal"
      }
      else: "Other / Unknown"
    }
  }

  dimension: context_app_version {
    hidden: yes
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_app_name {
    type: string
    sql: ${TABLE}.context_app_name ;;
    hidden: yes
  }

  dimension: hub_city {
    group_label: "* Location Dimensions *"
    label: "City"
    description: "City in which order was placed"
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: country_iso {
    group_label: "* Location Dimensions *"
    label: "Country ISO"
    description: "Country in which order was placed"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: timestamp {
    group_label: "* Times & Dates *"
    label: "Order Timestamp"
    description: "Time at which order was placed"
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  measure: cnt_distinct_orders {
    label: "# Distinct Orders"
    type: count_distinct
    sql: ${TABLE}.order_id ;;
  }

  measure: cnt_distinct_orders_with_tip {
    label: "# Distinct Orders With Tip"
    type: count_distinct
    sql: case when ${flag_rider_tip} = true
          then ${TABLE}.order_id
          else null end ;;
  }

  measure: sum_tip_value {
    description: "Sum over tip value in successful orders"
    type: sum
    sql: ${rider_tip_value} ;;
  }

  measure: cnt_has_next_order {
    label: "# Has Next Order"
    description: "# orders that have a next order"
    type: count_distinct
    sql: ${order_number} ;;
    filters: [has_next_order: "yes"]
  }

  measure: count {
    description: "Counts the number of occurrences of the selected dimension(s)"
    type: count
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      id,
      order_id,
      order_number,
      anonymous_id,
      context_app_version,
      context_app_name,
      context_device_type,
      hub_city,
      payment_method,
      timestamp_time,
      country_iso
    ]
  }
}
