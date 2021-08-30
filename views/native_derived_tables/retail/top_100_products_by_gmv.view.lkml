# https://help.looker.com/hc/en-us/articles/360024267673-Sort-by-Pivots-Rank-with-Other-Bucket-and-Percentile-Tail-Analysis
view: top_100_products_by_gmv {
  derived_table: {
    explore_source: retail_current_inventory {
      column:         sum_item_price_gross_7d { field: order_lineitems.sum_item_price_gross_7d }
      column:         name                    { field: products.product_name }
      derived_column: rank                    { sql: rank() over (order by sum_item_price_gross_7d desc) ;; }
    }
  }


  dimension: name {
    type: string
    primary_key: yes
  }

  dimension: sum_item_price_gross_7d {
    label: "SUM Item Prices sold (gross) - Last 7 days"
    description: "Sum of sold Item prices (incl. VAT)"
    value_format_name: eur
    type: number
  }

  dimension: rank {
    type: number
  }

  dimension: ranked_product {
    type: string
    sql:
        CASE
        WHEN
            ${rank} < 10 THEN '0'|| ${rank} || ') ' || ${name}
            ELSE ${rank} || ') ' || ${name}
        END ;;
  }

  filter: filter_top_x_products_by_7d_gmv {
    type: number
  }

  dimension: ranked_brand_with_tail {
    type: string
    sql:
    CASE
        WHEN {% condition filter_top_x_products_by_7d_gmv %} ${rank} {% endcondition %}
        THEN ${ranked_product}
        ELSE 'x) Other'
    END ;;
  }

}
