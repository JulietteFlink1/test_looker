view: discounts {
  sql_table_name: `flink-data-prod.curated.discounts`;;

  dimension: discount_id {
    hidden: yes
    type: string
    sql: ${TABLE}.discount_id ;;
    group_label: "* IDs *"

  }

  dimension: discount_uuid {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}.discount_uuid ;;
    group_label: "* IDs *"
  }

  dimension: cart_discount_id {
    label: "Cart Discount ID"
    hidden: yes
    type: string
    sql: ${TABLE}.cart_discount_id ;;
    group_label: "* IDs *"
  }

  dimension: cart_discount_type {
    label: "Cart Discount Type"
    type: string
    hidden:  yes
    sql: ${TABLE}.cart_discount_type ;;
  }

  dimension: discount_value_type {
    label: "Discount Value Type"
    group_label: "* Dimensions *"
    description: "Discount type. Either percentage, absolute or not available."
    type: string
    sql: ${TABLE}.discount_value_type ;;
  }

  dimension: backend_source {
    label: "Backend Source"
    group_label: "* Dimensions *"
    type: string
    sql: ${TABLE}.backend_source ;;
  }

  dimension: talon_one_campaign {
    label: "Campaign ID"
    group_label: "* IDs *"
    description: "Campaign ID for T1 campaigns only."
    type: string
    sql: ${TABLE}.talon_one_campaign ;;
  }

  dimension: minimum_order_value {
    label: "Minimum Order Value"
    group_label: "* Dimensions *"
    type: number
    sql: ${TABLE}.minimum_order_value ;;
  }

  dimension_group: created {
    label: "Discount Code Creation"
    group_label: "* Dates and Timestamps *"
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
    sql: ${TABLE}.created_at_timestamp ;;
  }

  dimension: discount_code {
    label: "Discount Code"
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.discount_code ;;
  }

  dimension: discount_description {
    label: "Discount Code Description"
    hidden:  yes
    type: string
    sql: ${TABLE}.discount_description ;;
  }

  dimension: discount_group {
    label: "Discount Code Group"
    group_label: "* Dimensions *"
    description: "Type of users targeted by the campaign."
    type: string
    sql: ${TABLE}.discount_group ;;
  }

  dimension: discount_name {
    label: "Discount Code Name"
    group_label: "* Dimensions *"
    description: "The marketing channel for the campaign."
    type: string
    sql: ${TABLE}.discount_name ;;
  }

  dimension: is_active {
    label: "Discount Code Is Active"
    group_label: "* Dimensions *"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.is_active ;;
  }

  dimension: is_free_delivery_discount {
    label: "Free Delivery Discount"
    group_label: "* Dimensions *"
    type: yesno
    sql: ${TABLE}.is_free_delivery_discount ;;
  }

  dimension_group: last_modified {
    label: "Date Discount Code Last Modified At"
    group_label: "* Dates and Timestamps *"
    hidden: yes
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
    sql: ${TABLE}.last_modified_timestamp ;;
  }

  dimension: max_applications {
    label: "Max Discount Applications"
    group_label: "* Dimensions *"
    type: number
    sql: ${TABLE}.max_applications ;;
  }

  dimension: max_applications_per_customer {
    label: "Max Discount Applications per Customer"
    group_label: "* Dimensions *"
    type: number
    sql: ${TABLE}.max_applications_per_customer ;;
  }

  dimension_group: valid_from {
    group_label: "* Dates and Timestamps *"
    label: "Valid From"
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
    sql: ${TABLE}.valid_from_timestamp ;;
  }

  dimension_group: valid_until {
    label: "Valid Until"
    group_label: "* Dates and Timestamps *"
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
    sql: ${TABLE}.valid_until_timestamp ;;
  }

  dimension: discount_value {
    label: "Discount Amount"
    group_label: "* Dimensions *"
    description: "Quantity of discount, according to how it is specified in discount value type."
    type: number
    sql: ${TABLE}.discount_value ;;
  }

  dimension: use_case {
    alias: [discount_use_case]
    label: "Use Case"
    group_label: "* Dimensions *"
    description: "  Defined use case for a voucher. On a marketing type granularity."
    type: string
    sql: ${TABLE}.use_case ;;
  }

  dimension: used {
    label: "Discounts Used"
    hidden: yes
    sql: ${TABLE}.used ;;
    value_format_name: decimal_0
  }


  measure: count {
    group_label: "* Generic Measures *"
    hidden: yes
    type: count
    drill_fields: [discount_id, discount_name]
  }
}
