view: price_change {
  derived_table: {
    sql:
    with a as
(
SELECT

      --extract(week from a.order_timestamp) as week,
      cast(a.order_timestamp as date) as order_date,
      "Chosen Time Frame" as period,
      prod.random_ct_category as category,
      prod.random_ct_subcategory as subcategory,
      prod.product_name,
      prod.product_sku,
      COALESCE(prod.substitute_group, prod.product_name) as substitute_group,
      a.country_iso,
      hub.country,
      --ub.hub_name,
      --hub.city,
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
      "Week -1" as period,
      prod.random_ct_category as category,
      prod.random_ct_subcategory as subcategory,
      prod.product_name,
      prod.product_sku,
      COALESCE(prod.substitute_group, prod.product_name) as substitute_group,
      a.country_iso,
      hub.country,
      --hub.hub_name,
      --hub.city,
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
      "Week -2" as period,
      prod.random_ct_category as category,
      prod.random_ct_subcategory as subcategory,
      prod.product_name,
      prod.product_sku,
      COALESCE(prod.substitute_group, prod.product_name) as substitute_group,
      a.country_iso,
      hub.country,
      --hub.hub_name,
      --hub.city,
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
      "Week -3" as period,
      prod.random_ct_category as category,
      prod.random_ct_subcategory as subcategory,
      prod.product_name,
      prod.product_sku,
      COALESCE(prod.substitute_group, prod.product_name) as substitute_group,
      a.country_iso,
      hub.country,
      --hub.hub_name,
      --hub.city,
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
      "Week -4" as period,
      prod.random_ct_category as category,
      prod.random_ct_subcategory as subcategory,
      prod.product_name,
      prod.product_sku,
      COALESCE(prod.substitute_group, prod.product_name) as substitute_group,
      a.country_iso,
      hub.country,
      --hub.hub_name,
      --hub.city,
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






f as
(
select
      period,
      order_date,
      category,
      subcategory,
      country_iso,
      --hub_name,
      avg(avg_unit_price_gross) as avg_unit_price_gross,
      sum(sum_item_value) as sum_item_value,
      sum(sum_quantity) as sum_quantity
from a

group by 1,2,3,4,5

UNION ALL

select
      period,
      order_date,
      category,
      subcategory,
      country_iso,
      --hub_name,
      avg(avg_unit_price_gross) as avg_unit_price_gross,
      sum(sum_item_value) as sum_item_value,
      sum(sum_quantity) as sum_quantity
from b

group by 1,2,3,4,5

UNION ALL

select
      period,
      order_date,
      category,
      subcategory,
      country_iso,
      --hub_name,
      avg(avg_unit_price_gross) as avg_unit_price_gross,
      sum(sum_item_value) as sum_item_value,
      sum(sum_quantity) as sum_quantity
from c

group by 1,2,3,4,5
UNION ALL

select
      period,
      order_date,
      category,
      subcategory,
      country_iso,
      --hub_name,
      avg(avg_unit_price_gross) as avg_unit_price_gross,
      sum(sum_item_value) as sum_item_value,
      sum(sum_quantity) as sum_quantity
from d

group by 1,2,3,4,5

UNION ALL

select
      period,
      order_date,
      category,
      subcategory,
      country_iso,
      --hub_name,
      avg(avg_unit_price_gross) as avg_unit_price_gross,
      sum(sum_item_value) as sum_item_value,
      sum(sum_quantity) as sum_quantity
from e

group by 1,2,3,4,5
),






j as
(
select
      period,
      order_date,
            country_iso,
      avg(avg_unit_price_gross) as avg_unit_price_gross,
      sum(sum_item_value) as sum_item_value,
      sum(sum_quantity) as sum_quantity
from a

group by 1,2,3

UNION ALL

select
      period,
      order_date,
            country_iso,
      avg(avg_unit_price_gross) as avg_unit_price_gross,
      sum(sum_item_value) as sum_item_value,
      sum(sum_quantity) as sum_quantity
from b

group by 1,2,3

UNION ALL

select
      period,
      order_date,
            country_iso,
      avg(avg_unit_price_gross) as avg_unit_price_gross,
      sum(sum_item_value) as sum_item_value,
      sum(sum_quantity) as sum_quantity
from c

group by 1,2,3
UNION ALL

select
      period,
      order_date,
            country_iso,
      avg(avg_unit_price_gross) as avg_unit_price_gross,
      sum(sum_item_value) as sum_item_value,
      sum(sum_quantity) as sum_quantity
from d

group by 1,2,3

UNION ALL

select
      period,
      order_date,
            country_iso,
      avg(avg_unit_price_gross) as avg_unit_price_gross,
      sum(sum_item_value) as sum_item_value,
      sum(sum_quantity) as sum_quantity
from e

group by 1,2,3
),













g as
(
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
),



/*
h as
(
select
g.*,
--f.avg_unit_price_gross as avg_unit_price_gross_subcateg,
f.sum_item_value as sum_item_value_subcateg,
f.sum_quantity as sum_quantity_subcateg,
j.sum_item_value as sum_item_value_company,
j.sum_quantity as sum_quantity_company


from g
left join f
on f.period = g.period
and f.order_date = g.order_date
and f.category = g.category
and f.subcategory = g.subcategory
and f.hub_name = g.hub_name

left join j
on j.period = g.period
and j.order_date = g.order_date
),
*/

i as
(
select
inventory_tracking_date,
product_sku,
sum(hours_oos) as hours_oos,
sum(open_hours_total) as open_hours_total
from (
SELECT
a.inventory_tracking_date,
c.hub_name,
COALESCE(b.substitute_group, b.product_name) as substitute_group,
product_sku,
min(hours_oos) as hours_oos,
max(open_hours_total) as open_hours_total
FROM `flink-data-prod.reporting.inventory_stock_count_daily` a
LEFT JOIN `flink-data-prod.curated.products` b
on a.sku = b.product_sku
left join `flink-data-prod.curated.hubs` c
on a.hub_code = c.hub_code
 WHERE inventory_tracking_date >= "2021-09-01"
--and product_sku = "11011445"
 group by 1,2,3,4
)
as a
group by 1,2

),
/*
pre_fn as
(
select
h.*,
i.hours_oos,
i.open_hours_total

from h
left join i
--on h.hub_name = i.hub_name
on h.substitute_group = i.substitute_group
and h.order_date = i.inventory_tracking_date
where order_date>="2021-09-01"
--and product_sku = "11013836"
order by 1
),
*/


aa as
      (

      SELECT
      cast(a.order_timestamp as date) as order_date,
      DATE_TRUNC( cast(a.order_timestamp as date), week) as week,
      DATE_TRUNC( cast(a.order_timestamp as date), month) as month,
      a.country_iso,
      hub.country,
      --hub.hub_name,
      --hub.city,
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
            group by 1,2,3,4,5,6--,7,8

),

bb as
    (

    SELECT
    country_iso,
    prod.random_ct_category,
    prod.random_ct_subcategory,
    prod.product_name,
    prod.product_sku,
    COALESCE(prod.substitute_group, prod.product_name) as substitute_group,
    from `flink-data-prod.curated.products` prod
    group by 1,2,3,4,5,6

),


p1 as
(
 SELECT

    aa.order_date,
    aa.week,
    aa.month,
   "Chosen Time Frame" as period,
    aa.country_iso,
      --a.country,
      --a.hub_name,
      --a.city,
    bb.random_ct_category,
    bb.random_ct_subcategory,
    bb.product_name,
    bb.product_sku,
    bb.substitute_group,
    i.hours_oos,
    i.open_hours_total

      from aa

      left join bb
      on aa.country_iso = bb.country_iso

      left join i
      on aa.order_date = i.inventory_tracking_date
      and bb.product_sku = i.product_sku


union all

 SELECT

    aa.order_date,
    aa.week,
    aa.month,
    "Week -1" as period,
    aa.country_iso,
      --a.country,
      --a.hub_name,
      --a.city,
    bb.random_ct_category,
    bb.random_ct_subcategory,
    bb.product_name,
    bb.product_sku,
    bb.substitute_group,
    i.hours_oos,
    i.open_hours_total

      from aa

      left join bb
      on aa.country_iso = bb.country_iso

    left join i
      on aa.order_date = date_add(i.inventory_tracking_date,interval +7 day)
      and bb.product_sku = i.product_sku

union all

 SELECT

    aa.order_date,
    aa.week,
    aa.month,
   "Week -2" as period,
    aa.country_iso,
      --a.country,
      --a.hub_name,
      --a.city,
    bb.random_ct_category,
    bb.random_ct_subcategory,
    bb.product_name,
    bb.product_sku,
    bb.substitute_group,
    i.hours_oos,
    i.open_hours_total

      from aa

      left join bb
      on aa.country_iso = bb.country_iso

    left join i
      on aa.order_date = date_add(i.inventory_tracking_date,interval +14 day)
      and bb.product_sku = i.product_sku

union all

 SELECT

    aa.order_date,
    aa.week,
    aa.month,
   "Week -3" as period,
    aa.country_iso,
      --a.country,
      --a.hub_name,
      --a.city,
    bb.random_ct_category,
    bb.random_ct_subcategory,
    bb.product_name,
    bb.product_sku,
    bb.substitute_group,
    i.hours_oos,
    i.open_hours_total

      from aa

      left join bb
      on aa.country_iso = bb.country_iso

    left join i
      on aa.order_date = date_add(i.inventory_tracking_date,interval +21 day)
      and bb.product_sku = i.product_sku

union all

 SELECT

    aa.order_date,
    aa.week,
    aa.month,
   "Week -4" as period,
    aa.country_iso,
      --a.country,
      --a.hub_name,
      --a.city,
    bb.random_ct_category,
    bb.random_ct_subcategory,
    bb.product_name,
    bb.product_sku,
    bb.substitute_group,
    i.hours_oos,
    i.open_hours_total

      from aa

      left join bb
      on aa.country_iso = bb.country_iso

          left join i
      on aa.order_date = date_add(i.inventory_tracking_date,interval +28 day)
      and bb.product_sku = i.product_sku

)


--select * from g where product_sku = "11013836"
--and order_date = "2021-10-14"


select
p1.*,
g.avg_unit_price_gross,
g.sum_item_value,
g.sum_quantity,
g.orders,

f.sum_item_value as sum_item_value_subcateg,
f.sum_quantity as sum_quantity_subcateg,
f.avg_unit_price_gross as avg_unit_price_gross_subcateg,

j.sum_item_value as sum_item_value_company,
j.sum_quantity as sum_quantity_company,
j.avg_unit_price_gross as avg_unit_price_gross_company

--i.hours_oos,
--i.open_hours_total

      from p1
      left join g
      on p1.product_sku = g.product_sku
      and p1.country_iso = g.country_iso
      and p1.order_date = g.order_date
      and p1.period = g.period

      left join f
      on p1.period = f.period
      and p1.order_date = f.order_date
      and p1.random_ct_subcategory = f.subcategory
      and p1.country_iso = f.country_iso

      left join j
      on p1.period = j.period
      and p1.order_date = j.order_date
      and p1.country_iso = j.country_iso

   --   left join i
  -- --   on p1.period = j.period
   --   on p1.order_date = i.inventory_tracking_date
   --   and p1.product_sku = i.product_sku
   --   and p1.period ="Chosen Time Frame"


      where p1.order_date>="2021-09-01"

      --where p1.order_date="2021-10-14"
      --and p1.product_sku = "11011445"
      order by 1


      ;;
}

  measure: sum_item_value {
    label: "Item Value"
    type: sum
    value_format_name: euro_accounting_1_precision
    sql: ${TABLE}.sum_item_value ;;
  }

  measure: sum_item_value_subcateg {
    label: "Item Value - Subcategory"
    type: sum
    value_format_name: euro_accounting_1_precision
    sql: ${TABLE}.sum_item_value_subcateg ;;
  }

  measure: sum_item_value_company {
    label: "Item Value - Company"
    type: sum
    value_format_name: euro_accounting_1_precision
    sql: ${TABLE}.sum_item_value_company ;;
  }

  measure: sum_quantity {
    label: "Quantity Sold"
    type: sum
    sql: ${TABLE}.sum_quantity ;;
  }

  measure: sum_quantity_subcateg {
    label: "Quantity Sold - Subcateg"
    type: sum
    sql: ${TABLE}.sum_quantity_subcateg ;;
  }

  measure: sum_quantity_company {
    label: "Quantity Sold - Company"
    type: sum
    sql: ${TABLE}.sum_quantity_company ;;
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

 # measure: avg_price_subcateg {
 #   label: "Unit Price Gross Subcategory"
 #   type: average
 #   value_format_name: euro_accounting_2_precision
 #   sql: ${TABLE}.avg_unit_price_gross_subcategory ;;
#  }

 # measure: avg_price_company {
#    label: "Unit Price Gross Company"
 #   type: average
 #   value_format_name: euro_accounting_2_precision
#    sql: ${TABLE}.avg_unit_price_gross_company ;;
 # }

  measure: hours_oos {
    label: "Hours ooo"
    type: sum
    sql: ${TABLE}.hours_oos ;;
  }

  measure: open_hours_total {
    label: "Open Hours"
    type: sum
    sql: ${TABLE}.open_hours_total ;;
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
