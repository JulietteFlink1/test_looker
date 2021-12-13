view: pdt_customer_retention {
  derived_table: {
    sql: with pdt_order as (
    select customer_email
        , country_iso
        , order_timestamp
        , date(order_timestamp) as  order_date
        , LEAD(date(order_timestamp),1) OVER (partition by customer_email, country_iso order by order_timestamp) as next_order_date
        , delivery_pdt_minutes
        , fulfillment_time_minutes
    from `flink-data-prod.curated.orders`
    where delivery_pdt_minutes is not null and is_successful_order is true
)
     select p.customer_email
        , p.country_iso
        , date(first_order_timestamp) as first_order_date
        , p.order_date
        , p.next_order_date
        , p.delivery_pdt_minutes
        , p.fulfillment_time_minutes
     from `flink-data-prod.curated.customers_metrics` c
     left join pdt_order p on c.customer_email = p.customer_email and c.country_iso = p.country_iso
     where c.first_order_timestamp = p.order_timestamp
    ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.customer_email, '_', ${TABLE}.country_iso) ;;
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: first_order_date {
    type: date
    datatype: date
    sql: ${TABLE}.first_order_date ;;
  }

  dimension: next_order_date {
    type: date
    datatype: date
    sql: ${TABLE}.next_order_date ;;
  }

  dimension: delivery_pdt_minutes {
    type: number
    sql: ${TABLE}.delivery_pdt_minutes ;;
  }

  dimension: fulfillment_time_minutes {
    type: number
    sql: ${TABLE}.fulfillment_time_minutes ;;
  }

  dimension: delta_fulfillment_pdt {
    description: "Computes the difference between fulfillment time minutes and delivery pdt minutes "
    type: number
    sql: round(${fulfillment_time_minutes} - ${delivery_pdt_minutes}, 0);;
    value_format: "0"
  }

  dimension: has_reordered_within_7_days {
    group_label: "* User Dimensions *"
    description: "Boolean dimension. Takes the value yes if the user has reordered within 7 days after their first order."
    type: yesno
    sql: case when date_diff(next_order_date, first_order_date, day) <= 7 then True else False end;;
  }


  dimension: cnt_7_day_retention {
    type: number
    sql: case when ${has_reordered_within_7_days} then 1 else 0 end;;
  }
  ################## Measures ####################



  measure: sum_7_day_retention {
    label: "Sum Return Customers"
    hidden:  no
    type: sum
    sql: ${cnt_7_day_retention};;
    value_format: "0"
  }

  measure: cnt_number_of_customers {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    type: count
    drill_fields: [customer_email]
  }

  measure: retention_rate {
    label: "Retention Rate"
    hidden:  no
    type: number
    sql: ${sum_7_day_retention}/nullif(${cnt_number_of_customers},0);;
    value_format: "0.0%"
  }




  set: detail {
    fields: [
      customer_email,
      country_iso,
      first_order_date,
      next_order_date,
      delivery_pdt_minutes,
      fulfillment_time_minutes,
      delta_fulfillment_pdt,
      has_reordered_within_7_days,
      cnt_7_day_retention
      ]
  }

}
