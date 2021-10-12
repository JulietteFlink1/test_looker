include: "/**/*.view"

explore: sku_performance_coefficiant_spc {
  hidden: yes

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      sku_performance_coefficiant_spc.country_iso: ""
    ]
  }
}
