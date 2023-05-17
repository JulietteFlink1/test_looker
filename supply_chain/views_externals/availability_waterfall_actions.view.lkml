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
    label: "Action Taken"
    description: "Shows the action taken in response to the issue of the out of stock of the item-location "
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
    label: "Out of Stock Reasont"
    description: "This column represents the impacted bucket for an out of stock issue within the availability waterfall."
    hidden: no
  }

  dimension: process {
    type: string
    sql: ${TABLE}.process ;;
    label: "Action Process "
    description: "This column represents the process responsible for the action being taken for the optimization of the item-location."
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
    label: "Responsible Team"
    description: "This column represents the team that is responsible for the appointed action of item-location"
    hidden: no
  }

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
