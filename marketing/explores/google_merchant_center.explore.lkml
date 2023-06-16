include: "/marketing/views/bigquery_curated/google_merchant_center.view.lkml"
include: "/core/views/bq_curated/products.view.lkml"

# Creator: Andreas Stueber
# When: 2023-06-08
# Purpose: Give the performnance marketing team access to the Google Merchant Cetner data in Looker


# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: google_merchant_center {
  hidden: no

  group_label: "Marketing"
  label: "Google Merchant Center"
  description: "This explore provides information on data exported from Google Merchant Center"


  access_filter: {
    field: google_merchant_center.country_iso
    user_attribute: country_iso
  }

  join: products {
    view_label: "Product Data (Flink)"
    relationship: many_to_one
    type: left_outer
    sql_on:
        ${google_merchant_center.sku}         = ${products.product_sku} and
        ${google_merchant_center.country_iso} = ${products.country_iso}
    ;;
  }


  # not exposing historical data for npw:
  # join: google_merchant_center__history {
  #   view_label: "Google Merchant Center: History"
  #   sql: LEFT JOIN UNNEST(${google_merchant_center.history}) as google_merchant_center__history ;;
  #   relationship: one_to_many
  # }
}
