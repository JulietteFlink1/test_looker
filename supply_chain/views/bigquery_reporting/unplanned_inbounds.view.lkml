view: unplanned_inbounds {
  derived_table: {
    sql:
    with rewe_desadv_info as (
    select delivery_date                                              as report_date
         , upper(left(hub_code, 2))                                   as country_iso
         , hub_code                                                   as hub_code
         , sku                                                        as sku
         , cast(null as string)                                       as all_parent_skus
         , sum(cast(selling_unit_quantity as numeric))                as total_purchased_quantity

    from `flink-data-prod`.curated.replenishment_purchase_orders
    where status = 'Sent'
    and delivery_date >= '2021-11-01'
        -- data only for month April 2022
        -- date(inbounded_timestamp) between '2022-04-01' and '2022-04-30'
        --date(delivery_date) >= '2022-03-01'
    group by 1, 2, 3, 4
),

lexbizz_item as (
         select *
         from `flink-data-prod`.curated.lexbizz_item
),

define_parent_skus as (
         select country_iso                                             as country_iso
              , item_replenishment_substitute_group                     as item_replenishment_substitute_group
              , max(sku)                                                as parent_sku
              , string_agg(distinct if(left (sku, 1) = '9', sku, null)) as all_parent_skus

         from lexbizz_item

         where item_replenishment_substitute_group is not null

         group by 1, 2
     ),

     actual_inbounding_data as (
         select inventory_daily.report_date as report_date
              , inventory_daily.country_iso                    as country_iso
              , inventory_daily.hub_code                       as hub_code
              , coalesce(
                 define_parent_skus.parent_sku,
                 inventory_daily.sku
             )                                                 as sku
              , define_parent_skus.all_parent_skus             as all_parent_skus
              , sum(number_of_total_inbound)                   as total_inbounded_quantity

         from `flink-data-prod`.reporting.inventory_daily

                  -- this join only adds the replenishment-group to the inventory table
                  left join lexbizz_item
                            on
                                        lexbizz_item.sku = inventory_daily.sku and
                                    -- get only the current-days data
                                        lexbizz_item.ingestion_date = inventory_daily.report_date

                  left join define_parent_skus
                            on
                                        define_parent_skus.country_iso = lexbizz_item.country_iso and
                                        define_parent_skus.item_replenishment_substitute_group =
                                        lexbizz_item.item_replenishment_substitute_group

                  left join `flink-data-prod`.curated.lexbizz_warehouse
                            on
                                        lexbizz_warehouse.hub_code = inventory_daily.hub_code
                                    -- take only the most recent warehouse assignment
                                    and lexbizz_warehouse.ingestion_date = inventory_daily.report_date
                                    -- take only the active warehouses to avoid duplications
                                    and lexbizz_warehouse.is_warehouse_active is true

                  left join `flink-data-prod`.curated.lexbizz_item_warehouse
                            on
                                        lexbizz_item_warehouse.warehouse_id = lexbizz_warehouse.warehouse_id and
                                        lexbizz_item_warehouse.sku = inventory_daily.sku and
                                        lexbizz_item_warehouse.ingestion_date = inventory_daily.report_date

         where
           -- data only for month April 2022
           -- report_date between '2022-04-01' and '2022-04-30'
             report_date >= '2021-11-01'
           -- only REWE
           --and lexbizz_item_warehouse.preferred_vendor_id = 'L000000039'

         group by 1, 2, 3, 4, 5
     ),

     merge_rewe_and_inbound as (
         select report_date,
                country_iso,
                hub_code,
                sku,

                sum(total_purchased_quantity)  as total_purchased_quantity,
                sum(total_inbounded_quantity) as total_inbounded_quantity

         from (
                  (select report_date,
                          country_iso,
                          hub_code,
                          sku,
                          all_parent_skus,
                          total_purchased_quantity,
                          cast(null as int64) as total_inbounded_quantity
                   from rewe_desadv_info)

                  union all

                  (select report_date,
                          country_iso,
                          hub_code,
                          sku,
                          all_parent_skus,
                          cast(null as int64) as total_purchased_quantity,
                          total_inbounded_quantity
                   from actual_inbounding_data)
              )
         group by 1, 2, 3, 4
     )

select *
from merge_rewe_and_inbound
;;
  }

###############################################################
################### Dimension/Measures ########################
###############################################################

  measure: count {
    type: count
    drill_fields: [detail*]
    hidden: yes
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: concat(${report_date}, ${hub_code}, ${sku}) ;;
  }


  dimension_group: report {
    label: "Unplanned Inbound"
    group_label: "> Measures (Unplanned Inbounds) <"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_date ;;
  }


  #dimension: report_date {
  #  type: date
  #  datatype: date
  #  sql: ${TABLE}.report_date ;;
  #}

 # dimension: all_parent_skus {
 #   label: "All possible parent SKUs"
 #    type: string
 #   hidden: no
 #    sql: ${TABLE}.all_parent_skus ;;
 # }

  dimension: country_iso {
    type: string
    group_label: "> Measures (Unplanned Inbounds) <"
    hidden: no
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    group_label: "> Measures (Unplanned Inbounds) <"
    hidden: no
    sql: ${TABLE}.hub_code ;;
  }

  dimension: sku {
    type: string
    group_label: "> Measures (Unplanned Inbounds) <"
    hidden: no
    sql: ${TABLE}.sku ;;
  }

  dimension: total_purchased_quantity {
    type: number
    sql: ${TABLE}.total_purchased_quantity ;;
    hidden: yes
  }

  dimension: total_inbounded_quantity {
    type: number
    sql: ${TABLE}.total_inbounded_quantity ;;
    hidden: yes
  }

    dimension: total_inbounded_quantity_unplanned {
      type: number
      sql: case
             when ${total_purchased_quantity} is null then ${total_inbounded_quantity}
             else 0
           end;;
      hidden: yes
    }


  measure: sum_total_inbounded_quantity {

    label: "SUM Inbounded"
    group_label: "> Measures (Unplanned Inbounds) <"

    type: sum
    sql: ${total_inbounded_quantity} ;;

    value_format_name: decimal_0
  }

    measure: sum_total_inbounded_quantity_unplanned {

      label: "SUM Unplanned Inbounded"
      group_label: "> Measures (Unplanned Inbounds) <"

      type: sum
      sql: ${total_inbounded_quantity_unplanned}  ;;

      value_format_name: decimal_0
    }

  measure: sum_total_purchased_quantity {

    label: "SUM Purchased"
    group_label: "> Measures (Unplanned Inbounds) <"

    type: sum
    sql: ${total_purchased_quantity} ;;

    value_format_name: decimal_0
  }

    measure: unplanned_inbound_rate{
      label: "% Unplanned Inbound Rate"
      group_label: "> Measures (Unplanned Inbounds) <"

      type: number
      sql: safe_divide(${sum_total_inbounded_quantity_unplanned}, ${sum_total_inbounded_quantity}) ;;

      value_format_name: percent_2
    }


#  measure: pct_fill_rate {
#    label: "% Fill-Rate"
#    hidden: yes
#
#    type: number
#    sql: safe_divide(${sum_total_inbounded_quantity}, ${total_purchased_quantity}) ;;
#
#    value_format_name: percent_2
#  }


  set: detail {
    fields: [
      report_date,
      country_iso,
      hub_code,
      sku,
      total_purchased_quantity,
      total_inbounded_quantity
    ]
  }
}
