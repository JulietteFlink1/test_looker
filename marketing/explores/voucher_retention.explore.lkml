include: "/marketing/views/bigquery_reporting/**/*.view"

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
