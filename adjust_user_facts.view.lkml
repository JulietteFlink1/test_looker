view: adjust_user_facts {
  derived_table: {
    persist_for: "12 hours"
    sql: with install as
    (
        SELECT adjust._adid_,
        adjust._city_,
        adjust._network_name_,
        adjust._os_name_,
        MIN(TIMESTAMP_SECONDS(adjust._created_at_)) as install_time
        FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
        where adjust._activity_kind_ in ('install')
        group by 1, 2, 3, 4
    ),

    purchase as
    (
        SELECT adjust._adid_,
        MIN(TIMESTAMP_SECONDS(adjust._created_at_)) as first_purchase_time
        FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
        WHERE adjust._event_name_ in ('Purchase', 'FirstPurchase') and
        adjust._activity_kind_ = 'event'
        group by 1
    )

    select
        install._adid_,
        install._city_,
        install._network_name_,
        install._os_name_,
        install.install_time,
        purchase.first_purchase_time,
        TIMESTAMP_DIFF(purchase.first_purchase_time, install.install_time, DAY) AS time_to_conversion,
        case when purchase.first_purchase_time is not null then TRUE else FALSE end as has_converted
        from install
        left join purchase
        on install._adid_ = purchase._adid_
        ;;
  }

  dimension: _adid_ {
    type: string
    primary_key: yes
    sql: ${TABLE}._adid_ ;;
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

  dimension_group: install {
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
    sql: ${TABLE}.install_time ;;
  }

  dimension_group: purchase {
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
    sql: ${TABLE}.first_purchase_time ;;
  }

  dimension: time_to_conversion {
    type: number
    sql: ${TABLE}.time_to_conversion ;;
  }

  dimension: has_converted {
    type: yesno
    sql: ${TABLE}.has_converted ;;
  }

  ####### Measures ######

  measure: count {
    type: count
    drill_fields: []
  }

  measure: avg_time_to_conversion {
    type: average
    hidden: no
    value_format: "0.00"
    sql: ${time_to_conversion} ;;
  }



}
