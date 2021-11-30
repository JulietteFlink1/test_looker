view: pdt_customer_retention {
  derived_table: {
    sql: with pdt_order as (
    select customer_email
        , country_iso
        , date(order_timestamp) as  order_date
        , LEAD(date(order_timestamp),1) OVER (partition by customer_email order by order_timestamp) as next_order_date
        , delivery_pdt_minutes
    from `flink-data-prod.curated.orders`
    where delivery_pdt_minutes is not null
)
     select p.customer_email
        , p.country_iso
        , date(first_order_timestamp) as first_order_date
        , p.order_date
        , p.next_order_date
        , p.delivery_pdt_minutes
     from `flink-data-prod.curated.customers_metrics` c
     left join pdt_order p on c.customer_email = p.customer_email and c.country_iso = p.country_iso
     where date(c.first_order_timestamp) = p.order_date
     group by 1, 2, 3, 4, 5, 6
    ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
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

  dimension: has_reordered_within_7_days {
    group_label: "* User Dimensions *"
    description: "Boolean dimension. Takes the value yes if the user has reordered within 7 days after their first order."
    type: yesno
    sql: case when date_diff(next_order_date, first_order_date, day) <= 7 then True else False end;;
  }



  ################## Measures ####################

  measure: cnt_7_day_retention {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    type: count
    filters: [has_reordered_within_7_days: "yes"]
  }

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
    sql: ${cnt_7_day_retention}/${cnt_number_of_customers};;
    value_format: "0.0%"
  }




  set: detail {
    fields: [
      customer_email,
      country_iso,
      first_order_date,
      next_order_date,
      delivery_pdt_minutes,
      has_reordered_within_7_days
      ]
  }

}
