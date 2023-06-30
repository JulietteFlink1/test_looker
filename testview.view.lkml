# Owner: Juliette Hampton
# Created: 2023-06-14
# This view was created as part of my onboarding task. It was created from James Davies' table as I don't have access to dbt.

view: testview {

  sql_table_name: flink-data-prod.curated.braze_contacts ;;

  view_label: "* Juliette test view *"
  drill_fields: [core_dimensions*]

  ################################################
  #                DIMENSIONS                    #
  ################################################

  #---------------Core dimensions set---------------------------#

  set: core_dimensions {
    fields: [
      country_iso,
      user_id
    ]
  }

#---------------Main dimensions---------------------------#

  dimension: country_iso {

    label: "Country"
    group_label: "* Geographic Dimensions *"
    description: "Country where order was placed or attempted"

    type: string
    sql: ${TABLE}.country_iso ;;
  }


  dimension: user_id {

    label: "User id"
    group_label: "* Geographic Dimensions *"
    description: "User id"

    type: string
    sql: ${TABLE}.user_id ;;
  }




#---------------Hidden dimensions---------------------------#

  dimension: table_uuid {

    group_label: "* Primary Key *"
    hidden:  yes

    primary_key: yes
    type: string
    sql: ${TABLE}.table_uuid ;;
  }
  }
