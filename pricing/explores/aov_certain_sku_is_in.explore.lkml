include: "/**/*.view"

explore: aov_certain_sku_is_in {
  group_label: "Pricing"
  label: "SKU basket Composition"
  hidden: no



  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }
}
