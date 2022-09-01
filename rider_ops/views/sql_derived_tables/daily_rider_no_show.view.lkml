view: daily_rider_no_show {
  derived_table: {
    sql:

    with hub_shift_metrics as
(select  shift_date,
        hub_code,
        country_iso,
        ifnull(sum(case when is_deleted = false and shift_status = 'missing_punch'
                then planned_shift_duration_minutes - planned_break_duration_minutes end)/60,0) as no_show_missing_punch_hours,

        ifnull(sum(case when is_deleted and shift_date <= date(deleted_at_timestamp)
                then planned_shift_duration_minutes - planned_break_duration_minutes end)/60,0) as no_show_deleted_shift_hours,

        ifnull(sum(case when is_deleted = false and shift_status = 'missing_punch'
                then planned_shift_duration_minutes - planned_break_duration_minutes end)/60,0) +
        ifnull(sum(case when is_deleted and shift_date <= date(deleted_at_timestamp)
                then planned_shift_duration_minutes - planned_break_duration_minutes end)/60,0) as total_no_show_hours,

        ifnull(sum(case when is_deleted = false and shift_status = 'done_evaluation'
                then actual_shift_duration_minutes - actual_break_duration_minutes end)/60,0) as worked_hours,

        ifnull(sum(case when is_deleted = false
                then planned_shift_duration_minutes - planned_break_duration_minutes end)/60,0) as planned_hours,
from `flink-data-prod.curated.hub_shifts`
where position_name = 'rider'
and shift_type = 'assigned'
and shift_date < current_date(timezone)
and shift_date > '2022-01-01'
group by 1,2,3)

select shift_date,
        hub_code,
        country_iso,
        no_show_missing_punch_hours,
        no_show_deleted_shift_hours,
        total_no_show_hours as number_of_no_show_hours,
        worked_hours as number_of_worked_hours,
        planned_hours + no_show_deleted_shift_hours as number_of_planned_hours,
        round(total_no_show_hours/nullif(planned_hours + no_show_deleted_shift_hours,0),3) pct_no_show
from hub_shift_metrics
order by pct_no_show desc, number_of_planned_hours desc;;
  }


  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension_group: shift {
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
    sql: ${TABLE}.shift_date ;;
  }


  measure: no_show_missing_punch_hours{
    type: sum
    label: "# Missing Punch No Show Hours"
    hidden: no
    sql:${TABLE}.no_show_missing_punch_hours;;
    value_format_name: decimal_0
  }

  measure: no_show_deleted_shift_hours  {
    type: sum
    hidden: no
    label: "# Deleted No Show Hours"
    sql:${TABLE}.no_show_deleted_shift_hours  ;;
    value_format_name: decimal_0
  }

  measure: number_of_no_show_hours{
    type: sum
    hidden: no
    label: "# No Show Hours"
    description: "Includes Deleted Shifts and Missing Punch Hours"
    sql:${TABLE}.number_of_no_show_hours;;
    value_format_name: decimal_0
  }

  measure: number_of_worked_hours{
    type: sum
    hidden: no
    label: "# Punched Hours"
    sql:${TABLE}.number_of_worked_hours;;
    value_format_name: decimal_0
  }

  measure: number_of_planned_hours{
    type: sum
    label: "# Planned Hours"
    hidden: no
    sql:${TABLE}.number_of_planned_hours;;
    value_format_name: decimal_0
  }

  measure: pct_no_show{
    type: number
    label: "% No Show Hours"
    hidden: no
    sql:${number_of_no_show_hours}/nullif(${number_of_planned_hours},0);;
    value_format_name: percent_0
  }


}
