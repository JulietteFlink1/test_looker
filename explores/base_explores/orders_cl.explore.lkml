include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: orders_cl {
  from: orders_ct
  extension: required # can not be used un-extended!
  view_name: orders_cl # needs to be set in order that the base_explore can be extended and referenced properly
  hidden: yes

  always_filter: {
    filters:  [
      hubs.country: "",
      hubs.hub_name: "",
      orders_cl.is_internal_order: "no",
      orders_cl.is_successful_order: "yes",
      orders_cl.created_date: "after 2021-01-25"
    ]
  }
  access_filter: {
    field: orders_cl.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  join: hubs {
    from: hubs_clean
    view_label: "* Hubs *"
    sql_on: ${orders_cl.country_iso}    = ${hubs.country_iso} AND
      ${orders_cl.warehouse_name} = ${hubs.hub_code_lowercase} ;;
    relationship: many_to_many
    type: left_outer

  }

    join: shyftplan_riders_pickers_hours {
      from: shyftplan_riders_pickers_hours_clean
      view_label: "* Shifts *"
      sql_on: ${orders_cl.created_date} = ${shyftplan_riders_pickers_hours.date} and
        ${hubs.hub_code} = ${shyftplan_riders_pickers_hours.hub_name};;
      relationship: many_to_one
      type: left_outer
    }

    #fields: [
    #  hubs.city,
    #  hubs.country_iso,
    #  hubs.country,
    #  hubs.hub_code,
    #  hubs.hub_code_lowercase,
    #  hubs.hub_name
    #]

}
