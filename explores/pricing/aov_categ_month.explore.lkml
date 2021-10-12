include: "/**/*.view"

explore: aov_per_category_month {
  group_label: "Pricing"
  label: "Category Value per Order - Month"
  hidden: yes

  always_filter: {
    filters:  [
      aov_per_category_month.country_iso: "Germany",
      aov_per_category_month.category: "-EMPTY,-%Event%"

    ]
  }

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }
}
