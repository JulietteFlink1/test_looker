# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning Performance
# - Supply Chain team
#
# Questions that can be answered
# - This database table archives the specific measures implemented by different teams aimed at enhancing product availability and minimizing out-of-stock situations. It serves as a consolidated record of strategic actions, like  supply chain adjustments, demand forecasting strategies, and other initiatives taken to ensure optimal stock levels and maximize product availability.

view: availability_waterfall_actions {
  sql_table_name: `flink-supplychain-prod.curated.availability_waterfall_actions`
    ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: decision {
    type: string
    sql: ${TABLE}.decision ;;
    label: "Decision"
    description: "Shows the action taken for the appointed optimization process of the item-location "
    hidden: no
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    label: "Hub Code"
    description: "Code of a hub identical to back-end source tables."
    hidden: yes
  }

  dimension: impacted_bucket {
    type: string
    sql: ${TABLE}.impacted_bucket ;;
    label: "Impacted Bucket"
    description: "Shows the availability bucket that is impacted by the process"
    hidden: no
  }

  dimension: process {
    type: string
    sql: ${TABLE}.process ;;
    label: "Process"
    description: "Shows the process name taken for the optimization action of the item-location"
    hidden: no
  }

  dimension_group: reporting_week {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.reporting_week ;;
    label: "Report Week"
    description: "Report Week used to assign the product-location information to actions"
    hidden: no
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    label: "SKU"
    description: "Product number used for identification"
    hidden: yes

  }

  dimension: team {
    type: string
    sql: ${TABLE}.team ;;
    label: "Team"
    description: "Shows the team impacted by the appointed action of item-location"
    hidden: no
  }

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
