# If necessary, uncomment the line below to include explore_source.
include: "/explores/base_explores/order_orderline_cl.explore.lkml"

view: orders_revenue_category_level {
  derived_table: {
    explore_source: order_orderline_cl_retail_customized {
      column: country_iso { field: orderline.country_iso }
      column: date { field: orderline.created_week }
      column: revenue_gross { field: orderline.sum_revenue_gross}
      column: category { field: orderline.product_category_erp}
      derived_column: unique_id {
        sql: concat(country_iso, date, ifnull(category, '')) ;;
      }
      derived_column: pop_revenue {
        sql:  (revenue_gross - LEAD(revenue_gross) OVER (PARTITION BY country_iso, category ORDER BY date DESC))
            /
            nullif(LEAD(revenue_gross) OVER (PARTITION BY country_iso, category ORDER BY date DESC), 0) ;;
      }
    }
  }

  dimension: unique_id {
    hidden: yes
    primary_key: yes
    type: string
  }

  dimension: country_iso {
    hidden: yes
    label: "* Orders * Country Iso"
  }

  dimension: date {
    hidden: yes
    label: "Week"
    type: date_week
  }

  dimension: revenue_gross {
    hidden: yes
    label: "Gross Revenue"
    description: "Sum of Gross Revenue"
    value_format_name: eur_0
    type: number
  }

  dimension: category {
    hidden: yes
    label: "Category"
  }

  dimension: pop_revenue {
    label: "PoP (Week) Revenue Growth - Category"
    type: number
    value_format_name: percent_2
  }

}
