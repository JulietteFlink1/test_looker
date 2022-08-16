view: first_order_refund_analysis {
  sql_table_name: `flink-data-dev.dbt_nwierzbowska.first_order_refund_analysis`;;
  view_label: "first order refunds analysis"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# ======= IDs ======= #

  dimension: customer_uuid {
    hidden: yes
    group_label: "IDs"
    label: "Customer UUID"
    description: "Customer UUID"
    type: string
    sql: ${TABLE}.customer_uuid ;;
  }

  dimension: user_id {
    hidden: yes
    group_label: "IDs"
    label: "User ID"
    description: "External ID from CT"
    type: string
    sql: ${TABLE}.external_id ;;
  }

  # dimension: device_id {
  #   hidden: yes
  #   group_label: "IDs"
  #   label: "Device ID"
  #   description: "Device ID from firebase installation"
  #   type: string
  #   sql: ${TABLE}.device_id ;;
  # }


  # ======= Generic Dimensions ======= #

  dimension_group: order_date {
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
    sql: CAST(${TABLE}.order_date AS DATE) ;;
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


  # ======= Order Dimensions ======= #

  dimension: order_uuid {
    hidden: yes
    # primary_key: yes
    group_label: "Order Dimensions"
    label: "Platform"
    description: "Platform"
    type: string
    sql: ${TABLE}.order_uuid ;;
  }


  dimension: is_discount_order {
    group_label: "Order Dimensions"
    label: "Is Discount Order"
    type: yesno
    sql: ${TABLE}.is_discount_order;;
  }

  dimension: discount_code {
    group_label: "Order Dimensions"
    label: "Discount Code"
    type: string
    sql: ${TABLE}.discount_code;;
  }

  dimension: discount_group {
    group_label: "Order Dimensions"
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

  dimension: is_refund_order {
    group_label: "Order Dimensions"
    label: "Is Refunded Order"
    type: yesno
    sql: ${TABLE}.is_refund_order;;
  }

  dimension: is_full_refund {
    group_label: "Order Dimensions"
    label: "Is Fully Refunded Order"
    type: yesno
    sql: ${TABLE}.is_full_refund;;
  }



  # measure: count_users_is_first_raf_sent {
  #   group_label: "Measures"
  #   label: "# Users is first RAF Sent"
  #   type: count_distinct
  #   sql: ${anonymous_id};;
  #   filters: [is_first_raf_sent: "yes"]
  # }

  measure: count_refunds_no_voucher {
    group_label: "Measures"
    label: "# of Refund orders without voucher"
    type: count_distinct
    sql: ${order_uuid};;
    filters: [is_refund_order: "yes", is_discount_order: "no"]
  }

  measure: count_orders_no_voucher {
    group_label: "Measures"
    label: "# of Orders without voucher"
    type: count_distinct
    sql: ${order_uuid};;
    filters: [is_discount_order: "no"]
  }

  measure: count_refunds_voucher {
    group_label: "Measures"
    label: "# of Refund orders with voucher"
    type: count_distinct
    sql: ${order_uuid};;
    filters: [is_refund_order: "yes", is_discount_order: "yes", is_raf_discount: "no"]
  }

  measure: count_orders_voucher {
    group_label: "Measures"
    label: "# of Orders with voucher"
    type: count_distinct
    sql: ${order_uuid};;
    filters: [is_discount_order: "yes", is_raf_discount: "no"]
  }


  measure: count_refunds_raf {
    group_label: "Measures"
    label: "# of Refund orders with raf voucher"
    type: count_distinct
    sql: ${order_uuid};;
    filters: [is_refund_order: "yes", is_raf_discount: "yes"]
  }

  measure: count_orders_raf {
    group_label: "Measures"
    label: "# of Orders with raf voucher"
    type: count_distinct
    sql: ${order_uuid};;
    filters: [is_raf_discount: "yes"]
  }


  measure: count_refunds {
    group_label: "Measures"
    label: "# of Refunds"
    type: count_distinct
    sql: ${order_uuid};;
    filters: [is_refund_order: "yes"]
  }


  measure: count_orders {
    group_label: "Measures"
    label: "# Orders"
    type: count_distinct
    sql: ${order_uuid};;
  }

  # measure: count_all_users {
  #   group_label: "Measures"
  #   label: "# Anonymous ids"
  #   type: count_distinct
  #   sql: ${anonymous_id};;
  # }

  measure: count_users {
    group_label: "Measures"
    label: "# User id"
    type: count_distinct
    sql: ${user_id};;
  }


 }
