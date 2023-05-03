include: "/commercial/views/bigquery_curated/product_categories.view.lkml"

explore:  product_categories{

  label: "Product Categories (commercetools)"
  group_label: "Commercial"
  description: "This Explore exposes category information from commercetools"
  from: product_categories

  access_filter: {
    field: product_categories.country_iso
    user_attribute: country_iso
  }
}
