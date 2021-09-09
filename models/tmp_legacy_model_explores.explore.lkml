
include: "/**/*.view.lkml"


# STAY- NEW FILE
####### TYPEFORM ANSWERS EXPLORE #######
explore: answers {
  from: desired_products_survey
  label: "Desired Products"
  view_label: "Desired Products"
  group_label: "04) Survey Data"
  description: "Customer Survey on Desired Products"

}



explore: marketing_performance {
  label: "Marketing Performance"
  view_label: "Marketing Performance"
  group_label: "11) Marketing"
  description: "Marketing Performance: Installs, Orders, CAC, CPI"
}

########### CRM EXPLORE ###########


explore: braze_crm_data {
  label: "CRM Email Data (Braze)"
  view_label: "CRM Email Data"
  group_label: "11) Marketing"
  description: "Information on our CRM activities (using Braze as service provider)"
  always_filter: {
    filters:  [
      braze_crm_data.campaign_name: "",
      braze_crm_data.country: ""
    ]
  }
}

########### HUB NPS EXPLORE ###########


explore: nps_hub_team {
  hidden: yes
  label: "NPS (Hub Teams)"
  view_label: "NPS (Hub Teams)"
  group_label: "12) NPS (Internal Teams)"
  description: "NPS surveys towards internal teams"

  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

  join: hubs {
    sql_on:
    ${nps_hub_team.hub_code} = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

}


########### AD-HOC EXPLORE ###########

explore: products_mba {
  hidden: yes
  label: "Market basket analysis at a product level"
  view_label: "Product MBA"
  group_label: "15) Ad-Hoc"
  description: "Product basket analysis"

}

explore: categories_mba {
  hidden: yes
  label: "Market basket analysis at a category level"
  view_label: "Category MBA"
  group_label: "15) Ad-Hoc"
  description: "Product category basket analysis"

}

explore: user_order_facts_phone_number {
  hidden: yes
  label: "User Order Facts - Unique User ID"
  view_label: "User Order Facts - Unique User ID"
  group_label: "15) Ad-Hoc"
  description: "User Order facts with phone number + last name as unique identifier"

  join: hubs {
    view_label: "* Hubs *"
    sql_on: ${user_order_facts_phone_number.country_iso} = ${hubs.country_iso} AND
      ${user_order_facts_phone_number.hub_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
  }

}
