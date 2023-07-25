# Owner: Daniel Tancu
# Main Stakeholder:
# - Supply Chain team
#
# Questions that can be answered
# - All questions around data related to the really long term out of stock's adjusted intro date data

view: really_long_term_adjusted_intro_date {
  sql_table_name: `flink-supplychain-prod.curated.really_long_term_adjusted_intro_date` ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    label: "Country ISO"
    description: "Geographical information of product-location"
    hidden: no
  }

  dimension: demand_planning_master_category {
    type: string
    sql: ${TABLE}.demand_planning_master_category ;;
    label: "Master Category"
    description: "Global Master Category for product-location"
    hidden: no
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    label: "Hub Code"
    description: "Hub Code for Product-Location"
    hidden: no
  }


  dimension_group: intro_date_change {
    type: time
    timeframes: [date, week, month]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.intro_date_change ;;
    label: "Introduction Date Change"
    description: "The date on which the introduction date shift is being created"
    hidden: no
  }

  dimension: is_currently_adjusted {
    type: yesno
    sql: ${TABLE}.is_currently_adjusted ;;
    label: "Is Currently Adjusted?"
    description: "Identifies whether product-locations have the introduction date currently adjusted"
    hidden: no
  }

  dimension: is_noos {
    type: yesno
    sql: ${TABLE}.is_noos ;;
    label: "Is Never Out of Stock?"
    description: "Identifies whether product-location is tagged as a 'Never Out Of Stock' (noos)"
    hidden: no
  }

  dimension: item_category {
    type: string
    sql: ${TABLE}.item_category ;;
    label: "Item Category"
    description: "Products Category for Product-Location"
    hidden: no
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
    label: "Item Name"
    description: "Description of item that has recieved the respective SKU"
    hidden: no
  }

  dimension_group: previous_introduction {
    type: time
    timeframes: [date, week, month]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.previous_introduction_date ;;
    label: "Previous Introduction Date"
    description: "Represents the previous date in which the product-location was in the really long term bucket before the date shift"
    hidden: no
  }

  dimension: shelf_life {
    type: number
    sql: ${TABLE}.shelf_life ;;
    label: "Shelf Life"
    description: "Shelf Life for Product-Location"
    hidden: no
  }

  dimension: shelf_life_hub {
    type: number
    sql: ${TABLE}.shelf_life_hub ;;
    label: "Shelf Life for Hub"
    description: "Shelf Life for Hub"
    hidden: no
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    label: "SKU"
    description: "SKU for Product-Location"
    hidden: no
  }

  dimension_group: updated_introduction {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.updated_introduction_date ;;
    label: "Updated Introduction Date"
    description: "Bucket allocated to product-location for waste topics based on MECE Logic (mutually exclusive and collectively exhaustive)"
    hidden: no
  }

}
