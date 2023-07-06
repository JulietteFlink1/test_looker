view: pdt_customer_retention {
  derived_table: {
    sql: with pdt_order as (
    select customer_email
        , country_iso
        , order_timestamp
        , date(order_timestamp) as  first_order_date
        , LEAD(date(order_timestamp),1) OVER (partition by customer_email, country_iso order by order_timestamp) as next_order_date
        , delivery_pdt_minutes
        , round(fulfillment_time_minutes,0) as fulfillment_time_minutes
        , is_first_order
        , count(order_uuid) over(partition by customer_email, country_iso order by order_timestamp rows between 1 following and unbounded following) * 7/DATE_DIFF(current_date - 6, DATE(order_timestamp),day) as weekly_order_frequency_after
        , count(order_uuid) over(partition by customer_email, country_iso order by order_timestamp rows between 1 following and unbounded following) * 30/DATE_DIFF(current_date - 6, DATE(order_timestamp),day) as monthly_order_frequency_after
        , customer_order_rank
    from `flink-data-prod.curated.orders`
    where delivery_pdt_minutes is not null
    and is_successful_order is true
    and order_date <= current_date - 7
)
     select *
     from  pdt_order
    ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.customer_email, '_', ${TABLE}.country_iso, ${TABLE}.customer_order_rank) ;;
  }

  dimension: customer_email {

    required_access_grants: [can_access_pii_customers]

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
    label: "Order Date"
    sql: ${TABLE}.first_order_date ;;
  }

  dimension: next_order_date {
    type: date
    datatype: date
    label: "Next Order Date"
    sql: ${TABLE}.next_order_date ;;
  }

  dimension: order_rank {
    type: number
    sql: ${TABLE}.customer_order_rank ;;
  }

  dimension: delivery_pdt_minutes {
    type: number
    sql: ${TABLE}.delivery_pdt_minutes ;;
  }

  dimension: weekly_order_frequency_after {
    type: number
    sql: ${TABLE}.weekly_order_frequency_after ;;
  }

  dimension: monthly_order_frequency_after {
    type: number
    sql: ${TABLE}.monthly_order_frequency_after ;;
  }

  dimension: fulfillment_time_minutes {
    type: number
    sql: ${TABLE}.fulfillment_time_minutes ;;
    value_format: "0"
  }

  dimension: delta_fulfillment_pdt {
    description: "Computes the difference between fulfillment time minutes and delivery pdt minutes "
    type: number
    sql: round(${fulfillment_time_minutes} - ${delivery_pdt_minutes}, 0);;
    value_format: "0"
  }

  dimension: has_reordered_within_7_days {
    group_label: "> User Dimensions"
    description: "Boolean dimension. Takes the value yes if the user has reordered within 7 days after their first order."
    type: yesno
    sql: case when date_diff(next_order_date, first_order_date, day) <= 7 then True else False end;;
  }


  dimension: cnt_7_day_retention {
    type: number
    sql: case when ${has_reordered_within_7_days} then 1 else 0 end;;
  }

  dimension: fulfillment_time_minutes_tier {
    type: tier
    style: relational
    tiers: [0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,45,60]
    sql: ${fulfillment_time_minutes} ;;
  }

  dimension: fulfillment_time_minutes_tier_10 {
    type: tier
    style: relational
    tiers: [0,10,20,30,45,60]
    sql: ${fulfillment_time_minutes} ;;
  }

  dimension: delta_fulfillment_pdt_tier {
    type: tier
    style: relational
    tiers: [-100,-50,-45,-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40,45,50,55,60,75,90,100]
    sql: ${delta_fulfillment_pdt} ;;
  }

  dimension: order_rank_tier {
    type: tier
    style: relational
    tiers: [1,2,3,4,5,6,7,8,9,10]
    sql: ${order_rank} ;;
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
    group_label: "> Basic Counts (Orders / Customers etc.)"
    type: count_distinct
    sql: ${primary_key} ;;
  }

  measure: retention_rate {
    label: "Retention Rate"
    hidden:  no
    type: number
    sql: ${sum_7_day_retention}/nullif(${cnt_number_of_customers},0);;
    value_format: "0.0%"
  }

  measure: avg_weekly_order_frequency_after {
    type: average
    value_format: "0.00"
    sql: ${TABLE}.weekly_order_frequency_after ;;
  }

  measure: avg_monthly_order_frequency_after {
    type: average
    value_format: "0.00"
    sql: ${TABLE}.monthly_order_frequency_after ;;
  }




  set: detail {
    fields: [
      customer_email,
      country_iso,
      next_order_date,
      delivery_pdt_minutes,
      fulfillment_time_minutes,
      delta_fulfillment_pdt,
      has_reordered_within_7_days,
      cnt_7_day_retention
      ]
  }

}
