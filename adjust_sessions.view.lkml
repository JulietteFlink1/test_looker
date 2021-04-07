view: adjust_sessions {
  derived_table: {
    sql: with adjust_sessions as
      (
      SELECT  _adid_ || '-' || row_number() over(partition by _adid_ order by _created_at_) as session_id,
      _adid_,
      _city_,
      _os_name_,
      _app_version_,
      _network_name_,
      _created_at_ as session_start_at,
      lead(_created_at_) over(partition by _adid_ order by _created_at_) as next_session_start_at,
      from  (select _adid_,
              _city_,
              _os_name_,
              _app_version_,
              _network_name_,
              TIMESTAMP_SECONDS(_created_at_) as _created_at_,
          TIMESTAMP_DIFF(TIMESTAMP_SECONDS(_created_at_),LAG(TIMESTAMP_SECONDS(_created_at_))
          OVER(PARTITION BY _adid_ ORDER BY TIMESTAMP_SECONDS(_created_at_)), MINUTE) AS inactivity_time
          FROM `flink-backend.customlytics_adjust.adjust_raw_imports`
          WHERE _activity_kind_ in ('event', 'install')) event
      WHERE (event.inactivity_time > 30 OR event.inactivity_time is null)
      order by 1, 3
      ),

      installs as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      MIN(TIMESTAMP_SECONDS(adjust._created_at_)) as install_date
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                  (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                  OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='install'
      group by 1, 2
      ),

      address_selected as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='AddressSelected'
      group by 1, 2
      ),

      address_selected_true as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where
      --adjust._activity_kind_='event' and
      --adjust._event_name_='AddressSelected' and
      adjust._UserAreaAvailable_= TRUE
      group by 1, 2
      ),

      address_selected_false as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='AddressSelected' and adjust._UserAreaAvailable_= FALSE
      group by 1, 2
      ),

      article_opened as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='ArticleOpened'
      group by 1, 2
      ),

      add_to_cart as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='AddToCart'
      group by 1, 2
      ),

      add_to_favourites as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='AddToFavourites'
      group by 1, 2
      ),

      search_executed as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='SearchExecuted'
      group by 1, 2
      ),

      view_item as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='ViewItem'
      group by 1, 2
      ),

      view_category as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='ViewCategory'
      group by 1, 2
      ),

      view_subcategory as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='ViewSubCategory'
      group by 1, 2
      ),

      view_cart as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='ViewCart'
      group by 1, 2
      ),

      begin_checkout as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='BeginCheckout'
      group by 1, 2
      ),

      payment_method_added as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='PaymentMethodAdded'
      group by 1, 2
      ),

      payment_failed as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='PaymentFailed'
      group by 1, 2
      ),

      first_purchase as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='FirstPurchase'
      group by 1, 2
      ),

      purchase as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(adjust._event_name_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where adjust._activity_kind_='event' and adjust._event_name_='Purchase'
      group by 1, 2
      )


      select
      adjust_sessions._adid_,
      adjust_sessions.session_id,
      adjust_sessions.session_start_at,
      adjust_sessions.next_session_start_at,
      adjust_sessions._city_,
      adjust_sessions._os_name_,
      adjust_sessions._app_version_,
      adjust_sessions._network_name_,
      installs.install_date as install_date,
      1 as session,
      address_selected.event_count as address_selected,
      address_selected_true.event_count as address_selected_true,
      address_selected_false.event_count as address_selected_false,
      article_opened.event_count as article_opened,
      add_to_cart.event_count as add_to_cart,
      add_to_favourites.event_count as add_to_favourites,
      search_executed.event_count as search_executed,
      view_item.event_count as view_item,
      view_category.event_count as view_category,
      view_subcategory.event_count as view_subcategory,
      view_cart.event_count as view_cart,
      begin_checkout.event_count as begin_checkout,
      payment_method_added.event_count as payment_method_added,
      payment_failed.event_count as payment_failed,
      first_purchase.event_count as first_purchase,
      purchase.event_count as purchase

      from adjust_sessions
      left join installs on adjust_sessions.session_id=installs.session_id
      left join address_selected on adjust_sessions.session_id=address_selected.session_id
      left join address_selected_true on adjust_sessions.session_id=address_selected_true.session_id
      left join address_selected_false on adjust_sessions.session_id=address_selected_false.session_id
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
      left join payment_failed on adjust_sessions.session_id=payment_failed.session_id
      left join first_purchase on adjust_sessions.session_id=first_purchase.session_id
      left join purchase on adjust_sessions.session_id=purchase.session_id

      order by 1
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: _adid_ {
    type: string
    sql: ${TABLE}._adid_ ;;
  }

  dimension: session_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.session_id ;;
  }

  dimension_group: session_start_at {
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
    sql: ${TABLE}.session_start_at ;;
  }

  dimension_group: next_session_start_at {
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
    sql: ${TABLE}.next_session_start_at ;;
  }

  dimension: _city_ {
    type: string
    sql: ${TABLE}._city_ ;;
  }

  dimension: _os_name_ {
    type: string
    sql: ${TABLE}._os_name_ ;;
  }

  dimension: _app_version_ {
    type: string
    sql: ${TABLE}._app_version_ ;;
  }

  dimension: _network_name_ {
    type: string
    sql: ${TABLE}._network_name_ ;;
  }

  dimension_group: install_date {
    type: time
    sql: ${TABLE}.install_date ;;
  }

  dimension: session {
    type: number
    sql: ${TABLE}.session ;;
  }

  dimension: address_selected {
    type: number
    sql: ${TABLE}.address_selected ;;
  }

  dimension: address_selected_true {
    type: number
    sql: ${TABLE}.address_selected_true ;;
  }

  dimension: address_selected_false {
    type: number
    sql: ${TABLE}.address_selected_false ;;
  }

  dimension: article_opened {
    type: number
    sql: ${TABLE}.article_opened ;;
  }

  dimension: add_to_cart {
    type: number
    sql: ${TABLE}.add_to_cart ;;
  }

  dimension: add_to_favourites {
    type: number
    sql: ${TABLE}.add_to_favourites ;;
  }

  dimension: search_executed {
    type: number
    sql: ${TABLE}.search_executed ;;
  }

  dimension: view_item {
    type: number
    sql: ${TABLE}.view_item ;;
  }

  dimension: view_category {
    type: number
    sql: ${TABLE}.view_category ;;
  }

  dimension: view_subcategory {
    type: number
    sql: ${TABLE}.view_subcategory ;;
  }

  dimension: view_cart {
    type: number
    sql: ${TABLE}.view_cart ;;
  }

  dimension: begin_checkout {
    type: number
    sql: ${TABLE}.begin_checkout ;;
  }

  dimension: payment_method_added {
    type: number
    sql: ${TABLE}.payment_method_added ;;
  }

  dimension: payment_failed {
    type: number
    sql: ${TABLE}.payment_failed ;;
  }

  dimension: first_purchase {
    type: number
    sql: ${TABLE}.first_purchase ;;
  }

  dimension: purchase {
    type: number
    sql: ${TABLE}.purchase ;;
  }

  set: detail {
    fields: [
      _adid_,
      session_id,
      session_start_at_time,
      next_session_start_at_time,
      _city_,
      _os_name_,
      _app_version_,
      _network_name_,
      install_date_time,
      session,
      address_selected,
      address_selected_true,
      address_selected_false,
      article_opened,
      add_to_cart,
      add_to_favourites,
      search_executed,
      view_item,
      view_category,
      view_subcategory,
      view_cart,
      begin_checkout,
      payment_method_added,
      payment_failed,
      first_purchase,
      purchase
    ]
  }
}
