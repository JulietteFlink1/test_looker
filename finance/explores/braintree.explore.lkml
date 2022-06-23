include: "/**/braintree_raw.view.lkml"
include: "/**/braintree_bq.view.lkml"

explore: braintree {
  from: braintree_data
  hidden: no

  group_label: "Finance"
  label: "Braintree"
  description: "PSP Braintree Data"

  view_label: "* Braintree *"

  }
