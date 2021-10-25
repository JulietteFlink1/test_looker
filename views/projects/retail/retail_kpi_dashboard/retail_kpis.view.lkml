view: retail_kpis {
  derived_table: {
    datagroup_trigger: flink_default_datagroup
    sql:
with
looker_base as (
    select
      hubs.country_iso                           as country_iso
    , hubs.hub_code                              as hub_code
    , hubs.city                                  as city
    , hubs.hub_name                              as hub_name
    , prod.subcategory                           as sub_category_name
    , prod.category                              as category_name
    , prod.product_name                          as product_name
    , item.sku                                   as sku
    , date(ord.order_timestamp, 'Europe/Berlin') as order_date
    , ord.order_uuid                             as order_uuid
    , ord.amt_gmv_gross                          as gross_order_value
    , ord.amt_gmv_net                            as net_order_value
    , ord.number_of_distinct_skus                as number_skus
    , ord.number_of_items                        as number_items
      -- AGGREGATES
    , sum(item.quantity)                         as sku_quantity
    --, sum(item.amt_unit_price_net)               as sku_unit_price
    , coalesce(sum(item.quantity * item.amt_unit_price_net),
               0)                                as sum_item_price_net
  from
                flink-data-prod.curated.orders          as ord
      left join flink-data-prod.curated.order_lineitems as item  on ord.order_uuid = item.order_uuid
      left join flink-data-prod.curated.hubs            as hubs  on ord.hub_code   = hubs.hub_code
      left join flink-data-prod.curated.products        as prod  on item.sku       = prod.product_sku

  where
          (ord.order_timestamp) >= date_add(current_timestamp, interval -90 day)

  group by
      1, 2, 3 , 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
),

looker_base_clean as (
    select
      *
    , case
      when order_date between date_add(current_date(), interval -7 day) and date_add(current_date(), interval -1 day)
          then 'current'
      when order_date between date_add(current_date(), interval -7 * 6 day) and date_add(current_date(), interval -(7 * 5 + 1) day)
          then 'previous'
          else 'undefined'
      end as cohorts

    from looker_base
  -- where placeholder LOOKER FILTER
     WHERE {% condition hub_code_filter %}    looker_base.hub_code    {% endcondition %}
       and {% condition hub_name_filter %}    looker_base.hub_name    {% endcondition %}
       and {% condition city_filter %}        looker_base.city        {% endcondition %}
       and {% condition country_iso_filter %} looker_base.country_iso {% endcondition %}

),

aggregations as (
    select
      sku
    , country_iso
    , product_name
    , order_date
    , cohorts
    -- , date_trunc(order_date, week)                                        as order_week
    , category_name
    , sub_category_name
      -- measures
    , sum(sum_item_price_net)                                             as sum_item_price_net
    , sum(if(cohorts = 'current', sum_item_price_net, 0))                 as sum_item_price_net_current
    , sum(if(cohorts = 'previous', sum_item_price_net, 0))                as sum_item_price_net_previous
    , count(distinct hub_code)                                            as distinct_hub_codes
    , count(distinct if(cohorts = 'current', hub_code, null))             as distinct_hub_codes_current
    , count(distinct if(cohorts = 'previous', hub_code, null))            as distinct_hub_codes_previous
    , sum(sum_item_price_net) / nullif(count(distinct hub_code), 0)       as equalized_revenue
    , sum(if(cohorts = 'current', sum_item_price_net, 0)) /
      nullif(count(distinct if(cohorts = 'current', hub_code, null)), 0)  as equalized_revenue_current
    , sum(if(cohorts = 'previous', sum_item_price_net, 0)) /
      nullif(count(distinct if(cohorts = 'previous', hub_code, null)), 0) as equalized_revenue_previous
    , avg(number_skus)                                                    as avg_basket_skus
    , avg(number_items)                                                   as avg_basket_items
    , avg(net_order_value)                                                as avg_basket_value
    from looker_base_clean
    group by
      1, 2, 3, 4, 5, 6, 7
),

equlalized_revenue_last_14_days as (
    select
      sku
    , country_iso
    -- to exclude sundays, non-working days, assuming on this aggregation, there are at least some sales
    , AVG(equalized_revenue) as avg_equalized_revenue_last_14d
    from aggregations
    where order_date >= date_add(current_date(), interval -14 day)
    group by sku, country_iso
),

out_of_stock_data as (
    select
        inv.inventory_tracking_date      as tracking_date
      , inv.sku                      as sku
        -- , upper(split(inv.hub_code, "_")[offset(0)]) as country_iso
      , hubs.country_iso             as country_iso
      , sum(inv.open_hours_total)    as open_hours_total
      , sum(inv.hours_oos)           as hours_oos
      --, sum(inv.sum_items_ordered) as sum_count_purchased
      , sum(inv.sum_count_restocked) as sum_count_restocked
      , avg(inv.avg_stock_count)     as avg_stock_count

    from flink-data-prod.reporting.inventory_stock_count_daily as inv
    left join `flink-data-prod`.curated.hubs                   as hubs
          on hubs.hub_code = inv.hub_code

    where
    inv.inventory_tracking_date >= date_add(current_date(), interval -90 day)
     and {% condition hub_code_filter %}    hubs.hub_code    {% endcondition %}
     and {% condition hub_name_filter %}    hubs.hub_name    {% endcondition %}
     and {% condition city_filter %}        hubs.city        {% endcondition %}
     and {% condition country_iso_filter %} hubs.country_iso {% endcondition %}
  group by 1,2,3
)

select
      aggregations.sku
    , aggregations.country_iso
    , product_name
    , order_date
    , cohorts
    -- , order_week
    , category_name
    , sub_category_name
    , sum_item_price_net
    , sum_item_price_net_current
    , sum_item_price_net_previous
    , distinct_hub_codes
    , distinct_hub_codes_current
    , distinct_hub_codes_previous
    , equalized_revenue
    , equalized_revenue_current
    , equalized_revenue_previous
    , avg_basket_skus
    , avg_basket_items
    , avg_basket_value
    , open_hours_total
    , hours_oos
    -- , sum_count_purchased
    , sum_count_restocked
    , avg_stock_count
    , equlalized_revenue_last_14_days.avg_equalized_revenue_last_14d
    , sum(equalized_revenue_current)  over (partition by aggregations.country_iso, sub_category_name) as equalized_revenue_subcategory_current
    , sum(equalized_revenue_previous) over (partition by aggregations.country_iso, sub_category_name) as equalized_revenue_subcategory_previous
    , sum(equalized_revenue_current)  over (partition by aggregations.country_iso)                    as equalized_revenue_total_current
    , sum(equalized_revenue_previous) over (partition by aggregations.country_iso)                    as equalized_revenue_total_previous
from aggregations
left join out_of_stock_data
     on out_of_stock_data.tracking_date = aggregations.order_date and
        out_of_stock_data.sku           = aggregations.sku and
        out_of_stock_data.country_iso   = aggregations.country_iso
left join equlalized_revenue_last_14_days
     on equlalized_revenue_last_14_days.sku         = aggregations.sku and
        equlalized_revenue_last_14_days.country_iso = aggregations.country_iso
             ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    sql: concat(${TABLE}.sku, ifnull(${TABLE}.country_iso, 'nA'), cast(${TABLE}.order_date as string)) ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: cohorts {
    type: string
    sql: ${TABLE}.cohorts ;;
  }

  dimension_group: order {
    type: time
    datatype: date
    sql: ${TABLE}.order_date ;;
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
  }

  dimension: category_name {
    label: "Parent Category Name"
    type: string
    sql: ${TABLE}.category_name ;;
  }

  dimension: sub_category_name {
    label: "Sub-Category Name"
    type: string
    sql: ${TABLE}.sub_category_name ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     FILTER         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  filter: hub_code_filter {
    type: string
  }

  filter: hub_name_filter {
    type: string

  }

  filter: city_filter {
    type: string
  }

  filter: country_iso_filter {
    type: string
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameter         ~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # TODO: parameter to set the week to compare with


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures         ~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: sum_item_price_net {
    label: "Sum Item Price (Net)"
    description: "Sum of sold items multiplied by their prices (excl. VAT)"
    group_label: "Measure - Complete Timeframe (last 90 days)"
    type: sum
    value_format_name: eur
  }
  measure: sum_item_price_net_current {
    label: "Sum Item Price (Net - Current Period)"
    description: "Sum of sold items multiplied by their prices (excl. VAT)"
    group_label: "Measure - Current Period (last 7 complete days)"
    type: sum
    value_format_name: eur
  }
  measure: sum_item_price_net_previous {
    label: "Sum Item Price (Net - Previous Period)"
    description: "Sum of sold items multiplied by their prices (excl. VAT)"
    group_label: "Measure - Previous Period (6 weeks ago for 7 days)"
    type: sum
    value_format_name: eur
  }
  # -----------------------------------------------------------
  measure: distinct_hub_codes {
    group_label: "Measure - Complete Timeframe (last 90 days)"
    type: max
    value_format_name: decimal_1
    hidden: no
  }
  measure: distinct_hub_codes_current {
    group_label: "Measure - Current Period (last 7 complete days)"
    type: max
    value_format_name: decimal_1
    hidden: no
  }
  measure: distinct_hub_codes_previous {
    group_label: "Measure - Previous Period (6 weeks ago for 7 days)"
    type: max
    value_format_name: decimal_1
    hidden: no
  }
  # -----------------------------------------------------------
  measure: equalized_revenue {
    label: "Equalized Revenue"
    description: "The Sum Item Price Net divided by the number of hubs, the product was sold"
    group_label: "Measure - Complete Timeframe (last 90 days)"
    type: sum
    value_format_name: eur
  }
  measure: equalized_revenue_current {
    label: "Equalized Revenue (Current Period)"
    description: "The Sum Item Price Net divided by the number of hubs, the product was sold"
    group_label: "Measure - Current Period (last 7 complete days)"
    type: sum
    value_format_name: eur
  }
  measure: equalized_revenue_previous {
    label: "Equalized Revenue (Previous Period)"
    description: "The Sum Item Price Net divided by the number of hubs, the product was sold"
    group_label: "Measure - Previous Period (6 weeks ago for 7 days)"
    type: sum
    value_format_name: eur
  }
  # -----------------------------------------------------------
  measure:  open_hours_total {
    label: "Total Open Hours of Hub"
    description: "The hours a hub was open on a specific day (will be smmed up across visible dimensions)"
    group_label: "Measure - Complete Timeframe (last 90 days)"
    type: sum
    value_format_name: decimal_0
  }
  measure:  hours_oos {
    label: "Hours SKU Out-Of-Stock"
    description: "The hours per day and hub, that a specific product was out-of-stock (will be smmed up across visible dimensions)"
    group_label: "Measure - Complete Timeframe (last 90 days)"
    type: sum
    value_format_name: decimal_0
  }
  measure:  sum_count_purchased {
    label: "Items Sold"
    description: "The (estimaed) number of sold goods based on the hourly comparison of the current and previous hour. If the current stock level is less than in the previous hour, we consider this a sale (might also be a book-out)"
    group_label: "Measure - Complete Timeframe (last 90 days)"
    type: sum
    value_format_name: decimal_1
    sql: NULL ;;
  }
  measure:  sum_count_restocked {
    label: "Items Restocked"
    description: "The (estimated) number of re-stocked goods based on the hourly comparison of the current and previous hour. If the current hour has a higher stock than the previous hour, we assume the differnce to be re-stocked"
    group_label: "Measure - Complete Timeframe (last 90 days)"
    type: sum
    value_format_name: decimal_1
  }
  measure: avg_equalized_revenue_last_14d_per_day {
    label: "AVG Equalized Revenue per day based on last 14 days"
    description: "The average daily Equalized Revenues within a 14 day window"
    group_label: "Measure - per DAY granularity"
    type: average
    value_format_name: eur
    sql:  ${TABLE}.avg_equalized_revenue_last_14d;;
  }
  measure:avg_equalized_revenue_last_14d_for_7_days  {
    label: "AVG Equalized Revenue per 7-day window"
    description: "The *AVG Equalized Revenue per day based on last 14 days* multiplied by 7"
    group_label: "Measure - Current Period (last 7 complete days)"
    type: number
    value_format_name: eur
    # dividing by 7 is just a heuristic
    # actually in some countries and or cities, this number may differ
    # the problem, why I can not solve this with a query is:
    # --> the equalized revenue is calculated by dividing the SKU-revenue by number hubs for a daily level
    # --> for this to work on a date-aggregated level, we would need to know hub-level data (which not exist anymore)
    #
    # --> as this KPI averages also over sundays and non-working-days, this metric should be an appropriate approximation
    sql: ${avg_equalized_revenue_last_14d_per_day} * 7 ;;
  }

  measure: avg_stock_count {
    label: "AVG Stock Count"
    description: "The average stock count of a product (averages over days and visible dimensions)"
    group_label: "Measure - Complete Timeframe (last 90 days)"
    type: average
    value_format_name: decimal_1
    sql: ${TABLE}.avg_stock_count ;;
  }
  measure: avg_stock_count_current {
    label: "AVG Stock Count (Current Period)"
    description: "The average stock count of a prodcut in the current period (averages over days and visible dimensions)"
    group_label: "Measure - Current Period (last 7 complete days)"
    type: average
    value_format_name: decimal_1
    sql: ${TABLE}.avg_stock_count ;;
    filters: [cohorts: "current"]
  }


  measure:  open_hours_total_current {
    label: "Total Open Hours of Hub (Current Period)"
    description: "The hours a hub was open on a specific day (will be smmed up across visible dimensions)"
    group_label: "Measure - Current Period (last 7 complete days)"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.open_hours_total ;;
    filters: [cohorts: "current"]
  }
  measure:  hours_oos_current {
    label: "Hours SKU Out-Of-Stock (Current Period)"
    description: "The hours per day and hub, that a specific product was out-of-stock (will be smmed up across visible dimensions)"
    group_label: "Measure - Current Period (last 7 complete days)"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.hours_oos ;;
    filters: [cohorts: "current"]
  }
  measure:  sum_count_purchased_current {
    label: "Items Sold (Current Period)"
    description: "The (estimaed) number of sold goods based on the hourly comparison of the current and previous hour. If the current stock level is less than in the previous hour, we consider this a sale (might also be a book-out)"
    group_label: "Measure - Current Period (last 7 complete days)"
    type: sum
    value_format_name: decimal_1
    sql: NULL ;;
    filters: [cohorts: "current"]
  }
  measure:  sum_count_restocked_current {
    label: "Items Restocked (Current Period)"
    description: "The (estimated) number of re-stocked goods based on the hourly comparison of the current and previous hour. If the current hour has a higher stock than the previous hour, we assume the differnce to be re-stocked"
    group_label: "Measure - Current Period (last 7 complete days)"
    type: sum
    value_format_name: decimal_1
    sql: ${TABLE}.sum_count_restocked ;;
    filters: [cohorts: "current"]
  }


  # ~~~~~~~    Window Calculation    ~~~~~~~
  measure: equalized_revenue_subcategory_current {
    label: "Equalized Revenue per Sub-Category"
    description: "The equalized revenue of of a sub-category in the current period"
    group_label: "Measure - Current Period (last 7 complete days)"
    type: max
    value_format_name: eur
  }
  measure: equalized_revenue_subcategory_previous {
    label: "Equalized Revenue per Sub-Category"
    description: "The equalized revenue of of a sub-category in the previous period"
    group_label: "Measure - Previous Period (6 weeks ago for 7 days)"
    type: max
    value_format_name: eur
  }
  measure: equalized_revenue_total_current {
    label: "Equalized Revenue across Business"
    description: "The equalized revenue across all categories in the current period"
    group_label: "Measure - Current Period (last 7 complete days)"
    type: max
    value_format_name: eur
  }
  measure: equalized_revenue_total_previous {
    label: "Equalized Revenue across Business"
    description: "The equalized revenue across all categories in the previous period"
    group_label: "Measure - Previous Period (6 weeks ago for 7 days)"
    type: max
    value_format_name: eur
  }



  # ~~~~~~~    Order Metrics    ~~~~~~~
  measure: avg_basket_skus {
    label: "AVG SKUs per Basket"
    description: "The average number of unique SKUs in a basket, given the SKU was part of the basket"
    group_label: "Measure - Complete Timeframe (last 90 days)"
    type: average
    sql: ${TABLE}.avg_basket_skus ;;
    value_format_name: decimal_2
  }

  measure: avg_basket_items {
    label: "AVG Items in Basket"
    description: "The average basket size (count of basket items), given the SKU was part of the basket"
    group_label: "Measure - Complete Timeframe (last 90 days)"
    type: average
    sql: ${TABLE}.avg_basket_items ;;
    value_format_name: decimal_2
  }

  measure: avg_basket_value {
    label: "AVG Basket Value"
    description: "The average basket value, given the SKU was part of the basket"
    group_label: "Measure - Complete Timeframe (last 90 days)"
    type: average
    sql: ${TABLE}.avg_basket_value ;;
    value_format_name: eur
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Percentages         ~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: pct_eq_revenue_share_subcat_current {
    label: "% Equalized Revenue Share Sub-Category"
    description: "The sahre of an SKU compared to its Sub-Category based on the Equalized Revenue."
    group_label: "Measure - Current Period (last 7 complete days)"
    type: number
    value_format_name: percent_1
    sql:  ${equalized_revenue_current} / nullif(${equalized_revenue_subcategory_current} ,0);;
  }

  measure: pct_overall_business_growth {
    label: "% Overall Business Growth"
    description: "% Overall Business Growth based on equalized revenue"
    group_label: "Measure - Current vs. Previous Period"
    type: number
    value_format_name: percent_1
    sql: (${equalized_revenue_total_current} - ${equalized_revenue_total_previous}) / nullif(${equalized_revenue_total_previous} ,0) ;;
  }

  measure: pct_sku_growth {
    label: "% SKU Growth (Current vs. Previous 7d)"
    description: "The growth of the equalized revenue of an SKU comparing the Current and Previous Period"
    group_label: "Measure - Current vs. Previous Period"
    type: number
    value_format_name: percent_1
    sql: (${equalized_revenue_current} - ${equalized_revenue_previous}) / nullif(${equalized_revenue_previous} ,0) ;;
    html:
      {% if value > 0.3 %}
      <p style="color: #2ECC71; background-color: #D5F5E3 ;font-size: 100%; text-align:center">{{ rendered_value }}</p>
      {% elsif value < -0.3 %}
      <p style="color: #E74C3C; background-color: #FADBD8 ; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% else %}
      <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% endif %};;
  }

  measure: pct_sku_growth_corrected {
    label: "% SKU Growth Corrected by Business Growth"
    description: "The % SKU Growth (Current vs. Previous 7d) minus the % Overall Business Growth"
    group_label: "Measure - Current vs. Previous Period"
    type: number
    value_format_name: percent_1
    sql: ${pct_sku_growth} - ${pct_overall_business_growth} ;;

    html:
      {% if value > 0.3 %}
      <p style="color: #2ECC71; background-color: #D5F5E3 ;font-size: 100%; text-align:center">{{ rendered_value }}</p>
      {% elsif value < -0.3 %}
      <p style="color: #E74C3C; background-color: #FADBD8 ; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% else %}
      <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% endif %};;
  }


  measure: pct_out_of_stock_current {
    label: "% Out Of Stock"
    description: "The hours out-of-stock of a product (calculated per day, sku and hub - summed up over the displayed dimensions) compared to the total opening hours of a hub on a specific day."
    group_label: "Measure - Current Period (last 7 complete days)"
    type: number
    value_format_name: percent_1
    sql: ${hours_oos_current} / nullif(${open_hours_total_current},0) ;;
    html:
    {% if value > 0.1 %}
    <p style="color: #ffffff; background-color: #B03A2E ;font-size: 100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value > 0.05 %}
    <p style="color: #AF601A; background-color: #FAD7A0 ; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value > 0 %}
    <p style="color: #F1C40F; background-color: #FEF9E7 ; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% else %}
    <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %};;
  }

  measure: missed_revenue {
    label: "Missed Revenue (oos)"
    description: "The revenue, FLink would have realized, if the product would not have been out-of-stock. The base of this calulcation is the average equalized revenue of the last 14 days"
    group_label: "Measure - Current Period (last 7 complete days)"
    type: number
    value_format_name: eur
    sql: ${pct_out_of_stock_current} * ${avg_equalized_revenue_last_14d_for_7_days} ;;
  }


  set: detail {
    fields: [
      sku,
      product_name,
      order_date,
      order_week,
      category_name,
      sub_category_name,
    ]
  }
}
