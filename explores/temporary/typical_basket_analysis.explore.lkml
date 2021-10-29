include: "/views/bigquery_tables/flink-data-dev/apriori_subcategory_3.view.lkml"

explore: typical_basket_analysis {
  hidden: no
  view_name:  apriori_subcategory_3
  label: "Subcategory Analysis"
  always_filter: {
    filters:  [
      granularity: "subcategory",
    ]
  }
}
