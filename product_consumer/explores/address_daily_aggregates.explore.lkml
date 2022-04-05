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
    type: inner
    relationship: one_to_one
    sql_on: ${daily_user_aggregates.daily_user_uuid}=${address_daily_aggregates.daily_user_uuid} ;;
    fields: [
      device_attributes*
      , location_attributes*
      , user_uuid
      , is_new_user
      , is_address_set
      , is_address_confirmed
      , is_home_viewed
      , is_checkout_viewed
      , is_order_placed
      , is_active_user
      , active_users
      , users_with_address
      , users_with_checkout_viewed
      ]
    }
  }
