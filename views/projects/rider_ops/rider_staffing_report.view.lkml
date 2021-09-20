view: rider_staffing_report {
  sql_table_name: `flink-data-prod.reporting.rider_staffing_report`
    ;;

  dimension: abs_error {
    type: number
    sql: ${TABLE}.abs_error ;;
  }

  dimension: actual_riders_needed {
    hidden: yes
    type: number
    sql: ${TABLE}.actual_riders_needed ;;
  }

  dimension: start_time {
    group_label: " * Dates * "
    label: "Start time"
    type: string
    sql:cast(extract(time from ${TABLE}.block_starts_at AT TIME ZONE "Europe/Berlin") as string) ;;
  }

  dimension_group: block_ends_at {
    group_label: " * Dates * "
    type: time
    timeframes: [
      time
    ]
    sql: ${TABLE}.block_ends_at ;;
  }

  dimension_group: block_starts_at {
    group_label: " * Dates * "
    type: time
    timeframes: [
      time
    ]
    sql: ${TABLE}.block_starts_at ;;
  }

  dimension: block_starts_pivot {
    group_label: " * Dates * "
    label: "Block"
    type: date_time
    sql: TIMESTAMP(concat("2021-01-01", " ", extract(hour from ${TABLE}.block_starts_at AT TIME ZONE "Europe/Berlin"),
      ":",extract(minute from ${TABLE}.block_starts_at), ":","00"), "Europe/Berlin") ;;
    html: {{ rendered_value | date: "%R" }};;
  }

  dimension: block_ends_pivot {
    group_label: " * Dates * "
    label: "Block ends at pivot"
    type: date_time
    sql: TIMESTAMP(concat("2021-01-01", " ", extract(hour from ${TABLE}.block_ends_at AT TIME ZONE "Europe/Berlin"),
      ":",extract(minute from ${TABLE}.block_ends_at), ":","00"), "Europe/Berlin") ;;
    html: {{ rendered_value | date: "%R" }};;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: date {
    group_label: " * Dates * "
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: filled_ext_picker_hours {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.filled_ext_picker_hours, 0) ;;
  }

  dimension: filled_ext_pickers {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.filled_ext_pickers, 0) ;;
  }

  dimension: filled_ext_rider_hours {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.filled_ext_rider_hours, 0) ;;
  }

  dimension: filled_ext_riders {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.filled_ext_riders, 0) ;;
  }

  dimension: filled_no_show_picker_hours {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.filled_no_show_picker_hours) ;;
  }

  dimension: filled_no_show_pickers {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.filled_no_show_pickers, 0) ;;
  }

  dimension: filled_no_show_rider_hours {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.filled_no_show_rider_hours, 0) ;;
  }

  dimension: filled_no_show_riders {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.filled_no_show_riders, 0) ;;
  }

  dimension: filled_picker_hours {
    type: number
    hidden: yes
    sql: coalesce(${TABLE}.filled_picker_hours, 0) ;;
  }

  dimension: filled_pickers {
    type: number
    hidden: yes
    sql: coalesce(${TABLE}.filled_pickers, 0) ;;
  }

  dimension: filled_rider_hours {
    type: number
    hidden: yes
    sql: coalesce(${TABLE}.filled_rider_hours, 0) ;;
  }

  dimension: filled_riders {
    type: number
    hidden: yes
    sql: coalesce(${TABLE}.filled_riders, 0) ;;
  }

  dimension: forecast_riders_needed {
    hidden: yes
    type: number
    sql: ${TABLE}.forecast_riders_needed ;;
  }

  dimension: hub_name {
    hidden: yes
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: is_open {
    type: number
    sql: ${TABLE}.is_open ;;
  }

  dimension: unique_id {
    type: string
    sql: concat(${hub_name}, ${block_starts_at_time}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: null_filter {
    hidden: no
    type: yesno
    sql: CASE when ${TABLE}.predicted_orders is null then True else False end ;;
  }

  dimension_group: local_end_datetime {
    group_label: " * Dates * "
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_end_datetime ;;
  }

  dimension_group: local_order {
    group_label: " * Dates * "
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.local_order_date ;;
  }

  dimension_group: local_start_datetime {
    group_label: " * Dates * "
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_start_datetime ;;
  }

  dimension: local_start_time {
    hidden: yes
    type: string
    sql: ${TABLE}.local_start_time ;;
  }

  dimension: model_planned_picker_hours {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.model_planned_picker_hours, 0) ;;
  }

  dimension: model_planned_pickers {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.model_planned_pickers, 0) ;;
  }

  dimension: model_planned_rider_hours {
    type: number
    hidden: yes
    sql: coalesce(${TABLE}.model_planned_rider_hours, 0) ;;
  }

  dimension: model_planned_riders {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.model_planned_riders, 0) ;;
  }

  dimension: planned_picker_hours {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.planned_picker_hours, 0) ;;
  }

  dimension: planned_pickers {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.planned_pickers, 0) ;;
  }

  dimension: planned_rider_hours {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.planned_rider_hours, 0) ;;
  }

  dimension: planned_riders {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.planned_riders, 0) ;;
  }

  dimension: predicted_orders {
    type: number
    hidden: yes
    sql: ${TABLE}.predicted_orders ;;
  }

  dimension: lower_bound {
    type: number
    hidden: yes
    sql: coalesce(${TABLE}.predicted_orders_lower_bound, 0) ;;
  }

  dimension: upper_bound {
    type: number
    hidden: yes
    sql: coalesce(${TABLE}.predicted_orders_upper_bound, 0) ;;
  }

  dimension: punched_picker_hours {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.punched_picker_hours, 0) ;;
  }

  dimension: punched_rider_hours {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.punched_rider_hours, 0) ;;
  }

  dimension: orders {
    hidden: yes
    type: number
    sql: coalesce(${TABLE}.total_orders, 0) ;;
  }

  dimension: required_rider_hours {
    group_label: " * Rider Hours * "
    label: "# Required Rider Hours"
    hidden: yes
    sql: coalesce(${orders} / NULLIF(({% parameter rider_UTR %}/2), 0), 0)  ;;
    type: number
  }

  dimension_group: week_starts {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.week_starts ;;
  }

  dimension: forecasted_riders {
    hidden: yes
    type: number
    sql: case when ${date} < '2021-09-20'
          then
            coalesce(CAST(CEIL(${upper_bound} / ({% parameter rider_UTR %}/2)) AS INT64), 0)
          else
            coalesce(CAST(CEIL(${predicted_orders} / ({% parameter rider_UTR %}/2)) AS INT64), 0)
            end
            ;;
  }

  dimension: forecasted_pickers {
    hidden: yes
    type: number
    sql: case when ${date} < '2021-09-20'
          then
            coalesce(CAST(CEIL(${upper_bound} / (${picker_utr}/2)) AS INT64), 0)
          else
            coalesce(CAST(CEIL(${predicted_orders} / (${picker_utr}/2)) AS INT64), 0)
          end
            ;;

  }

  dimension: forecasted_rider_hours {
    hidden: yes
    type: number
    sql:case when ${date} < '2021-09-20'
          then
          coalesce(CAST(CEIL(${upper_bound} / ({% parameter rider_UTR %}/2)) AS INT64) / 2, 0)
          else
          coalesce(CAST(CEIL(${predicted_orders} / ({% parameter rider_UTR %}/2)) AS INT64) / 2, 0)
          end
          ;;
  }

  dimension: forecasted_picker_hours {
    hidden: yes
    type: number
    sql:case when ${date} < '2021-09-20'
          then
          coalesce(CAST(CEIL(${upper_bound} / (${picker_utr}/2)) AS INT64) / 2, 0)
        else
          coalesce(CAST(CEIL(${predicted_orders} / (${picker_utr}/2)) AS INT64) / 2, 0)
          end
          ;;
  }

