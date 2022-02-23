view: external_shift_misuse {
  derived_table: {
    sql:select  country_iso,
        hub_code,
        shift_date,
        position_name,
        count(distinct shift_id) as number_of_shifts
from `flink-data-prod.curated.hub_shifts`
where employment_id is not null
and scheduling_source = 'quinyx'
and fleet_type = 'one-time'
group by 1,2,3,4;;
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


  dimension: position_name {
    type: string
    sql: ${TABLE}.position_name ;;
  }

  measure: number_of_shifts{
    type: sum
    hidden: no
    sql:${TABLE}.number_of_shifts;;
    value_format_name: decimal_0
  }



}
