view: adjust_sessions {
  derived_table: {
    datagroup_trigger: flink_default_datagroup
    sql: with adjust_sessions as
    (
    SELECT  _adid_ || '-' || row_number() over(partition by _adid_ order by _created_at_) as session_id,
    _adid_,pd,
    _created_at_ as session_start_at,
    lead(_created_at_) over(partition by _adid_ order by _created_at_) as next_session_start_at,
    from  (select _adid_, TIMESTAMP_SECONDS(_created_at_) as _created_at_,_PARTITIONTIME as pd,
        TIMESTAMP_DIFF(TIMESTAMP_SECONDS(_created_at_),LAG(TIMESTAMP_SECONDS(_created_at_))
        OVER(PARTITION BY _adid_ ORDER BY TIMESTAMP_SECONDS(_created_at_)), MINUTE) AS inactivity_time
        FROM `flink-backend.customlytics_adjust.adjust_raw_imports`
        WHERE _activity_kind_ in ('event', 'install')) event
    WHERE (event.inactivity_time > 30 OR event.inactivity_time is null)
    order by 3 asc, 2
    ),

    installs as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, MIN(TIMESTAMP_SECONDS(adjust._created_at_)) as install_date
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='install'
    group by 1, 2
    ),

    address_selected as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, count(adjust._event_name_) as event_count
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='event' and adjust._event_name_='AddressSelected'
    group by 1, 2
    ),

    article_opened as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, count(adjust._event_name_) as event_count
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='event' and adjust._event_name_='ArticleOpened'
    group by 1, 2
    ),

    add_to_cart as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, count(adjust._event_name_) as event_count
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='event' and adjust._event_name_='AddToCart'
    group by 1, 2
    ),

    add_to_favourites as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, count(adjust._event_name_) as event_count
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='event' and adjust._event_name_='AddToFavourites'
    group by 1, 2
    ),

    search_executed as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, count(adjust._event_name_) as event_count
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='event' and adjust._event_name_='SearchExecuted'
    group by 1, 2
    ),

    view_item as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, count(adjust._event_name_) as event_count
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='event' and adjust._event_name_='ViewItem'
    group by 1, 2
    ),

    view_category as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, count(adjust._event_name_) as event_count
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='event' and adjust._event_name_='ViewCategory'
    group by 1, 2
    ),

    view_subcategory as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, count(adjust._event_name_) as event_count
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='event' and adjust._event_name_='ViewSubCategory'
    group by 1, 2
    ),

    view_cart as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, count(adjust._event_name_) as event_count
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='event' and adjust._event_name_='ViewCart'
    group by 1, 2
    ),

    begin_checkout as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, count(adjust._event_name_) as event_count
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='event' and adjust._event_name_='BeginCheckout'
    group by 1, 2
    ),

    payment_method_added as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, count(adjust._event_name_) as event_count
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='event' and adjust._event_name_='PaymentMethodAdded'
    group by 1, 2
    ),

    first_purchase as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, count(adjust._event_name_) as event_count
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='event' and adjust._event_name_='FirstPurchase'
    group by 1, 2
    ),

    purchase as
    (
    SELECT  adjust_sessions._adid_, adjust_sessions.session_id, count(adjust._event_name_) as event_count
    FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
    left join adjust_sessions
    on adjust._adid_=adjust_sessions._adid_
    and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at
    and (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at OR adjust_sessions.next_session_start_at is null)
    where adjust._activity_kind_='event' and adjust._event_name_='Purchase'
    group by 1, 2
    )

    select
    adjust_sessions._adid_,
    adjust_sessions.session_id,
    adjust_sessions.session_start_at,
    adjust_sessions.next_session_start_at,
    adjust_sessions.pd,
    installs.install_date as install_date,
    address_selected.event_count as address_selected,
    article_opened.event_count as article_opened,
    add_to_cart.event_count  as add_to_cart,
    add_to_favourites.event_count as add_to_favourites,
    search_executed.event_count as search_executed,
    view_item.event_count as view_item,
    view_category.event_count as view_category,
    view_subcategory.event_count as view_subcategory,
    view_cart.event_count as view_cart,
    begin_checkout.event_count as begin_checkout,
    payment_method_added.event_count as payment_method_added,
    first_purchase.event_count as first_purchase,
    purchase.event_count as purchase

    from adjust_sessions
    left join installs on adjust_sessions.session_id=installs.session_id
    left join address_selected on adjust_sessions.session_id=address_selected.session_id
    left join article_opened on adjust_sessions.session_id=article_opened.session_id
    left join add_to_cart on adjust_sessions.session_id=add_to_cart.session_id
    left join add_to_favourites on adjust_sessions.session_id=add_to_favourites.session_id
    left join search_executed on adjust_sessions.session_id=search_executed.session_id
    left join view_item on adjust_sessions.session_id=view_item.session_id
    left join view_category on adjust_sessions.session_id=view_category.session_id
    left join view_subcategory on adjust_sessions.session_id=view_subcategory.session_id
    left join view_cart on adjust_sessions.session_id=view_cart.session_id
    left join begin_checkout on adjust_sessions.session_id=begin_checkout.session_id
    left join payment_method_added on adjust_sessions.session_id=payment_method_added.session_id
    left join first_purchase on adjust_sessions.session_id=first_purchase.session_id
    left join purchase on adjust_sessions.session_id=purchase.session_id

    order by 1
     ;;
  }

  dimension: _adid_ {
    type: string
    sql: ${TABLE}._adid_ ;;
  }

  dimension: add_to_cart {
    type: number
    sql: ${TABLE}.add_to_cart ;;
  }

  dimension: add_to_favourites {
    type: number
    sql: ${TABLE}.add_to_favourites ;;
  }

  dimension: address_selected {
    type: number
    sql: ${TABLE}.address_selected ;;
  }

  dimension: article_opened {
    type: number
    sql: ${TABLE}.article_opened ;;
  }

  dimension: begin_checkout {
    type: number
    sql: ${TABLE}.begin_checkout ;;
  }

  dimension: first_purchase {
    type: number
    sql: ${TABLE}.first_purchase ;;
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
    sql: ${TABLE}.install_date ;;
  }

  dimension_group: next_session_start {
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
    sql: ${TABLE}.next_session_start_at ;;
  }

  dimension: payment_method_added {
    type: number
    sql: ${TABLE}.payment_method_added ;;
  }

  dimension: purchase {
    type: number
    sql: ${TABLE}.purchase ;;
  }

  dimension: search_executed {
    type: number
    sql: ${TABLE}.search_executed ;;
  }

  dimension: session_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension_group: session_start {
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
    sql: ${TABLE}.session_start_at ;;
  }

  dimension: view_cart {
    type: number
    sql: ${TABLE}.view_cart ;;
  }

  dimension: view_category {
    type: number
    sql: ${TABLE}.view_category ;;
  }

  dimension: view_item {
    type: number
    sql: ${TABLE}.view_item ;;
  }

  dimension: view_subcategory {
    type: number
    sql: ${TABLE}.view_subcategory ;;
  }

  #### Flags

  dimension: has_add_to_cart_in_session {
    type: yesno
    sql: ${TABLE}.add_to_cart is not null ;;
  }

  dimension: has_add_to_favourites_in_session {
    type: yesno
    sql: ${TABLE}.add_to_favourites is not null ;;
  }

  dimension: has_address_selected_in_session {
    type: yesno
    sql: ${TABLE}.address_selected is not null ;;
  }

  dimension: has_article_opened_in_session {
    type: yesno
    sql: ${TABLE}.article_opened is not null ;;
  }

  dimension: has_begin_checkout_in_session {
    type: yesno
    sql: ${TABLE}.begin_checkout is not null ;;
  }

  dimension: has_first_purchase_in_session {
    type: yesno
    sql: ${TABLE}.first_purchase is not null ;;
  }

  dimension: has_install_in_session {
    type: yesno
    sql: ${TABLE}.install_date is not null ;;
  }

  dimension: has_payment_method_added_in_session {
    type: yesno
    sql: ${TABLE}.payment_method_added is not null ;;
  }

  dimension: has_purchase_in_session {
    type: yesno
    sql: ${TABLE}.purchase is not null ;;
  }

  dimension: has_search_executed_in_session {
    type: yesno
    sql: ${TABLE}.search_executed is not null ;;
  }

  dimension: has_view_cart_in_session {
    type: yesno
    sql: ${TABLE}.view_cart is not null ;;
  }

  dimension: has_view_category_in_session {
    type: yesno
    sql: ${TABLE}.view_category is not null ;;
  }

  dimension: has_view_item_in_session {
    type: yesno
    sql: ${TABLE}.view_item ;;
  }

  dimension: has_view_subcategory_in_session {
    type: yesno
    sql: ${TABLE}.view_subcategory is not null ;;
  }

  dimension: _partitiondate {
    type: date
    convert_tz: no
    datatype: date
    sql: DATE(${TABLE}.pd) ;;
  }

  dimension_group: _partitiontime {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.pd ;;
  }

  ##### Measures

  measure: count {
    type: count
    drill_fields: []
  }
}
