# If necessary, uncomment the line below to include explore_source.
# include: "retail_kpis.explore.lkml"

view: shelf_planning_top_x_per_subcat {
  derived_table: {
    explore_source: shelf_planning {
      column: sku {}
      column: product_category_name { field: product_facts.product_category_name }
      column: avg_main_kpis {}
      derived_column: rank_per_subcat {
        sql: RANK() OVER (PARTITION BY product_category_name ORDER BY avg_main_kpis DESC) ;;
      }
      bind_all_filters: yes
    }
  }
  dimension: sku {
    primary_key: yes
    hidden: yes
  }
  dimension: product_category_name {}
  dimension: avg_main_kpis {
    label: "Shelf Planning 3) AVG over 1) and 2)"
    value_format: "#,##0.0"
    type: number
  }

  dimension: rank_per_subcat {
    type: number
    sql: ${TABLE}.rank_per_subcat ;;
  }
}
