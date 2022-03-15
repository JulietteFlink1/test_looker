include: "/**/cc_contacts.view.lkml"
include: "/customer_care/cc_orders_hourly.view.lkml"
include: "/**/cc_conversation_agents.view.lkml"


explore: cc_contacts {
  from: cc_contacts
  view_name: cc_contacts
  group_label: "Customer Care"
  view_label: "* Intercom Conversations *"
  label: "Contacts & Agents"
  description: "This explore provides information on all Intercom chats"

  hidden: yes

  access_filter: {
    field: cc_contacts.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      cc_contacts.country_iso: "",
      cc_contacts.conversation_created_date: "last 60 days"
    ]
  }


  join: cc_conversation_agents {
    from: cc_conversation_agents
    view_label: "* Agents *"
    sql_on:${cc_conversation_agents.conversation_id} = ${cc_contacts.conversation_uuid}
      and ${cc_conversation_agents.country_iso} = ${cc_contacts.country_iso};;
    relationship: one_to_many
    type: left_outer

  }
}
