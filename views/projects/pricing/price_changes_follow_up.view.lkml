view: price_changes_follow_up {
  derived_table: {
    sql:
with

oos as
(
    SELECT
    inventory_tracking_date,
    product_sku as sku,
    sum(hours_oos) as hours_oos,
    sum(open_hours_total) as open_hours_total
        from (
            SELECT
                a.inventory_tracking_date,
                c.hub_name,
                case when b.category ="Obst & Gemüse" then b.substitute_group else b.product_sku end  as substitute_group,
                --product_sku,
                min(hours_oos) as hours_oos,
                max(open_hours_total) as open_hours_total
        FROM `flink-data-prod.reporting.inventory_stock_count_daily` a
        LEFT JOIN `flink-data-prod.curated.products` b
            on a.sku = b.product_sku
        LEFT JOIN `flink-data-prod.curated.hubs` c
            on a.hub_code = c.hub_code
        -- WHERE inventory_tracking_date >= date_sub(current_date(), interval 88 day)
        group by 1,2,3
            )
    as a
    left join `flink-data-prod.curated.products` b
        on a.substitute_group  = case when b.category ="Obst & Gemüse" then b.substitute_group else b.product_sku end
    group by 1,2

),

price_today_aux as
(
    SELECT

    cast(a.order_timestamp as date) AS order_date,
    a.sku,
    a.amt_unit_price_gross as price_today,
    max (a.order_timestamp) as max_order_timestamp

    FROM `flink-data-prod.curated.order_lineitems`  AS a
        LEFT JOIN `flink-data-prod.curated.orders`  AS ord
            ON ord.order_uuid = a.order_uuid

where ord.is_successful_order is true
      -- and sku = "11013686"
       and cast(a.order_timestamp as time) <="22:30:00"
group by 1,2,3
order by 1,2,4 desc
),

/*for the cases in which the product had two prices in the same day, I keep the one tnat had more revenue*/
price_today_aux2 as
(
select
row_number() over (partition by concat(order_date,sku) order by max_order_timestamp desc) as rn,
a.*,
from price_today_aux a
order by 2
),

price_today as
(
select
a.order_date,
a.sku,
a.price_today,
 cast(COALESCE(SUM(b.amt_total_price_gross), 0) as decimal)  AS sum_item_price_gross,
 COALESCE(SUM(b.quantity), 0) AS sum_item_quantity,
 count(distinct b.order_uuid) as dist_ord
from price_today_aux2 a
left join `flink-data-prod.curated_incremental.order_lineitems` b
on a.sku = b.sku
and a.order_date = cast(b.order_timestamp as date)
where rn=1
 and price_today <> 0
group by 1,2,3
order by 1

),

price_yesterday_aux as
(
SELECT
    cast(a.order_timestamp as date) AS order_date,
    case when  (FORMAT_TIMESTAMP('%A', a.order_timestamp))="Saturday" and a.country_iso ="DE" then cast(date_add(a.order_timestamp,interval +2 day) as date)
    else cast(date_add(a.order_timestamp,interval +1 day) as date) end as order_date_min_1,
    a.sku,
    a.amt_unit_price_gross as price_yest,
    max (case when  (FORMAT_TIMESTAMP('%A', a.order_timestamp))="Saturday" and a.country_iso ="DE" then date_add(a.order_timestamp,interval +2 day)
    else date_add(a.order_timestamp,interval +1 day) end) as max_order_timestamp,
    -- cast(COALESCE(SUM(a.amt_total_price_gross), 0) as decimal)  AS sum_item_price_gross,
    -- COALESCE(SUM(a.quantity ), 0) AS sum_item_quantity,
    --cast(COALESCE(SUM(a.amt_total_price_gross), 0) as decimal) / COALESCE(SUM(a.quantity ), 0) as price_yest

FROM `flink-data-prod.curated.order_lineitems`  AS a
    LEFT JOIN `flink-data-prod.curated.orders`  AS ord
            ON ord.order_uuid = a.order_uuid
    where ord.is_successful_order is true
    and cast(a.order_timestamp as time) <="22:30:00"
    group by 1,2,3,4
),

price_yesterday_aux2 as
(
select
row_number() over (partition by concat(order_date_min_1,sku) order by max_order_timestamp desc) as rn,
a.*,
from price_yesterday_aux a
order by 2
),

price_yesterday as
(
select
a.order_date_min_1,
a.sku,
a.price_yest
from price_yesterday_aux2 a
where rn=1
 and price_yest <> 0
group by 1,2,3
order by 1
),

day_sku_pr_change as
(
select
a.*,
b.price_yest,
(a.price_today - b.price_yest) / b.price_yest as price_change_percentage,
case when (a.price_today - b.price_yest) = 0 then 0 else 1 end as did_change
    from price_today a
        left join price_yesterday b
            on a.order_date = b.order_date_min_1
            and a.sku = b.sku
        left join `flink-data-prod.google_sheets.price_test_tracking` c
            on a.order_date >= c.start_date
            and a.order_date <= c.end_date
            and a.sku = cast(c.sku as string)


        where
        ((a.price_today - b.price_yest) / b.price_yest) <> 0.0
        or c.test_id is not null
order by 1
),

--select * from day_sku_pr_change

sales_after as
(
select
a.order_date,
a.sku,
a.price_today,
a.price_yest,
a.price_change_percentage,
sum(b.sum_item_price_gross) as sum_item_value_after,
sum(b.sum_item_quantity) as sum_quantity_after,
sum(b.dist_ord) as orders_after,
sum(c.did_change) as times_change_after,
    from day_sku_pr_change a
        left join price_today b
            on a.sku = b.sku
            and a.order_date <= b.order_date
            and a.order_date > date_add(b.order_date,interval -7 day)
        left join day_sku_pr_change c
            on a.sku = c.sku
            and b.order_date = c.order_date
group by 1,2,3,4,5
),



oos_after as
(
select
a.order_date,
a.sku,
a.price_today,
a.price_yest,
a.price_change_percentage,
sum_item_value_after,
sum_quantity_after,
orders_after,
times_change_after,
sum(hours_oos) as hours_oos_after,
sum(open_hours_total) as open_hours_total_after
    from sales_after a
        left join oos
            on a.sku = oos.sku
            and a.order_date <= oos.inventory_tracking_date
            and a.order_date > date_add(oos.inventory_tracking_date,interval -7 day)
    group by 1,2,3,4,5,6,7,8,9
),

sales_before as
(
select
row_number() over (partition by concat(a.sku) order by a.order_date) as rn,
a.order_date,
a.sku,
a.price_today,
a.price_yest,
a.price_change_percentage,
a.sum_item_value_after,
a.sum_quantity_after,
a.orders_after,
hours_oos_after,
open_hours_total_after,
a.times_change_after -1 as times_change_after /*always counts the change itself*/ ,
sum(b.sum_item_price_gross) as sum_item_value_before,
sum(b.sum_item_quantity) as sum_quantity_before,
sum(b.dist_ord) as orders_before,
coalesce (sum(c.did_change),0) as times_change_before,
    from oos_after  a
        left join price_today b
            on a.sku = b.sku
            and a.order_date > b.order_date
            and a.order_date <= date_add(b.order_date,interval +7 day)
        left join day_sku_pr_change c
        on a.sku = c.sku
            and b.order_date = c.order_date
group by 2,3,4,5,6,7,8,9,10,11,12
order by 2
),

oos_before as
(
select
rn,
a.order_date,
a.sku,
a.price_today,
a.price_yest,
a.price_change_percentage,
a.sum_item_value_after,
a.sum_quantity_after,
a.orders_after,
hours_oos_after,
open_hours_total_after,
times_change_after /*always counts the change itself*/ ,
sum_item_value_before,
sum_quantity_before,
orders_before,
times_change_before,
sum(hours_oos) as hours_oos_before,
sum(open_hours_total) as open_hours_total_before
    from sales_before a
        left join oos
            on a.sku = oos.sku
            and a.order_date > oos.inventory_tracking_date
            and a.order_date <= date_add(oos.inventory_tracking_date,interval +7 day)
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
),

valid_until as
(
    select
    rn -1 as rn_yest,
    sku,
    date_add(order_date,interval -1 day) as valid_until
        from oos_before
),

pre_final as
(
    select
    a.order_date as valid_from,
    DATE_TRUNC(a.order_date, week) as week,
    DATE_TRUNC(a.order_date, month) as month,
    case when b.valid_until is null then date_add(current_date(),interval -1 day) else b.valid_until end as valid_until,
    c.country_iso,
    a.sku,
    c.product_name,
    c.category as category,
    c.subcategory as subcategory,
    a.price_today as current_price,
    a.price_yest as previous_price,
    a.price_change_percentage,
    case when a.price_change_percentage>0 then "Increase"
         when a.price_change_percentage=0 then "No change (Monitor Price Test)"
         else "Decrease" end as price_change,
    a.sum_item_value_after as sum_item_value_after_7days,
    a.sum_item_value_before as sum_item_value_before_7days,
    a.sum_quantity_after as sum_quantity_after_7days,
    a.sum_quantity_before as sum_quantity_before_7days,
    a.orders_after as orders_after_7days,
    a.orders_before as orders_before_7days,
    case when a.times_change_after is null then 0 else a.times_change_after end as price_changes_next_7_days,
    case when a.times_change_before is null then 0 else a.times_change_before end as price_changes_previous_7_days,
    a.hours_oos_after as hours_oos_after_7_days,
    a.open_hours_total_after as open_hours_total_after_7days,
    a.hours_oos_before as hours_oos_before_7_days,
    a.open_hours_total_before as open_hours_total_before_7days ,
    case when date_diff(date_add(current_date(),interval 0 day), a.order_date, day)>7 then 7
    when date_diff(date_add(current_date(),interval 0 day), a.order_date, day)=0 then 1
    else date_diff(date_add(current_date(),interval 0 day), a.order_date, day) end as days_of_revenue
        from oos_before a
            left join valid_until b
                on a.sku = b.sku
                and a.rn = b.rn_yest
            left join  `flink-data-prod.curated.products` c
                on a.sku = c.product_sku
    --where a.order_date < current_date()
),

max_date_kvi as
(
    select
    max(kvi_date) as max_kvi_date
    from `flink-data-prod.reporting.key_value_items`
),

kvi as
(
    select
    sku
    from `flink-data-prod.reporting.key_value_items` a
    inner join max_date_kvi  b
    on a.kvi_date = b.max_kvi_date
)

select
a.*,
a.price_change_percentage*a.sum_item_value_after_7days/nullif(days_of_revenue,0) as perc_price_change_weight_rev_nominator,
a.sum_item_value_after_7days/nullif(days_of_revenue,0) as perc_price_change_weight_rev_denominator,
1 as count_row,
case when b.sku is not null then "KVI" else "Not KVI" end as KVI,
 case when  c.test_id is not null then c.test_id  else " No Price Test" end as price_test

from pre_final a

    left join kvi b
       on a.sku = b.sku

    left join `flink-data-prod.google_sheets.price_test_tracking` c
        on a.valid_from >= c.start_date
        and a.valid_from <= c.end_date
        and a.sku = cast(c.sku as string)



      ;;
  }

  measure: sum_item_value_after_7days {
    label: "Item Value - 7 Days after"
    type: sum
    value_format_name: euro_accounting_1_precision
    sql: ${TABLE}.sum_item_value_after_7days ;;
  }

    measure: sum_item_value_before_7days {
      label: "Item Value - 7 previous Days"
      type: sum
      value_format_name: euro_accounting_1_precision
      sql: ${TABLE}.sum_item_value_before_7days ;;
    }

  measure: sum_quantity_after_7days {
    label: "Quantity Sold - 7 Days after"
    type: sum
    sql: ${TABLE}.sum_quantity_after_7days ;;
  }

  measure: sum_quantity_before_7days {
    label: "Quantity Sold - 7 previous Days"
    type: sum
    sql: ${TABLE}.sum_quantity_before_7days ;;
  }

  measure: orders_after_7days {
    label: "Orders - 7 Days after"
    type: sum
    sql: ${TABLE}.orders_after_7days ;;
  }

  measure: orders_before_7days {
    label: "Orders - 7 previous Days"
    type: sum
    sql: ${TABLE}.orders_before_7days ;;
  }

  # measure: price_changes_next_7_days {
  #   label: "Times price changed- 7 next Days"
  #   type: sum
  #   sql: ${TABLE}.price_changes_next_7_days ;;
  # }

  # measure: price_changes_previous_7_days {
  #   label: "Times price changed- 7 previous Days"
  #   type: sum
  #   sql: ${TABLE}.price_changes_previous_7_days ;;
  # }

  measure: hours_oos_after_7_days {
    label: "Hours Oos- 7 Days after"
   # hidden: yes
    type: sum
    sql: ${TABLE}.hours_oos_after_7_days ;;
  }

  measure: hours_oos_before_7_days {
    label: "Hours Oos- 7 previous Days"
   # hidden: yes
    type: sum
    sql: ${TABLE}.hours_oos_before_7_days ;;
  }

  measure: open_hours_total_after_7days {
    label: "Open Hours- 7 Days after"
   # hidden: yes
    type: sum
    sql: ${TABLE}.open_hours_total_after_7days ;;
  }

  measure: open_hours_total_before_7days {
    label: "Open Hours- 7 previous Days"
   # hidden: yes
    type: sum
    sql: ${TABLE}.open_hours_total_before_7days ;;
  }

  measure: days_of_revenue {
    label: "Days Rev. after"
    type: sum
   # hidden: yes
    sql: ${TABLE}.days_of_revenue ;;
  }

  measure: perc_price_change_weight_rev_nominator {
    # label: "% Price Change"
    type: sum
    hidden: yes
    sql: ${TABLE}.perc_price_change_weight_rev_nominator ;;
  }

  measure: perc_price_change_weight_rev_denominator {
    # label: "% Price Change"
    type: sum
    hidden: yes
    sql: ${TABLE}.perc_price_change_weight_rev_denominator ;;
  }

  measure: count_row {
     label: "Count SKU-Price Change event"
    type: sum
    hidden: no
    sql: ${TABLE}.count_row ;;
  }





  measure: distinct_SKU {
    type: count_distinct
    description: "Count Distinct SKU"
    value_format_name: decimal_0
    sql: ${sku} ;;

  }

  measure: Oos_rate_before {
    type: number
    label: "% Out of Stock Previous 7 days"
    value_format_name: percent_1
    sql: ${hours_oos_after_7_days} /nullif(${open_hours_total_after_7days},0)
    ;;
  }

  measure: Oos_rate_after {
    type: number
    label: "% Out of Stock 7 days after"
    value_format_name: percent_1
    sql: ${hours_oos_before_7_days} /nullif(${open_hours_total_before_7days},0)
    ;;
  }



  measure: perc_price_change_weight_rev {
    type: number
    label: "% Price Change Weighted by avg revenue"
    value_format_name: percent_1
    sql: ${perc_price_change_weight_rev_nominator}/${perc_price_change_weight_rev_denominator}
      ;;
  }




  # dimension: valid_from {
  #   type: date
  #   # label: "Price Change Date"
  #   datatype: date
  #   sql: ${TABLE}.valid_from ;;
  # }

  dimension: valid_until {
    type: date
    datatype: date
    sql: ${TABLE}.valid_until ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: subcategory {
    type: string
    sql: ${TABLE}.subcategory ;;
  }

  dimension: current_price {
    type: number
    sql: ${TABLE}.current_price ;;
  }


  dimension: price_test {
    type: string
    sql: ${TABLE}.price_test ;;
  }

  dimension: price_changes_next_7_days {
    type: number
    label: "Times price changed- 7 Days after"
    sql: ${TABLE}.price_changes_next_7_days ;;
  }

  dimension: price_changes_previous_7_days {
    type: number
    label: "Times price changed- 7 previous Days"
    sql: ${TABLE}.price_changes_previous_7_days ;;
  }





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
    sql: ${TABLE}.valid_from ;;
    datatype: date
  }



  dimension: day {
    type: date
    datatype: date
    sql: ${TABLE}.valid_from ;;
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


  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  dimension: valid_from {
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





  dimension: previous_price {
    type: number
    sql: ${TABLE}.previous_price ;;
  }

  dimension: price_change_percentage {
    type: number
    sql: ${TABLE}.price_change_percentage ;;
  }

  dimension: country_iso {
    label: "Country Iso"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: price_change_type {
    type: string
    label: "Price Change Type"
    sql: ${TABLE}.price_change ;;
  }

  dimension: kvi {
    type: string
    sql: ${TABLE}.kvi ;;
  }


  set: detail {
    fields: [day,
      week,
      month,
      valid_until,
      category,
      subcategory,
      product_name,
      sku,
      country_iso
    ]
  }

}
