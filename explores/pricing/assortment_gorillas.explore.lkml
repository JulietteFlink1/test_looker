include: "/**/*.view"

explore: gorillas_assortment_t1 {
  from: gorillas_v1_items
  group_label: "17) Pricing"
  hidden: yes
  always_filter: {
    filters:  [
      gorillas_assortment_t1.time_scraped_date: "after 2021-06-18"
    ]
  }
}

explore: gorillas_assortment_t2 {
  from: gorillas_v1_items
  group_label: "17) Pricing"
  hidden: yes
  always_filter: {
    filters:  [
      gorillas_assortment_t1.time_scraped_date: "after 2021-06-18"
    ]
  }

  join: gorillas_assortment_t1 {
    from: gorillas_v1_items
    sql_on:  ${gorillas_assortment_t1.hub_code} = ${gorillas_assortment_t2.hub_code} AND
          ${gorillas_assortment_t1.id} = ${gorillas_assortment_t2.id} AND --match by id instead
          DATE_ADD(${gorillas_assortment_t1.time_scraped_date}, INTERVAL 1 DAY) = ${gorillas_assortment_t2.time_scraped_date};;
    relationship: one_to_one
    type:  left_outer
  }

  join: gorillas_hubs_t3 {
    from: gorillas_v1_hubs_master
    sql_on: ${gorillas_hubs_t3.id} = ${gorillas_assortment_t2.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: gorillas_v1_item_hub_collection_group_allocation {
    sql_on: ${gorillas_v1_item_hub_collection_group_allocation.item_id} = ${gorillas_assortment_t2.id}
      AND ${gorillas_v1_item_hub_collection_group_allocation.hub_id} = ${gorillas_assortment_t2.hub_code};;
    relationship: one_to_one
    type: left_outer
  }

  join: gorillas_category_mapping {
    sql_on: ${gorillas_category_mapping.gorillas_collection_id} = ${gorillas_v1_item_hub_collection_group_allocation.collection_id}
      AND ${gorillas_category_mapping.gorillas_group_id} = ${gorillas_v1_item_hub_collection_group_allocation.group_id};;
    relationship: one_to_one
    type: left_outer
  }
}
