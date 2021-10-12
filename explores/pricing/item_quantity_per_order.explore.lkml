include: "/**/*.view"

explore: item_quantity_per_order {
  group_label: "Pricing"
  label: "Item Quantity per Order"
  #hidden: yes

  always_filter: {
    filters:  [
      item_quantity_per_order.country_iso: "Germany",
      item_quantity_per_order.subcategory: "%Bier%"

    ]
  }

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }
}
