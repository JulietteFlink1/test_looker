include: "/views/**/*.view"

explore:  getir_products {
  hidden: no
  label: "Getir Products"
  view_label: "Getir Products"
  group_label: "Competitive Intel"
  description: "Competitive Intelligence Data"

  join: getir_categories {
    view_label: "* Category Information *"
    from: getir_categories
    sql_on: ${getir_categories.hub_id} = ${getir_products.hub_id}
            AND ${getir_categories.subcategory_id} = ${getir_categories.subcategory_id}
            and ${getir_categories.parent_category_id} = ${getir_products.parent_category_id};;
    relationship: many_to_one
    type:  left_outer
  }

  join: getir_hubs {
    from: getir_hubs
    view_label: "* Hub Information *"
    sql_on: ${getir_hubs.hub_id} = ${getir_products.hub_id} ;;
    relationship: many_to_one
    type:  left_outer
  }
  }
