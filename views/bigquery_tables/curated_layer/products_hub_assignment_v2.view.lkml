view: products_hub_assignment_v2 {
  sql_table_name: `flink-data-dev.curated.products_hub_assignment_v2`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameter      ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter: select_calculation_granularity {
    # this paramter does:
    #  1. replace the SKU with a leading SKU name
    #  2. reduces the data in inventory tables to report only leading SKU level per group

    # this parameter is defined at the products_hub_assignment level, as this view is the base of the Supply Chain explore

    label:       "Select Metric Aggregation Level"
    group_label: "* Parameters & Dynamic Fields *"
    description: "Chose, on what level you want to calculate metrics such as esp. the oos-rate"

    type: unquoted

    allowed_value: {
      label: "per SKU"
      value: "sku"
    }

    allowed_value: {
      label: "per SKU - Aggregated per Replenishment Groups"
      value: "replenishment"
    }

    allowed_value: {
      label: "per SKU - Aggregated per Substitute Groups"
      value: "customer"
    }

    default_value: "replenishment"
  }
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;

  }

  dimension: report_date {
    type: date
    datatype: date
    sql: ${TABLE}.report_date ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: sku_dynamic {

    label:       "SKU (Dynamically aggregated)"
    description: "In most cases, this field shows the regular SKU of a product.
                  When a product is part of a substitute group or part of a replenishment substitute group, this field will return the parent/leading SKU of this group,
                  when the parameter 'Select Metric Aggregation Level' is defined accordingly"
    group_label: "* Parameters & Dynamic Fields *"

    type: string
    sql:
        case
            when {% condition select_calculation_granularity %} 'sku'           {% endcondition %}
            then ${sku}

            when {% condition select_calculation_granularity %} 'replenishment' {% endcondition %}
            then coalesce( ${leading_sku_replenishment_substitute_group} , ${sku} )

            when {% condition select_calculation_granularity %} 'customer'      {% endcondition %}
            then coalesce( ${leading_sku_ct_substitute_group} , ${sku} )

            else null
        end
    ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_most_recent_record {
    type: yesno
    sql: ${TABLE}.is_most_recent_record ;;
  }


  dimension: ct_final_decision_is_sku_assigned_to_hub {
    label: "Is SKU Assigned (CT)"
    type: yesno
    sql: ${TABLE}.ct_final_decision_is_sku_assigned_to_hub ;;
  }

  dimension: erp_final_decision_is_sku_assigned_to_hub {
    label: "Is SKU Assigned (ERP)"
    type: yesno
    sql: ${TABLE}.erp_final_decision_is_sku_assigned_to_hub ;;
  }

  dimension: is_sku_assigned_to_hub {
    label: "Is SKU Assigned (Official Definition)"
    type: yesno
    sql: ${TABLE}.is_sku_assigned_to_hub ;;
  }



  # =========  ERP Data   =========

  dimension: erp_is_hub_active {
    group_label: "ERP Fields"
    type: yesno
    sql: ${TABLE}.erp_is_hub_active ;;
  }

  dimension: erp_is_warehouse_active {
    group_label: "ERP Fields"
    type: yesno
    sql: ${TABLE}.erp_is_warehouse_active ;;
  }

  dimension: erp_item_at_warehouse_status {
    group_label: "ERP Fields"
    type: string
    sql: ${TABLE}.erp_item_at_warehouse_status ;;
  }

  dimension: erp_item_status {
    group_label: "ERP Fields"
    type: string
    sql: ${TABLE}.erp_item_status ;;
  }

  dimension: erp_vendor_id {
    group_label: "ERP Fields"
    type: string
    sql: ${TABLE}.erp_vendor_id ;;
  }

  dimension: erp_vendor_location_id {
    group_label: "ERP Fields"
    type: string
    sql: ${TABLE}.erp_vendor_location_id ;;
    hidden: yes
  }

  dimension: erp_vendor_name {

    label: "Supplier Name"
    description: "The name of the supplier of a SKU as defined in ERP/lexbizz"
    group_label: "ERP Fields"

    type: string
    sql: ${TABLE}.erp_vendor_name ;;
  }

  dimension: erp_vendor_status {

    label: "Supplier Status"
    description: "A flag indicating, whether a vendor is still considered active aka delivering SKUs"
    group_label: "ERP Fields"

    type: string
    sql: ${TABLE}.erp_vendor_status ;;
  }

  dimension: leading_sku_replenishment_substitute_group {

    label: "Replenishment Group - Leading SKU"
    description: "The parent SKU of a SKU that is part of a replenishment substitute group - these SKUs usually start with 99x"
    group_label: "ERP Fields"

    type: string
    sql: ${TABLE}.leading_sku_replenishment_substitute_group ;;
  }

  dimension: replenishment_substitute_group {

    label: "Replenishment Group"
    description: "The replenishment substitute group defined by the Supply Chain team to tag substitute products for replenishment."
    group_label: "ERP Fields"

    type: string
    sql: ${TABLE}.replenishment_substitute_group ;;
  }







  # =========  CT Data   =========
  dimension: ct_is_published_globally {

    label: "Is Published (CT)"
    description: "The global status of a SKU in CommerceTools, that defines if a SKU is published or not"
    group_label: "CT Fields"

    type: yesno
    sql: ${TABLE}.ct_is_published_globally ;;
  }

  dimension: ct_is_published_per_hub {

    label: "Is SKU assigned to Hub (CT)"
    description: "The assignment status of a SKU per hub according to CommerceTools"
    group_label: "CT Fields"

    type: yesno
    sql: ${TABLE}.ct_is_published_per_hub ;;
  }

  dimension: substitute_group {

    label: "Substitute Group (CT)"
    description: "The substitute group according to CommerceTools defining substitute products from the customer perspective"
    group_label: "CT Fields"

    type: string
    sql: ${TABLE}.substitute_group ;;
  }

  dimension: leading_sku_ct_substitute_group {

    label: "Substitute Group - Leading SKU"
    description: "The (artificially generated) parent SKU of a SKU that is part of a CommerceTools substitute group - these SKUs usually end with -SG"
    group_label: "CT Fields"

    type: string
    sql: ${TABLE}.leading_sku_ct_substitute_group ;;
  }


  # =========  hidden   =========
  dimension: filter_one_sku_per_replenishment_substitute_group {

    label: "Filter: Only leading SKU per Replenishment Substitute Group"
    description: "If set to true, this boolean reduces replenshment substitute groups to only show 1 SKU per group"
    group_label: "ERP Fields"

    type: yesno
    sql: ${TABLE}.filter_one_sku_per_replenishment_substitute_group  ;;
    hidden: yes
  }

  dimension: filter_one_sku_per_substitute_group {

    label: "Filter: Only leading SKU per CT Substitute Group"
    description: "If set to true, this boolean reduces CT substitute groups to only show 1 SKU per group"
    group_label: "CT Fields"

    type: yesno
    sql: ${TABLE}.filter_one_sku_per_substitute_group  ;;
    hidden: yes
  }


  # =========  IDs   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: cnt_unique_skus {
    label: "# unique SKUs"
    type: count_distinct
    sql: ${sku_dynamic} ;;
  }


}
