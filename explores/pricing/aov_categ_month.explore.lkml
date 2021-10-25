include: "/**/*.view"

explore: aov_per_category_month {
  group_label: "Pricing"
  label: "Category Value per Order - Month"
  hidden: yes



  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }
}
