include: "/**/*.view"

explore: aov_per_subcategory_month {
  group_label: "Pricing"
  label: "Pricing Test"
  hidden: no

  always_filter: {
    filters:  [
      aov_per_subcategory_month.country_iso: "Germany",
      aov_per_subcategory_month.category: "-EMPTY,-%Event%"

    ]
  }

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }
}
