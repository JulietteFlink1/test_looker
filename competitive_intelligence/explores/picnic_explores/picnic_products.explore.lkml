include: "/competitive_intelligence/views/bigquery_curated/picnic_products.view.lkml"
include: "/competitive_intelligence/views/bigquery_curated/picnic_categories.view.lkml"

explore:  picnic_products {
  hidden: yes
  label: "Picnic Products"
  view_label: "Picnic Products"
  group_label: "Competitive Intelligence"
  description: "Competitive Intelligence Data"

  join: category_l0 {
    view_label: "Category L0"
    from: picnic_categories
    sql_on: ${category_l0.category_id} = ${picnic_products.category_l0};;
    relationship: many_to_one
    type: left_outer
  }

  join: category_l1 {
    view_label: "Category L1"
    from: picnic_categories
    sql_on: ${category_l1.category_id} = ${picnic_products.category_l1};;
    relationship: many_to_one
    type: left_outer
  }

  join: category_l2 {
    view_label: "Category L2"
    from: picnic_categories
    sql_on: ${category_l2.category_id} = ${picnic_products.category_l1};;
    relationship: many_to_one
    type: left_outer
  }


}
