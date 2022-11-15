view: stickiness_analysis {
    sql_table_name: `flink-data-dev.dbt_nwierzbowska.customer_lifecycle_stickiness`;;

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
      hidden: yes
      label: "max # of weeks in which we recorded an order (from first order)"
      type: number
      sql: ${TABLE}.num_of_weeks_from_first_to_latest_order;;
    }

    dimension: total_orders_in_num_weeks {
      group_label: "Stickiness Dimensions"
      label: "Max Orders"
      description: "Total # of orders placed since first order until the max week (within f25w)"
      type: number
      sql: ${TABLE}.total_orders_in_num_weeks;;
    }



    # ======= Order Dimensions ======= #

    dimension: week_index {
      group_label: "Order Dimensions"
      label: "# Week"
      description: "Number of Week since first order"
      type: number
      sql: ${TABLE}.week_index;;
    }

  dimension: sum_of_orders {
    group_label: "Order Dimensions"
    label: "# Orders"
    description: "# of Orders in Y weks"
    type: number
    sql: ${TABLE}.sum_of_orders;;
  }

  dimension: sum_of_gmv_gross {
    group_label: "Order Dimensions"
    label: "GMV"
    description: "SUm GMV of Orders in Y weks"
    type: number
    sql: ${TABLE}.sum_of_gmv_gross;;
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
