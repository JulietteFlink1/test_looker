view: favourites_analysis_part1 {
    sql_table_name:`flink-data-dev.dbt_famin.account_favourites_analysis_part1`;;

    view_label: "Favourites Analysis"

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# ======= IDs ======= #

    dimension: anonymous_id {
      hidden: yes
      group_label: "IDs"
      label: "Anonymous ID"
      description: "Anonymous ID"
      type: string
      sql: ${TABLE}.anonymous_id ;;
    }


# ======= Date ======= #


    dimension_group: first_visit_date {
      group_label: "Date"
      label: "First Visit Date"
      description: "Date of First Visit"
      type: time
      timeframes: [
        date,
        week,
        month,
        year
      ]
      sql: ${TABLE}.first_visit_date ;;
      datatype: date
    }


    dimension_group: first_order_date {
      group_label: "Date"
      label: "First Order"
      description: "Date of First Order"
      type: time
      timeframes: [
        date,
        week,
        month,
        year
      ]
      sql: ${TABLE}.first_order_date ;;
      datatype: date
    }

    dimension_group: first_discovery_date {
      group_label: "Date"
      label: "First Interaction Date"
      description: "Date of First Interaction with Favourites Feature"
      type: time
      timeframes: [
        date,
        week,
        month,
        year
      ]
      sql: ${TABLE}.first_discovery_date ;;
      datatype: date
    }

    dimension_group: event_date {
      group_label: "Date"
      label: "Favourites Interaction Date"
      description: "Date of Interaction with Favourites"
      type: time
      timeframes: [
        date,
        week,
        month,
        year
      ]
      sql: ${TABLE}.favourites_interaction_event_date ;;
      datatype: date
    }

# ======= Location Dimension ======= #

    dimension: country_iso {
      group_label: "Location Dimension"
      label: "Country ISO"
      description: "First visit ISO country"
      type: string
      sql: ${TABLE}.country_iso ;;
    }

# ======= Device Dimension ======= #

    dimension: platform {
      group_label: "Device Dimension"
      label: "Platform"
      description: "First visit platform"
      type: string
      sql: ${TABLE}.platform ;;
    }

# ======= Favourites ======= #

    dimension: flag_interacted_with_favourites{
      group_label: "Favourites Dimension"
      label: "Has interacted with favourites"
      description: "Is customer has interacted with favourites at least once"
      type: yesno
      sql: ${TABLE}.flag_interacted_with_favourites;;
    }

    dimension: num_days_from_first_visit_to_first_interaction {
      group_label: "Favourites"
      label: "# of days to first interaction (from first visit date)"
      type: number
      sql: ${TABLE}.num_days_from_first_visit_to_first_interaction;;
    }

    dimension: num_days_from_first_order_to_first_interaction {
      group_label: "Favourites"
      label: "# of days to first interaction (from first order date)"
      type: number
      sql: ${TABLE}.num_days_from_first_order_to_first_interaction;;
    }

  dimension: num_of_visits_to_first_interaction {
    group_label: "Favourites"
    label: "# of visits to first interaction (from first visit date)"
    type: number
    sql: ${TABLE}.num_of_visits_to_first_interaction;;
  }


  dimension: weeks_since_first_interaction {
    group_label: "Favourites"
    label: "# of weeks to interaction (from first interaction with favourites)"
    type: number
    sql: ${TABLE}.weeks_since_first_interaction;;
  }


  dimension: number_of_unique_events_per_day { #field name should be number_of_unique_interactions
    group_label: "Favourites"
    label: "# of unique interactions with favourites"
    type: number
    sql: ${TABLE}.weeks_since_first_interaction;;
  }


# ======= Measures ======= #


    measure: count_users {
      group_label: "Measures"
      hidden: no
      label: "# of Unique Users"
      type: count_distinct
      sql: ${anonymous_id};;
    }


    measure: count_users_favourites {
      group_label: "Measures"
      hidden: no
      label: "# of Unique Users Who Interacted With Favourites"
      type: count_distinct
      sql: ${anonymous_id};;
      filters: [flag_interacted_with_favourites: "yes"]
    }


  }
