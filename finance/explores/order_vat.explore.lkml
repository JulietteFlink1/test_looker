include: "/*/**/vat_order.view.lkml"

explore: vat_order {
  hidden: no
  view_name:  vat_order
  label: "VAT on Order Level"
  view_label: "VAT on Order Level"
  group_label: "Finance"
  description: "Provides VAT data on order level"

  access_filter: {
    field: vat_order.country_iso
    user_attribute: country_iso
  }


  always_filter: {
    filters: [
      vat_order.order_date: "",
      vat_order.is_successful_order: "yes",
      vat_order.country_iso: ""
    ]
  }
}
