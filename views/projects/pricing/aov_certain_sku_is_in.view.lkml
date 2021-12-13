view: aov_certain_sku_is_in{
  derived_table: {
    sql:
with aux_sku_categ as
(
    SELECT
    a.country_iso,
    a.random_ct_category
    from `flink-data-prod.curated.products` a
    group by 1,2
),


or_sku as
(

SELECT
a.country_iso,
cast(a.order_timestamp as date) as order_date,
c.hub_name,
c.hub_code,
a.order_uuid,
--b.random_ct_category,
coalesce (b.substitute_group, b.product_name) as subs_group_or_sku,
b.product_name,
b.product_sku

FROM `flink-data-prod.curated.order_lineitems` a
left join `flink-data-prod.curated.products` b
on a.sku = b.product_sku
left join `flink-data-prod.curated.orders` c
on a.order_uuid = c.order_uuid

WHERE DATE(a.order_timestamp) >= date_sub(current_date(), interval 60 day)
and DATE(c.order_timestamp) >= date_sub(current_date(), interval 60 day)
--WHERE DATE(a.order_timestamp) = "2021-11-25"
--and DATE(c.order_timestamp) = "2021-11-25"
and c.is_successful_order is true
--and c.country_iso = "NL"

--and a.order_uuid in ("DE_4147bf58-1b4c-4356-b24c-ffd712c3ca8a", "DE_6ed6f58a-9135-4be1-9670-d8f4db5c447b")
group by 1,2,3,4,5,6,7,8
--cast(a.order_timestamp as date)= "2021-11-26"
--and sku= "11014044"

),

aux_sku_categ_2 as
(
    SELECT
    a.*,
    b.random_ct_category
    from or_sku a
    left join aux_sku_categ b
    on a.country_iso = b.country_iso
    --group by 1,2
),

--select * from aux_sku_categ_2

numb_or as
(
select
country_iso,
order_date,
hub_name,
hub_code,
subs_group_or_sku,
product_name,
product_sku,
count(distinct order_uuid) as orders_sku_date,
from or_sku
group by 1,2,3,4,5,6,7
),

numb_or_categ as
(
select
country_iso,
order_date,
hub_name,
hub_code,
random_ct_category,
count(distinct order_uuid) as orders_categ_date,
from aux_sku_categ_2
group by 1,2,3,4,5
),

--select * from numb_or
--where subs_group_or_sku  = "Smirnoff Ice Vodka Mixed Drink 70 cl"
or_categ as
(

SELECT
a.country_iso,
cast(a.order_timestamp as date) as order_date,
a.order_uuid,
c.hub_name,
c.hub_code,
b.random_ct_category,
a.quantity,
a.amt_total_price_gross

FROM `flink-data-prod.curated.order_lineitems` a
left join `flink-data-prod.curated.products` b
on a.sku = b.product_sku
left join `flink-data-prod.curated.orders` c
on a.order_uuid = c.order_uuid


WHERE DATE(a.order_timestamp) >= date_sub(current_date(), interval 60 day)
and DATE(c.order_timestamp) >= date_sub(current_date(), interval 60 day)
--WHERE DATE(a.order_timestamp) >= "2021-11-25"
--and DATE(c.order_timestamp) >= "2021-11-25"
and c.is_successful_order is true
--and a.order_uuid in ("DE_4147bf58-1b4c-4356-b24c-ffd712c3ca8a", "DE_6ed6f58a-9135-4be1-9670-d8f4db5c447b")
),

or_sku_categ as
(

SELECT
a.country_iso,
a.order_date,
--a.order_uuid,
a.hub_name,
a.hub_code,
a.subs_group_or_sku,
a.product_name,
a.product_sku,
--a.product_name,
a.random_ct_category,
sum(b.quantity) as quantity,
sum(b.amt_total_price_gross) as amt_total_price_gross

from aux_sku_categ_2 a
left join or_categ b
on a.order_uuid = b.order_uuid
and a.random_ct_category = b.random_ct_category

--where subs_group_or_sku  = "Smirnoff Ice Vodka Mixed Drink 70 cl"
--and a.hub_code = "nl_gro_cent"
group by 1,2,3,4,5,6,7,8

)

--select * from or_sku_categ
--* from aux_sku_categ_2
--where subs_group_or_sku  = "Smirnoff Ice Vodka Mixed Drink 70 cl"

select
a.country_iso,
a.order_date,
a.hub_name,
a.hub_code,
 DATE_TRUNC( cast(a.order_date as date), week) as week,
 DATE_TRUNC( cast(a.order_date as date), month) as month,
a.subs_group_or_sku,
a.product_name,
a.product_sku,
--a.product_name,
a.random_ct_category as category,
b.orders_sku_date as sum_orders,
c.orders_categ_date as sum_orders_category,
sum(quantity) as sum_quantity,
sum(amt_total_price_gross) as sum_item_value,

from or_sku_categ a
left join numb_or b
on  a.order_date = b.order_date
and a.product_sku = b.product_sku
and a.country_iso = b.country_iso
and a.hub_code = b.hub_code
and a.hub_name = b.hub_name
left join numb_or_categ c
on  a.order_date = c.order_date
and a.random_ct_category = c.random_ct_category
and a.country_iso = c.country_iso
and a.hub_code = c.hub_code
and a.hub_name = c.hub_name
group by 1,2,3,4,5,6,7,8,9,10,11,12
order by 3


 ;;
  }



measure: sum_orders {
  type: sum
  sql: ${TABLE}.sum_orders ;;

}

measure: sum_item_value {
  type: sum
  sql: ${TABLE}.sum_item_value ;;
}

measure: sum_quantity {
  type: sum
  sql: ${TABLE}.sum_quantity ;;
}

measure: sum_orders_category {
  type: sum
  sql: ${TABLE}.sum_orders_category ;;
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
  sql: ${sum_quantity}/ nullif(${sum_orders},0) ;;

}

measure: presence_in_basket {
  type: number
  #value_format: "0%"
  description: "Percentage of baskets that have an item of the category"
  value_format_name: percent_0
  sql: ${sum_orders}/nullif(${sum_orders_category},0) ;;

}

#dimension: order_date {
#  type: date
#  datatype: date
#  sql: ${TABLE}.order_date ;;
#}



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


dimension: category {
  type: string
  sql: ${TABLE}.category ;;
}


  dimension: substitute_group_filled{
    type: string
    sql: ${TABLE}.subs_group_or_sku ;;
  }

  dimension: product_name{
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_sku{
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }


  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
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
    category,
    substitute_group_filled,
    product_name,
    product_sku,
    hub_code,
    hub_name,
    sum_item_value,
    orders]
}
}
