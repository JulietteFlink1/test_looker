view: adjust_user_funnel {
  derived_table: {
    sql: with install as
          (
              SELECT adjust._adid_,
              adjust._country_,
              adjust._city_,
              adjust._network_name_,
              adjust._os_name_,
              MIN(datetime(TIMESTAMP_SECONDS(adjust._created_at_), 'Europe/Berlin')) as install_time
              FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
              where adjust._activity_kind_ in ('install') and adjust._environment_!="sandbox"
              group by 1, 2, 3, 4, 5
          ),

          unique_installs as
          (
              select *
                from (
                    select _adid_,_country_, _city_, _network_name_, _os_name_, install_time, ROW_NUMBER() OVER (PARTITION BY _adid_, install_time)
                    row_number
                    from install
                )
                where row_number = 1
          ),

          first_address_selected as
          (
              SELECT adjust._adid_,
              MIN(datetime(TIMESTAMP_SECONDS(adjust._created_at_), 'Europe/Berlin')) as first_address_selected_time
              FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
              WHERE adjust._event_name_ in ('AddressSelected') and
              adjust._activity_kind_ = 'event' and adjust._environment_!="sandbox"
              group by 1
          ),

          first_address_selected_true as
          (
              SELECT adjust._adid_,
              MIN(datetime(TIMESTAMP_SECONDS(adjust._created_at_), 'Europe/Berlin')) as first_address_selected_true_time
              FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
              WHERE (adjust._event_name_='AddressSelected' and adjust._UserAreaAvailable_= TRUE and adjust._app_version_short_ != '2.0.0')
                    or (adjust._event_name_='locationPinPlaced' and JSON_EXTRACT_SCALAR(_publisher_parameters_, '$.user_area_available') IN ('true')
                        and adjust._app_version_short_ = '2.0.0') and
                    adjust._activity_kind_ = 'event' and adjust._environment_!="sandbox"
              group by 1
          ),

          first_view_item as
          (
              SELECT adjust._adid_,
              MIN(datetime(TIMESTAMP_SECONDS(adjust._created_at_), 'Europe/Berlin')) as first_view_item_time
              FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
              WHERE adjust._event_name_ in ('ViewItem') and
              adjust._activity_kind_ = 'event' and adjust._environment_!="sandbox"
              group by 1
          ),

          first_add_to_cart as
          (
              SELECT adjust._adid_,
              MIN(datetime(TIMESTAMP_SECONDS(adjust._created_at_), 'Europe/Berlin')) as first_add_to_cart_time
              FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
              WHERE adjust._event_name_ in ('AddToCart') and
              adjust._activity_kind_ = 'event' and adjust._environment_!="sandbox"
              group by 1
          ),

          first_checkout_started as
          (
              SELECT adjust._adid_,
              MIN(datetime(TIMESTAMP_SECONDS(adjust._created_at_), 'Europe/Berlin')) as first_checkout_started_time
              FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
              WHERE adjust._event_name_ in ('BeginCheckout', 'checkoutStarted') and
              adjust._activity_kind_ = 'event' and adjust._environment_!="sandbox"
              group by 1
          ),

          first_purchase as
          (
              SELECT adjust._adid_,
              MIN(datetime(TIMESTAMP_SECONDS(adjust._created_at_), 'Europe/Berlin')) as first_purchase_time
              FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
              WHERE adjust._event_name_ in ('Purchase', 'FirstPurchase') and
              adjust._activity_kind_ = 'event' and adjust._environment_ != "sandbox"
              group by 1
          )

select
    unique_installs._adid_,
    unique_installs._country_,
    unique_installs._city_,
    unique_installs._network_name_,
    unique_installs._os_name_,
    date(unique_installs.install_time) as install_time,
    first_address_selected.first_address_selected_time,
    first_address_selected_true.first_address_selected_true_time,
    first_view_item.first_view_item_time,
    first_add_to_cart.first_add_to_cart_time,
    first_checkout_started.first_checkout_started_time,
    first_purchase.first_purchase_time,
    TIMESTAMP_DIFF(first_address_selected.first_address_selected_time, unique_installs.install_time, DAY) AS time_to_select_address,
    TIMESTAMP_DIFF(first_address_selected_true.first_address_selected_true_time, unique_installs.install_time, DAY) AS time_to_select_address_true,
    TIMESTAMP_DIFF(first_view_item.first_view_item_time, unique_installs.install_time, DAY) AS time_to_view_item,
    TIMESTAMP_DIFF(first_add_to_cart.first_add_to_cart_time, unique_installs.install_time, DAY) AS time_to_add_to_cart,
    TIMESTAMP_DIFF(first_checkout_started.first_checkout_started_time, unique_installs.install_time, DAY) AS time_to_start_checkout,
    TIMESTAMP_DIFF(first_purchase.first_purchase_time, unique_installs.install_time, DAY) AS time_to_conversion,
    case when first_purchase.first_purchase_time is not null then TRUE else FALSE end as has_converted,
    count (distinct unique_installs._adid_) over (partition by date(unique_installs.install_time)) as cohort_base
    from unique_installs
    left join first_address_selected
    on unique_installs._adid_ = first_address_selected._adid_
    left join first_address_selected_true
    on unique_installs._adid_ = first_address_selected_true._adid_
    left join first_view_item
    on unique_installs._adid_ = first_view_item._adid_
    left join first_add_to_cart
    on unique_installs._adid_ = first_add_to_cart._adid_
    left join first_checkout_started
    on unique_installs._adid_ = first_checkout_started._adid_
    left join first_purchase
    on unique_installs._adid_ = first_purchase._adid_
    where first_purchase.first_purchase_time >= unique_installs.install_time or first_purchase.first_purchase_time is null
 ;;
  }

  dimension: _adid_ {
    type: string
    sql: ${TABLE}._adid_ ;;
    primary_key: yes
  }

  dimension: _country_ {
    type: string
    sql: ${TABLE}._country_ ;;
  }

  dimension: _city_ {
    type: string
    sql: ${TABLE}._city_ ;;
  }

  dimension: _network_name_ {
    type: string
    sql: ${TABLE}._network_name_ ;;
  }

  dimension: _os_name_ {
    type: string
    sql: ${TABLE}._os_name_ ;;
  }

  dimension_group: install_time {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
    sql: ${TABLE}.install_time ;;
  }

  dimension_group: first_address_selected_time {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
    sql: ${TABLE}.first_address_selected_time ;;
  }

  dimension_group: first_address_selected_true_time {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
    sql: ${TABLE}.first_address_selected_true_time ;;
  }

  dimension_group: first_view_item_time {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
    sql: ${TABLE}.first_view_item_time ;;
  }

  dimension_group: first_add_to_cart_time {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
    sql: ${TABLE}.first_add_to_cart_time ;;
  }

  dimension_group: first_checkout_started_time {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
    sql: ${TABLE}.first_checkout_started_time ;;
  }

  dimension_group: first_purchase_time {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
    sql: ${TABLE}.first_purchase_time ;;
  }


  dimension: time_to_select_address {
    type: number
    sql: ${TABLE}.time_to_select_address ;;
  }

  dimension: time_to_select_address_true {
    type: number
    sql: ${TABLE}.time_to_select_address_true ;;
  }

  dimension: time_to_view_item {
    type: number
    sql: ${TABLE}.time_to_view_item ;;
  }

  dimension: time_to_add_to_cart {
    type: number
    sql: ${TABLE}.time_to_add_to_cart ;;
  }

  dimension: time_to_start_checkout {
    type: number
    sql: ${TABLE}.time_to_start_checkout ;;
  }

  dimension: time_to_conversion {
    label: "Days to conversion"
    type: number
    sql: ${TABLE}.time_to_conversion ;;
  }

  dimension: has_converted {
    type: yesno
    sql: ${TABLE}.has_converted ;;
  }

  dimension: cohort_base {
    type: number
    sql: ${TABLE}.cohort_base ;;
  }

  ####### Parameters

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  ####### Dynamic Dimensions

  dimension: install_date {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${install_time_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${install_time_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${install_time_month}
    {% endif %};;
  }

  ######## Custom Dimensions

  dimension_group: duration_in_days_between_install_and_purchase {
    label: "Days Between Install And First Purchase"
    type: duration
    sql_start: ${install_time_raw} ;;
    sql_end: ${first_purchase_time_raw} ;;
    intervals: [day]
  }

######## MEASURES


  measure: count {
    type: count
    label: "# Unique Users"
    drill_fields: [detail*]
  }


  ####### Time to events

  measure: avg_time_to_select_address {
    label: "Avg time to select address (days)"
    type: average
    hidden: no
    value_format: "0.00"
    sql: ${time_to_select_address};;
  }

  measure: avg_time_to_select_address_true {
    label: "Avg time to user area available (days)"
    type: average
    hidden: no
    value_format: "0.00"
    sql: ${time_to_select_address_true} ;;
  }

  measure: avg_time_to_view_item {
    label: "Avg time to view item (days)"
    type: average
    hidden: no
    value_format: "0.00"
    sql: ${time_to_view_item} ;;
  }

  measure: avg_time_to_add_to_cart {
    label: "Avg time to add to cart (days)"
    type: average
    hidden: no
    value_format: "0.00"
    sql: ${time_to_add_to_cart} ;;
  }

  measure: avg_time_to_start_checkout {
    label: "Avg time to start checkout (days)"
    type: average
    hidden: no
    value_format: "0.00"
    sql: ${time_to_start_checkout} ;;
  }

  measure: avg_time_to_conversion {
    label: "Avg time to conversion (days)"
    type: average
    hidden: no
    value_format: "0.00"
    sql: ${time_to_conversion} ;;
    }

  measure: median_time_to_conversion {
    label: "Median time to conversion (days)"
    type: median
    hidden: no
    value_format: "0.00"
    sql: ${time_to_conversion} ;;
  }

  measure: first_quartile_time_to_conversion {
    label: "25th percentile time to conversion (days)"
    type: percentile
    percentile: 25
    hidden: no
    value_format: "0.00"
    sql: ${time_to_conversion} ;;
  }

  measure: third_quartile_time_to_conversion {
    label: "75th percentile time to conversion (days)"
    type: percentile
    percentile: 75
    hidden: no
    value_format: "0.00"
    sql: ${time_to_conversion} ;;
  }

    ###### COUNTS

  measure: cnt_select_address {
    label: "Address Selected count"
    type: count
    filters: [first_address_selected_time_date: "NOT NULL"]
  }

  measure: cnt_select_address_true {
    label: "User Area Available count"
    type: count
    filters: [first_address_selected_true_time_date: "NOT NULL"]
  }

  measure: cnt_view_item {
    label: "View Item count"
    type: count
    filters: [first_view_item_time_date: "NOT NULL"]
  }

  measure: cnt_add_to_cart {
    label: "Add to Cart count"
    type: count
    filters: [first_add_to_cart_time_date: "NOT NULL"]
  }

  measure: cnt_checkout_started {
    label: "Checkout Started count"
    type: count
    filters: [first_checkout_started_time_date: "NOT NULL"]
  }

  measure: cnt_conversions {
    label: "Conversion count"
    type: count
    filters: [has_converted: "yes"]
  }

  set: detail {
    fields: [
      _adid_,
      _city_,
      _network_name_,
      _os_name_,
      install_time_date,
      first_address_selected_time_time,
      first_address_selected_true_time_time,
      first_view_item_time_time,
      first_add_to_cart_time_time,
      first_checkout_started_time_time,
      first_purchase_time_time,
      time_to_select_address,
      time_to_select_address_true,
      time_to_view_item,
      time_to_add_to_cart,
      time_to_start_checkout,
      time_to_conversion,
      has_converted
    ]
  }
}
