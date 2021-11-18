include: "/views/native_derived_tables/retail/category_performance/weekly/orders_country_level.view"
include: "/views/native_derived_tables/retail/category_performance/weekly/orders_revenue_subcategory_level.view"

explore: orders_revenue_subcategory_level {
  hidden: no
  label: "Subcategory Performance Tracker"
  group_label: "Retail"
  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  join: orders_country_level {
    sql_on: ${orders_country_level.country_iso} = ${orders_revenue_subcategory_level.country_iso}
            and ${orders_country_level.date} = ${orders_revenue_subcategory_level.date};;
    relationship: many_to_one
  }

}
