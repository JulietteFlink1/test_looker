# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning Performance
# - Supply Chain team
#
# Questions that can be answered
# - All questions around the list of specific item-locations that are verified to be ideally never out of stock (NOoS)

view: noos_list {
  sql_table_name: `flink-supplychain-prod.curated.noos_list`
    ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: corrected_sales_rank {
    type: number
    sql: ${TABLE}.corrected_sales_rank ;;
    label: "Corrected Sales Rank"
    description: "Shows the rank of corrected sales units belonging to the item locations of the never out of stock list"
    hidden: no
  }

  dimension: corrected_sales_units {
    type: number
    sql: ${TABLE}.corrected_sales_units ;;
    label: "Corrected Sales Units"
    description: "Shows the amount of corrected sales units belonging to the item locations of the never out of stock list"
    hidden: no
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    label: "Corrected Sales Units"
    description: "Code of a hub identical to back-end source tables."
    hidden: yes
  }

  dimension: sequence_added_hub_rank {
    type: number
    sql: ${TABLE}.sequence_added_hub_rank ;;
    label: "Sequence-added Hub Ranking"
    description: "Shows the rank of the item-location based on the likehood of the customer adding in the item the basket as first item (per hub ranked) "
    hidden: no
  }

  dimension: sku {
    type: number
    sql: cast(${TABLE}.sku as string) ;;
    label: "SKU"
    description: "Product number used for identification"
    hidden: yes
  }

  dimension: is_noos {
    type: string
    sql: ${TABLE}.is_noos ;;
    label: "Is Never Out Of Stock (NOOS)"
    description: "Shows if the item-location is marked as an item that should never be out of stock"
    hidden: no
  }

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
