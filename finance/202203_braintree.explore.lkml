include: "/**/202203_braintree_data.view.lkml"

explore: braintree {
  from: braintree_data_202203
  hidden: no

  group_label: "Finance"
  label: "Braintree"
  description: "PSP Braintree Data"

  view_label: "* Braintree *"


  }
