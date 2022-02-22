include: "/customer_care/cc_conversations.view.lkml"
include: "/customer_care/cc_orders_hourly.view.lkml"
include: "/customer_care/cc_conversation_agents.view.lkml"


explore: cc_conversations {
  from: cc_conversations
  view_name: cc_conversations
  group_label: "Customer Care"
  view_label: "* Intercom Conversations *"
  label: "Conversations & Agents"
  description: "This explore provides information on all Intercom chats"

  hidden: no

  access_filter: {
    field: cc_conversations.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      cc_conversations.country_iso: "",
      cc_conversations.conversation_created_date: "last 60 days"
    ]
  }

  join: cc_orders_hourly {
    from: cc_orders_hourly
    view_label: "* Orders *"
    sql_on: timestamp_trunc(cast(${cc_conversations.conversation_created_time} as timestamp),hour) = cast(${cc_orders_hourly.order_timestamp_time} as timestamp)
    and ${cc_conversations.country_iso} = ${cc_orders_hourly.country_iso};;
    relationship: many_to_one
    type: left_outer

  }

  join: cc_conversation_agents {
    from: cc_conversation_agents
    view_label: "* Agents *"
    sql_on:${cc_conversation_agents.conversation_id} = ${cc_conversations.conversation_uuid} as timestamp)
      and ${cc_conversations.country_iso} = ${cc_conversation_agents.country_iso};;
    relationship: one_to_many
    type: left_outer

  }
  }
