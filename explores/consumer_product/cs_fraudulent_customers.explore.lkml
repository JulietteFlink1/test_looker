include: "/views/bigquery_tables/curated_layer/*.view"

include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: cs_fraudulent_customers_email {
  extends: [orders_cl]
  label: "CS Fraudulent Customers - Email List"
  view_label: "* Orders *"
  group_label: "07) Customer Service"
  hidden: no


  join: cs_post_delivery_issues {
    view_label: "* Post Delivery Issues on Order-Level *"
    sql_on: ${orders_cl.country_iso} = ${cs_post_delivery_issues.country_iso} AND
      ${cs_post_delivery_issues.order_nr_} = ${orders_cl.order_number};;
    relationship: one_to_many
    type: left_outer
  }

  join: products {
    view_label: "* Product Information *"
    sql_on: REGEXP_REPLACE(lower(${products.product_name}),r'\W','') = REGEXP_REPLACE(lower(REGEXP_REPLACE(${cs_post_delivery_issues.ordered_product},"[^<][NDF][LER]-[NDF][LER][^<]",'')),r'\W','')
    and lower(${products.country_iso}) = lower(${cs_post_delivery_issues.country_iso}) ;;
    relationship: many_to_one
    type: left_outer
  }

  join: map_customer_email_id {
    view_label: "* Customer ID *"
    sql_on: ${map_customer_email_id.customer_email} = ${orders_cl.user_email};;
    relationship: many_to_one
    type:  left_outer
  }
  }
