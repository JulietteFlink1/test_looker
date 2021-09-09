view: item_quantity_per_order {
  derived_table: {
    sql: SELECT
      c.order_month,
      c.country as country_iso,
      c.category,
      c.subcategory,
      --  case when sum_quantity>20 then ">20" else cast(sum_quantity as string) end as x,
      case when sum_quantity >20 then "more20"
      when      sum_quantity >15 then "betw16-20"
      when      sum_quantity >10 then "betw11-15"
      when      sum_quantity =10 then "a10"  else cast(sum_quantity as string)  end as quantity,
      sum(sum_item_value) as sum_item_value,
      count (c.order_uuid) as orders

      FROM
      (
      SELECT
      concat(extract(year from cast(a.order_timestamp as date)),"-",extract(month from cast(a.order_timestamp as date))) as order_month,
      a.country_iso,
      hub.country,
      a.order_uuid,
      b.category,
      b.subcategory,
      sum (a.amt_total_price_gross) as sum_item_value,
      sum (a.quantity) as sum_quantity
      FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.products` b
             on a.sku = b.product_sku
        left join `flink-data-prod.curated.hubs` hub
             on a.hub_code = hub.hub_code
      WHERE DATE(a.partition_timestamp) >= "2021-02-01"



      group by 1,2,3,4,5,6

      )
      as c


      group by 1,2,3,4,5
      order by 1,2,3,4,5
      ;;
}


  measure: sum_item_value {
    type: sum
    sql: ${TABLE}.sum_item_value ;;
  }

  measure: orders {
    type: sum
    sql: ${TABLE}.orders ;;
  }


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

  dimension: quantity {
    type: string
    sql: ${TABLE}.quantity ;;
  }

#  dimension: hub_name {
#    type: string
#    sql: ${TABLE}.hub_name ;;
#  }


  set: detail {
    fields: [order_month, country_iso, category, sum_item_value, quantity]
  }

}
