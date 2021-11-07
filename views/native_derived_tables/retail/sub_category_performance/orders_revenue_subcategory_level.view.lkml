# If necessary, uncomment the line below to include explore_source.
include: "/explores/base_explores/order_orderline_cl.explore.lkml"

view: orders_revenue_subcategory_level {
  derived_table: {
    explore_source: order_orderline_cl {
      column: country_iso { field: orderline.country_iso }
      column: date { field: orderline.created_week }
      column: revenue_gross { field: orderline.sum_revenue_gross}
      column: subcategory { field: orderline.product_subcategory_erp}
      derived_column: lead_revenue_gross {
        sql: LEAD(revenue_gross)
          OVER (PARTITION BY country_iso, subcategory ORDER BY date DESC) ;;
      }
      derived_column: pop_revenue {
        sql:  (revenue_gross - LEAD(revenue_gross) OVER (PARTITION BY country_iso, subcategory ORDER BY date DESC))
            /
            nullif(LEAD(revenue_gross) OVER (PARTITION BY country_iso, subcategory ORDER BY date DESC), 0) ;;
      }
    }
  }

  dimension: country_iso {
    hidden: no
    label: "* Orders * Country Iso"
  }

  dimension: date {
    hidden: no
    label: "Week"
    type: date_week
  }

  dimension: revenue_gross {
    hidden: no
    label: "Gross Revenue"
    description: "Sum of Gross Revenue"
    value_format_name: eur_0
    type: number
  }

  dimension: subcategory {
    hidden: no
    label: "Subcategory"
  }

  dimension: lead_revenue_gross {
    hidden: no
    value_format_name: eur_0
    type: number
  }

  dimension: pop_revenue {
    label: "PoP Gross Revenue"
    type: number
    value_format_name: percent_2
  }
}
