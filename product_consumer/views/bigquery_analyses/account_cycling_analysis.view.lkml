view: account_cycling_analysis {
  sql_table_name: `flink-data-dev.dbt_nwierzbowska.account_cycling_analysis`;;

  view_label: "Accoount cycling analysis"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# ======= IDs ======= #

  dimension: anonymous_id {
    hidden: yes
    group_label: "IDs"
    label: "Anonymous ID"
    description: "Customer UUID"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: user_id {
    hidden: yes
    group_label: "IDs"
    label: "User ID"
    description: "External ID from CT"
    type: string
    sql: ${TABLE}.external_id ;;
  }

  dimension: device_id {
    hidden: yes
    primary_key: yes
    group_label: "IDs"
    label: "Device ID"
    description: "Device ID from firebase installation"
    type: string
    sql: ${TABLE}.device_id ;;
  }


  # ======= Generic Dimensions ======= #

  dimension_group: event_date {
    group_label: "Date"
    label: "Event Date"
    description: "Date of when an event happened"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.event_date AS DATE) ;;
    datatype: date
  }

  dimension: country_iso {
    group_label: "Dimensions"
    label: "Country ISO"
    description: "ISO country"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: platform {
    group_label: "Dimensions"
    label: "Platform"
    description: "Platform"
    type: string
    sql: ${TABLE}.platform ;;
  }



  dimension: number_of_orders_cumulative {
    group_label: "Dimensions"
    label: "# of orders at point of deletion of account"
    type: number
    sql: ${TABLE}.number_of_orders_cumulative;;
  }

  dimension: is_delete_account_request_confirmed {
    group_label: "Account Dimensions"
    label: "Is Delete Account"
    type: yesno
    sql: ${TABLE}.is_delete_account_request_confirmed;;
  }

  dimension: is_account_registration_succeeded {
    group_label: "Account Dimensions"
    label: "Is Open New Account"
    type: yesno
    sql: ${TABLE}.is_account_registration_succeeded;;
  }

  dimension: num_days_from_deletion_to_opening {
    group_label: "Account Dimensions"
    label: "# of days from deletion to opening new account"
    type: number
    sql: ${TABLE}.num_days_from_deletion_to_opening;;
  }



  # ======= Order Dimensions ======= #

  # dimension: order_uuid {
  #   hidden: yes
  #   group_label: "Order Dimensions"
  #   label: "Platform"
  #   description: "Platform"
  #   type: string
  #   sql: ${TABLE}.order_uuid ;;
  # }

  dimension: has_order_placed_after_registration {
    group_label: "Order Dimensions"
    label: "Order Placed after New Registration"
    type: yesno
    sql: ${TABLE}.has_order_placed_after_registration;;
  }

  dimension: is_first_order {
    group_label: "Order Dimensions"
    label: "Is First Order"
    description: "Whether a user was logged-in when an event was triggered"
    type: yesno
    sql: ${TABLE}.is_first_order ;;
  }

  dimension: is_discount_order {
    group_label: "Order Dimensions"
    label: "Is Discount Order"
    type: yesno
    sql: ${TABLE}.order_with_discount;;
  }

  dimension: discount_code {
    group_label: "Order Dimensions"
    hidden: yes
    label: "Discount Code"
    type: string
    sql: ${TABLE}.discount_code;;
  }

  dimension: discount_group {
    group_label: "Order Dimensions"
    hidden: yes
    label: "Discount Group"
    type: string
    sql: ${TABLE}.discount_group;;
  }

  dimension: is_raf_discount {
    group_label: "Order Dimensions"
    label: "Is RAF discount"
    type: yesno
    sql: ${TABLE}.is_raf_discount;;
  }

  dimension: num_days_from_new_account_to_order {
    group_label: "Order Dimensions"
    label: "Nmber of Days between New Account and Order"
    type: number
    sql: ${TABLE}.num_days_from_new_account_to_order;;
  }



  # measure: count_refunds_no_voucher {
  #   group_label: "Measures"
  #   label: "# of Refund orders without voucher"
  #   type: count_distinct
  #   sql: ${order_uuid};;
  #   filters: [is_refund_order: "yes", is_discount_order: "no"]
  # }

  measure: count_anonymous_ids_registration {
    group_label: "Measures"
    hidden: yes
    label: "# of Anonymous_id registered after deletion"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_account_registration_succeeded: "yes"]
  }

  measure: count_anonymous_ids_no_registration {
    group_label: "Measures"
    hidden: yes
    label: "# of Anonymous_id did not register after deletion"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_account_registration_succeeded: "no"]
  }

  measure: count_anonymous_ids {
    group_label: "Measures"
    hidden: yes
    label: "# of Anonymous_ids"
    type: count_distinct
    sql: ${anonymous_id};;
  }

  measure: count_device_ids_registration {
    group_label: "Measures"
    label: "# of Device ids registered after deletion"
    type: count_distinct
    sql: ${device_id};;
    filters: [is_account_registration_succeeded: "yes"]
  }

  measure: count_device_ids_no_registration {
    group_label: "Measures"
    label: "# of Device ids did not register after deletion"
    type: count_distinct
    sql: ${device_id};;
    filters: [is_account_registration_succeeded: "no"]
  }

  measure: count_device_ids {
    group_label: "Measures"
    label: "# of Device Ids"
    type: count_distinct
    sql: ${device_id};;
  }


  measure: count_device_ids_registration_and_order_placed {
    group_label: "Measures"
    label: "# of Device ids registered after deletion and placed an order"
    type: count_distinct
    sql: ${device_id};;
    filters: [is_account_registration_succeeded: "yes", has_order_placed_after_registration: "yes"]
  }


  measure: count_device_ids_registration_and_order_placed_with_discount {
    group_label: "Measures"
    label: "# of Device ids registered after deletion and placed an order with a discount"
    type: count_distinct
    sql: ${device_id};;
    filters: [is_account_registration_succeeded: "yes", has_order_placed_after_registration: "yes", is_discount_order: "yes"]
  }


  measure: count_device_ids_registration_and_order_placed_with_discount_raf {
    group_label: "Measures"
    label: "# of Device ids registered after deletion and placed an order with a raf discount"
    type: count_distinct
    sql: ${device_id};;
    filters: [is_account_registration_succeeded: "yes", has_order_placed_after_registration: "yes", is_discount_order: "yes", is_raf_discount: "yes"]
  }


  # measure: count_all_users {
  #   group_label: "Measures"
  #   label: "# Anonymous ids"
  #   type: count_distinct
  #   sql: ${anonymous_id};;
  # }

  # measure: count_users {
  #   group_label: "Measures"
  #   label: "# User id"
  #   type: count_distinct
  #   sql: ${user_id};;
  # }


}
