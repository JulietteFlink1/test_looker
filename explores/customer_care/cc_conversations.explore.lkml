include: "/views/bigquery_tables/curated_layer/customer_care/cc_conversations.view.lkml"


explore: cc_conversations {
  from: cc_conversations
  view_name: cc_conversations
  group_label: "Customer Care"
  view_label: "* Intercom Conversations *"
  label: "Conversations & Agents"
  description: "This explore provides information on all Intercom chats"

  hidden: yes
  }
