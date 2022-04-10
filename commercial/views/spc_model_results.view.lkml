view: spc_model_results {
  sql_table_name: `flink-data-dev.sandbox_andreas.spc_model_results`;;
  view_label: "WIP - SPC 2.0 Assortment Model"


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========

  dimension: group {

    label:       "Model Decision Level"
    description: "The granularity, the decision was made"

    type: string
    sql: ${TABLE}.`Group` ;;
  }

  dimension: description {

    label:       "Model Definition - Description"
    description: "The definition, how the decision was made for the given SKU"

    type: string
    sql: ${TABLE}.Description ;;
  }


  dimension: model_status {

    label:       "Model Status"
    description: "The mode, the mdoel came to it's decision"

    type: string
    sql: ${TABLE}.Model_Status ;;

  }

  dimension: result {

    label:       "Model Result - Keep SKU"
    description: "Defines, whether a SKU is suggested to be de-listed (encoded as '0' or 'False') or not (encoded as '1' or 'Yes')"

    type: yesno
    sql: if(${TABLE}.Result = 1, True, False) ;;

  }



  # =========  IDs   =========
  dimension: sku {
    type: string
    sql: ${TABLE}.SKU ;;
    hidden: yes
    primary_key: yes
  }



  # =========  hidden   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: subcategory {
    type: string
    sql: ${TABLE}.subcategory ;;
    hidden: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



}
