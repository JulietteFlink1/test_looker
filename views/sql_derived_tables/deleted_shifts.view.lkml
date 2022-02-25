view: deleted_shifts {
  derived_table: {
    sql: with no_show as
(
select
shift_date,
country_iso,
hub_code,
leave_reason,
round(sum(case when shift_status = 'no_show' and is_deleted = false then planned_shift_duration_minutes-break_duration_minutes end)/60) as  current_no_show_hours,
round(sum(case when shift_status = 'no_show' and is_deleted then planned_shift_duration_minutes-break_duration_minutes end)/60) as deleted_no_show_hours,
round(sum(case when shift_status = 'no_show' then planned_shift_duration_minutes-break_duration_minutes end)/60) as total_no_show_hours,
round(sum(case when shift_status = 'no_show' and is_deleted then planned_shift_duration_minutes-break_duration_minutes end) /
sum(case when shift_status = 'no_show' then planned_shift_duration_minutes-break_duration_minutes end) * 100) as pct_deleted_no_show,

from `flink-data-prod.curated.hub_shifts`
group by 1,2,3,4
)


select *
from no_show;;
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


  dimension: leave_reason {
    type: string
    sql: ${TABLE}.leave_reason ;;
  }


  measure: current_no_show_hours{
    type: sum
    hidden: no
    sql:${TABLE}.current_no_show_hours;;
    value_format_name: decimal_0
  }

  measure: deleted_no_show_hours{
    type: sum
    hidden: no
    sql:${TABLE}.deleted_no_show_hours;;
    value_format_name: decimal_0
  }

  measure: total_no_show_hours{
    type: sum
    hidden: no
    sql:${TABLE}.total_no_show_hours;;
    value_format_name: decimal_0
  }

  measure: pct_deleted_no_show{
    type: number
    hidden: no
    sql:${deleted_no_show_hours}/nullif(${total_no_show_hours},0);;
    value_format_name: percent_0
  }


}
