view: assortment_puzzle_pieces {
  sql_table_name: `flink-data-dev.dbt_astueber.assortment_puzzle_pieces`
    ;;


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Main: Hub-Level
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: hub_layout {

    label:       "Hub Layout"
    description: "The hub layout refers to the design of the hub, the number and order of shelves it contains, etc."
    group_label: "Hub Level Data"
    type: string
    sql: ${TABLE}.hub_layout ;;
  }

  dimension: hub_puzzles_array {

    label:       "Puzzle Pieces (Hub)"
    description: "The hub puzzle pieces refer to the specific sets of SKUs, it may be linked to (e.g. Standard, Premium or Discount SKUs)"
    group_label: "Hub Level Data"
    type: string
    sql: ${TABLE}.hub_puzzles_array ;;
  }

  dimension: hub_size {

    label:       "Hub Size"
    description: "The hub size (measured as S, M or L) refers to the physical size/space of a hub"
    group_label: "Hub Level Data"

    type: string
    sql: ${TABLE}.hub_size ;;
  }

  dimension: hub_tier {

    label:       "Hub Tier"
    description: "The hub tiers (1-4) refer to the amount of assortment diversity, that is related to a specific hub (whereby 4 refers to the broadest assortment and 1 to the smallest assortment)"
    group_label: "Hub Level Data"

    type: number
    sql: ${TABLE}.hub_tier ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Main: SKU-Level
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: sku_assigned_hub_layout {

    label:       "Hub Layout (assigned SKU)"
    description: "The hub layout in the context of SKUs refers to which hubs can potentially offer a SKU (whereby a 1.0 SKU can be sold in both 1.0 and 2.0 hubs.)"
    group_label: "SKU Level Data"

    type: string
    sql: ${TABLE}.sku_assigned_hub_layout ;;
  }

  dimension: sku_assigned_hub_puzzle {

    label:       "Puzzle Pieces (assigned SKU)"
    description: "The puzzle piece in the context of SKUs refers to which hubs can potentially offer a SKU (whereby a PREMIUM SKU can only be sold in hubs with puzzle piece PREMIUM)"
    group_label: "SKU Level Data"

    type: string
    sql: ${TABLE}.sku_assigned_hub_puzzle ;;
  }

  dimension: sku_assigned_hub_size {

    label:       "Hub Size (assigned SKU)"
    description: "The hub size in the context of SKUs refers to which hubs can potentially offer a SKU (whereby a MEDIUM SKU can only be sold in hubs with hub size of either MEDIUM or LARGE)"
    group_label: "SKU Level Data"

    type: string
    sql: ${TABLE}.sku_assigned_hub_size ;;
  }

  dimension: sku_assigned_tier {

    label:       "Hub Tier (assigned SKU)"
    description: "The hub tier in the context of SKUs refers to which hubs can potentially offer a SKU (whereby a tier 2 SKU can only be sold in hubs with hub tier of 2 or greater)"
    group_label: "SKU Level Data"

    type: number
    sql: ${TABLE}.sku_assigned_tier ;;
  }

  dimension: source_of_sku_data {

    label:       "Source of SKU data"
    description: "This fields defined, where the SKU puzzle piece data is derived. If defined, it is pulled from the related Airtable. If an SKU is not defined in the Airtable, it will be filled with Lexbizz Item data: Values are: Hub-Size : As defined in Lexbizz | Puzzle Piece : always 'Standard' | tier : always 1 | layout : always 1.0"
    group_label: "SKU Level Data"

    type: string
    sql: ${TABLE}.source_of_sku_data ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Dates & Timestamps
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension_group: ingestion {
    type: time
    timeframes: [
      date
    ]
    datatype: date
    sql: ${TABLE}.ingestion_date ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    IDs
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Hidden Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
    hidden: yes
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: count {
    type: count
    drill_fields: [product_name]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

}
