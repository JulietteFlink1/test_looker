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
          select

                orders.order_uuid
              , orders.customer_email
              , orders.order_timestamp
              , orders.amt_gmv_gross
              , string_agg(distinct order_lineitems.sku, ' , ' order by order_lineitems.sku) as filtered_skus_in_order
              , string_agg(distinct order_lineitems.product_name, ' , ' order by order_lineitems.product_name) as filtered_product_name_in_order


          from       `flink-data-prod`.curated.orders
          inner join `flink-data-prod`.curated.order_lineitems on orders.order_uuid = order_lineitems.order_uuid

          where 1=1
              -- and date(orders.order_timestamp)          >= '2021-11-15'
              -- and date(order_lineitems.order_timestamp) >= '2021-11-15'
              and {% condition filter_order_date %} date(orders.order_timestamp) {% endcondition %}
              and {% condition filter_order_date %} date(order_lineitems.order_timestamp) {% endcondition %}
              and {% condition select_skus_for_recurring_sku_tracking %} order_lineitems.sku {% endcondition %}

          group by
              1,2,3,4

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

                  , lag(filtered_skus_in_order) over win_user as prev_filtered_skus_in_order

                  , lag(filtered_product_name_in_order) over win_user as prev_filtered_product_name_in_order


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
    label: "Filter: Order Date"
    type: date
    datatype: date
    default_value: "last 4 weeks"
  }

  filter: select_skus_for_recurring_sku_tracking {
    label: "Filter: SKUs in Order"
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
    hidden: yes
  }

  dimension_group: order_timestamp {
    label: "Order"
    type: time
    sql: ${TABLE}.order_timestamp ;;
  }

  dimension: amt_gmv_gross {
    label: "GMV (gross)"
    type: number
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  measure: sum_amt_gmv_gross {
    label: "Sum GMV (gross)"
    type: sum
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: order_sequence_with_defined_skus {
    label: "Order Sequence"
    description: "Defines, if the filtered SKUs have been bought in the first or following orders"
    type: number
    sql: ${TABLE}.order_sequence_with_defined_skus ;;
  }

  dimension: days_since_last_order_with_skus {
    label: "Days since last Order"
    type: number
    sql: ${TABLE}.days_since_last_order_with_skus ;;
  }

  dimension: filtered_skus_in_order {
    label: "Filtered SKUs"
    type: string
    sql: ${TABLE}.filtered_skus_in_order ;;
  }

  dimension: prev_filtered_skus_in_order {
    label: "Filtered SKUs from prev. order"
    type: string
    sql: ${TABLE}.prev_filtered_skus_in_order ;;
  }

  dimension: filtered_product_name_in_order {
    label: "Product Name of filtered SKUs"
    type: string
    sql: ${TABLE}.filtered_product_name_in_order ;;
  }

  dimension: prev_filtered_product_name_in_order {
    label: "Product Name of filtered SKUs from prev. order"
    type: string
    sql: ${TABLE}.prev_filtered_product_name_in_order ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    hidden: yes
  }

  measure: cnt_orders {
    label: "# Orders"
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
