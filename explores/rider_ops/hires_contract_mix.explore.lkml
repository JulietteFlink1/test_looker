include: "/views/projects/rider_ops/hires_contract_mix.view"

explore: hires_contract_mix {
  hidden: yes
  label: "Hires Contract Mix"
  view_label: "Hires Contract Mix"
  description: "Hires Contract Mix"
  group_label: "Rider Ops"

  access_filter: {
    field: hires_contract_mix.country
    user_attribute: country_iso
  }

  access_filter: {
    field: hires_contract_mix.city
    user_attribute: city
  }

}
