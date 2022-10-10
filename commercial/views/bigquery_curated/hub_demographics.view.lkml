explore: hub_demographics {
  hidden: yes
}

view: hub_demographics {
  sql_table_name: `flink-data-prod.curated.hub_demographics`
    ;;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Exposed Dimensions
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: age_0_to_14_years {
    label: "Age 0-14 years"
    description: "The share of the population in the age range of 0 and 14"
    group_label: "Age Distribution"
    type: number
    sql: ${TABLE}.age_0_to_14_years ;;
  }

  dimension: age_15_to_29_years {
    label: "Age 15-29 years"
    description: "The share of the population in the age range of 15 and 29"
    group_label: "Age Distribution"
    type: number
    sql: ${TABLE}.age_15_to_29_years ;;
  }

  dimension: age_30_to_44_years {
    label: "Age 30-44 years"
    description: "The share of the population in the age range of 30 and 44"
    group_label: "Age Distribution"
    type: number
    sql: ${TABLE}.age_30_to_44_years ;;
  }

  dimension: age_45_to_59_years {
    label: "Age 45-59 years"
    description: "The share of the population in the age range of 45 and 59"
    group_label: "Age Distribution"
    type: number
    sql: ${TABLE}.age_45_to_59_years ;;
  }

  dimension: age_60_plus_years {
    label: "Age 60+ years"
    description: "The share of the population in the age range of 60+"
    group_label: "Age Distribution"
    type: number
    sql: ${TABLE}.age_60_plus_years ;;
  }

  dimension: area_sqkm {
    label: "Area (square km)"
    type: number
    sql: ${TABLE}.area_sqkm ;;
  }

  dimension: population {
    label: "Population"
    description: "The number of people living in the specified hub turf"
    type: number
    sql: ${TABLE}.population ;;
  }

  dimension: population_female {
    label: "Population Female"
    description: "The number of female people living in the specified hub turf"
    type: number
    sql: ${TABLE}.population_female ;;
  }

  dimension: population_male {
    label: "Population Male"
    description: "The number of male people living in the specified hub turf"
    type: number
    sql: ${TABLE}.population_male ;;
  }

  dimension: spending_power {
    type: number
    sql: ${TABLE}.spending_power ;;
  }

  dimension: supermarket {
    type: number
    sql: ${TABLE}.supermarket ;;
  }

  dimension: total_households {
    type: number
    sql: ${TABLE}.total_households ;;
  }

  dimension: unemployed {
    type: number
    sql: ${TABLE}.unemployed ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }





  dimension: income_group_1 {
    type: number
    sql: ${TABLE}.income_group_1 ;;
  }

  dimension: income_group_2 {
    type: number
    sql: ${TABLE}.income_group_2 ;;
  }

  dimension: income_group_3 {
    type: number
    sql: ${TABLE}.income_group_3 ;;
  }

  dimension: income_group_4 {
    type: number
    sql: ${TABLE}.income_group_4 ;;
  }

  dimension: income_group_5 {
    type: number
    sql: ${TABLE}.income_group_5 ;;
  }

  dimension: food_and_beverages_stores {
    type: number
    sql: ${TABLE}.food_and_beverages_stores ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Join Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Hidden Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: hub_demographics_uuid {
    type: string
    sql: ${TABLE}.hub_demographics_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: avg_household_spending_power {
    type: number
    sql: ${TABLE}.avg_household_spending_power ;;
  }

  dimension: avg_inhabitant_spending_power {
    type: number
    sql: ${TABLE}.avg_inhabitant_spending_power ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Exposed Measures
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  measure: count {
    type: count
    drill_fields: []
  }
}
