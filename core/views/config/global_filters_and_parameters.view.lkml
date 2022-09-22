 view: global_filters_and_parameters {
  derived_table: {
    sql: select TRUE as generic_join_dim;;
  }

  view_label: "Generic"

  parameter: timeframe_picker {

    label: "Date Granularity"
    group_label: ">> Settings"

    type: unquoted
    allowed_value: { value: "Date" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }

    default_value: "Date"

  }

  parameter: show_info {
    # this paramter does:
    #  1. replace the SKU with a leading SKU name
    #  2. reduces the data in inventory tables to report only leading SKU level per group

    # this parameter is defined at the products_hub_assignment level, as this view is the base of the Supply Chain explore

    label:       "Show KPI details"
    group_label: ">> Settings"
    description: "Chose yes, if you want to see more details"

    type: unquoted

    allowed_value: {
      label: "yes"
      value: "yes"
    }

    allowed_value: {
      label: "no"
      value: "no"
    }

    default_value: "no"
  }


  dimension: generic_join_dim {
    type: yesno
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.generic_join_dim ;;
  }

  filter: datasource_filter {
    type: date
    datatype: date
    default_value: "last 30 days"
    label: "Timeframe"
    group_label: ">> Settings"
    description: "Limits the data for the big tables, that are used in this explore."
  }


  filter: generic_current_period_filter {
    type: date
    datatype: date
    hidden: yes
    default_value: "7 days ago for 7 days"
    label: "Generic Current Period Filter"
    # view_label: "Database Date Filter 📅"
    group_label: ">> Period-over-Period Filter"
    description: "This filter is independent of any database field. You can use it in table calcualtions, to limit a metric to the fitlered timeframe"
    convert_tz: yes
  }

  filter: generic_previous_period_filter {
    type: date
    datatype: date
    hidden: yes
    default_value: "14 days ago for 7 days"
    label: "Generic Previous Period Filter"
    # view_label: "Database Date Filter 📅"
    group_label: ">> Period-over-Period Filter"
    description: "This filter is independent of any database field. You can use it in table calcualtions, to limit a metric to the fitlered timeframe"
    convert_tz: yes
  }

  dimension: current_period_start {
    type: date
    datatype: date
    sql: {% date_start generic_current_period_filter %};;
    hidden: yes
  }

  dimension: current_period_end {
    type: date
    datatype: date
    sql: {% date_end generic_current_period_filter %};;
    hidden: yes
  }

  dimension: previous_period_start {
    type: date
    datatype: date
    sql: {% date_start generic_previous_period_filter %};;
    hidden: yes
  }

  dimension: previous_period_end {
    type: date
    datatype: date
    sql: {% date_end generic_previous_period_filter %};;
    hidden: yes
  }


}
