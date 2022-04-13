
view: top_10_products_per_parent_category {
  derived_table: {
    explore_source: retail_current_inventory {
      column: product_name             { field: products.product_name}
      column: parent_category_name     { field: products.category }
      column: sum_item_price_gross_14d { field: order_lineitems.sum_item_price_gross_14d }
      derived_column: rank_per_category {
        sql: rank() over (partition by parent_category_name order by sum_item_price_gross_14d desc) ;;
      }
      bind_all_filters: yes
    }
  }

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    sql: ${product_name} ;;
  }

  dimension: product_name {
    label: "SKU Name"
  }

  dimension: parent_category_name {
    label: "Parent Category Name"
  }

  dimension: sum_item_price_gross_14d {
    label: "SUM Item Prices sold (gross) - Last 14 days"
    description: "Sum of sold Item prices (incl. VAT) - in the Last 14 days"
    value_format_name: eur
    type: number
  }

  dimension: rank_per_category {}

  dimension: rank_per_category_named {
    type: string
    sql:
        CASE
        WHEN
            ${rank_per_category} < 10 THEN '0'|| ${rank_per_category} || ') ' || ${product_name}
            ELSE ${rank_per_category} || ') ' || ${product_name}
        END ;;
  }


  filter: apply_filter {
    type: yesno
    hidden: no
    sql: ${rank_per_category} <= 10 ;;
  }

  # dimension: rank_per_category_named_with_tail {
  #   type: string
  #   sql:
  #   CASE
  #       WHEN {% condition filter_top_x_products_by_14d_gmv %} ${rank_per_category} {% endcondition %}
  #       THEN ${rank_per_category_named}
  #       ELSE 'x) Other'
  #   END ;;
  # }

}
