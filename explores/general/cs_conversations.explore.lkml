include: "/views/bigquery_tables/curated_layer/cs_conversations.view.lkml"
include: "/views/bigquery_tables/curated_layer/orders.view.lkml"

# tag_names is a repeated record. join to get all the fully nested relationships from this view
# see https://help.looker.com/hc/en-us/articles/360023638874-Nested-Data-in-BigQuery-Repeated-Records-
explore: cs_conversations {
  hidden: no
  label: "Customer Service - Conversations"
  view_label: "Customer Service - Conversations"
  group_label: "Consumer Product"

  join: cs_conversations__tag_names {
    view_label: "Tag Names"
    sql: LEFT JOIN UNNEST(${cs_conversations.tag_names}) as cs_conversations__tag_names ;;
    relationship: one_to_many
  }

  join: orders {
    view_label: "Orders"
    type: full_outer
    relationship: many_to_many
    sql_on: ${cs_conversations.conversation_created_timestamp_date}=${orders.created_date};;
    fields: [cnt_orders, created_date, is_successful_order]
  }
}
