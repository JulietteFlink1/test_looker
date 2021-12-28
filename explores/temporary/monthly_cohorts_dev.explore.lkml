include: "/views/bigquery_tables/flink-data-dev/orders_cleaned_dev.view.lkml"
include: "/views/bigquery_tables/flink-data-dev/customer_metrics_cleaned_dev.view.lkml"
# include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
explore: orders_cleaned_dev {

  join: customer_metrics_cleaned_dev {
    from: customer_metrics_cleaned_dev
    sql_on: ${orders_cleaned_dev.customer_id_mapped} =  ${customer_metrics_cleaned_dev.customer_id_mapped};;
    type: left_outer
    relationship: many_to_one
  }

}
