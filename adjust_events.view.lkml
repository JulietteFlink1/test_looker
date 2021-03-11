view: adjust_events {
  derived_table: {
    persist_for: "12 hours"
    sql: select adjust.*, adjust._adid_ ||'-'|| adjust._created_at_ as event_id,
        case when _event_name_ = 'SearchExecuted' and lead(_event_name_) over(partition by _adid_ order by TIMESTAMP_SECONDS(_created_at_)) IN('AddToCart', 'ViewItem') then TRUE else FALSE end as has_search_and_consecutive_add_to_cart_or_view_item
        from `flink-backend.customlytics_adjust.adjust_raw_imports` adjust
        WHERE adjust._activity_kind_ = 'event';;
  }

  dimension: _activity_kind_ {
    type: string
    sql: ${TABLE}._activity_kind_ ;;
  }

  dimension: _ad_mediation_platform_ {
    type: string
    sql: ${TABLE}._ad_mediation_platform_ ;;
  }

  dimension: _ad_revenue_network_ {
    type: string
    sql: ${TABLE}._ad_revenue_network_ ;;
  }

  dimension: _ad_revenue_placement_ {
    type: string
    sql: ${TABLE}._ad_revenue_placement_ ;;
  }

  dimension: _ad_revenue_unit_ {
    type: string
    sql: ${TABLE}._ad_revenue_unit_ ;;
  }

  dimension: _adgroup_name_ {
    type: string
    sql: ${TABLE}._adgroup_name_ ;;
  }

  dimension: _adid_ {
    type: string
    sql: ${TABLE}._adid_ ;;
  }

  dimension: _android_id_ {
    type: string
    sql: ${TABLE}._android_id_ ;;
  }

  dimension: _android_id_md5_ {
    type: string
    sql: ${TABLE}._android_id_md5_ ;;
  }

  dimension: _api_level_ {
    type: number
    sql: ${TABLE}._api_level_ ;;
  }

  dimension: _app_id_ {
    type: string
    sql: ${TABLE}._app_id_ ;;
  }

  dimension: _app_name_ {
    type: string
    sql: ${TABLE}._app_name_ ;;
  }

  dimension: _app_name_dashboard_ {
    type: string
    sql: ${TABLE}._app_name_dashboard_ ;;
  }

  dimension: _app_version_ {
    type: string
    sql: ${TABLE}._app_version_ ;;
  }

  dimension: _app_version_raw_ {
    type: string
    sql: ${TABLE}._app_version_raw_ ;;
  }

  dimension: _app_version_short_ {
    type: string
    sql: ${TABLE}._app_version_short_ ;;
  }

  dimension: _article_id_ {
    type: string
    sql: ${TABLE}._ArticleId_ ;;
  }

  dimension: _article_name_ {
    type: string
    sql: ${TABLE}._ArticleName_ ;;
  }

  dimension: _att_status_ {
    type: string
    sql: ${TABLE}._att_status_ ;;
  }

  dimension: _attribution_updated_at_ {
    type: string
    sql: ${TABLE}._attribution_updated_at_ ;;
  }

  dimension: _campaign_name_ {
    type: string
    sql: ${TABLE}._campaign_name_ ;;
  }

  dimension: _category_id_ {
    type: string
    sql: ${TABLE}._CategoryId_ ;;
  }

  dimension: _category_ids_ {
    type: string
    sql: ${TABLE}._CategoryIds_ ;;
  }

  dimension: _category_name_ {
    type: string
    sql: ${TABLE}._CategoryName_ ;;
  }

  dimension: _category_names_ {
    type: string
    sql: ${TABLE}._CategoryNames_ ;;
  }

  dimension: _city_ {
    type: string
    sql: ${TABLE}._city_ ;;
  }

  dimension: _click_attribution_window_ {
    type: number
    sql: ${TABLE}._click_attribution_window_ ;;
  }

  dimension: _click_referer_ {
    type: string
    sql: ${TABLE}._click_referer_ ;;
  }

  dimension: _click_time_ {
    type: string
    sql: ${TABLE}._click_time_ ;;
  }

  dimension: _click_time_hour_ {
    type: string
    sql: ${TABLE}._click_time_hour_ ;;
  }

  dimension: _connection_type_ {
    type: string
    sql: ${TABLE}._connection_type_ ;;
  }

  dimension: _conversion_duration_ {
    type: string
    sql: ${TABLE}._conversion_duration_ ;;
  }

  dimension: _cost_amount_ {
    type: string
    sql: ${TABLE}._cost_amount_ ;;
  }

  dimension: _cost_currency_ {
    type: string
    sql: ${TABLE}._cost_currency_ ;;
  }

  dimension: _cost_id_md5_ {
    type: string
    sql: ${TABLE}._cost_id_md5_ ;;
  }

  dimension: _cost_type_ {
    type: string
    sql: ${TABLE}._cost_type_ ;;
  }

  dimension: _country_ {
    type: string
    sql: ${TABLE}._country_ ;;
  }

  dimension: _country_subdivision_ {
    type: string
    sql: ${TABLE}._country_subdivision_ ;;
  }

  dimension: _coupon_ {
    type: yesno
    sql: ${TABLE}._Coupon_ ;;
  }

  dimension: _coupon_code_ {
    type: string
    sql: ${TABLE}._CouponCode_ ;;
  }

  dimension: _coupon_value_ {
    type: number
    sql: ${TABLE}._CouponValue_ ;;
  }

  dimension: _cpu_type_ {
    type: string
    sql: ${TABLE}._cpu_type_ ;;
  }

  dimension_group: _created_at_ {
    label: "Created"
    description: "Event created time"
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
    sql: TIMESTAMP_SECONDS(${TABLE}._created_at_) ;;
    datatype: timestamp
  }

  dimension: _created_at_hour_ {
    type: number
    sql: ${TABLE}._created_at_hour_ ;;
  }

  dimension: _created_at_milli_ {
    type: number
    sql: ${TABLE}._created_at_milli_ ;;
  }

  dimension: _creative_name_ {
    type: string
    sql: ${TABLE}._creative_name_ ;;
  }

  dimension: _currency_ {
    type: string
    sql: ${TABLE}._currency_ ;;
  }

  dimension: _deeplink_ {
    type: string
    sql: ${TABLE}._deeplink_ ;;
  }

  dimension: _delivery_city_ {
    type: string
    sql: ${TABLE}._DeliveryCity_ ;;
  }

  dimension: _delivery_cost_ {
    type: number
    sql: ${TABLE}._DeliveryCost_ ;;
  }

  dimension: _delivery_estimated_time_ {
    type: number
    sql: ${TABLE}._DeliveryEstimatedTime_ ;;
  }

  dimension: _delivery_lat_ {
    type: number
    sql: ${TABLE}._DeliveryLat_ ;;
  }

  dimension: _delivery_long_ {
    type: number
    sql: ${TABLE}._DeliveryLong_ ;;
  }

  dimension: _delivery_polygon_id_ {
    type: string
    sql: ${TABLE}._DeliveryPolygonId_ ;;
  }

  dimension: _delivery_zip_ {
    type: number
    sql: ${TABLE}._DeliveryZip_ ;;
  }

  dimension: _device_manufacturer_ {
    type: string
    sql: ${TABLE}._device_manufacturer_ ;;
  }

  dimension: _device_name_ {
    type: string
    sql: ${TABLE}._device_name_ ;;
  }

  dimension: _device_type_ {
    type: string
    sql: ${TABLE}._device_type_ ;;
  }

  dimension: _engagement_time_ {
    type: string
    sql: ${TABLE}._engagement_time_ ;;
  }

  dimension: _engagement_time_hour_ {
    type: string
    sql: ${TABLE}._engagement_time_hour_ ;;
  }

  dimension: _environment_ {
    type: string
    sql: ${TABLE}._environment_ ;;
  }

  dimension: _event_ {
    type: string
    sql: ${TABLE}._event_ ;;
  }

  dimension: _event_name_ {
    type: string
    sql: ${TABLE}._event_name_ ;;
  }

  dimension: _fb_account_id_ {
    type: string
    sql: ${TABLE}._fb_account_id_ ;;
  }

  dimension: _fb_ad_objective_name_ {
    type: string
    sql: ${TABLE}._fb_ad_objective_name_ ;;
  }

  dimension: _fb_adgroup_id_ {
    type: string
    sql: ${TABLE}._fb_adgroup_id_ ;;
  }

  dimension: _fb_adgroup_name_ {
    type: string
    sql: ${TABLE}._fb_adgroup_name_ ;;
  }

  dimension: _fb_campaign_group_id_ {
    type: string
    sql: ${TABLE}._fb_campaign_group_id_ ;;
  }

  dimension: _fb_campaign_group_name_ {
    type: string
    sql: ${TABLE}._fb_campaign_group_name_ ;;
  }

  dimension: _fb_campaign_id_ {
    type: string
    sql: ${TABLE}._fb_campaign_id_ ;;
  }

  dimension: _fb_campaign_name_ {
    type: string
    sql: ${TABLE}._fb_campaign_name_ ;;
  }

  dimension: _fb_content_id_ {
    type: string
    sql: ${TABLE}._fb_content_id_ ;;
  }

  dimension: _fb_content_type_ {
    type: string
    sql: ${TABLE}._fb_content_type_ ;;
  }

  dimension: _fb_platform_position_ {
    type: string
    sql: ${TABLE}._fb_platform_position_ ;;
  }

  dimension: _fingerprint_attribution_window_ {
    type: number
    sql: ${TABLE}._fingerprint_attribution_window_ ;;
  }

  dimension: _fire_adid_ {
    type: string
    sql: ${TABLE}._fire_adid_ ;;
  }

  dimension: _first_tracker_ {
    type: string
    sql: ${TABLE}._first_tracker_ ;;
  }

  dimension: _first_tracker_name_ {
    type: string
    sql: ${TABLE}._first_tracker_name_ ;;
  }

  dimension: _gclid_ {
    type: string
    sql: ${TABLE}._gclid_ ;;
  }

  dimension: _google_ads_adgroup_id_ {
    type: string
    sql: ${TABLE}._google_ads_adgroup_id_ ;;
  }

  dimension: _google_ads_campaign_id_ {
    type: string
    sql: ${TABLE}._google_ads_campaign_id_ ;;
  }

  dimension: _google_ads_campaign_name_ {
    type: string
    sql: ${TABLE}._google_ads_campaign_name_ ;;
  }

  dimension: _google_ads_campaign_type_ {
    type: string
    sql: ${TABLE}._google_ads_campaign_type_ ;;
  }

  dimension: _google_ads_creative_id_ {
    type: string
    sql: ${TABLE}._google_ads_creative_id_ ;;
  }

  dimension: _google_ads_keyword_ {
    type: string
    sql: ${TABLE}._google_ads_keyword_ ;;
  }

  dimension: _google_ads_matchtype_ {
    type: string
    sql: ${TABLE}._google_ads_matchtype_ ;;
  }

  dimension: _google_ads_network_subtype_ {
    type: string
    sql: ${TABLE}._google_ads_network_subtype_ ;;
  }

  dimension: _google_ads_network_type_ {
    type: string
    sql: ${TABLE}._google_ads_network_type_ ;;
  }

  dimension: _google_ads_placement_ {
    type: string
    sql: ${TABLE}._google_ads_placement_ ;;
  }

  dimension: _google_ads_video_id_ {
    type: string
    sql: ${TABLE}._google_ads_video_id_ ;;
  }

  dimension: _gps_adid_ {
    type: string
    sql: ${TABLE}._gps_adid_ ;;
  }

  dimension: _gps_adid_md5_ {
    type: string
    sql: ${TABLE}._gps_adid_md5_ ;;
  }

  dimension: _hardware_name_ {
    type: string
    sql: ${TABLE}._hardware_name_ ;;
  }

  dimension: _iad_conversion_type_ {
    type: string
    sql: ${TABLE}._iad_conversion_type_ ;;
  }

  dimension: _iad_creative_set_id_ {
    type: string
    sql: ${TABLE}._iad_creative_set_id_ ;;
  }

  dimension: _iad_creative_set_name_ {
    type: string
    sql: ${TABLE}._iad_creative_set_name_ ;;
  }

  dimension: _iad_keyword_matchtype_ {
    type: string
    sql: ${TABLE}._iad_keyword_matchtype_ ;;
  }

  dimension: _idfa_ {
    type: string
    sql: ${TABLE}._idfa_ ;;
  }

  dimension: _idfa__android_id_ {
    type: string
    sql: ${TABLE}._idfa__android_id_ ;;
  }

  dimension: _idfa__gps_adid_ {
    type: string
    sql: ${TABLE}._idfa__gps_adid_ ;;
  }

  dimension: _idfa__gps_adid__fire_adid_ {
    type: string
    sql: ${TABLE}._idfa__gps_adid__fire_adid_ ;;
  }

  dimension: _idfa_md5_ {
    type: string
    sql: ${TABLE}._idfa_md5_ ;;
  }

  dimension: _idfa_md5_hex_ {
    type: string
    sql: ${TABLE}._idfa_md5_hex_ ;;
  }

  dimension: _idfa_upper_ {
    type: string
    sql: ${TABLE}._idfa_upper_ ;;
  }

  dimension: _idfv_ {
    type: string
    sql: ${TABLE}._idfv_ ;;
  }

  dimension: _impression_attribution_window_ {
    type: string
    sql: ${TABLE}._impression_attribution_window_ ;;
  }

  dimension: _impression_based_ {
    type: number
    sql: ${TABLE}._impression_based_ ;;
  }

  dimension: _impression_time_ {
    type: string
    sql: ${TABLE}._impression_time_ ;;
  }

  dimension: _impression_time_hour_ {
    type: string
    sql: ${TABLE}._impression_time_hour_ ;;
  }

  dimension: _inactive_user_definition_ {
    type: string
    sql: ${TABLE}._inactive_user_definition_ ;;
  }

  dimension: _install_begin_time_ {
    type: number
    sql: ${TABLE}._install_begin_time_ ;;
  }

  dimension: _install_finish_time_ {
    type: number
    sql: ${TABLE}._install_finish_time_ ;;
  }

  dimension: _installed_at_ {
    type: date_time
    sql: TIMESTAMP_SECONDS(${TABLE}._installed_at_) ;;
  }

  dimension: _installed_at_hour_ {
    type: number
    sql: ${TABLE}._installed_at_hour_ ;;
  }

  dimension: _ip_address_ {
    type: string
    sql: ${TABLE}._ip_address_ ;;
  }

  dimension: _is_organic_ {
    type: number
    sql: ${TABLE}._is_organic_ ;;
  }

  dimension: _is_reattributed_ {
    type: number
    sql: ${TABLE}._is_reattributed_ ;;
  }

  dimension: _is_s2s_ {
    type: number
    sql: ${TABLE}._is_s2s_ ;;
  }

  dimension: _is_s2s_engagement_based_ {
    type: number
    sql: ${TABLE}._is_s2s_engagement_based_ ;;
  }

  dimension: _isp_ {
    type: string
    sql: ${TABLE}._isp_ ;;
  }

  dimension: _item_discount_ {
    type: string
    sql: ${TABLE}._ItemDiscount_ ;;
  }

  dimension: _item_id_ {
    type: string
    sql: ${TABLE}._ItemId_ ;;
  }

  dimension: _item_ids_ {
    type: string
    sql: ${TABLE}._ItemIds_ ;;
  }

  dimension: _item_name_ {
    type: string
    sql: ${TABLE}._ItemName_ ;;
  }

  dimension: _item_names_ {
    type: string
    sql: ${TABLE}._ItemNames_ ;;
  }

  dimension: _item_price_ {
    type: number
    sql: ${TABLE}._ItemPrice_ ;;
  }

  dimension: _label_ {
    type: string
    sql: ${TABLE}._label_ ;;
  }

  dimension: _language_ {
    type: string
    sql: ${TABLE}._language_ ;;
  }

  dimension: _last_session_time_ {
    type: number
    sql: ${TABLE}._last_session_time_ ;;
  }

  dimension: _last_time_spent_ {
    type: number
    sql: ${TABLE}._last_time_spent_ ;;
  }

  dimension: _last_tracker_ {
    type: string
    sql: ${TABLE}._last_tracker_ ;;
  }

  dimension: _last_tracker_name_ {
    type: string
    sql: ${TABLE}._last_tracker_name_ ;;
  }

  dimension: _lifetime_session_count_ {
    type: number
    sql: ${TABLE}._lifetime_session_count_ ;;
  }

  dimension: _mac_md5_ {
    type: string
    sql: ${TABLE}._mac_md5_ ;;
  }

  dimension: _mac_sha1_ {
    type: string
    sql: ${TABLE}._mac_sha1_ ;;
  }

  dimension: _match_type_ {
    type: string
    sql: ${TABLE}._match_type_ ;;
  }

  dimension: _mcc_ {
    type: number
    sql: ${TABLE}._mcc_ ;;
  }

  dimension: _mnc_ {
    type: number
    sql: ${TABLE}._mnc_ ;;
  }

  dimension: _network_name_ {
    type: string
    sql: ${TABLE}._network_name_ ;;
  }

  dimension: _network_type_ {
    type: string
    sql: ${TABLE}._network_type_ ;;
  }

  dimension: _nonce_ {
    type: string
    sql: ${TABLE}._nonce_ ;;
  }

  dimension: _oaid_ {
    type: string
    sql: ${TABLE}._oaid_ ;;
  }

  dimension: _oaid_md5_ {
    type: string
    sql: ${TABLE}._oaid_md5_ ;;
  }

  dimension: _order_id_ {
    type: string
    sql: ${TABLE}._OrderId_ ;;
  }

  dimension: _os_name_ {
    type: string
    sql: ${TABLE}._os_name_ ;;
  }

  dimension: _os_version_ {
    type: string
    sql: ${TABLE}._os_version_ ;;
  }

  dimension: _outdated_tracker_ {
    type: string
    sql: ${TABLE}._outdated_tracker_ ;;
  }

  dimension: _partitiondate {
    type: date
    convert_tz: no
    datatype: date
    sql: DATE(${TABLE}._PARTITIONTIME) ;;
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
    sql: ${TABLE}._PARTITIONTIME ;;
  }

  dimension: _payment_method_ {
    type: string
    sql: ${TABLE}._PaymentMethod_ ;;
  }

  dimension: _postal_code_ {
    type: number
    sql: ${TABLE}._postal_code_ ;;
  }

  dimension: _proxy_ip_address_ {
    type: string
    sql: ${TABLE}._proxy_ip_address_ ;;
  }

  dimension: _publisher_parameters_ {
    type: string
    sql: ${TABLE}._publisher_parameters_ ;;
  }

  dimension: _push_token_ {
    type: string
    sql: ${TABLE}._push_token_ ;;
  }

  dimension: _quantity_ {
    type: number
    sql: ${TABLE}._Quantity_ ;;
  }

  dimension: _random_ {
    type: number
    sql: ${TABLE}._random_ ;;
  }

  dimension: _random_user_id_ {
    type: string
    sql: ${TABLE}._random_user_id_ ;;
  }

  dimension: _reattributed_at_ {
    type: string
    sql: ${TABLE}._reattributed_at_ ;;
  }

  dimension: _reattributed_at_hour_ {
    type: string
    sql: ${TABLE}._reattributed_at_hour_ ;;
  }

  dimension: _reattribution_attribution_window_ {
    type: string
    sql: ${TABLE}._reattribution_attribution_window_ ;;
  }

  dimension: _referral_time_ {
    type: number
    sql: ${TABLE}._referral_time_ ;;
  }

  dimension: _referrer_ {
    type: string
    sql: ${TABLE}._referrer_ ;;
  }

  dimension: _reftag_ {
    type: string
    sql: ${TABLE}._reftag_ ;;
  }

  dimension: _region_ {
    type: string
    sql: ${TABLE}._region_ ;;
  }

  dimension: _reinstalled_at_ {
    type: string
    sql: ${TABLE}._reinstalled_at_ ;;
  }

  dimension: _rejection_reason_ {
    type: string
    sql: ${TABLE}._rejection_reason_ ;;
  }

  dimension: _reporting_cost_ {
    type: string
    sql: ${TABLE}._reporting_cost_ ;;
  }

  dimension: _reporting_currency_ {
    type: string
    sql: ${TABLE}._reporting_currency_ ;;
  }

  dimension: _reporting_revenue_ {
    type: number
    sql: ${TABLE}._reporting_revenue_ ;;
  }

  dimension: _revenue_ {
    type: number
    sql: ${TABLE}._revenue_ ;;
  }

  dimension: _revenue_float_ {
    type: number
    sql: ${TABLE}._revenue_float_ ;;
  }

  dimension: _revenue_usd_ {
    type: number
    sql: ${TABLE}._revenue_usd_ ;;
  }

  dimension: _revenue_usd_cents_ {
    type: number
    sql: ${TABLE}._revenue_usd_cents_ ;;
  }

  dimension: _sdk_version_ {
    type: string
    sql: ${TABLE}._sdk_version_ ;;
  }

  dimension: _search_term_ {
    type: string
    sql: ${TABLE}._SearchTerm_ ;;
  }


  dimension: _session_count_ {
    type: number
    sql: ${TABLE}._session_count_ ;;
  }

  dimension: _store_ {
    type: string
    sql: ${TABLE}._store_ ;;
  }

  dimension: _sub_category_id_ {
    type: string
    sql: ${TABLE}._SubCategoryId_ ;;
  }

  dimension: _sub_category_ids_ {
    type: string
    sql: ${TABLE}._SubCategoryIds_ ;;
  }

  dimension: _sub_category_name_ {
    type: string
    sql: ${TABLE}._SubCategoryName_ ;;
  }

  dimension: _sub_category_names_ {
    type: string
    sql: ${TABLE}._SubCategoryNames_ ;;
  }

  dimension: _third_party_sharing_disabled_ {
    type: number
    sql: ${TABLE}._third_party_sharing_disabled_ ;;
  }

  dimension: _time_spent_ {
    type: number
    sql: ${TABLE}._time_spent_ ;;
  }

  dimension: _time_to_reinstall_ {
    type: string
    sql: ${TABLE}._time_to_reinstall_ ;;
  }

  dimension: _time_to_uninstall_ {
    type: string
    sql: ${TABLE}._time_to_uninstall_ ;;
  }

  dimension: _timezone_ {
    type: string
    sql: ${TABLE}._timezone_ ;;
  }

  dimension: _tracker_ {
    type: string
    sql: ${TABLE}._tracker_ ;;
  }

  dimension: _tracker_name_ {
    type: string
    sql: ${TABLE}._tracker_name_ ;;
  }

  dimension: _tracking_enabled_ {
    type: number
    sql: ${TABLE}._tracking_enabled_ ;;
  }

  dimension: _tracking_limited_ {
    type: number
    sql: ${TABLE}._tracking_limited_ ;;
  }

  dimension: _transaction_id_ {
    type: string
    sql: ${TABLE}._TransactionId_ ;;
  }

  dimension: _tweet_id_ {
    type: string
    sql: ${TABLE}._tweet_id_ ;;
  }

  dimension: _twitter_line_item_id_ {
    type: string
    sql: ${TABLE}._twitter_line_item_id_ ;;
  }

  dimension: _uninstalled_at_ {
    type: string
    sql: ${TABLE}._uninstalled_at_ ;;
  }

  dimension: _user_agent_ {
    type: string
    sql: ${TABLE}._user_agent_ ;;
  }

  dimension: _user_area_available_ {
    type: yesno
    sql: ${TABLE}._UserAreaAvailable_ ;;
  }

  dimension: _user_id_ {
    type: string
    sql: ${TABLE}._UserId_ ;;
  }

  dimension: _user_status_ {
    type: string
    sql: ${TABLE}._UserStatus_ ;;
  }

  dimension: _web_uuid_ {
    type: string
    sql: ${TABLE}._web_uuid_ ;;
  }

  dimension: _win_adid_ {
    type: string
    sql: ${TABLE}._win_adid_ ;;
  }

  dimension: _win_hwid_ {
    type: string
    sql: ${TABLE}._win_hwid_ ;;
  }

  dimension: _win_naid_ {
    type: string
    sql: ${TABLE}._win_naid_ ;;
  }

  dimension: _win_udid_ {
    type: string
    sql: ${TABLE}._win_udid_ ;;
  }

  ### Custom dimensions

  dimension: event_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.event_id ;;
  }

  dimension: has_search_and_consecutive_add_to_cart_or_view_item {
    label: "Search is successful"
    description: "If a search executed event is followed by an add to cart event or view item event this dimension is true otherwise is false"
    type: yesno
    sql: ${TABLE}.has_search_and_consecutive_add_to_cart_or_view_item is not FALSE ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }


############
## COUNTS ##
############

  measure: cnt_unique_adid {
    label: "# Unique Users"
    description: "Count of Unique Users identified via their ADID generated by Adjust"
    hidden:  no
    type: count_distinct
    sql: ${_adid_};;
    value_format: "0"
  }
}
