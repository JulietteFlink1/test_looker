include: "/**/*.view"



explore: vendor_performance {

  from: bulk_items
  view_name: bulk_items
  view_label: "* DESADV data *"

  fields: [bulk_items.main_fields*,
           inventory_changes_daily*,
           vendor_performance_fill_rate*,
           products*
          ]



  join: inventory_changes_daily {

    type: left_outer
    relationship: one_to_many
    sql_on:
           ${inventory_changes_daily.parent_sku} = ${bulk_items.sku}
       and ${inventory_changes_daily.hub_code}              = ${bulk_items.hub_code}
       and ${inventory_changes_daily.inventory_change_date} = ${bulk_items.delivery_date}
    ;;

    fields: [inventory_changes_daily.sum_inbound_inventory,
             inventory_changes_daily.sku,
             inventory_changes_daily.parent_sku,
             inventory_changes_daily.is_inbound
            ]
  }

  join: vendor_performance_fill_rate {

    view_label: "* DESADV data *"

    type: left_outer
    relationship: many_to_one
    sql_on: ${vendor_performance_fill_rate.dispatch_notification_id} =  ${bulk_items.dispatch_notification_id};;

    fields: [vendor_performance_fill_rate.avg_desadv_fill_rate,
             vendor_performance_fill_rate.desadv_fill_rate,
             vendor_performance_fill_rate.is_desadv_inbounded
            ]
  }

  join: products {

    type: left_outer
    relationship: many_to_one
    sql_on: ${products.replenishment_substitute_group_parent_sku} = ${bulk_items.sku} ;;
  }

}
