
view: top_50_skus_per_gmv_supply_chain_explore {
  view_label: "* Top 50 by GMV (last 14d) *"

  derived_table: {
    explore_source: supply_chain {

      column: country_iso              { field: products.country_iso }
      column: sku                      { field: products.product_sku }
      column: name                     { field: products.product_name }

      column: sum_item_price_gross_14d { field: order_lineitems.sum_item_price_gross_14d }

      derived_column: rank             { sql: rank() over (partition by country_iso order by sum_item_price_gross_14d desc) ;; }

      bind_all_filters: yes
    }
  }

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    sql: concat(${country_iso}, ${sku}) ;;
  }


  measure: sum_item_price_gross_14d {
    label: "SUM Item Prices sold (gross) - Last 14 days"
    description: "Sum of sold Item prices (incl. VAT) - in the Last 14 days"
    value_format_name: eur_0
    type: sum
    hidden: no
  }


  dimension: country_iso {
    label: "Country Iso"
    hidden: no
  }
  dimension: sku {
    type: string
    label: "SKU"
    # value_format_name: decimal_0
    hidden: no
  }

  dimension: name {
    label: "Name"
    hidden: yes
  }


  dimension: rank {
    type: number
  }

  dimension: ranked_product {
    type: string
    sql:
        CASE
        WHEN
            ${rank} < 10
        THEN
            '0'|| ${rank} || ') ' || ${name}
        ELSE
                  ${rank} || ') ' || ${name}
        END ;;
  }

  dimension: top_50 {
    label: "Top 50 products by GMV per country"
    type: string
    sql:
    CASE
        WHEN ${rank} <= 50
        THEN ${ranked_product}
        ELSE 'x) Other'
    END ;;
  }

  dimension: is_top_50 {
    label: "Is Top 50 product by GMV per country"
    type: yesno
    sql:  ${rank} <= 50 ;;

  }

  filter: filter_top_x_products_by_7d_gmv {
    type: number
    default_value: "50"
    hidden: yes
  }

  dimension: ranked_brand_with_tail {
    type: string
    sql:
    CASE
        WHEN {% condition filter_top_x_products_by_7d_gmv %} ${rank} {% endcondition %}
        THEN ${ranked_product}
        ELSE 'x) Other'
    END ;;
    hidden: yes
  }
}
