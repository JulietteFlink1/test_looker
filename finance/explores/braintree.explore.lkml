include: "/**/braintree_raw.view.lkml"
include: "/**/braintree_bq.view.lkml"

explore: braintree {
  from: braintree_data
  hidden: no

  group_label: "Finance"
  label: "Braintree"
  description: "PSP Braintree Data"

  view_label: "* Braintree *"

  join: braintree_bq {
    view_label: "* Saleor & Braintree Mapping *"
    sql_on: ${braintree.transaction_id} = ${braintree_bq.braintree_id} ;;
    type: left_outer
    relationship: one_to_many
  }

  }
