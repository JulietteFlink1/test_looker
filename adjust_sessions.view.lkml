view: adjust_sessions {
  derived_table: {
    sql: with adjust_sessions as
      (
      SELECT  _adid_ || '-' || row_number() over(partition by _adid_ order by _created_at_) as session_id,
      _adid_,
      _city_,
      _os_name_,
      _app_version_short_,
      _network_name_,
      _created_at_ as session_start_at,
      lead(_created_at_) over(partition by _adid_ order by _created_at_) as next_session_start_at,
      from  (select _adid_,
              _city_,
              _os_name_,
              _app_version_short_,
              _network_name_,
              TIMESTAMP_SECONDS(_created_at_) as _created_at_,
          TIMESTAMP_DIFF(TIMESTAMP_SECONDS(_created_at_),LAG(TIMESTAMP_SECONDS(_created_at_))
          OVER(PARTITION BY _adid_ ORDER BY TIMESTAMP_SECONDS(_created_at_)), MINUTE) AS inactivity_time
          FROM `flink-backend.customlytics_adjust.adjust_raw_imports`
          WHERE _activity_kind_ in ('event', 'install') and _environment_!="sandbox" and _created_at_ is not null) event
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
      where adjust._activity_kind_='install' and adjust._environment_!="sandbox"
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
      where adjust._activity_kind_='event' and adjust._event_name_ in ('AddressSelected', 'locationPinPlaced') and adjust._environment_!="sandbox"
      group by 1, 2
      ),

      address_selected_true as
      (
      SELECT  adjust_sessions._adid_,
      adjust_sessions.session_id,
      count(distinct adjust._created_at_) as event_count
      FROM `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
      left join adjust_sessions
      on adjust._adid_=adjust_sessions._adid_
          and TIMESTAMP_SECONDS(adjust._created_at_) >= adjust_sessions.session_start_at and
                      (TIMESTAMP_SECONDS(adjust._created_at_) < adjust_sessions.next_session_start_at
                      OR adjust_sessions.next_session_start_at is null)
      where
      adjust._activity_kind_='event' and
      ((adjust._event_name_ in ('AddressSelected', 'locationPinPlaced') and adjust._UserAreaAvailable_= TRUE and cast(substr(adjust._app_version_short_, 1, 1) as int64) < 2)
      or (adjust._event_name_='locationPinPlaced' and JSON_EXTRACT_SCALAR(_publisher_parameters_, '$.user_area_available') IN ('true') and
      cast(substr(adjust._app_version_short_, 1, 1) as int64) >= 2)
      or adjust._UserAreaAvailable_= TRUE) and
      adjust._environment_!='sandbox'
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
      where
      adjust._activity_kind_='event' and
      ((adjust._event_name_='AddressSelected' and adjust._UserAreaAvailable_= FALSE and substr(adjust._app_version_short_, 1, 1) != '2')
      or (adjust._event_name_='locationPinPlaced' and JSON_EXTRACT_SCALAR(_publisher_parameters_, '$.user_area_available') IN ('false') and cast(substr(adjust._app_version_short_, 1, 1) as int64) >= 2)) and
      adjust._environment_!='sandbox'
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
      where adjust._activity_kind_='event' and adjust._event_name_='ArticleOpened' and adjust._environment_!="sandbox"
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
      where adjust._activity_kind_='event' and adjust._event_name_='AddToCart' and adjust._environment_!="sandbox"
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
      where adjust._activity_kind_='event' and adjust._event_name_='AddToFavourites' and adjust._environment_!="sandbox"
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
      where adjust._activity_kind_='event' and adjust._event_name_='SearchExecuted' and adjust._environment_!="sandbox"
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
      where adjust._activity_kind_='event' and adjust._event_name_='ViewItem' and adjust._environment_!="sandbox"
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
      where adjust._activity_kind_='event' and adjust._event_name_='ViewCategory' and adjust._environment_!="sandbox"
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
      where adjust._activity_kind_='event' and adjust._event_name_='ViewSubCategory' and adjust._environment_!="sandbox"
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
      where adjust._activity_kind_='event' and adjust._event_name_='ViewCart' and adjust._environment_!="sandbox"
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
      where adjust._activity_kind_='event' and adjust._event_name_ in ('BeginCheckout', 'checkoutStarted') and adjust._environment_!="sandbox"
      group by 1, 2
      ),

      checkout_confirmed as
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
      where adjust._activity_kind_='event' and adjust._event_name_ in ('CheckoutAttempted', 'purchaseConfirmed') and adjust._environment_!="sandbox"
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
      where adjust._activity_kind_='event' and adjust._event_name_='PaymentMethodAdded' and adjust._environment_!="sandbox"
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
      where adjust._activity_kind_='event' and adjust._event_name_='PaymentFailed' and adjust._environment_!="sandbox"
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
      where adjust._activity_kind_='event' and adjust._event_name_='FirstPurchase' and adjust._environment_!="sandbox"
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
      where adjust._activity_kind_='event' and adjust._event_name_='Purchase' and adjust._environment_!="sandbox"
      group by 1, 2
      )


      select
      adjust_sessions._adid_,
      adjust_sessions.session_id,
      datetime(adjust_sessions.session_start_at, 'Europe/Berlin') as session_start_at,
      datetime(adjust_sessions.next_session_start_at, 'Europe/Berlin') as next_session_start_at,
      adjust_sessions._city_,
      adjust_sessions._os_name_,
      adjust_sessions._app_version_short_,
      adjust_sessions._network_name_,
      datetime(installs.install_date, 'Europe/Berlin') as install_date,
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
      checkout_confirmed.event_count as checkout_confirmed,
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
      left join checkout_confirmed on adjust_sessions.session_id=checkout_confirmed.session_id
      left join payment_method_added on adjust_sessions.session_id=payment_method_added.session_id
      left join payment_failed on adjust_sessions.session_id=payment_failed.session_id
      left join first_purchase on adjust_sessions.session_id=first_purchase.session_id
      left join purchase on adjust_sessions.session_id=purchase.session_id

      order by 1
 ;;
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
    datatype: datetime
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
    datatype: datetime
  }

  dimension: city {
    type: string
    sql: ${TABLE}._city_ ;;
  }

  dimension: os_name {
    type: string
    sql: ${TABLE}._os_name_ ;;
  }

  dimension: _app_version_ {
    type: string
    sql: ${TABLE}._app_version_short_ ;;
  }

  dimension: _network_name_ {
    type: string
    sql: ${TABLE}._network_name_ ;;
  }

  dimension_group: install_date {
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
    sql: ${TABLE}.install_date ;;
    datatype: datetime
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

  dimension: checkout_started {
    type: number
    sql: ${TABLE}.begin_checkout ;;
  }

  dimension: checkout_confirmed {
    type: number
    sql: ${TABLE}.checkout_confirmed ;;
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

  dimension: first_session {
    type: yesno
    sql: ${TABLE}.install_date is not NULL ;;
  }

  dimension: marketing_channel {
    type: string
    sql: ${TABLE}._network_name_ ;;
  }



  #### Measures

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  #### Flags

  dimension: has_add_to_cart_in_session {
    type: yesno
    sql: ${add_to_cart} is not null ;;
  }

  dimension: has_add_to_favourites_in_session {
    type: yesno
    sql: ${add_to_favourites} is not null ;;
  }

  dimension: has_address_selected_in_session {
    type: yesno
    sql: ${address_selected} is not null ;;
  }

  dimension: has_address_selected_true_in_session {
    type: yesno
    sql: ${address_selected_true} is not null ;;
  }

  dimension: has_address_selected_false_in_session {
    type: yesno
    sql: ${address_selected_false} is not null ;;
  }

  dimension: has_article_opened_in_session {
    type: yesno
    sql: ${article_opened} is not null ;;
  }

  dimension: has_checkout_started_in_session {
    type: yesno
    sql: ${checkout_started} is not null ;;
  }

  dimension: has_first_purchase_in_session {
    type: yesno
    sql: ${first_purchase} is not null ;;
  }

  dimension: has_install_in_session {
    type: yesno
    sql: ${install_date_raw} is not null ;;
  }

  dimension: has_payment_method_added_in_session {
    type: yesno
    sql: ${payment_method_added} is not null ;;
  }

  dimension: has_payment_failed_in_session {
    type: yesno
    sql: ${payment_failed} is not null ;;
  }

  dimension: has_purchase_in_session {
    type: yesno
    sql: ${purchase} is not null ;;
  }

  dimension: has_search_executed_in_session {
    type: yesno
    sql: ${search_executed} is not null ;;
  }

  dimension: has_view_cart_in_session {
    type: yesno
    sql: ${view_cart} is not null ;;
  }

  dimension: has_view_category_in_session {
    type: yesno
    sql: ${view_category} is not null ;;
  }

  dimension: has_view_item_in_session {
    type: yesno
    sql: ${view_item} is not null;;
  }

  dimension: has_view_subcategory_in_session {
    type: yesno
    sql: ${view_subcategory} is not null ;;
  }

##### Unique count of events during a session. If multiple events are triggerred during a session, e.g 3 times view item, the event is only counted once.

  measure: cnt_installs {
    label: "Installs count"
    type: count
    filters: [install_date_date: "NOT NULL"]
  }

  measure: cnt_address_selected {
    label: "Address selected count"
    type: count
    filters: [address_selected: "NOT NULL"]
  }

  measure: cnt_address_selected_true {
    label: "User area available count"
    type: count
    filters: [address_selected_true: "NOT NULL"]
  }

  measure: cnt_view_item {
    label: "View item count"
    type: count
    filters: [view_item: "NOT NULL"]
  }

  measure: cnt_add_to_cart {
    label: "Add to cart count"
    type: count
    filters: [add_to_cart: "NOT NULL"]
  }

  measure: cnt_checkout_started {
    label: "Checkout started count"
    type: count
    filters: [checkout_started: "NOT NULL"]
  }

  measure: cnt_checkout_confirmed {
    label: "Checkout confirmed count"
    type: count
    filters: [checkout_confirmed: "NOT NULL"]
  }

  measure: cnt_payment_failed {
    label: "Payment failed count"
    type: count
    filters: [payment_failed: "NOT NULL"]
  }

  measure: cnt_first_purchase {
    label: "First purchase count"
    type: count
    filters: [first_purchase: "NOT NULL"]
  }

  measure: cnt_purchase {
    label: "Purchase count"
    type: count
    filters: [purchase: "NOT NULL"]
  }

  ###### Sum of events

  measure: sum_sessions {
    label: "Session count"
    type: sum
    sql: ${session} ;;
  }


  measure: sum_address_selected {
    label: "Address selected sum of events"
    type: sum
    sql: ${address_selected} ;;
  }

  measure: sum_address_selected_true {
    label: "User area available sum of events"
    type: sum
    sql: ${address_selected_true} ;;
  }

  measure: sum_view_item {
    label: "View item sum of events"
    type: sum
    sql: ${view_item} ;;
  }

  measure: sum_add_to_cart {
    label: "Add to cart sum of events"
    type: sum
    sql: ${add_to_cart} ;;
  }

  measure: sum_checkout_started {
    label: "Checkout started sum of events"
    type: sum
    sql: ${checkout_started} ;;
  }

  measure: sum_checkout_confirmed {
    label: "Checkout confirmed sum of events"
    type: sum
    sql: ${checkout_confirmed} ;;
  }

  measure: sum_payment_failed {
    label: "Payment failed sum of events"
    type: sum
    sql: ${payment_failed} ;;
  }

  measure: sum_first_purchase {
    label: "First purchase sum of events"
    type: sum
    sql: ${first_purchase} ;;
  }

  measure: sum_purchases {
    label: "Purchase sum of events"
    type: sum
    sql: ${purchase} ;;
  }

###### Percentage new users ######

  measure: pct_address_selected_new_users {
    label: "% Install sessions with address selected"
    description: "Share of install sessions that had address selected"
    hidden:  no
    type: number
    sql: ${cnt_address_selected} / NULLIF(${cnt_installs}, 0);;
    value_format: "0%"
  }

  measure: pct_user_area_available_new_users {
    label: "% Install sessions with user area available true"
    description: "Share of install sessions that had user area available true"
    hidden:  no
    type: number
    sql: ${cnt_address_selected_true} / NULLIF(${cnt_installs}, 0);;
    value_format: "0%"
  }

  measure: pct_view_item_new_users {
    label: "% Install sessions with view item"
    description: "Share of install sessions that had view item"
    hidden:  no
    type: number
    sql: ${cnt_view_item} / NULLIF(${cnt_installs}, 0);;
    value_format: "0%"

  }

  measure: pct_add_to_cart_new_users {
    label: "% Install sessions with add to cart"
    description: "Share of install sessions that had add to cart"
    hidden:  no
    type: number
    sql: ${cnt_add_to_cart} / NULLIF(${cnt_installs}, 0);;
    value_format: "0%"
  }

  measure: pct_checkout_started_new_users {
    label: "% Install sessions with checkout started"
    description: "Share of install sessions that had checkout started"
    hidden:  no
    type: number
    sql: ${cnt_checkout_started} / NULLIF(${cnt_installs}, 0);;
    value_format: "0%"
  }

  measure: pct_first_purchase_new_users {
    label: "% Install sessions with first purchase"
    description: "Share of install sessions that had first purchase"
    hidden:  no
    type: number
    sql: ${cnt_first_purchase} / NULLIF(${cnt_installs}, 0);;
    value_format: "0%"
  }

###### Percentage returning users ######

  measure: pct_address_selected_returning_users {
    label: "% Sessions with address selected"
    description: "Share of Sessions that had address selected"
    hidden:  no
    type: number
    sql: ${cnt_address_selected} / NULLIF(${sum_sessions}, 0);;
    value_format: "0%"
  }

  measure: pct_user_area_available_returning_users {
    label: "% Sessions with user area avialable true"
    description: "Share of sessions that had user area available true"
    hidden:  no
    type: number
    sql: ${cnt_address_selected_true} / NULLIF(${sum_sessions}, 0);;
    value_format: "0%"
  }

  measure: pct_view_item_returning_users {
    label: "% Sessions with view item"
    description: "Share of sessions that had view item"
    hidden:  no
    type: number
    sql: ${cnt_view_item} / NULLIF(${sum_sessions}, 0);;
    value_format: "0%"
  }

  measure: pct_add_to_cart_returning_users {
    label: "% Sessions with add to cart"
    description: "Share of sessions that had add to cart"
    hidden:  no
    type: number
    sql: ${cnt_add_to_cart} / NULLIF(${sum_sessions}, 0);;
    value_format: "0%"
  }

  measure: pct_checkout_started_returning_users {
    label: "% Sessions with checkout started"
    description: "Share of sessions that had checkout started"
    hidden:  no
    type: number
    sql: ${cnt_checkout_started} / NULLIF(${sum_sessions}, 0);;
    value_format: "0%"
  }

  measure: pct_checkout_confirmed_returning_users {
    label: "% Sessions with checkout confirmed"
    description: "Share of sessions that had checkout confirmed"
    hidden:  no
    type: number
    sql: ${cnt_checkout_confirmed} / NULLIF(${sum_sessions}, 0);;
    value_format: "0%"
  }

  measure: pct_purchase_returning_users {
  label: "% Sessions with purchase"
  description: "Share of sessions that had purchase"
  hidden:  no
  type: number
  sql: ${cnt_purchase} / NULLIF(${sum_sessions}, 0);;
  value_format: "0%"
  }


  set: detail {
    fields: [
      _adid_,
      session_id,
      session_start_at_time,
      next_session_start_at_time,
      city,
      os_name,
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
      checkout_started,
      payment_method_added,
      payment_failed,
      first_purchase,
      purchase
    ]
  }
}
