view: cart_mismatch_temp {
  derived_table: {
    sql: with base as (
      select count(distinct order_uuid) as total_orders
      , o.order_date
      from `flink-data-prod.curated.orders` o
      where date(o.order_timestamp) >= '2022-01-01'
      GROUP BY 2 )

      , cart_mismatch as (
      select
      count(distinct o.order_uuid) as total_orders_mismatch
      , o.order_date
      from `flink-data-prod.curated.orders` o
      left join `flink-data-prod.curated.psp_transactions` psp on psp.order_uuid=o.order_uuid and psp.record_type='Authorised'
      where date(o.order_timestamp) >= '2022-01-01'
      and round((o.amt_gmv_gross-o.amt_discount_gross),2) <> psp.main_amount
      GROUP BY 2)


      , final as (
      SELECT c.total_orders_mismatch
      , b.total_orders
      , b.order_date
      , (c.total_orders_mismatch / b.total_orders) as mismatch_rate
      FROM base b
      LEFT JOIN cart_mismatch c on b.order_date = c.order_date
      )


      SELECT * FROM final
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_orders_mismatch {
    type: sum
    sql: ${TABLE}.total_orders_mismatch ;;
  }

  measure: total_orders {
    type: sum
    sql: ${TABLE}.total_orders ;;
  }

  dimension: order_date {
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  measure: mismatch_rate {
    type: sum
    sql: ${TABLE}.mismatch_rate ;;
    value_format_name: percent_2

  }

  set: detail {
    fields: [total_orders_mismatch, total_orders, order_date, mismatch_rate]
  }
}
