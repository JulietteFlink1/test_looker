include: "/**/*.view"
# created : December 2021
view: recurring_sku_purchases {
  derived_table: {
    sql: -- ----------------------------------------------------------------------------
      -- ------  https://goflink.atlassian.net/browse/DATA-1252    ------------------
      -- ----------------------------------------------------------------------------
      with
      orders as (
          -- data is unique per orders
          select distinct

                orders.order_uuid
              , orders.customer_email
              , orders.order_timestamp
              , orders.amt_gmv_gross

          from       `flink-data-prod`.curated.orders
          inner join `flink-data-prod`.curated.order_lineitems on orders.order_uuid = order_lineitems.order_uuid

          where 1=1
              -- and date(orders.order_timestamp)          >= '2021-11-15'
              -- and date(order_lineitems.order_timestamp) >= '2021-11-15'
              and {% condition filter_order_date %} date(orders.order_timestamp) {% endcondition %}
              and {% condition filter_order_date %} date(order_lineitems.order_timestamp) {% endcondition %}
              and {% condition select_skus_for_recurring_sku_tracking %} order_lineitems.sku {% endcondition %}

      ),

      final_table as (

              select

                    *

                  , ROW_NUMBER() over win_user as order_sequence_with_defined_skus

                   -- get time in days since last order
                  , if(lag(order_timestamp) over win_user is null
                      , 0
                      , TIMESTAMP_DIFF(order_timestamp, lag(order_timestamp) over win_user, day)
                      ) as days_since_last_order_with_skus

              from orders

              window
              win_user as (partition by customer_email
                               order by order_timestamp
                          )
      )

      select * from final_table
       ;;
  }

  filter: filter_order_date {
    type: date
    datatype: date
    default_value: "last 4 weeks"
  }

  filter: select_skus_for_recurring_sku_tracking {
    type: string
    default_value: "11014089"
  }

  dimension: order_uuid {
    type: string
    sql: ${TABLE}.order_uuid ;;
    primary_key: yes
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension_group: order_timestamp {
    type: time
    sql: ${TABLE}.order_timestamp ;;
  }

  dimension: amt_gmv_gross {
    type: number
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: order_sequence_with_defined_skus {
    type: number
    sql: ${TABLE}.order_sequence_with_defined_skus ;;
  }

  dimension: days_since_last_order_with_skus {
    type: number
    sql: ${TABLE}.days_since_last_order_with_skus ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: cnt_orders {
    type: count_distinct
    sql: ${order_uuid} ;;
  }

  measure: avg_days_since_last_order_with_skus {
    label: "AVG days since last order"
    type: average
    sql: ${days_since_last_order_with_skus} ;;
    value_format_name: decimal_0

  }

  set: detail {
    fields: [
      order_uuid,
      customer_email,
      order_timestamp_time,
      amt_gmv_gross,
      order_sequence_with_defined_skus,
      days_since_last_order_with_skus
    ]
  }
}
