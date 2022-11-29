view: voucher_funnel_analysis {
    sql_table_name: `flink-data-dev.dbt_nwierzbowska.promo_826`;;

    view_label: "Voucher Funnel analysis"

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# ======= IDs ======= #

    dimension: anonymous_id {
      hidden: yes
      group_label: "IDs"
      label: "Anonymous ID"
      description: "Anonymous ID"
      type: string
      sql: ${TABLE}.anonymous_id ;;
    }

  dimension: user_id {
    hidden: yes
    group_label: "IDs"
    label: "User ID"
    description: "User ID"
    type: string
    sql: ${TABLE}.user_id ;;
  }


    # ======= Generic Dimensions ======= #


    dimension_group: event_date_partition {
      hidden: yes
      type: time
      datatype: date
      sql: ${TABLE}.event_date ;;
    }

    dimension_group: event_date_at {
      group_label: "Date"
      label: "Event Date"
      description: "Date of Event"
      type: time
      timeframes: [
        date,
        week,
        month,
        year
      ]
      sql: ${TABLE}.event_date ;;
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
      description: "Event Platform"
      type: string
      sql: ${TABLE}.platform ;;
    }


  dimension: is_new_user {
    group_label: "Dimensions"
    label: "Is New User"
    description: "Daily User Aggregates defition of New user (first visit)"
    type: yesno
    sql: ${TABLE}.is_new_user ;;
  }



#################### flags


    dimension: is_home_viewed {
      group_label: "Funnel Flags"
      label: "Is Home Viewed"
      type: yesno
      sql: ${TABLE}.is_home_viewed;;
    }

  dimension: is_address_set {
    group_label: "Funnel Flags"
    label: "Is Address Set"
    type: yesno
    sql: ${TABLE}.is_address_set;;
  }

  dimension: is_discount_message_viewed {
    group_label: "Funnel Flags"
    label: "Is Discount in-App Message Viewed"
    type: yesno
    sql: ${TABLE}.is_discount_message_viewed;;
  }


  dimension: is_product_added_to_cart {
    group_label: "Funnel Flags"
    label: "Is Product ATC"
    type: yesno
    sql: ${TABLE}.is_product_added_to_cart;;
  }

    dimension: is_checkout_viewed {
        group_label: "Funnel Flags"
        label: "Is Checkout Viewed"
        type: yesno
        sql: ${TABLE}.is_checkout_viewed;;
      }

  dimension: is_payment_started {
    group_label: "Funnel Flags"
    label: "Is Payment Started"
    type: yesno
    sql: ${TABLE}.is_payment_started;;
  }

    dimension: number_of_checkout_viewed {
      group_label: "Funnel Dimensions"
      label: "# Checkout Viewed"
      description: "# of time user visited checkout on that day"
      type: number
      sql: ${TABLE}.number_of_checkout_viewed;;
    }


  dimension: is_order_placed {
    group_label: "Funnel Flags"
    label: "Is Order Placed"
    type: yesno
    sql: ${TABLE}.is_order_placed;;
  }

  dimension: is_order_placed_discounted {
    group_label: "Funnel Flags"
    label: "Is Order Placed with Discount"
    type: yesno
    sql: ${TABLE}.is_order_placed_discounted;;
  }


  dimension: is_voucher_redemption_attempted {
    group_label: "Funnel Flags"
    label: "Is Voucher Redemption Attempted"
    type: yesno
    sql: ${TABLE}.is_voucher_redemption_attempted;;
  }

  dimension: is_voucher_applied_succeeded {
    group_label: "Funnel Flags"
    label: "Is Voucher Applied Succeeded"
    type: yesno
    sql: ${TABLE}.is_voucher_applied_succeeded;;
  }

    # ======= Voucher Dimensions ======= #

  dimension: has_available_voucher {
    group_label: "Voucher Dimensions"
    label: "Has Available Voucher"
    description: "If user has an active voucher, from TalonOne"
    type: yesno
    sql: ${TABLE}.has_available_voucher;;
  }

    dimension: number_available_vouchers_talonone {
      group_label: "Voucher Dimensions"
      label: "# of Available Vouchers TalonOne"
      description: "# of Available vouchers, from TalonOne"
      type: number
      sql: ${TABLE}.number_available_vouchers;;
    }

  dimension: is_voucher_wallet_visited {
    group_label: "Voucher Dimensions"
    label: "Visited Voucher Wallet"
    description: "If User visited Voucher Walltet"
    type: yesno
    sql: ${TABLE}.is_voucher_wallet_visited;;
  }

  dimension: number_of_available_vouchers_in_voucher_wallet {
    group_label: "Voucher Dimensions"
    label: "# of Available Vouchers in Voucher Wallted"
    description: "# of Available vouchers when user visits Voucher Wallet"
    type: number
    sql: ${TABLE}.number_of_available_vouchers_in_voucher_wallet;;
  }

    dimension: is_voucher_applied_succeeded_from_voucher_wallet {
      group_label: "Voucher Dimensions"
      label: "Applied Voucher from Wallet"
      description: "Flag if user applied voucher from Voucher Wallet"
      type: yesno
      sql: ${TABLE}.is_voucher_applied_succeeded_from_voucher_wallet;;
    }

  dimension: event_origin_of_applied_voucher_code_from_voucher_wallet {
    group_label: "Voucher Dimensions"
    label: "Event Origin of Voucher Applied "
    description: "Method of Voucher Application from Voucher Wallet"
    type: string
    sql: ${TABLE}.event_origin_of_applied_voucher_code_from_voucher_wallet;;
  }


    dimension: number_of_days_to_expire_min {
      group_label: "Voucher Dimensions"
      label: "# Days Voucher to Expire"
      description: "MIN # days of the voucher to expire"
      type: number
      sql: ${TABLE}.number_of_days_to_expire_min;;
    }


    # ======= Funnel Measures ======= #

  measure: count_users {
    group_label: "Measures"
    hidden: no
    label: "# of Unique Users"
    type: count_distinct
    sql: ${anonymous_id};;
  }

    measure: count_users_home {
      group_label: "Funnel Measures"
      hidden: no
      label: "# Users on Home"
      type: count_distinct
      sql: ${anonymous_id};;
      filters: [is_home_viewed: "yes"]
    }

  measure: count_users_address_set {
    group_label: "Funnel Measures"
    hidden: no
    label: "# Users with Address Set"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_address_set: "yes"]
  }

  measure: count_users_discount_message_viewed {
    group_label: "Funnel Measures"
    hidden: no
    label: "# Users Discount Message Viewed"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_discount_message_viewed: "yes"]
  }

  measure: count_users_product_add_to_cart {
    group_label: "Funnel Measures"
    hidden: no
    label: "# Users Product ATC"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_product_added_to_cart: "yes"]
  }

  measure: count_users_in_checkout {
    group_label: "Funnel Measures"
    hidden: no
    label: "# Users in Checkout"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_checkout_viewed: "yes"]
  }

  measure: count_users_payment_started {
    group_label: "Funnel Measures"
    hidden: no
    label: "# Users Payment Started"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_payment_started: "yes"]
  }

  measure: count_users_orders {
    group_label: "Funnel Measures"
    hidden: no
    label: "# Users with Order"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_order_placed: "yes"]
  }

    # ======= Additional Measures ======= #



  measure: count_users_in_checkout_with_available_vouchers {
    group_label: "Measures"
    hidden: no
    label: "# of Users in Checkout with Available Vouchers"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_checkout_viewed: "yes", has_available_voucher: "yes"]
  }

  measure: count_users_in_checkout_no_available_vouchers {
    group_label: "Measures"
    hidden: no
    label: "# of Users in Checkout with No Vouchers"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_checkout_viewed: "yes", has_available_voucher: "no"]
  }

  measure: count_users_visit_voucher_wallet {
    group_label: "Measures"
    hidden: no
    label: "# of Users in Voucher Wallet"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_checkout_viewed: "yes", is_voucher_wallet_visited: "yes"]
  }

  measure: count_users_in_checkout_with_available_vouchers_and_wallet_visit {
    group_label: "Measures"
    hidden: no
    label: "# of Users in Checkout with Available Vouchers and Wallet Visit"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_checkout_viewed: "yes", has_available_voucher: "yes",is_voucher_wallet_visited: "yes"]
  }

  measure: count_users_in_checkout_with_available_vouchers_no_wallet_visit {
    group_label: "Measures"
    hidden: no
    label: "# of Users in Checkout with Available Vouchersbut no Wallet Visit"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_checkout_viewed: "yes", has_available_voucher: "yes",is_voucher_wallet_visited: "no"]
  }


  measure: count_users_apply_voucher_in_wallet {
    group_label: "Measures"
    hidden: yes
    label: "# of All Users Apply Voucher from Wallet"
    type: count_distinct
    sql: ${user_id};;
    filters: [is_checkout_viewed: "yes", is_voucher_applied_succeeded_from_voucher_wallet: "yes"]
  }


  measure: count_users_discounted_orders {
    group_label: "Measures"
    hidden: no
    label: "# of Users with Discounted Order"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_order_placed_discounted: "yes"]
  }


  measure: count_users_orders_missed_vouchers {
    group_label: "Order Measures"
    hidden: no
    label: "# of Users Order w. available non-redeemed vouchers"
    description: "# of Users with Order that had available vouchers but didn't check voucher wallet and did not redeem it"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_order_placed: "yes", is_order_placed_discounted: "no", is_voucher_wallet_visited: "no", has_available_voucher: "yes"]
  }

  measure: count_users_orders_no_missed_vouchers {
    group_label: "Order Measures"
    hidden: no
    label: "# of Users Order w. available and redeemed vouchers"
    description: "# of Users with Order that had available vouchers, checked voucher wallet and used it in order"
    type: count_distinct
    sql: ${anonymous_id};;
    filters: [is_order_placed: "yes", is_order_placed_discounted: "yes", is_voucher_wallet_visited: "yes", has_available_voucher: "yes"]
  }




  }
