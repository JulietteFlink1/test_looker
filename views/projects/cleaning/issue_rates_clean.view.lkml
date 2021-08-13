view: issue_rates_clean {
  derived_table: {
    sql: with issues_orders as
      (
        select
        -- Dimensions
        hub_code,
        date(orders.order_timestamp, 'Europe/Berlin') as date,
        -- Aggregates
        count(distinct if(cs.problem_group = 'Wrong Order', order_nr_, null)) as wrong_order,
        count(distinct if(cs.problem_group = 'Wrong Product', order_nr_, null)) as wrong_product,
        count(distinct if(cs.problem_group = 'Perished Product', order_nr_, null)) as perished_product,
        count(distinct if(cs.problem_group = 'Missing Product', order_nr_, null)) as missing_product,
        count(distinct if(cs.problem_group = 'Damaged', order_nr_, null)) as damaged,
        count(distinct if (cs.problem_group is not null, order_nr_, null)) as orders_with_issues
        -- Joins
        from `flink-data-prod.curated.orders` orders
        left join `flink-data-prod.curated.cs_post_delivery_issues` cs
        on cs.country_iso = orders.country_iso and cs.order_nr_ = orders.order_number
        -- other
        group by 1, 2
      ),

      orders_per_hub as
      (
          select
          -- Dimensions
          hub_code,
          date(order_timestamp, 'Europe/Berlin') as date,
          -- Aggregates
          count(distinct order_uuid) as count_orders
          -- Joins
          from `flink-data-prod.curated.orders`
          -- Where
          where is_successful_order is true and
          customer_email NOT LIKE '%goflink%' AND customer_email NOT LIKE '%pickery%'
          AND LOWER(customer_email) NOT IN ('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com', 'alenaschneck@gmx.de', 'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com', 'fabian.hardenberg@gmail.com', 'benjamin.zagel@gmail.com')
          -- Other
          group by 1, 2
      )

      select
      -- Dimensions
      orders_per_hub.date as date,
      orders_per_hub.hub_code as hub_code,
      -- Aggregates
      sum(wrong_order) as wrong_order,
      sum(wrong_product) as wrong_product,
      sum(perished_product) as perished_product,
      sum(missing_product) as missing_product,
      sum(damaged) as damaged,

      sum(orders_with_issues) as  orders_with_issues,
      sum(count_orders) as orders_total
      -- Joins
      from issues_orders
      left join orders_per_hub
      on issues_orders.hub_code = orders_per_hub.hub_code
      and issues_orders.date = orders_per_hub.date
      -- Other
      where orders_per_hub.date >= '2021-08-10' and orders_per_hub.hub_code in ('fr_par_bagn', 'nl_del_cent', 'fr_par_brul')
      group by 1,2
      order by 1, 2
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.date, ${TABLE}.hub_code) ;;
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~  DIMENSIONS ~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: date {
    label: "Order Date"
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension_group: created {
    group_label: "* Dates and Timestamps *"
    label: "Issue"
    description: "Issue Date/Time"
    type: time
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${date} ;;
    datatype: date
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: date_dynamic {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: orders.date_granularity
    sql:
    {% if orders.date_granularity._parameter_value == 'Day' %}
      ${created_date}
    {% elsif orders.date_granularity._parameter_value == 'Week' %}
      ${created_week}
    {% elsif orders.date_granularity._parameter_value == 'Month' %}
      ${created_month}
    {% endif %};;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~  Hidden Fields     ~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: orders_with_issues {
    type: number
    sql: ${TABLE}.orders_with_issues ;;
    hidden: yes
  }

  dimension: orders_total {
    type: number
    sql: ${TABLE}.orders_total ;;
    hidden: yes
  }

  dimension: wrong_product {
    type: number
    sql: ${TABLE}.wrong_product ;;
    hidden: yes
  }

  dimension: wrong_order {
    type: number
    sql: ${TABLE}.wrong_order ;;
    hidden: yes
  }

  dimension: perished_product {
    type: number
    sql: ${TABLE}.perished_product ;;
    hidden: yes
  }

  dimension: missing_product {
    type: number
    sql: ${TABLE}.missing_product ;;
    hidden: yes
  }

  dimension: damaged {
    type: number
    sql: ${TABLE}.damaged ;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~   MEASURES     ~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: sum_orders_total {
    label: "# Total Orders"
    description: "The total number of orders"
    type: sum
    sql: ${orders_total} ;;
  }

  measure: sum_orders_with_issues {
    label: "# Orders with Issues"
    description: "The sum of orders that have issues (the sum of: Wrong Product, Wrong Order, Perished Product, Missing Product and Damaged Product)"
    type: sum
    sql: ${orders_with_issues} ;;
  }


  measure: sum_wrong_product {
    label: "# Wrong Prodcuts"
    description: "The number of orders, that have a customer complain with the main reason 'Wrong Product'."
    type: sum
    sql: ${wrong_product} ;;
  }

  measure: sum_wrong_order {
    label: "# Wrong Order"
    description: "The number of orders, that have a customer complain with the main reason 'Wrong Order'."
    type: sum
    sql: ${wrong_order} ;;
  }

  measure: sum_perished_product {
    label: "# Perished Product"
    description: "The number of orders, that have a customer complain with the main reason 'Perished Product'."
    type: sum
    sql: ${perished_product} ;;
  }

  measure: sum_missing_product {
    label: "# Missing Product"
    description: "The number of orders, that have a customer complain with the main reason 'Missing Product'."
    type: sum
    sql: ${missing_product} ;;
  }

  measure: sum_damaged {
    label: "# Damaged Product"
    description: "The number of orders, that have a customer complain with the main reason 'Damaged Product'."
    type: sum
    sql: ${damaged} ;;
  }


  measure: pct_orders_with_issues {
    label: "% Issue Rate"
    description: "The number of orders that have issues (the sum of: Wrong Product, Wrong Order, Perished Product, Missing Product and Damaged Product) divided by the total number of orders."
    type: number
    sql: (1.0 * ${sum_orders_with_issues}) / NULLIF(${sum_orders_total}, 0) ;;
    value_format_name: percent_1
  }


  measure: pct_orders_missing_product {
    label: "% Missing Product Issue Rate"
    description: "The number of orders with missing products divided by the total number of orders."
    type: number
    sql: (1.0 * ${sum_missing_product}) / NULLIF(${sum_orders_total}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_wrong_order {
    label: "% Wrong Order Issue Rate"
    description: "The number of orders with completely wrong baskets delivered divided by the total number of orders."
    type: number
    sql: (1.0 * ${sum_wrong_order}) / NULLIF(${sum_orders_total}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_perished_product {
    label: "% Perished Product Issue Rate"
    description: "The number of orders with perished products divided by the total number of orders."
    type: number
    sql: (1.0 * ${sum_perished_product}) / NULLIF(${sum_orders_total}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_wrong_product {
    label: "% Wrong Product Issue Rate"
    description: "The number of orders with wrong products divided by the total number of orders."
    type: number
    sql: (1.0 * ${sum_wrong_product}) / NULLIF(${sum_orders_total}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_damaged_product {
    label: "% Damaged Product Issue Rate"
    description: "The number of orders with damaged products divided by the total number of orders."
    type: number
    sql: (1.0 * ${sum_damaged}) / NULLIF(${sum_orders_total}, 0) ;;
    value_format_name: percent_1
  }



  set: detail {
    fields: [date, hub_code, orders_with_issues, orders_total]
  }
}
