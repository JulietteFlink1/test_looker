view: aov_per_subcategory_month{
  derived_table: {
    sql: SELECT
      c.order_month,
      c.country as country_iso,
      c.category,
      c.subcategory,
      c.sum_item_value,
      c.sum_quantity,
      c.orders_subcategory,
      count (d.order_uuid) as orders

      FROM
      (
      SELECT
      concat(extract(year from cast(a.order_timestamp as date)),"-",extract(month from cast(a.order_timestamp as date))) as order_month,
      a.country_iso,
      hub.country,
      b.category,
      b.subcategory,
      sum (a.amt_total_price_gross) as sum_item_value,
      sum (a.quantity) as sum_quantity,
      count (distinct a.order_uuid) as orders_subcategory
      FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.products` b
             on a.sku = b.product_sku
        left join `flink-data-prod.curated.hubs` hub
             on a.hub_code = hub.hub_code
      WHERE DATE(a.partition_timestamp) >= "2021-02-01"


      group by 1,2,3,4,5
      )
      as c

      left join
      `flink-data-prod.curated.orders` d
      on c.order_month = d.order_month
      and c.country_iso = d.country_iso
      --and c.hub_name = d.hub_name
      WHERE DATE(d.partition_timestamp) >= "2021-02-01"
      and d.is_successful_order = true
      group by 1,2,3,4,5,6,7
      order by 1,2 desc
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: avg_number_orders {
    type: average
    drill_fields: [detail*]
  }

  measure: sum_orders {
    type: sum
    sql: ${TABLE}.orders ;;

  }

  measure: avg_orders {
    type: average
    sql: ${TABLE}.orders ;;

  }

  measure: sum_item_value {
    type: sum
    sql: ${TABLE}.sum_item_value ;;
  }

  measure: sum_quantity {
    type: sum
    sql: ${TABLE}.sum_quantity ;;
  }

  measure: sum_orders_subcategory {
    type: sum
    sql: ${TABLE}.orders_subcategory ;;
  }

  measure: item_value_per_order {
    type: number
    description: "Item Value per category divided by total number of orders"
    value_format_name: decimal_2
    sql: ${sum_item_value}/nullif(${avg_orders},0) ;;

  }

 measure: items_per_basket {
    type: number
    description: "Items per category in the orders they are present"
    value_format_name: decimal_2
    sql: ${sum_quantity}/ nullif(${sum_orders_subcategory},0) ;;

  }

#  measure: presence_in_basket {
#    type: number
#    #value_format: "0%"
#    description: "Percentage of baskets that have an item of the category"
#    value_format_name: percent_0
#    sql: ${sum_orders_category}/nullif(${avg_orders},0) ;;

#  }

  dimension: order_month {
    type: string
    sql: ${TABLE}.order_month ;;
  }

  dimension: country_iso {
    label: "country"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: subcategory {
    type: string
    sql: ${TABLE}.subcategory ;;
  }

  dimension: orders {
    type: number
    sql: ${TABLE}.orders ;;
  }

#  dimension: hub_name {
#    type: string
#    sql: ${TABLE}.hub_name ;;
#  }


  set: detail {
    fields: [order_month, country_iso, category, sum_item_value, orders]
  }
}
