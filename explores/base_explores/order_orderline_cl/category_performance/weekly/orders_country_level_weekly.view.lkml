# If necessary, uncomment the line below to include explore_source.
#include: "order_orderline_cl.explore.lkml"

view: orders_country_level_weekly {

  derived_table: {

    explore_source: order_orderline_cl {

      column: country_iso                { field: orderline.country_iso }
      column: date                       { field: orderline.created_week }
      column: cnt_orders                 { field: orders_cl.cnt_orders }
      column: revenue_gross              { field: orderline.sum_item_price_gross}
      column: number_of_unique_customers { field: orders_cl.cnt_unique_customers }
      derived_column: unique_id {
        sql: concat(country_iso, date) ;;
      }
      derived_column: pop_orders {
        sql:  (cnt_orders - LEAD(cnt_orders) OVER (PARTITION BY country_iso ORDER BY date DESC))
            /
            nullif(LEAD(cnt_orders) OVER (PARTITION BY country_iso ORDER BY date DESC), 0) ;;
      }
      derived_column: pop_revenue {
        sql:  (revenue_gross - LEAD(revenue_gross) OVER (PARTITION BY country_iso ORDER BY date DESC))
            /
            nullif(LEAD(revenue_gross) OVER (PARTITION BY country_iso ORDER BY date DESC), 0) ;;
      }
    }
  }

  dimension: unique_id {
    hidden: yes
    primary_key: yes
    label: "Unique ID"
  }

  dimension: country_iso {
    hidden: yes
    label: "* PoP * Country Iso"
  }

  dimension: date {
    hidden: yes
    label: "Week"
    type: date_week
  }

  dimension: cnt_orders {
    hidden: yes
    label: "* Orders * # Orders"
    description: "Count of successful Orders"
    value_format: "0"
    type: number
  }

  dimension: revenue_gross {
    hidden: yes
    label: "Gross Revenue"
    description: "Sum of Gross Revenue"
    value_format_name: eur_0
    type: number
  }

  dimension: pop_orders {
    label: "PoP (Week) Orders Growth - Country"
    type: number
    value_format_name: percent_2
    hidden: yes
  }

  dimension: pop_revenue {
    label: "PoP (Week) Revenue Growth - Country"
    type: number
    value_format_name: percent_2
    hidden: yes
  }

  dimension: number_of_weekly_unique_customers {
    label: "# Unique Customers (per order-date & hub)"
    description: "Count of Unique Customers identified via their Customer UUID aggregated on a order-date and hub level"

    sql: ${TABLE}.number_of_unique_customers ;;
    value_format: "0"
    type: number
    hidden: no
  }

  dimension: number_of_weekly_orders {
    label: "# Orders (per order-date & hub)"
    description: "Count of Orders on a date and hub level"

    sql: ${TABLE}.cnt_orders ;;
    value_format_name: decimal_0
    type: number
    hidden: no
  }

  ############### Measures

  measure: pop_orders_max {
    type: average
    sql: ${pop_orders} ;;
    label: "PoP Orders - Country"
    group_label: "Weekly"
    value_format_name: percent_2
  }

  measure: pop_revenue_max {
    type: average
    sql: ${pop_revenue} ;;
    label: "PoP Revenue - Country"
    group_label: "Weekly"
    value_format_name: percent_2
  }

  measure: sum_number_of_orders {
    label: "# Orders (per order-date & hub)"
    description: "Count of Orders on a date and hub level"

    type: sum
    sql: ${number_of_weekly_orders} ;;
    value_format_name: decimal_0

    hidden: no
  }

  measure: sum_number_of_unique_customers {
    label: "# Unique Customers (per order-date & hub)"
    description: "Count of Unique Customers identified via their Customer UUID aggregated on a order-date and hub level"
    value_format: "0"
    type: sum
    sql: ${number_of_weekly_unique_customers} ;;
    hidden: no
  }

}
