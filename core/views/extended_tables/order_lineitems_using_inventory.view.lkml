include: "/**/orderline.view"
include: "/**/inventory.view"


view: order_lineitems_using_inventory {
  extends: [orderline]
  view_label: "* Order Lineitems *"

  measure: pct_stock_range_1d {
    label: "Stock Range [days, based on 1d avg.]"
    description: "Current stock divided by 1d AVG Daily Sales"
    hidden:  no
    type: number
    sql: ${inventory.sum_stock_quantity} / NULLIF(${avg_daily_item_quantity_last_1d}, 0);;
    value_format: "0.0"
  }

  measure: pct_stock_range_3d {
    label: "Stock Range [days, based on 3d avg.]"
    description: "Current stock divided by 3d AVG Daily Sales"
    hidden:  no
    type: number
    sql: ${inventory.sum_stock_quantity} / NULLIF(${avg_daily_item_quantity_last_3d}, 0);;
    value_format: "0.0"
  }

  measure: pct_stock_range_7d {
    label: "Stock Range [days, based on 7d avg.]"
    description: "Current stock divided by 7d AVG Daily Sales"
    hidden:  no
    type: number
    sql: ${inventory.sum_stock_quantity} / NULLIF(${avg_daily_item_quantity_last_7d}, 0);;
    value_format: "0.0"
    #html:
    #{% if value < 1 %}
    #<p style="color: white; background-color: #E74C3C;font-size: 100%; text-align:center">{{ rendered_value }}</p>
    #{% elsif value < 3 %}
    #<p style="color: #E67E22;background-color: #F4D03F; font-size:100%; text-align:center">{{ rendered_value }}</p>
    #{% else %}
    #<p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
    #{% endif %};;
  }


}
