view: supply_chain_config {

  parameter: filter_terminated_hubs {
    label: "Filter terminated hubs"
    type: unquoted
    allowed_value: {
      label: "active"
      value: "active"
    }
    allowed_value: {
      label: "inactive"
      value: "inactive"
    }
    default_value: "active"

  }

}
