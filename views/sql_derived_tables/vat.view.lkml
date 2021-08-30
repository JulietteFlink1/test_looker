view: vat {
  derived_table: {
    sql: WITH orderline AS (
          SELECT order_id,
              o.country_iso,
              CASE WHEN ppt.name = 'Reduced Tax' THEN 0.07
                   WHEN ppt.name = 'Standard Tax' or ppt.name = 'Standard tax' THEN 0.19 END
              AS pct_tax,
              CASE WHEN ppt.name = 'Reduced Tax' THEN unit_price_gross_amount * quantity_fulfilled / (1+0.07)
                   WHEN ppt.name = 'Standard Tax' or ppt.name = 'Standard tax' THEN unit_price_gross_amount * quantity_fulfilled / (1+0.19)  END
              AS item_price_net,
              unit_price_gross_amount * quantity_fulfilled AS item_price_gross,
              o.shipping_price_gross_amount as delivery_fee_gross,
              o.discount_amount AS discount_amount
          FROM `flink-backend.saleor_db_global.product_producttype` ppt
          LEFT JOIN `flink-backend.saleor_db_global.product_product` pp ON pp.country_iso = ppt.country_iso and ppt.id = pp.product_type_id
          LEFT JOIN `flink-backend.saleor_db_global.product_productvariant` ppv ON ppv.country_iso = pp.country_iso and pp.id = ppv.product_id
          LEFT JOIN `flink-backend.saleor_db_global.order_orderline` oo ON oo.country_iso = pp.country_iso and oo.product_sku = ppv.sku
          LEFT JOIN `flink-backend.saleor_db_global.order_order` o on o.country_iso = oo.country_iso and o.id = oo.order_id
          WHERE ppt.country_iso = 'DE'
      ),
      weighted_tax_rate AS (
          SELECT order_id,
            country_iso,
            delivery_fee_gross,
            discount_amount,
            ROUND(SUM(pct_tax * item_price_net)/SUM(item_price_net),2) AS tax_rate_weighted,
            SUM(item_price_net) as sum_items_price_net,
            SUM(item_price_gross) as sum_items_price_gross
          FROM orderline
          WHERE item_price_net <>0
          GROUP BY 1,2,3,4
      ),
      delivery_fees_discount AS (
          SELECT  order_id,
                  country_iso,
                  tax_rate_weighted ,
                  sum_items_price_net,
                  sum_items_price_gross,
                  delivery_fee_gross,
                  discount_amount,
                  ROUND(delivery_fee_gross / ( 1 + tax_rate_weighted),2) as delivery_fee_net,
                  ROUND(discount_amount / ( 1 + tax_rate_weighted),2) as discount_amount_net
          FROM weighted_tax_rate
      ),
      refund AS (
          SELECT order_id,
                 pp.country_iso,
                 SUM(amount) as refund_amount
          FROM `flink-backend.saleor_db_global.payment_payment` pp
          LEFT JOIN `flink-backend.saleor_db_global.payment_transaction` pt ON pp.id = pt.payment_id AND pp.country_iso = pt.country_iso
          WHERE kind = 'refund'
          AND is_success IS TRUE
          GROUP BY 1, 2
      ),
      net_gross AS (
      SELECT d.order_id,
             d.country_iso,
             tax_rate_weighted,
             COALESCE(delivery_fee_net,0) AS delivery_fee_net,
             COALESCE(discount_amount_net,0) AS discount_amount_net,
             sum_items_price_net AS sum_item_price_net,
             COALESCE(ROUND(refund_amount / ( 1 + tax_rate_weighted),2),0) AS refund_amount_net,
             COALESCE(refund_amount,0) AS refund_amount_gross,
             COALESCE(delivery_fee_gross,0) AS delivery_fee_gross,
             COALESCE(discount_amount,0) as discount_amount_gross,
             sum_items_price_gross as sum_items_price_gross
      FROM delivery_fees_discount d
      LEFT JOIN refund USING (order_id, country_iso)
      )

      SELECT order_id,
      country_iso,
      tax_rate_weighted,
      SUM(delivery_fee_net+sum_item_price_net-refund_amount_net-discount_amount_net) as total_net,
      SUM(delivery_fee_gross+sum_items_price_gross-refund_amount_gross-discount_amount_gross) as total_gross,
      SUM(delivery_fee_gross+sum_items_price_gross-refund_amount_gross-discount_amount_gross)-SUM(delivery_fee_net+sum_item_price_net-refund_amount_net-discount_amount_net)  AS total_VAT
      FROM net_gross
      GROUP BY 1,2,3
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: tax_rate_weighted {
    label: "Tax Rate (Weighted)"
    type: number
    sql: ${TABLE}.tax_rate_weighted ;;
  }

  dimension: total_net {
    type: number
    sql: ${TABLE}.total_net ;;
  }

  dimension: total_gross {
    type: number
    sql: ${TABLE}.total_gross ;;
  }

  dimension: total_vat {
    label: "VAT (Total)"
    type: number
    sql: ${TABLE}.total_VAT ;;
    value_format_name: euro_accounting_2_precision
  }

  set: detail {
    fields: [order_id, tax_rate_weighted, total_net, total_gross, total_vat]
  }

  measure: sum_vat_total {
    label: "SUM VAT (Total)"
    type: sum
    sql: ${TABLE}.total_VAT  ;;
    value_format_name: euro_accounting_2_precision
  }
}
