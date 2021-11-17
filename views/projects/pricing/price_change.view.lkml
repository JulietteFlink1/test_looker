view: price_change {
  derived_table: {
    sql:
     with w as
(

SELECT

      cast(a.order_timestamp as date) as order_date,
      "Chosen Time Frame" as period,
      prod.random_ct_category as category,
      prod.random_ct_subcategory as subcategory,
      prod.product_name,
      prod.product_sku,
      COALESCE(prod.substitute_group, prod.product_name) as substitute_group,
      a.country_iso,
      avg(a.amt_unit_price_gross) as avg_unit_price_gross,
      cast(sum(a.amt_total_price_gross) as decimal) as sum_item_value,
      sum (a.quantity) as sum_quantity,
      count (distinct a.order_uuid) as orders
      FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.products` prod
             on a.sku = prod.product_sku
        left join `flink-data-prod.curated.orders` ord
             on a.order_uuid = ord.order_uuid
             and ord.is_successful_order = true
      WHERE DATE(a.order_timestamp) >= date_sub(current_date(), interval 60 day)
      and DATE(ord.order_timestamp) >= date_sub(current_date(), interval 60 day)
      group by 1,2,3,4,5,6,7,8

),

w_minus_1 as
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
      avg(a.amt_unit_price_gross) as avg_unit_price_gross,
      cast(sum(a.amt_total_price_gross) as decimal) as sum_item_value,
      sum (a.quantity) as sum_quantity,
      count (distinct a.order_uuid) as orders
      FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.products` prod
             on a.sku = prod.product_sku
        left join `flink-data-prod.curated.orders` ord
             on a.order_uuid = ord.order_uuid
             and ord.is_successful_order = true
      WHERE DATE(a.order_timestamp) >= date_sub(current_date(), interval 67 day)
      and DATE(ord.order_timestamp) >= date_sub(current_date(), interval 67 day)
      group by 1,2,3,4,5,6,7,8

),

w_minus_2 as
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
      avg(a.amt_unit_price_gross) as avg_unit_price_gross,
      cast(sum(a.amt_total_price_gross) as decimal) as sum_item_value,
      sum (a.quantity) as sum_quantity,
      count (distinct a.order_uuid) as orders
      FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.products` prod
             on a.sku = prod.product_sku
        left join `flink-data-prod.curated.orders` ord
             on a.order_uuid = ord.order_uuid
             and ord.is_successful_order = true
      WHERE DATE(a.order_timestamp) >= date_sub(current_date(), interval 74 day)
      and DATE(ord.order_timestamp) >= date_sub(current_date(), interval 74 day)
      group by 1,2,3,4,5,6,7,8

),

w_minus_3 as
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
      avg(a.amt_unit_price_gross) as avg_unit_price_gross,
      cast(sum(a.amt_total_price_gross) as decimal) as sum_item_value,
      sum (a.quantity) as sum_quantity,
      count (distinct a.order_uuid) as orders
      FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.products` prod
             on a.sku = prod.product_sku
        left join `flink-data-prod.curated.orders` ord
             on a.order_uuid = ord.order_uuid
             and ord.is_successful_order = true
      WHERE DATE(a.order_timestamp) >= date_sub(current_date(), interval 81 day)
      and DATE(ord.order_timestamp) >= date_sub(current_date(), interval 81 day)
      group by 1,2,3,4,5,6,7,8

),

w_minus_4 as
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
      avg(a.amt_unit_price_gross) as avg_unit_price_gross,
      cast(sum(a.amt_total_price_gross) as decimal) as sum_item_value,
      sum (a.quantity) as sum_quantity,
      count (distinct a.order_uuid) as orders
      FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.products` prod
             on a.sku = prod.product_sku
        left join `flink-data-prod.curated.orders` ord
             on a.order_uuid = ord.order_uuid
             and ord.is_successful_order = true
      WHERE DATE(a.order_timestamp) >= date_sub(current_date(), interval 88 day)
      and DATE(ord.order_timestamp) >= date_sub(current_date(), interval 88 day)
      group by 1,2,3,4,5,6,7,8

),

sku_lvl as
(
select
w.*
from w

UNION ALL

select
w_minus_1.*
from w_minus_1

UNION ALL

select
w_minus_2.*
from w_minus_2

UNION ALL

select
w_minus_3.*
from w_minus_3

UNION ALL

select
w_minus_4.*
from w_minus_4
),


subcateg_lvl as
(
select
      period,
      order_date,
      category,
      subcategory,
      country_iso,
      avg(avg_unit_price_gross) as avg_unit_price_gross,
      sum(sum_item_value) as sum_item_value,
      sum(sum_quantity) as sum_quantity
from sku_lvl

group by 1,2,3,4,5
),


flink_lvl as
(
select
      period,
      order_date,
            country_iso,
      avg(avg_unit_price_gross) as avg_unit_price_gross,
      sum(sum_item_value) as sum_item_value,
      sum(sum_quantity) as sum_quantity
from sku_lvl

group by 1,2,3
),



oos as
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
 WHERE inventory_tracking_date >= date_sub(current_date(), interval 88 day)
 group by 1,2,3,4
)
as a
group by 1,2

),


day_country as
      (

      SELECT
      cast(a.order_timestamp as date) as order_date,
      DATE_TRUNC( cast(a.order_timestamp as date), week) as week,
      DATE_TRUNC( cast(a.order_timestamp as date), month) as month,
      a.country_iso,
      1 as flag,
      FROM `flink-data-prod.curated.order_lineitems` a
      WHERE DATE(a.order_timestamp) >=  date_sub(current_date(), interval 60 day)
            group by 1,2,3,4,5

),

sku_country as
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


day_sku_country_oos as
(
 SELECT

    day_country.order_date,
    day_country.week,
    day_country.month,
   "Chosen Time Frame" as period,
    day_country.country_iso,
    sku_country.random_ct_category as category,
    sku_country.random_ct_subcategory as subcategory,
    sku_country.product_name,
    sku_country.product_sku,
    sku_country.substitute_group,
    oos.hours_oos,
    oos.open_hours_total

      from day_country

      left join sku_country
      on day_country.country_iso = sku_country.country_iso

      left join oos
      on day_country.order_date = oos.inventory_tracking_date
      and sku_country.product_sku = oos.product_sku


union all

 SELECT

    day_country.order_date,
    day_country.week,
    day_country.month,
    "Week -1" as period,
    day_country.country_iso,
    sku_country.random_ct_category as category,
    sku_country.random_ct_subcategory as subcategory,
    sku_country.product_name,
    sku_country.product_sku,
    sku_country.substitute_group,
    oos.hours_oos,
    oos.open_hours_total

      from day_country

      left join sku_country
      on day_country.country_iso = sku_country.country_iso

    left join oos
      on day_country.order_date = date_add(oos.inventory_tracking_date,interval +7 day)
      and sku_country.product_sku = oos.product_sku

union all

 SELECT

    day_country.order_date,
    day_country.week,
    day_country.month,
   "Week -2" as period,
    day_country.country_iso,
    sku_country.random_ct_category as category,
    sku_country.random_ct_subcategory as subcategory,
    sku_country.product_name,
    sku_country.product_sku,
    sku_country.substitute_group,
    oos.hours_oos,
    oos.open_hours_total

      from day_country

      left join sku_country
      on day_country.country_iso = sku_country.country_iso

    left join oos
      on day_country.order_date = date_add(oos.inventory_tracking_date,interval +14 day)
      and sku_country.product_sku = oos.product_sku

union all

 SELECT

    day_country.order_date,
    day_country.week,
    day_country.month,
   "Week -3" as period,
    day_country.country_iso,
    sku_country.random_ct_category as category,
    sku_country.random_ct_subcategory as subcategory,
    sku_country.product_name,
    sku_country.product_sku,
    sku_country.substitute_group,
    oos.hours_oos,
    oos.open_hours_total

      from day_country

      left join sku_country
      on day_country.country_iso = sku_country.country_iso

    left join oos
      on day_country.order_date = date_add(oos.inventory_tracking_date,interval +21 day)
      and sku_country.product_sku = oos.product_sku

union all

 SELECT

    day_country.order_date,
    day_country.week,
    day_country.month,
   "Week -4" as period,
    day_country.country_iso,
    sku_country.random_ct_category as category,
    sku_country.random_ct_subcategory as subcategory,
    sku_country.product_name,
    sku_country.product_sku,
    sku_country.substitute_group,
    oos.hours_oos,
    oos.open_hours_total

      from day_country

      left join sku_country
      on day_country.country_iso = sku_country.country_iso

          left join oos
      on day_country.order_date = date_add(oos.inventory_tracking_date,interval +28 day)
      and sku_country.product_sku = oos.product_sku

)



select
day_sku_country_oos.*,
sku_lvl.avg_unit_price_gross,
sku_lvl.sum_item_value,
sku_lvl.sum_quantity,
sku_lvl.orders,

subcateg_lvl.sum_item_value as sum_item_value_subcateg,
subcateg_lvl.sum_quantity as sum_quantity_subcateg,
subcateg_lvl.avg_unit_price_gross as avg_unit_price_gross_subcateg,

flink_lvl.sum_item_value as sum_item_value_company,
flink_lvl.sum_quantity as sum_quantity_company,
flink_lvl.avg_unit_price_gross as avg_unit_price_gross_company


      from day_sku_country_oos
      left join sku_lvl
      on day_sku_country_oos.product_sku = sku_lvl.product_sku
      and day_sku_country_oos.country_iso = sku_lvl.country_iso
      and day_sku_country_oos.order_date = sku_lvl.order_date
      and day_sku_country_oos.period = sku_lvl.period

      left join subcateg_lvl
      on day_sku_country_oos.period = subcateg_lvl.period
      and day_sku_country_oos.order_date = subcateg_lvl.order_date
      and day_sku_country_oos.subcategory = subcateg_lvl.subcategory
      and day_sku_country_oos.country_iso = subcateg_lvl.country_iso

      left join flink_lvl
      on day_sku_country_oos.period = flink_lvl.period
      and day_sku_country_oos.order_date = flink_lvl.order_date
      and day_sku_country_oos.country_iso = flink_lvl.country_iso

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
