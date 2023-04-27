# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around testing groups of specific item-locations (called cohorts in this case) which are to be benchmarked for the performance of modifications made on them (ex: RELEX adjustments in a specific week, etc)

view: demand_planning_test_cohort {
  sql_table_name: `flink-supplychain-prod.curated.demand_planning_test_cohort`
    ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: cohort {
    type: string
    sql: ${TABLE}.cohort ;;
    label: "Cohort Code"
    description: "Shows the code of the cohort attributed to the item locations for testing/benchmarking purposes"
    hidden: no
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
    label: "Cohort Description"
    description: "Shows the description/meaning for the cohort attributed to the item locations"
    hidden: no
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: end {
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
    sql: ${TABLE}.end_date ;;
    label: "End Date"
    description: "Shows the end date for the cohort attributed to the item locations"
    hidden: no
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    label: "Hub Code"
    hidden: no
  }

  dimension_group: ingestion_timestamp {
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
    sql: ${TABLE}.ingestion_timestamp ;;
    label: "Ingestion Timestamp"
    description: "Shows the ingestion timestamp from Knime to Big Query for the cohort attributed to the item locations"
    hidden: no
  }

  dimension_group: report {
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
    sql: ${TABLE}.report_date ;;
    label: "Report Date"
    description: "Shows the report date for the cohort attributed to the item locations"
    hidden: no
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    label: "SKU"
    hidden: no
  }

  dimension_group: start {
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
    sql: ${TABLE}.start_date ;;
    label: "Start Date"
    description: "Shows the Start date for the cohort attributed to the item locations"
    hidden: no
  }

  dimension: time_frame_type {
    type: string
    sql: coalesce(${TABLE}.time_frame_type,'outside_testing_timeframe') ;;
    label: "Time Frame Type"
    description: "Filter for showing either if item location is inside the time frame of the cohort test or not"
    hidden: no
  }

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
