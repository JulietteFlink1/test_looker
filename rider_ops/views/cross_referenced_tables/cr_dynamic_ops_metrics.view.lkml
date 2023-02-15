view: cr_dynamic_ops_metrics {


   measure: hub_ops_kpis {
    type: number
    group_label: "> Dynamic KPIs"
    label: "OKR Level 1 KPIs (Dynamic)"
    label_from_parameter: dynamic_kpi_parameter
    sql:
    {% if dynamic_kpi_parameter._parameter_value == 'ops_associate_utr' %}
      ${ops.utr_ops_associate}
    {% elsif dynamic_kpi_parameter._parameter_value == 'hub_staff_utr' %}
      ${ops.utr_hub_staff}
    {% elsif dynamic_kpi_parameter._parameter_value == 'rider_utr' %}
      ${ops.utr_rider}
    {% elsif dynamic_kpi_parameter._parameter_value == 'rider_idle' %}
      ${ops.pct_rider_idle_time}
    {% elsif dynamic_kpi_parameter._parameter_value == 'no_show_rider' %}
      ${ops.pct_no_show_hours_rider}
    {% elsif dynamic_kpi_parameter._parameter_value == 'no_show_ops_associate' %}
      ${ops.pct_no_show_hours_ops_associate}
    {% elsif dynamic_kpi_parameter._parameter_value == 'no_show_rider_ops_associate' %}
      ${ops.pct_no_show_hours_rider_ops_associate}
    {% elsif dynamic_kpi_parameter._parameter_value == 'pct_forecast_deviation_hours_adjusted' %}
      ${forecasts.pct_forecast_deviation_hours_adjusted}
    {% elsif dynamic_kpi_parameter._parameter_value == 'pct_overpunched_hours_ops_associate' %}
      ${ops.pct_overpunched_hours_ops_associate}
    {% elsif dynamic_kpi_parameter._parameter_value == 'pct_overpunched_hours_rider' %}
      ${ops.pct_overpunched_hours_rider}
    {% endif %};;

    html:
    {% if dynamic_kpi_parameter._parameter_value ==  'ops_associate_utr' %}
        {{ops.utr_ops_associate._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'hub_staff_utr' %}
        {{ops.utr_hub_staff._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'rider_utr' %}
        {{ops.utr_rider._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'rider_idle' %}
        {{ops.pct_rider_idle_time._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'no_show_rider' %}
        {{ops.pct_no_show_hours_rider._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'no_show_ops_associate' %}
        {{ops.pct_no_show_hours_ops_associate._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'no_show_rider_ops_associate' %}
        {{ops.pct_no_show_hours_rider_ops_associate._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'pct_forecast_deviation_hours_adjusted' %}
        {{forecasts.pct_forecast_deviation_hours_adjusted._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'pct_overpunched_hours_ops_associate' %}
        {{ops.pct_overpunched_hours_ops_associate._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'pct_overpunched_hours_rider' %}
        {{ops.pct_overpunched_hours_rider._rendered_value }}
    {% endif %}
    ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  parameter: dynamic_kpi_parameter {
    group_label: "> Dynamic KPIs"
    label: "OKR Level 1 KPIs (Dynamic)"
    type: unquoted
    allowed_value: {label: "Ops Associate UTR" value: "ops_associate_utr" }
    allowed_value: {label: "Hub Staff UTR" value: "hub_staff_utr" }
    allowed_value: {label: "Rider UTR" value: "rider_utr" }
    allowed_value: {label: "% Rider Worked Time Spent Idle" value: "rider_idle" }
    allowed_value: {label: "% No Show Rider Hours" value: "no_show_rider" }
    allowed_value: {label: "% No Show Ops Associate Hours" value: "no_show_ops_associate" }
    allowed_value: {label: "% No Show Rider + Ops Associate" value: "no_show_rider_ops_associate" }
    allowed_value: {label: "% Adjusted Scheduled Hours Forecast Deviation (Incl. EC Shift)" value: "pct_forecast_deviation_hours_adjusted" }
    allowed_value: {label: "% Overpunched Ops Associate Hours" value: "pct_overpunched_hours_ops_associate" }
    allowed_value: {label: "% Overpunched Rider Hours" value: "pct_overpunched_hours_rider" }

    default_value: "rider_utr"
  }
}
