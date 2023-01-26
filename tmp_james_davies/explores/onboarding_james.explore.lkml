##Owner: James Davies
##Description: This explore provides an analysis for the table built as part of the onboarding programme.

include: "/**/james_onboarding_task.view.lkml"

explore: james_onboarding_task {
  group_label: " Onboarding Task "
  view_label: " *30 Day Order and Rider Ouput* "
  label: "30 Day Order and Rider Ouput"
  description: "Order and Rider ouput from the last 30 days for successful orders. KPIs include # Orders,
  # Riders, # Rider Hours Worked, Avg Fulfullment Time, Avg Items per Basket"
  hidden: no

  always_filter: {
    filters: [
      order_date: "last 30 days",
      hub_code: "",
      country_iso: ""
    ]
  }

  access_filter: {
    field: james_onboarding_task.country_iso
    user_attribute: country_iso
  }



}
