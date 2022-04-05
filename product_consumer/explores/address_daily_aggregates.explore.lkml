include: "/product_consumer/views/address_daily_aggregates.view.lkml"
include: "/product_consumer/views/daily_user_aggregates.view.lkml"

explore: address_daily_aggregates {
  view_name: address_daily_aggregates
  label: "Address Daily User Activity"
  view_label: "Address Daily User Activity"
  group_label: "Consumer Product"
  description: "Address-centered tracking events aggregated per day per user"

  join: daily_user_aggregates {
    from: daily_user_aggregates
    type: left_outer
    relationship: one_to_one
    sql_on: ${daily_user_aggregates.daily_user_uuid}=${address_daily_aggregates.daily_user_uuid} ;;
  }

  fields: [daily_user_aggregates.user_uuid
    , daily_user_aggregates.country_iso
    , daily_user_aggregates.city
    , daily_user_aggregates.hub_code
    , daily_user_aggregates.device_type
    , daily_user_aggregates.platform
    , daily_user_aggregates.app_version
    , daily_user_aggregates.full_app_version
    , daily_user_aggregates.delivery_pdt
    , daily_user_aggregates.delivery_lat
    , daily_user_aggregates.delivery_lng
    , daily_user_aggregates.is_new_user
    , daily_user_aggregates.is_address_set
    , daily_user_aggregates.is_address_confirmed
    , daily_user_aggregates.is_home_viewed
    , daily_user_aggregates.is_checkout_viewed
    , daily_user_aggregates.is_order_placed
    , daily_user_aggregates.is_active_user
    , daily_user_aggregates.active_users
    , daily_user_aggregates.users_with_address
    , daily_user_aggregates.users_with_checkout_viewed
    , address_daily_aggregates*]
}
