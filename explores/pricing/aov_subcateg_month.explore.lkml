include: "/**/*.view"

explore: aov_per_subcategory_month {
  group_label: "Pricing"
  label: "Pricing Test"
  hidden: no



  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }
}
