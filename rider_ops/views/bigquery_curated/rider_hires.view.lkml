view: rider_hires {
  sql_table_name: `flink-data-prod.curated.rider_hires`
    ;;

  dimension: applicant_email {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.applicant_email ;;
  }

  dimension: applicant_uuid {
    group_label: "* IDs *"
    primary_key: yes
    type: string
    sql: ${TABLE}.applicant_uuid ;;
  }

  dimension: channel {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: city {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: type_of_contract {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.type_of_contract ;;
  }

  dimension: country {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: applied_at {
    group_label: "* Dates & Timestamps *"
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
    sql: ${TABLE}.created_at_timestamp ;;
  }

  dimension_group: hired_at {
    group_label: "* Dates & Timestamps *"
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
    sql: ${TABLE}.hired_at_timestamp ;;
  }

  dimension: position {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: contract_label{
    label: "Contract Type label"
    type: string
    sql: case
              -- DE/AT Contract Type
              when REGEXP_CONTAINS(lower (${type_of_contract}),'mini') then 'Minijob'
              when REGEXP_CONTAINS(lower (${type_of_contract}),'student') then 'Working Student'
              when REGEXP_CONTAINS(lower (${type_of_contract}),'full') OR REGEXP_CONTAINS(lower (${type_of_contract}),'voll') then 'Full-Time'
              when REGEXP_CONTAINS(lower (${type_of_contract}),'part') OR REGEXP_CONTAINS(lower (${type_of_contract}),'teil') then 'Part-Time'


              -- NL Contract Type
              when REGEXP_CONTAINS(lower (${type_of_contract}),'0-hours') then '0-Hours'
              when REGEXP_CONTAINS(lower (${type_of_contract}),'min/max') then 'Min/Max'


              -- FR Contract Type
              when REGEXP_CONTAINS(lower (${type_of_contract}),'15') then '15 Hours'
              when REGEXP_CONTAINS(lower (${type_of_contract}),'20') then '20 Hours'
              when REGEXP_CONTAINS(lower (${type_of_contract}),'35') then '35 Hours'



              else 'Others' end;;

    }

  ##################### Measures

  measure: count_hired_applicants {
    group_label: "* Basic Counts *"
    label: "# Hired Applicants"
    type: count
    drill_fields: []
  }
}
