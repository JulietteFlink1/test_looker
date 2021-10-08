include: "/**/*.view"

explore: basket_composition_sku_date {
  group_label: "Pricing"
  label: "Basket Composition Date SKU"
  #hidden: yes

  always_filter: {
    filters:
    [
      basket_composition_sku_date.country_iso: "Germany",
      basket_composition_sku_date.product_substitute_group: "%Bananen%"

    ]
  }

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }
}
