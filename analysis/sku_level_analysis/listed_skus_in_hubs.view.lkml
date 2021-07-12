# If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"

view: listed_skus_in_hubs {
  derived_table: {
    explore_source: product_product {
      column: sku                                     { field: product_productvariant.sku }
      column: weeks_time_between_hub_launch_and_today { field: hubs.weeks_time_between_hub_launch_and_today }
      column: hub_code                                { field: hubs.hub_code }
      column: country_iso                             { field: hubs.country_iso }
      column: city                                    { field: hubs.city }
      column: product_name                            { field: product_product.name}
      column: sub_category                            { field: product_category.name }
      column: parent_category                         { field: parent_category.name }
      filters: {
        field: hubs.country
        value: ""
      }
      filters: {
        field: hubs.hub_name
        value: ""
      }
      filters: {
        field: product_product.is_published
        value: ""
      }
      filters: {
        field: order_orderline_facts.is_internal_order
        value: ""
      }
      filters: {
        field: order_orderline_facts.is_successful_order
        value: ""
      }
    }
  }
  dimension: sku {
    label: "* Product / SKU Data * SKU"
  }
  dimension: weeks_time_between_hub_launch_and_today {
    label: "* Hubs * Weeks Time Between Hub Launch and Today"
    value_format: "0"
    type: duration_week
  }
  dimension: hub_code {
    label: "Hub Code"
  }
  dimension: country_iso {
    label: "Country Iso"
  }
  dimension: city {
    label: "City"
  }
  dimension: product_name {
    label: "Product Name"
  }
  dimension: sub_category {
    label: "Sub-Category Name"
  }
  dimension: parent_category {
    label: "Parent Category Name"
  }
  measure: cnt_hub_code {
    label: "# Hub Codes"
    sql: ${TABLE}.hub_code ;;
    type: count_distinct
  }

  measure: cnt_skus {
    label: "# SKUs"
    sql: ${TABLE}.sku ;;
    type: count_distinct
  }
}
