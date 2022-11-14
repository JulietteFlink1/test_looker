view: stickiness_analysis_v1 {
  sql_table_name: `flink-data-dev.dbt_nwierzbowska.customer_lifecycle_stickiness_v1`;;

    view_label: "Stickiness analysis"

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



    # ======= Generic Dimensions ======= #


  dimension_group: event_date_partition {
    hidden: yes
    type: time
    datatype: date
    sql: ${TABLE}.first_order_date ;;
    }

    dimension_group: first_order_at {
      group_label: "Date"
      label: "First Order"
      description: "Date of First Order"
      type: time
      timeframes: [
        date,
        week,
        month,
        year
      ]
      sql: ${TABLE}.first_order_date ;;
      datatype: date
    }

  dimension_group: first_visit_at {
    group_label: "Date"
    label: "First Visit Date"
    description: "Date of First Visit"
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.first_visit_date AS DATE) ;;
    datatype: date
  }

    dimension: country_iso {
      group_label: "Dimensions"
      label: "Country ISO"
      description: "First order ISO country"
      type: string
      sql: ${TABLE}.country_iso ;;
    }

    dimension: platform {
      group_label: "Dimensions"
      label: "Platform"
      description: "First Order Platform"
      type: string
      sql: ${TABLE}.platform ;;
    }


    dimension: number_of_days_to_first_order {
      group_label: "Dimensions"
      label: "# of days to first order (from first visit date)"
      type: number
      sql: ${TABLE}.number_of_days_to_first_order;;
    }

#################### Stickiness


    dimension: num_of_weeks_from_first_to_latest_order {
      group_label: "Stickiness Dimensions"
      label: "max # of weeks in which we recorded an order (from first order)"
      type: number
      sql: ${TABLE}.num_of_weeks_from_first_to_latest_order;;
    }

    dimension: total_orders_in_num_weeks {
      group_label: "Stickiness Dimensions"
      label: "Total # of orders placed since first order until the max week (within f25w)"
      type: number
      sql: ${TABLE}.total_orders_in_num_weeks;;
    }



    # ======= Order Dimensions ======= #

    dimension: w1_had_discounted_order {
      group_label: "Order Dimensions"
      label: "W1 Is Discounted"
      description: "User Had a discounted order in 1st week"
      type: yesno
      sql: ${TABLE}.w1_had_discounted_order;;
    }

    dimension: w1_sum_of_discounted_orders {
      group_label: "Order Dimensions"
      label: "W1 discounted orders"
      description: "Total orders with discount in W1 since first order"
      type: number
      sql: ${TABLE}.w1_sum_of_discounted_orders ;;
    }

    dimension: w1_sum_of_orders {
      group_label: "Order Dimensions"
      label: "W1 orders"
      description: "Total orders in W1 since first order"
      type: number
      sql: ${TABLE}.w1_sum_of_orders;;
    }

  dimension: w2_sum_of_orders {
    group_label: "Order Dimensions"
    label: "W2 orders"
    description: "Total orders in W2 since first order"
    type: number
    sql: ${TABLE}.w2_sum_of_orders;;
  }

  dimension: w3_sum_of_orders {
    group_label: "Order Dimensions"
    label: "W3 orders"
    description: "Total orders in W3 since first order"
    type: number
    sql: ${TABLE}.w3_sum_of_orders;;
  }

  dimension: w4_sum_of_orders {
    group_label: "Order Dimensions"
    label: "W4 orders"
    description: "Total orders in W4 since first order"
    type: number
    sql: ${TABLE}.w4_sum_of_orders;;
  }

  dimension: w5_sum_of_orders {
    group_label: "Order Dimensions"
    label: "W5 orders"
    description: "Total orders in W5 since first order"
    type: number
    sql: ${TABLE}.w5_sum_of_orders;;
  }

  dimension: w10_sum_of_orders {
    group_label: "Order Dimensions"
    label: "W10 orders"
    description: "Total orders in W10 since first order"
    type: number
    sql: ${TABLE}.w10_sum_of_orders;;
  }

  dimension: w15_sum_of_orders {
    group_label: "Order Dimensions"
    label: "W15 orders"
    description: "Total orders in W15 since first order"
    type: number
    sql: ${TABLE}.w15_sum_of_orders;;
  }

  dimension: w20_sum_of_orders {
    group_label: "Order Dimensions"
    label: "W20 orders"
    description: "Total orders in W20 since first order"
    type: number
    sql: ${TABLE}.w20_sum_of_orders;;
  }

  dimension: ltr_if_any_orders {
    group_label: "Order Dimensions"
    label: "Is LTR"
    description: "Long Term Retained - If users places an order after 20 weeks (max25)"
    type: yesno
    sql: ${TABLE}.ltr_if_any_orders;;
  }

  dimension: ltr_sum_of_orders {
    group_label: "Order Dimensions"
    label: "LTR orders"
    description: "Total orders in max week since first order"
    type: number
    sql: ${TABLE}.ltr_sum_of_orders;;
  }

    # dimension: discount_code {
    #   group_label: "Order Dimensions"
    #   hidden: yes
    #   label: "Discount Code"
    #   type: string
    #   sql: ${TABLE}.discount_code;;
    # }


    # ======= Measures ======= #


    measure: count_users {
      group_label: "Measures"
      hidden: no
      label: "# of Unique Users"
      type: count_distinct
      sql: ${customer_uuid};;
    }


    measure: count_users_ltr {
      group_label: "Measures"
      hidden: no
      label: "# of Unique Users retained after 20 weeks"
      type: count_distinct
      sql: ${customer_uuid};;
      filters: [ltr_if_any_orders: "yes"]
    }


  }
