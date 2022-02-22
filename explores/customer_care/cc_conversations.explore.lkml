include: "/views/bigquery_tables/curated_layer/customer_care/cc_conversations.view.lkml"
include: "/views/bigquery_tables/reporting_layer/customer_care/cc_orders_hourly.view.lkml"


explore: cc_conversations {
  from: cc_conversations
  view_name: cc_conversations
  group_label: "Customer Care"
  view_label: "* Intercom Conversations *"
  label: "Conversations & Agents"
  description: "This explore provides information on all Intercom chats"

  hidden: yes


  join: cc_orders_hourly {
    from: cc_orders_hourly
    view_label: "* Orders *"
    sql_on: timestamp_trunc(cast(${cc_conversations.conversation_created_time} as timestamp),hour) = cast(${cc_orders_hourly.order_timestamp_time} as timestamp)
    and ${cc_conversations.country_iso} = ${cc_orders_hourly.country_iso};;
    relationship: many_to_one

  }
  }
