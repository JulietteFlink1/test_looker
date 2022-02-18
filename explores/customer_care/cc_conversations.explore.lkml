include: "/views/bigquery_tables/curated_layer/customer_care/cc_conversations.view.lkml"
include: "/views/bigquery_tables/curated_layer/orders.view.lkml"


explore: cc_conversations {
  from: cc_conversations
  view_name: cc_conversations
  group_label: "Customer Care"
  view_label: "* Intercom Conversations *"
  label: "Conversations & Agents"
  description: "This explore provides information on all Intercom chats"

  hidden: yes


  join: orders {
    from: orders
    sql_on: ${cc_conversations.conversation_created_date} = ${orders.order_date}
    and ${cc_conversations.country_iso} = ${orders.country_iso};;
    fields: [orders.country_iso,orders.cnt_orders,orders.is_successful_order]
    relationship: many_to_many

  }
  }
