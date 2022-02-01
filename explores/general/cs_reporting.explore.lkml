include: "/views/sql_derived_tables/cs_reporting.view.lkml"

explore: cs_reporting {
  hidden: no
  label: "Customer Service"
  view_label: "Conversations"
  group_label: "Consumer Product"

  join: cs_reporting__tag_names {
    view_label: "Tag Names"
    sql: LEFT JOIN UNNEST(${cs_reporting.tag_names}) as cs_conversations__tag_names ;;
    relationship: one_to_many
  }
}
