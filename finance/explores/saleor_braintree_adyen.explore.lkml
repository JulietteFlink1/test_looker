include: "/**/braintree_raw.view.lkml"
include: "/**/braintree_bq.view.lkml"

explore: saleor_bt_adyen {
  from: braintree_bq
  hidden: no

  group_label: "Finance"
  label: "Saleor BT/Adyen"
  description: "Saleor Orders linked to Braintree and Adyen transactions"

}
