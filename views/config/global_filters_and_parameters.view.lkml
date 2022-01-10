 view: global_filters_and_parameters {
  derived_table: {
    sql: select TRUE as generic_join_dim;;
  }

  view_label: "Generic"


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
    group_label: ">> Database Filter"
    description: "Limits the data for the big tables, that are used in this explore."
  }


  filter: generic_current_period_filter {
    type: date
    datatype: date
    hidden: no
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
    hidden: no
    default_value: "14 days ago for 7 days"
    label: "Generic Previous Period Filter"
    # view_label: "Database Date Filter 📅"
    group_label: ">> Period-over-Period Filter"
    description: "This filter is independent of any database field. You can use it in table calcualtions, to limit a metric to the fitlered timeframe"
    convert_tz: no
  }

  dimension: current_period_start {
    type: date
    datatype: date
    sql: {% date_start generic_current_period_filter %};;
    hidden: no
  }

  dimension: current_period_end {
    type: date
    datatype: date
    sql: {% date_end generic_current_period_filter %};;
    hidden: no
  }

  dimension: previous_period_start {
    type: date
    datatype: date
    sql: {% date_start generic_previous_period_filter %};;
    hidden: no
  }

  dimension: previous_period_end {
    type: date
    datatype: date
    sql: {% date_end generic_previous_period_filter %};;
    hidden: no
  }


}
