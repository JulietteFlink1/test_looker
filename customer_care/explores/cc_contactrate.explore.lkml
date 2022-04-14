include: "/customer_care/views/sql_derived_tables/cc_contactrate.view.lkml"

explore: cc_contactrate {
  hidden: no
  label: "Customer Service"
  view_label: "Conversations"
  group_label: "Consumer Product"

  join: cc_contactrate__tag_names {
    view_label: "Tag Names"
    sql: LEFT JOIN UNNEST(${cc_contactrate.tag_names}) as cs_conversations__tag_names ;;
    relationship: one_to_many
  }
}
