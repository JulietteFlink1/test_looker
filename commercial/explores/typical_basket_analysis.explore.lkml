include: "/views/bigquery_tables/reporting_layer/retail/typical_basket_analysis.view.lkml"

explore: typical_basket_analysis {
  hidden: no
  view_name:  typical_basket_analysis
  label: "Subcategory Analysis"
  always_filter: {
    filters:  [
      granularity: "subcategory",
    ]
  }
}
