include: "/views/**/*.view"
include: "/**/*.view"



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~     Hourly Aggregation     ~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
explore: hourly_historical_stock_levels {
  group_label: "16) Retail Test"

  always_filter: {
    filters: [
      hourly_historical_stock_levels.tracking_datetime_date: "2 days"
    ]
  }

  join: hubs {
    view_label: "* Hubs *"
    type: left_outer
    relationship: many_to_one
    sql_on: ${hubs.hub_code_lowercase} = ${hourly_historical_stock_levels.hub_code} ;;
  }
  join: product_productvariant {
    sql_on: ${hourly_historical_stock_levels.country_iso} = ${product_productvariant.country_iso} AND
            ${hourly_historical_stock_levels.sku}         = ${product_productvariant.sku} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: product_product {
    sql_on: ${product_productvariant.country_iso} = ${product_product.country_iso} AND
      ${product_productvariant.product_id} = ${product_product.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: product_attribute_facts {
    sql_on: ${product_product.country_iso} = ${product_attribute_facts.country_iso} AND
      ${product_product.id} = ${product_attribute_facts.id} ;;
    relationship: one_to_one
    type: left_outer
    fields: [product_attribute_facts.noos_group,
      substitute_group,
      product_attribute_facts.leading_product
    ]
  }

  join: product_category {
    sql_on: ${product_category.country_iso} = ${product_product.country_iso} AND
      ${product_category.id} = ${product_product.category_id} ;;
    relationship: one_to_one
    type: left_outer
    fields: [product_category.description, product_category.name]
  }

  join: product_producttype {
    sql_on:${product_product.country_iso} = ${product_producttype.country_iso} AND
      ${product_product.product_type_id} = ${product_producttype.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: parent_category {
    view_label: "* Product / SKU Parent Category Data *"
    from: product_category
    sql_on: ${product_category.country_iso} = ${parent_category.country_iso} AND
      ${product_category.parent_id} = ${parent_category.id} ;;
    relationship: one_to_one
    type: left_outer
    fields: [parent_category.name, parent_category.description]
  }

}
