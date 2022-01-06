view: hubtech_all {
    derived_table: {
      sql: select * from `flink-data-dev.enps.202112_hubtech_all`
        ;;
    }

    measure: count {
      type: count
      label: "# Responses"
      #hidden: yes
      drill_fields: [detail*]
    }

    dimension: token {
      type: string
      sql: ${TABLE}.token ;;
    }

    dimension: how_satisfied_are_you_with_the_flink_picker_app {
      type: number
      sql: ${TABLE}.How_satisfied_are_you_with_the_Flink_Picker_App ;;
    }

    dimension: how_satisfied_are_you_with_the_flink_inventory_manager_zebra_app {
      type: number
      sql: ${TABLE}.How_satisfied_are_you_with_the_Flink_Inventory_Manager_Zebra_App ;;
    }

    dimension: do_you_find_the_hub_dashboard_tv_useful {
      type: number
      sql: ${TABLE}.Do_you_find_the_Hub_Dashboard_TV_useful ;;
    }

    dimension: how_satisfied_are_you_with_the_hub_it_infrastructure_eg_internet_computers_etc {
      type: number
      sql: ${TABLE}.How_satisfied_are_you_with_the_Hub_IT_infrastructure_eg_internet_computers_etc ;;
    }

    dimension: how_satisfied_are_you_with_the_support_you_get_from_the_tech_ops_team {
      type: number
      sql: ${TABLE}.How_satisfied_are_you_with_the_support_you_get_from_the_TechOps_Team ;;
    }

    dimension: is_there_anything_else_youd_like_to_share {
      type: string
      sql: ${TABLE}.Is_there_anything_else_youd_like_to_share ;;
    }

    dimension_group: submitted_at {
      type: time
      hidden: yes
      sql: ${TABLE}.submitted_at ;;
    }

    dimension: country_iso {
      type: string
      sql: ${TABLE}.country_iso ;;
    }

    dimension: nps_how_satisfied_are_you_with_the_flink_picker_app {
      type: number
      sql: case when ${how_satisfied_are_you_with_the_flink_picker_app} >= 9 THEN 100
                when ${how_satisfied_are_you_with_the_flink_picker_app} < 7 THEN -100
                else 0
                end;;
    }

    measure: avg_nps_how_satisfied_are_you_with_the_flink_picker_app {
      type: average
      value_format: "0"
      sql:  ${nps_how_satisfied_are_you_with_the_flink_picker_app} ;;
    }

    dimension: nps_how_satisfied_are_you_with_the_flink_inventory_manager_zebra_app {
      type: number
      sql: case when ${how_satisfied_are_you_with_the_flink_inventory_manager_zebra_app} >= 9 THEN 100
                  when ${how_satisfied_are_you_with_the_flink_inventory_manager_zebra_app} < 7 THEN -100
                  else 0
                  end;;
    }

    measure: avg_nps_how_satisfied_are_you_with_the_flink_inventory_manager_zebra_app {
      type: average
      value_format: "0"
      sql:  ${nps_how_satisfied_are_you_with_the_flink_inventory_manager_zebra_app} ;;
    }

    dimension: nps_do_you_find_the_hub_dashboard_tv_useful {
      type: number
      sql: case when ${do_you_find_the_hub_dashboard_tv_useful} >= 9 THEN 100
                    when ${do_you_find_the_hub_dashboard_tv_useful} < 7 THEN -100
                    else 0
                    end;;
    }

    measure: avg_nps_do_you_find_the_hub_dashboard_tv_useful {
      type: average
      value_format: "0"
      sql:  ${nps_do_you_find_the_hub_dashboard_tv_useful} ;;
    }

    dimension: nps_how_satisfied_are_you_with_the_hub_it_infrastructure_eg_internet_computers_etc {
      type: number
      sql: case when ${how_satisfied_are_you_with_the_hub_it_infrastructure_eg_internet_computers_etc} >= 9 THEN 100
                      when ${how_satisfied_are_you_with_the_hub_it_infrastructure_eg_internet_computers_etc} < 7 THEN -100
                      else 0
                      end;;
    }

    measure: avg_nps_how_satisfied_are_you_with_the_hub_it_infrastructure_eg_internet_computers_etc {
      type: average
      value_format: "0"
      sql:  ${nps_how_satisfied_are_you_with_the_hub_it_infrastructure_eg_internet_computers_etc} ;;
    }

    dimension: nps_how_satisfied_are_you_with_the_support_you_get_from_the_tech_ops_team {
      type: number
      sql: case when ${how_satisfied_are_you_with_the_support_you_get_from_the_tech_ops_team} >= 9 THEN 100
                        when ${how_satisfied_are_you_with_the_support_you_get_from_the_tech_ops_team} < 7 THEN -100
                        else 0
                        end;;
    }

    measure: avg_nps_how_satisfied_are_you_with_the_support_you_get_from_the_tech_ops_team {
      type: average
      value_format: "0"
      sql:  ${nps_how_satisfied_are_you_with_the_support_you_get_from_the_tech_ops_team} ;;
    }

    set: detail {
      fields: [
        how_satisfied_are_you_with_the_flink_picker_app,
        how_satisfied_are_you_with_the_flink_inventory_manager_zebra_app,
        do_you_find_the_hub_dashboard_tv_useful,
        how_satisfied_are_you_with_the_hub_it_infrastructure_eg_internet_computers_etc,
        how_satisfied_are_you_with_the_support_you_get_from_the_tech_ops_team,
        is_there_anything_else_youd_like_to_share,
        country_iso
      ]
    }
  }
