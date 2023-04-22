include: "/commercial/views/bigquery_curated/product_categories.view.lkml"

explore:  product_categories{

  label: "Product Categories (CommererceTools)"
  group_label: "Commercial"
  description: "This Explore exposes category information from CommerceTools"
  from: product_categories
}
