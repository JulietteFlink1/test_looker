view: psp_reference_authorised_date {
  derived_table: {
    sql: select psp_reference,
       booking_date as psp_reference_authorised_booking_date,
       left(cast(booking_date as string),7) as psp_reference_authorised_booking_month
from `flink-data-prod.curated.psp_transactions`
where record_type = 'Authorised'
qualify row_number() over(partition by psp_reference order by booking_timestamp) = 1
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: psp_reference {
    type: string
    sql: ${TABLE}.psp_reference ;;
    primary_key: yes
  }

  dimension: psp_reference_authorised_booking_date {
    type: date
    datatype: date
    sql: ${TABLE}.psp_reference_authorised_booking_date ;;
  }

  dimension: psp_reference_authorised_booking_month {
    type: date
    datatype: date
    sql: ${TABLE}.psp_reference_authorised_booking_month ;;
  }

  set: detail {
    fields: [psp_reference, psp_reference_authorised_booking_date]
  }
}
