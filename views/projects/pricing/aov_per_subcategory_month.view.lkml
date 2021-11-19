view: aov_per_subcategory_month{
  derived_table: {
    sql: with a as
      (

      SELECT
      cast(a.order_timestamp as date) as order_date,
      case when extract (hour from a.order_timestamp)<12 then "Before 12PM"
        when  extract (hour from a.order_timestamp)<17 then "12PM to 17PM"
        else "After 17PM" end as hour,
      DATE_TRUNC( cast(a.order_timestamp as date), week) as week,
      DATE_TRUNC( cast(a.order_timestamp as date), month) as month,
      a.country_iso,
      hub.country,
      hub.hub_name,
      hub.city,
      1 as flag,
     --b.category,
      --sum (a.amt_total_price_gross) as sum_item_value,
      --sum (a.quantity) as sum_quantity,
      --count (distinct a.order_uuid) as orders_category
      FROM `flink-data-prod.curated.order_lineitems` a
        --full outer join `flink-data-prod.curated.products` b
             --on a.sku = b.product_sku
        left join `flink-data-prod.curated.hubs` hub
             on a.hub_code = hub.hub_code
        left join `flink-data-prod.curated.orders` f
             on a.order_uuid = f.order_uuid
      WHERE DATE(a.order_timestamp) >= "2021-02-01"
          and f.is_successful_order = true
            group by 1,2,3,4,5,6,7,8,9

),

b as
    (

    SELECT
    country_iso,
    random_ct_category as category,
    random_ct_subcategory as subcategory,
    from `flink-data-prod.curated.products` prod
    group by 1,2,3
    order by 3
),

c as
    (
   SELECT
      cast(a.order_timestamp as date) as order_date,
      case when extract (hour from a.order_timestamp)<12 then "Before 12PM"
        when  extract (hour from a.order_timestamp)<17 then "12PM to 17PM"
        else "After 17PM" end as hour,
      DATE_TRUNC( cast(a.order_timestamp as date), week) as week,
      DATE_TRUNC( cast(a.order_timestamp as date), month) as month,
      a.country_iso,
      hub.country,
      hub.hub_name,
      hub.city,
      random_ct_category as category,
      b.random_ct_subcategory as subcategory,
      sum (a.amt_total_price_gross) as sum_item_value,
      sum (a.quantity) as sum_quantity,
      count (distinct a.order_uuid) as orders_subcategory
      FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.products` b
             on a.sku = b.product_sku
        left join `flink-data-prod.curated.hubs` hub
             on a.hub_code = hub.hub_code
      left join `flink-data-prod.curated.orders` f
             on a.order_uuid = f.order_uuid
      WHERE DATE(a.order_timestamp) >= "2021-02-01"
          and f.is_successful_order = true
      group by 1,2,3,4,5,6,7,8,9,10
      order by 9
     ),

d as
    (
        select
        order_date,
        case when extract (hour from d.order_timestamp)<12 then "Before 12PM"
        when  extract (hour from d.order_timestamp)<17 then "12PM to 17PM"
        else "After 17PM" end as hour,
        hub_name,
        count (distinct d.order_uuid) as orders

  FROM `flink-data-prod.curated.orders` d
      WHERE DATE(d.order_timestamp) >= "2021-02-01"
      and d.is_successful_order = true

      group by 1,2,3

)


    SELECT

      a.order_date,
      a.week,
      a.month,
      a.hour,
      a.country_iso,
      --a.country,
      a.hub_name,
      a.city,
      b.category,
      b.subcategory,
      cast(c.sum_item_value as int) as sum_item_value,
      c.sum_quantity,
      c.orders_subcategory,
      d.orders


      from a
      left join b
      on a.country_iso = b.country_iso
      left join c
      on a.order_date = c.order_date
      and a.hour = c.hour
      and a.hub_name = c.hub_name
      and b.category = c.category
      and b.subcategory = c.subcategory
      inner join d
      on a.order_date = d.order_date
      and a.hour = d.hour
      and a.hub_name = d.hub_name
      order by 1,2,3,4,5,6,7,8
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
    sql: ${sum_item_value}/nullif(${sum_orders},0) ;;

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

  dimension_group: created {
    group_label: "* Dates and Timestamps *"
    label: "Order"
    description: "Order Placement Date"
    type: time
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      year
    ]
    sql: ${TABLE}.order_date ;;
    datatype: date

  }

  dimension: day {
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: month {
    type: date
    datatype: date
    sql: ${TABLE}.month ;;
  }


  dimension: week {
    type: date
    datatype: date
    sql: ${TABLE}.week ;;
  }

  dimension: Hour {
    type: string
    sql: ${TABLE}.hour ;;
  }

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  dimension: order_date {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
      {% if date_granularity._parameter_value == 'Day' %}
      ${day}
      {% elsif date_granularity._parameter_value == 'Week' %}
      ${week}
      {% elsif date_granularity._parameter_value == 'Month' %}
      ${month}
      {% endif %};;
  }

  dimension: country_iso {
    label: "Country Iso"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_name {
    label: "hub_name"
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: city {
    label: "city"
    type: string
    sql: ${TABLE}.city ;;
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
    fields: [day,
      week,
      month,
      country_iso,
      city,
      hub_name,
      category,
      subcategory,
      sum_item_value,
      orders]
  }
}
