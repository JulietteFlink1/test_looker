include: "/views/bigquery_tables/reporting_layer/**/*.view"

explore: voucher_retention {
  hidden: yes

  access_filter: {
    field: voucher_retention.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: voucher_retention.city
    user_attribute: city
  }

}