####### Dynamic dimensions

  dimension: dynamic_timeline_base {
    label_from_parameter: timeline_base
    description: "Changes the field based on on the value of the parameter. Useful to switch the aggregation level of the data"
    sql:
    {% if timeline_base._parameter_value == 'Date' %}
      ${date}
    {% elsif timeline_base._parameter_value == 'Hub' %}
      ${hubs.hub_name}
    {% endif %};;
  }

  dimension: forecasted_dimension {
    #group_label: "* Dynamic KPI Fields *"
    #label: "Forecasted"
    hidden: yes
    #label_from_parameter: KPI_parameter
    #value_format: "#,##0.00"
    value_format_name: id
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'riders' %}
      ${forecasted_riders}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      ${forecasted_rider_hours}
    {% elsif KPI_parameter._parameter_value == 'pickers' %}
      ${forecasted_pickers}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      ${forecasted_picker_hours}
    {% elsif KPI_parameter._parameter_value == 'orders' %}
      ${predicted_orders}
    {% endif %}
    ;;
  }

  dimension: model_planned_dimension {
    #group_label: "* Dynamic KPI Fields *"
    #label: "Forecasted"
    hidden: yes
    #label_from_parameter: KPI_parameter
    #value_format: "#,##0.00"
    value_format_name: id
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'riders' %}
      ${model_planned_riders}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      ${model_planned_rider_hours}
    {% elsif KPI_parameter._parameter_value == 'pickers' %}
      ${model_planned_pickers}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      ${model_planned_picker_hours}
    {% elsif KPI_parameter._parameter_value == 'orders' %}
      ${predicted_orders}
    {% endif %}
    ;;
  }


  dimension: filled_dimension {
    #group_label: "* Dynamic KPI Fields *"
    #label: "Filled"
    hidden: yes
    #label_from_parameter: KPI_parameter
    #value_format: "#,##0.00"
    value_format_name: id
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'riders' %}
      ${filled_riders}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      ${filled_rider_hours}
    {% elsif KPI_parameter._parameter_value == 'pickers' %}
      ${filled_pickers}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      ${filled_picker_hours}
    {% elsif KPI_parameter._parameter_value == 'orders' %}
      ${orders}
    {% endif %}
    ;;
  }

  dimension: delta {
    description: "Computes the difference between forecasted and filled depending on the selected KPI"
    type: number
    #label: "D"
    hidden: yes
    sql: ${forecasted_dimension} - ${filled_dimension} ;;
  }

  dimension: delta_hours_filled_actuals {
    description: "Computes the difference between actual filled hours and required hours"
    type: number
    hidden: yes
    sql: ${filled_rider_hours} - ${required_rider_hours};;
  }

  dimension: delta_hours_punched_actuals {
    description: "Computes the difference between actual punched hours and required hours"
    type: number
    hidden: yes
    sql: ${punched_rider_hours} - ${required_rider_hours};;
  }

  ###### Parameters

  parameter: rider_UTR{
    group_label: " * Parameters * "
    label: "Rider UTR"
    type: unquoted
    allowed_value: { value: "1" }
    allowed_value: { value: "1.5" }
    allowed_value: { value: "2" }
    allowed_value: { value: "2.5" }
    allowed_value: { value: "3" }
    allowed_value: { value: "3.5" }
    allowed_value: { value: "4" }
    default_value: "2.5"
  }

  parameter: timeline_base {
    group_label: " * Parameters * "
    label: "Timeline Base"
    type: unquoted
    allowed_value: { value: "Date" }
    allowed_value: { value: "Hub" }
    default_value: "Date"
  }

  parameter: KPI_parameter {
    label: "* KPI Parameter *"
    group_label: " * Parameters * "
    type: unquoted
    allowed_value: { value: "rider_hours" label: "# Rider Hours"}
    allowed_value: { value: "riders" label: "# Riders"}
    allowed_value: { value: "picker_hours" label: "# Picker Hours"}
    allowed_value: { value: "pickers" label: "# Pickers"}
    allowed_value: { value: "orders" label: "# Orders"}
    default_value: "riders"
  }

  dimension: picker_utr {
    hidden: yes
    group_label: " * Parameters * "
    label: "Picker UTR"
    type: number
    sql: {% parameter rider_UTR %} * 5 ;;
  }

  ######## Measures

  #measure: count {
  #  type: count
  #  drill_fields: [detail*]
  #}

  measure: sum_predicted_orders {
    group_label: " * Orders * "
    label: "# Forecasted Orders"
    sql: ${predicted_orders} ;;
    type: sum
  }

  measure: sum_orders {
    group_label: " * Orders * "
    label: "# Orders"
    sql: ${orders} ;;
    type: sum
  }

  measure: sum_required_rider_hours {
    group_label: " * Rider Hours * "
    label: "# Required Rider Hours"
    sql: ${required_rider_hours} ;;
    type: sum
  }

  measure: sum_model_planned_rider_hours {
    group_label: " * Rider Hours * "
    label: "# Model Planned Rider Hours"
    sql: ${model_planned_rider_hours} ;;
    type: sum
  }

  measure: sum_predicted_orders_lower_bound {
    group_label: " * Orders * "
    label: "# Predicted Orders Lower Bound"
    sql: ${lower_bound} ;;
    type: sum
  }

  measure: sum_predicted_orders_upper_bound {
    group_label: " * Orders * "
    label: "# Predicted Orders Upper Bound"
    sql: ${upper_bound} ;;
    type: sum
  }

  measure: sum_planned_riders {
    group_label: " * Riders * "
    label: "# Planned Riders"
    sql: ${planned_riders} ;;
    type: sum
  }

  measure: sum_model_planned_riders {
    group_label: " * Riders * "
    label: "# Model Planned Riders"
    sql: ${model_planned_riders} ;;
    type: sum
  }

  measure: sum_planned_pickers {
    group_label: " * Pickers * "
    label: "# Planned Pickers"
    sql: ${planned_pickers} ;;
    type: sum
  }

  measure: sum_model_planned_pickers {
    group_label: " * Pickers * "
    label: "# Model Planned Pickers"
    sql: ${model_planned_pickers} ;;
    type: sum
  }

  measure: sum_filled_riders {
    group_label: " * Riders * "
    label: "# Filled Riders"
    sql: ${filled_riders} ;;
    type: sum
  }

  measure: sum_filled_pickers {
    group_label: " * Pickers * "
    label: "# Filled Pickers"
    sql: ${filled_pickers} ;;
    type: sum
  }

  measure: sum_planned_rider_hours {
    group_label: " * Rider Hours * "
    label: "# Planned Rider Hours"
    sql: ${planned_rider_hours} ;;
    type: sum
  }


  measure: sum_planned_picker_hours {
    group_label: " * Picker Hours * "
    label: "# Planned Picker Hours"
    sql: ${planned_picker_hours} ;;
    type: sum
  }

  measure: sum_model_planned_picker_hours {
    group_label: " * Picker Hours * "
    label: "# Model Planned Picker Hours"
    sql: ${model_planned_picker_hours} ;;
    type: sum
  }

  measure: sum_filled_rider_hours {
    group_label: " * Rider Hours * "
    label: "# Filled Rider Hours"
    sql: ${filled_rider_hours} ;;
    type: sum
  }


  measure: sum_filled_picker_hours {
    group_label: " * Picker Hours * "
    label: "# Filled Picker Hours"
    sql: ${filled_picker_hours} ;;
    type: sum
  }


  measure: sum_forecasted_riders {
    group_label: " * Riders * "
    label: "# Forecasted Riders"
    type: sum
    sql: ${forecasted_riders} ;;
  }

  measure: sum_forecasted_pickers {
    group_label: " * Pickers * "
    label: "# Forecasted Pickers"
    type: sum
    sql: ${forecasted_pickers} ;;
  }

  measure: sum_forecasted_rider_hours {
    group_label: " * Rider Hours * "
    label: "# Forecasted Rider Hours"
    type: sum
    sql: ${forecasted_rider_hours} ;;
  }

  measure: sum_forecasted_picker_hours {
    group_label: " * Picker Hours * "
    label: "# Forecasted Picker Hours"
    type: sum
    sql: ${forecasted_picker_hours} ;;
  }

  measure: squared_error {
    type: sum
    sql: pow(${predicted_orders} - ${orders}, 2) ;;
  }

  measure: count_values {
    type: count
  }

  measure: root_mean_squared_error {
    type: number
    sql: sqrt(${squared_error}  / NULLIF(${count_values}, 0)) ;;
    value_format_name: decimal_1
  }

  measure: bias {
    type: sum
    sql: ${predicted_orders} - ${orders} ;;
    value_format_name: decimal_1
  }

  measure: mean_absolute_percentage_error {
    type: number
    sql: ABS(${predicted_orders} - ${orders})/(GREATEST(1, ${orders}) * NULLIF(${count_values}, 0))) ;;
    value_format_name: decimal_1
  }

  measure: pct_no_show {
    label: "% No Show"
    type: number
    sql: ${sum_filled_no_show_rider_hours} / NULLIF(${sum_filled_rider_hours}, 0) ;;
    value_format_name: percent_0
  }

  #measure: sum_pct_no_show {
  #  label: "% Agg No Show"
  #  type: sum
  #  sql: ${filled_no_show_rider_hours} / NULLIF(${filled_rider_hours}, 0) ;;
  #  value_format_name: percent_0
  #}

  ####### Dynamic Measures

  measure: KPI_forecasted {
    group_label: "* Dynamic KPI Fields *"
    label: "Forecasted"
    #label_from_parameter: KPI_parameter
    #value_format: "#,##0.00"
    value_format_name: id
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'riders' %}
      ${sum_forecasted_riders}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      ${sum_forecasted_rider_hours}
    {% elsif KPI_parameter._parameter_value == 'pickers' %}
      ${sum_forecasted_pickers}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      ${sum_forecasted_picker_hours}
    {% elsif KPI_parameter._parameter_value == 'orders' %}
      ${sum_predicted_orders}
    {% endif %}
    ;;
  }

  measure: KPI_planned {
    group_label: "* Dynamic KPI Fields *"
    label: "Planned"
    #label_from_parameter: KPI_parameter
    #value_format: "#,##0.00"
    value_format_name: id
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'riders' %}
      ${sum_planned_riders}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      ${sum_planned_rider_hours}
    {% elsif KPI_parameter._parameter_value == 'pickers' %}
      ${sum_planned_pickers}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      ${sum_planned_picker_hours}
    {% elsif KPI_parameter._parameter_value == 'orders' %}
      ${sum_predicted_orders}
    {% endif %}
    ;;
  }

  measure: KPI_model_planned {
    group_label: "* Dynamic KPI Fields *"
    label: "Model Planned"
    #label_from_parameter: KPI_parameter
    #value_format: "#,##0.00"
    value_format_name: id
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'riders' %}
      ${sum_model_planned_riders}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      ${sum_model_planned_rider_hours}
    {% elsif KPI_parameter._parameter_value == 'pickers' %}
      ${sum_model_planned_pickers}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      ${sum_model_planned_picker_hours}
    {% elsif KPI_parameter._parameter_value == 'orders' %}
      ${sum_predicted_orders}
    {% endif %}
    ;;
  }

  measure: KPI_filled {
    group_label: "* Dynamic KPI Fields *"
    label: "Filled"
    #label_from_parameter: KPI_parameter
    #value_format: "#,##0.00"
    value_format_name: id
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'riders' %}
      ${sum_filled_riders}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      ${sum_filled_rider_hours}
    {% elsif KPI_parameter._parameter_value == 'pickers' %}
      ${sum_filled_pickers}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      ${sum_filled_picker_hours}
    {% elsif KPI_parameter._parameter_value == 'orders' %}
      ${sum_orders}
    {% endif %}
    ;;
  }

  #measure: delta_filled_required_hours {
  #  #type: number
  #  sql: ${delta_hours_actuals} ;;
  #  label: "Delta Between Filled and Required Rider Hours"
  #  group_label: " * Rider Hours * "
  #}

  measure: count_blocks {
    label: "Count Blocks"
    hidden: yes
    type: count_distinct
    sql: ${block_starts_at_time} ;;
  }

  measure: count_over {
    label: "Count Over Blocks"
    hidden: yes
    type: count_distinct
    sql: ${block_starts_at_time} ;;
    filters: [delta: "<0"]
  }

  measure: count_over_hours_filled {
    label: "Count Over Blocks"
    hidden: yes
    type: count_distinct
    sql: ${block_starts_at_time} ;;
    filters: [delta_hours_filled_actuals: ">0"]
  }

  measure: count_over_hours_punched {
    label: "Count Over Blocks"
    hidden: yes
    type: count_distinct
    sql: ${block_starts_at_time} ;;
    filters: [delta_hours_punched_actuals: ">0"]
  }

  measure: count_under {
    label: "Count Under Blocks"
    hidden: yes
    type: count_distinct
    sql: ${block_starts_at_time} ;;
    filters: [delta: ">0"]
  }

  measure: count_under_hours_filled {
    label: "Count Under Blocks"
    hidden: yes
    type: count_distinct
    sql: ${block_starts_at_time} ;;
    filters: [delta_hours_filled_actuals: "<0"]
  }

  measure: count_under_hours_punched {
    label: "Count Under Blocks"
    hidden: yes
    type: count_distinct
    sql: ${block_starts_at_time} ;;
    filters: [delta_hours_punched_actuals: "<0"]
  }

  measure: over_kpi {
    label: "% Over"
    description: "Proportion of 30 min blocks that are over the forecasted number"
    type: number
    sql: ${count_over} / NULLIF(${count_blocks}, 0) ;;
    value_format_name: percent_2
  }

  measure: under_kpi {
    label: "% Under"
    description: "Proportion of 30 min blocks that are under the forecasted number"
    type: number
    sql: ${count_under} / NULLIF(${count_blocks}, 0) ;;
    value_format_name: percent_2
  }

  measure: over_kpi_hours_filled {
    label: "% Over Filled Hours"
    description: "Proportion of 30 min blocks that are over the required rider hours"
    type: number
    sql: ${count_over_hours_filled} / NULLIF(${count_blocks}, 0) ;;
    value_format_name: percent_2
  }

  measure: under_kpi_hours_filled {
    label: "% Under Filled Hours"
    description: "Proportion of 30 min blocks that are under the required rider hours"
    type: number
    sql: ${count_under_hours_filled} / NULLIF(${count_blocks}, 0) ;;
    value_format_name: percent_2
  }

  measure: over_kpi_hours_punched {
    label: "% Over Punched Hours"
    description: "Proportion of 30 min blocks that are over the required rider hours"
    type: number
    sql: ${count_over_hours_punched} / NULLIF(${count_blocks}, 0) ;;
    value_format_name: percent_2
  }

  measure: under_kpi_hours_punched {
    label: "% Under Punched Hours"
    description: "Proportion of 30 min blocks that are under the required rider hours"
    type: number
    sql: ${count_under_hours_punched} / NULLIF(${count_blocks}, 0) ;;
    value_format_name: percent_2
  }

  measure: sum_punched_rider_hours {
    label: "# Punched Rider Hours"
    group_label: " * Rider Hours * "
    type: sum
    sql: ${punched_rider_hours} ;;
    value_format_name: decimal_1
  }

  measure: sum_punched_picker_hours {
    label: "# Punched Picker Hours"
    group_label: " * Picker Hours * "
    type: sum
    sql: ${punched_picker_hours} ;;
    value_format_name: decimal_1
  }

  measure: delta_filled_required_hours {
    description: "Delta Between Filled and Required Rider Hours"
    label: "Delta Between Filled and Required Rider Hours"
    group_label: " * Rider Hours * "
    type: sum
    hidden: no
    sql: ${filled_rider_hours} - ${required_rider_hours};;
    value_format_name: decimal_1
  }

  measure: delta_filled_model_hours {
    description: "Delta Between Filled and Model Planned Rider Hours"
    label: "Delta Between Filled and Model Planned Rider Hours"
    group_label: " * Rider Hours * "
    type: sum
    hidden: no
    sql: ${filled_rider_hours} - ${model_planned_rider_hours};;
    value_format_name: decimal_1
  }

  measure: delta_punched_required_hours {
    description: "Delta Between Punched and Required Rider Hours"
    label: "Delta Between Punched and Required Rider Hours"
    group_label: " * Rider Hours * "
    type: sum
    hidden: no
    sql: ${punched_rider_hours} - ${required_rider_hours};;
    value_format_name: decimal_1
  }


  ####### Measures Hub-Leaderboard
  measure: sum_filled_ext_rider_hours {
    view_label: "Hub Leaderboard"
    group_label: "Hub Leaderboard - Shift Metrics"
    label: "Hours: Filled Ext. Rider"
    sql: ${TABLE}.filled_ext_rider_hours ;;
    hidden: no
    type: sum
    value_format_name: decimal_1
  }

  measure: sum_filled_no_show_rider_hours {
    view_label: "Hub Leaderboard"
    group_label: "Hub Leaderboard - Shift Metrics"
    label: "Hours: No Show Rider"
    sql: ${TABLE}.filled_no_show_rider_hours ;;
    hidden: no
    type: sum
    value_format_name: decimal_1
  }

  measure: sum_filled_ext_picker_hours {
    view_label: "Hub Leaderboard"
    group_label: "Hub Leaderboard - Shift Metrics"
    label: "Hours: Filled Ext. Pickers"
    sql: ${TABLE}.filled_ext_picker_hours ;;
    hidden: no
    type: sum
    value_format_name: decimal_1
  }
  measure: sum_filled_no_show_picker_hours {
    view_label: "Hub Leaderboard"
    group_label: "Hub Leaderboard - Shift Metrics"
    label: "Hours: No Show Pickers"
    sql: ${TABLE}.filled_no_show_picker_hours ;;
    hidden: no
    type: sum
    value_format_name: decimal_1
  }

  measure: sum_unfilled_picker_hours {
    view_label: "Hub Leaderboard"
    group_label: "Hub Leaderboard - Shift Metrics"
    label: "Hours: Unfilled Pickers"
    type: number
    value_format_name: decimal_1
    sql: if(
              (${sum_planned_picker_hours} - ${sum_filled_picker_hours}) < 0
            , 0
            , (${sum_planned_picker_hours} - ${sum_filled_picker_hours})
    );;
  }

  measure: sum_unfilled_rider_hours {
    view_label: "Hub Leaderboard"
    group_label: "Hub Leaderboard - Shift Metrics"
    label: "Hours: Unfilled Riders"
    type: number
    value_format_name: decimal_1
    sql: if(
              (${sum_planned_rider_hours} - ${sum_filled_rider_hours}) < 0
            , 0
            , (${sum_planned_rider_hours} - ${sum_filled_rider_hours})
    ) ;;
  }
}
