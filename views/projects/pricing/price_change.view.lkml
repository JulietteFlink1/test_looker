view: price_change {
  derived_table: {
    sql:
with a as
(
SELECT

      --extract(week from a.order_timestamp) as week,
      cast(a.order_timestamp as date) as order_date,
      "Chosen Time Frame" as period,
      prod.category,
      prod.subcategory,
      --prod.product_name,
      --prod.product_sku,
      COALESCE(prod.substitute_group, prod.product_name) as substitute_group,
      a.country_iso,
      hub.country,
      hub.hub_name,
      hub.city,
      avg(a.amt_unit_price_gross) as avg_unit_price_gross,
      cast(sum(a.amt_total_price_gross) as decimal) as sum_item_value,
      sum (a.quantity) as sum_quantity,
      count (distinct a.order_uuid) as orders
      FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.products` prod
             on a.sku = prod.product_sku
        left join `flink-data-prod.curated.hubs` hub
             on a.hub_code = hub.hub_code
        left join `flink-data-prod.curated.orders` ord
             on a.order_uuid = ord.order_uuid
      WHERE DATE(a.order_timestamp) >= "2021-08-01"
      and ord.is_successful_order = true
      --and DATE(a.order_timestamp) < current_date()
      group by 1,2,3,4,5,6,7,8,9--,10,11
      order by 1
),

b as
(

     SELECT
      cast(date_add(a.order_timestamp,interval +7 day) as date) as order_date,
      "W -1" as period,
      prod.category,
      prod.subcategory,
      --prod.product_name,
      --prod.product_sku,
      COALESCE(prod.substitute_group, prod.product_name) as substitute_group,
      a.country_iso,
      hub.country,
      hub.hub_name,
      hub.city,
      avg(a.amt_unit_price_gross) as avg_unit_price_gross,
      cast(sum(a.amt_total_price_gross) as decimal) as sum_item_value,
      sum (a.quantity) as sum_quantity,
      count (distinct a.order_uuid) as orders
      FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.products` prod
             on a.sku = prod.product_sku
        left join `flink-data-prod.curated.hubs` hub
             on a.hub_code = hub.hub_code
        left join `flink-data-prod.curated.orders` ord
             on a.order_uuid = ord.order_uuid
      WHERE DATE(a.order_timestamp) >= "2021-08-01"
      and ord.is_successful_order = true
      --and DATE(a.order_timestamp) < current_date()
      group by 1,2,3,4,5,6,7,8,9--,10,11
      order by 1

),

c as
(
     SELECT
      cast(date_add(a.order_timestamp,interval +14 day) as date) as order_date,
      "W -2" as period,
      prod.category,
      prod.subcategory,
      --prod.product_name,
      --prod.product_sku,
      COALESCE(prod.substitute_group, prod.product_name) as substitute_group,
      a.country_iso,
      hub.country,
      hub.hub_name,
      hub.city,
      avg(a.amt_unit_price_gross) as avg_unit_price_gross,
      cast(sum(a.amt_total_price_gross) as decimal) as sum_item_value,
      sum (a.quantity) as sum_quantity,
      count (distinct a.order_uuid) as orders
      FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.products` prod
             on a.sku = prod.product_sku
        left join `flink-data-prod.curated.hubs` hub
             on a.hub_code = hub.hub_code
        left join `flink-data-prod.curated.orders` ord
             on a.order_uuid = ord.order_uuid
      WHERE DATE(a.order_timestamp) >= "2021-08-01"
      and ord.is_successful_order = true
      --and DATE(a.order_timestamp) < current_date()
      group by 1,2,3,4,5,6,7,8,9--,10,11
      order by 1

),

d as
(
     SELECT
      cast(date_add(a.order_timestamp,interval +21 day) as date) as order_date,
      "W -3" as period,
      prod.category,
      prod.subcategory,
      --prod.product_name,
      --prod.product_sku,
      COALESCE(prod.substitute_group, prod.product_name) as substitute_group,
      a.country_iso,
      hub.country,
      hub.hub_name,
      hub.city,
      avg(a.amt_unit_price_gross) as avg_unit_price_gross,
      cast(sum(a.amt_total_price_gross) as decimal) as sum_item_value,
      sum (a.quantity) as sum_quantity,
      count (distinct a.order_uuid) as orders
      FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.products` prod
             on a.sku = prod.product_sku
        left join `flink-data-prod.curated.hubs` hub
             on a.hub_code = hub.hub_code
        left join `flink-data-prod.curated.orders` ord
             on a.order_uuid = ord.order_uuid
      WHERE DATE(a.order_timestamp) >= "2021-08-01"
      and ord.is_successful_order = true
      --and DATE(a.order_timestamp) < current_date()
      group by 1,2,3,4,5,6,7,8,9--,10,11
      order by 1

),

e as
(
     SELECT
      cast(date_add(a.order_timestamp,interval +28 day) as date) as order_date,
      "W -4" as period,
      prod.category,
      prod.subcategory,
      --prod.product_name,
      --prod.product_sku,
      COALESCE(prod.substitute_group, prod.product_name) as substitute_group,
      a.country_iso,
      hub.country,
      hub.hub_name,
      hub.city,
      avg(a.amt_unit_price_gross) as avg_unit_price_gross,
      cast(sum(a.amt_total_price_gross) as decimal) as sum_item_value,
      sum (a.quantity) as sum_quantity,
      count (distinct a.order_uuid) as orders
      FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.products` prod
             on a.sku = prod.product_sku
        left join `flink-data-prod.curated.hubs` hub
             on a.hub_code = hub.hub_code
        left join `flink-data-prod.curated.orders` ord
             on a.order_uuid = ord.order_uuid
      WHERE DATE(a.order_timestamp) >= "2021-08-01"
      and ord.is_successful_order = true
      --and DATE(a.order_timestamp) < current_date()
      group by 1,2,3,4,5,6,7,8,9--,10,11
      order by 1

)



select
a.*
from a

--where product_sku = "11011445"
--and hub_name ="DE - Berlin - Mitte 2"

UNION ALL

select
b.*
from b

--where product_sku = "11011445"
--and hub_name ="DE - Berlin - Mitte 2"

UNION ALL

select
c.*
from c

--where product_sku = "11011445"
--and hub_name ="DE - Berlin - Mitte 2"

UNION ALL

select
d.*
from d

--where product_sku = "11011445"
--and hub_name ="DE - Berlin - Mitte 2"

UNION ALL

select
e.*
from e

--where product_sku = "11011445"
--and hub_name ="DE - Berlin - Mitte 2"

      ;;
}

  measure: sum_item_value {
    label: "Item Value"
    type: sum
    value_format_name: euro_accounting_1_precision
    sql: ${TABLE}.sum_item_value ;;
  }

  measure: sum_quantity {
    label: "Quantity Sold"
    type: sum
    sql: ${TABLE}.sum_quantity ;;
  }

  measure: orders {
    label: "Orders"
    type: sum
    sql: ${TABLE}.orders ;;
  }

  measure: avg_price {
    label: "Unit Price Gross"
    type: average
    value_format_name: euro_accounting_2_precision
    sql: ${TABLE}.avg_unit_price_gross ;;
  }

#    measure: sum_item_value_1W_back {
#    type: sum
#    sql: ${TABLE}.sum_item_value_1W_back ;;
#  }

#  measure: sum_item_value_2W_back {
#    type: sum
#    sql: ${TABLE}.sum_item_value_2W_back ;;
#  }

#  measure: sum_item_value_3W_back {
#    type: sum
#    sql: ${TABLE}.sum_item_value_3W_back ;;
 # }

 # measure: sum_item_value_4W_back {
#    type: sum
 #   sql: ${TABLE}.sum_item_value_4W_back ;;
 # }


  dimension_group: created {
    group_label: "* Dates and Timestamps *"
    label: "Order"
    description: "Order Placement Date"
    type: time
    timeframes: [
      date,
      day_of_week,
      week
    ]
    sql: ${TABLE}.order_date ;;
    datatype: date
  }

  dimension: day {
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

#  dimension: day_of_week {
#    type: string
#    sql: ${TABLE}.day_of_week ;;
#  }

  dimension: week {
    type: string
    sql: ${TABLE}.week ;;
  }

  dimension: period {
    type: string
    sql: ${TABLE}.period ;;
  }

   dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: subcategory {
    type: string
    sql: ${TABLE}.subcategory ;;
  }

  dimension: substitute_group {
    type: string
    sql: ${TABLE}.substitute_group ;;
  }

  dimension: product_name {
    label: "Product Name"
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_sku {
    label: "SKU"
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: country_iso {
    label: "Country Iso"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: country {
    label: "Country"
    type: string
    sql: ${TABLE}.country ;;
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



  set: detail {
    fields: [week,
      day,
  #    day_of_week,
      period,
      category,
      subcategory,
      product_name,
      product_sku,
      country_iso,
      country,
      city,
      hub_name
      ]
  }

    }
