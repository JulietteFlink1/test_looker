view: vat_order {
  derived_table: {
    sql: WITH
      country_tax_rates AS (
          SELECT country_iso,
                 AVG(CASE WHEN tax_name = 'Reduced tax category' THEN tax_rate END) as tax_rate_reduced,
                 AVG(CASE WHEN tax_name = 'Standard tax category' THEN tax_rate END) as tax_rate_standard
          FROM `flink-data-prod.curated.products`
          GROUP BY 1
      ),
      orderline AS (
                SELECT order_id,
                    o.order_number,
                    o.order_uuid,
                    o.country_iso,
                    o.hub_code,
                    o.customer_email as user_email,
                    order_date,
                    p.tax_rate as  pct_tax,
                    amt_unit_price_gross * quantity / (1+p.tax_rate) AS item_price_net,
                    CASE WHEN  p.tax_name = 'Reduced tax category' THEN amt_unit_price_gross * quantity / (1+p.tax_rate) END AS item_price_reduced_net,
                    CASE WHEN  p.tax_name = 'Standard tax category' or  p.tax_name <> 'Reduced tax category'  THEN amt_unit_price_gross * quantity / (1+p.tax_rate) END AS item_price_standard_net,
                    amt_unit_price_gross * quantity AS item_price_gross,
                    CASE WHEN  p.tax_name = 'Standard tax category' or p.tax_name <> 'Reduced tax category'
                    THEN amt_unit_price_gross * quantity END AS item_price_standard_gross,
                    CASE WHEN  p.tax_name = 'Reduced tax category' THEN amt_unit_price_gross * quantity END AS item_price_reduced_gross,
                    o.amt_delivery_fee_gross as delivery_fee_gross,
                    o.amt_discount_gross AS discount_amount
                FROM `flink-data-prod.curated.order_lineitems` oo
                LEFT JOIN `flink-data-prod.curated.products` p ON p.country_iso = oo.country_iso and p.product_sku = oo.sku
                LEFT JOIN `flink-data-prod.curated.orders` o on o.country_iso = oo.country_iso and o.order_uuid = oo.order_uuid
                WHERE TRUE
                AND is_successful_order is true
                AND o.hub_code <> 'de_ber_ufhi'
                AND p.tax_rate is not null
               -- AND date(o.order_timestamp) = current_date -1
              --  AND date(oo.order_timestamp) = current_date -1

       ),
            weighted_tax_rate AS (
                SELECT order_id,
                  order_uuid,
                  order_date,
                  country_iso,
                  hub_code,
                  user_email,
                  delivery_fee_gross,
                  discount_amount,
                  SUM(pct_tax * item_price_net)/SUM(item_price_net) as tax_rate_weighted,
                  SUM(item_price_net)                               as sum_items_price_net,
                  SUM(item_price_gross)                             as sum_items_price_gross,
                  SUM(item_price_standard_net)                      as sum_items_price_standard_net,
                  SUM(item_price_standard_gross)                    as sum_items_price_standard_gross,
                  SUM(item_price_reduced_gross)                     as sum_items_price_reduced_gross,
                  SUM(item_price_reduced_net)                       as sum_items_price_reduced_net
                FROM orderline
                GROUP BY 1,2,3,4,5,6,7,8
            ),
            delivery_fees_discount AS (
                SELECT  order_id,
                        order_uuid,
                        country_iso,
                        order_date,
                        hub_code,
                        user_email,
                        tax_rate_weighted ,
                        sum_items_price_net,
                        sum_items_price_gross,
                        delivery_fee_gross,
                        discount_amount,
                        sum_items_price_standard_net,
                        sum_items_price_standard_gross,
                        sum_items_price_reduced_gross,
                        sum_items_price_reduced_net,
                        delivery_fee_gross / ( 1 + tax_rate_weighted) as delivery_fee_net,
                        discount_amount / ( 1 + tax_rate_weighted) as discount_amount_net
                FROM weighted_tax_rate
            ),

            refund AS (
                SELECT order_uuid,
                       country_iso,
                       AVG(CASE WHEN transaction_type = 'refund' then transaction_amount end) as refund_amount --changed to avg
                FROM `flink-data-prod.curated.payment_transactions` pp
                where transaction_state = 'success'
                GROUP BY 1, 2
            ),

            net_gross AS (
            SELECT d.order_id,
                   order_date,
                   d.country_iso,
                   hub_code,
                   d.user_email,
                   tax_rate_weighted,
                   COALESCE(delivery_fee_net,0)                             as delivery_fee_net,
                   COALESCE(discount_amount_net,0)                          as discount_amount_net,
                   COALESCE(sum_items_price_net,0)                          as sum_items_price_net,
                   COALESCE(delivery_fee_gross,0)                           as delivery_fee_gross,
                   COALESCE(discount_amount,0)                              as discount_amount_gross,
                   COALESCE(sum_items_price_gross,0)                        as sum_items_price_gross,
                   COALESCE(sum_items_price_standard_gross,0)               as sum_items_price_standard_gross,
                   COALESCE(sum_items_price_standard_net,0)                 as sum_items_price_standard_net,
                   COALESCE(sum_items_price_reduced_gross,0)                as sum_items_price_reduced_gross,
                   COALESCE(sum_items_price_reduced_net,0)                  as sum_items_price_reduced_net,
                   COALESCE(refund_amount / ( 1 + tax_rate_weighted),0)     as refund_amount_net,
                   COALESCE(refund_amount, 0)                               as refund_amount_gross,
            FROM delivery_fees_discount d
            LEFT JOIN refund r ON r.order_uuid = d.order_uuid and r.country_iso = d.country_iso
      )
      --,raw_data as (
      SELECT order_id,
            n.country_iso,
            order_date,
            user_email,
            hub_name,
            n.hub_code,
            tax_rate_weighted,

            -- Items Data
            sum_items_price_net,
            sum_items_price_gross,
            sum_items_price_reduced_net,
            sum_items_price_reduced_gross,
            sum_items_price_standard_net,
            sum_items_price_standard_gross,
            sum_items_price_reduced_gross-sum_items_price_reduced_net as vat_items_reduced,
            sum_items_price_standard_gross-sum_items_price_standard_net as vat_items_standard,
            sum_items_price_reduced_gross+sum_items_price_standard_gross-sum_items_price_reduced_net-sum_items_price_standard_net as vat_items_total,

            --Delivery Fees Data
            delivery_fee_net,
            delivery_fee_gross,
            delivery_fee_net * (sum_items_price_reduced_net/(sum_items_price_reduced_net+sum_items_price_standard_net))            as delivery_fee_reduced_net,
            delivery_fee_net * (sum_items_price_standard_net/(sum_items_price_reduced_net+sum_items_price_standard_net))           as delivery_fee_standard_net,
            delivery_fee_net * (sum_items_price_reduced_net/(sum_items_price_reduced_net+sum_items_price_standard_net)) * tax_rate_reduced     as vat_delivery_fee_reduced,
            delivery_fee_net * (sum_items_price_standard_net/(sum_items_price_reduced_net+sum_items_price_standard_net)) * tax_rate_standard    as vat_delivery_fee_standard,
            delivery_fee_net * (sum_items_price_reduced_net/(sum_items_price_reduced_net+sum_items_price_standard_net)) * tax_rate_reduced + delivery_fee_net * (sum_items_price_standard_net/(sum_items_price_reduced_net+sum_items_price_standard_net)) * tax_rate_standard as vat_delivery_fee_total,

            -- Discount Data
            discount_amount_net,
            discount_amount_gross,
            discount_amount_net * (sum_items_price_reduced_net/(sum_items_price_reduced_net+sum_items_price_standard_net))         as discount_amount_reduced_net,
            discount_amount_net * (sum_items_price_reduced_net/(sum_items_price_reduced_net+sum_items_price_standard_net)) *tax_rate_reduced   as vat_discount_amount_reduced,
            discount_amount_net * (sum_items_price_standard_net/(sum_items_price_reduced_net+sum_items_price_standard_net))        as discount_amount_standard_net,
            discount_amount_net * (sum_items_price_standard_net/(sum_items_price_reduced_net+sum_items_price_standard_net)) *tax_rate_standard  as  vat_discount_amount_standard,
            discount_amount_net * (sum_items_price_reduced_net/(sum_items_price_reduced_net+sum_items_price_standard_net))* tax_rate_reduced + discount_amount_net * (sum_items_price_standard_net/(sum_items_price_reduced_net+sum_items_price_standard_net)) * tax_rate_standard as vat_discount_amount_total,

            --Refund Data
            refund_amount_net,
            refund_amount_gross,
            refund_amount_net * (sum_items_price_reduced_net/(sum_items_price_reduced_net+sum_items_price_standard_net)) as refund_amount_reduced_net,
            refund_amount_net * (sum_items_price_standard_net/(sum_items_price_reduced_net+sum_items_price_standard_net)) as refund_amount_standard_net,
            refund_amount_net * (sum_items_price_reduced_net/(sum_items_price_reduced_net+sum_items_price_standard_net)) * tax_rate_reduced as vat_refund_amount_reduced,
            refund_amount_net * (sum_items_price_standard_net/(sum_items_price_reduced_net+sum_items_price_standard_net)) * tax_rate_standard as vat_refund_amount_standard,
            refund_amount_net * (sum_items_price_reduced_net/(sum_items_price_reduced_net+sum_items_price_standard_net)) * tax_rate_reduced + refund_amount_net * (sum_items_price_standard_net/(sum_items_price_reduced_net+sum_items_price_standard_net)) * tax_rate_standard as vat_refund_amount_total,

            --Total VAT data
            delivery_fee_net+sum_items_price_net-refund_amount_net-discount_amount_net as total_net,
            delivery_fee_gross+sum_items_price_gross-refund_amount_gross-discount_amount_gross as total_gross,
            delivery_fee_gross+sum_items_price_gross-refund_amount_gross-discount_amount_gross-delivery_fee_net-sum_items_price_net+refund_amount_net+discount_amount_net  AS total_VAT
      FROM net_gross n
      LEFT JOIN `flink-data-prod.google_sheets.hub_metadata` g ON lower(g.hub_code) = lower(n.hub_code )
      LEFT JOIN country_tax_rates ct on ct.country_iso = n.country_iso
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: uuid {
    hidden: yes
    primary_key: yes
    type: string
    sql: concat(${order_id},${country_iso}) ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: created {
    group_label: "Order Date"
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
    sql: ${TABLE}.order_date ;;
  }

  dimension: user_email {
    type: string
    sql: ${TABLE}.user_email ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: tax_rate_weighted {
    type: number
    sql: ${TABLE}.tax_rate_weighted ;;
  }

  dimension: sum_items_price_net {
    hidden: yes
    type: number
    sql: ${TABLE}.sum_items_price_net ;;
  }

  dimension: sum_items_price_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.sum_items_price_gross ;;
  }

  dimension: sum_items_price_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.sum_items_price_reduced_net ;;
  }

  dimension: sum_items_price_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.sum_items_price_reduced_gross ;;
  }

  dimension: sum_items_price_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.sum_items_price_standard_net ;;
  }

  dimension: sum_items_price_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.sum_items_price_standard_gross ;;
  }

  dimension: vat_items_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_items_reduced ;;
  }

  dimension: vat_items_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_items_standard ;;
  }

  dimension: vat_items_total {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_items_total ;;
  }

  dimension: delivery_fee_net {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_net ;;
  }

  dimension: delivery_fee_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_gross ;;
  }

  dimension: delivery_fee_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_reduced_net ;;
  }

  dimension: delivery_fee_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_standard_net ;;
  }

  dimension: vat_delivery_fee_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_delivery_fee_reduced ;;
  }

  dimension: vat_delivery_fee_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_delivery_fee_standard ;;
  }

  dimension: vat_delivery_fee_total {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_delivery_fee_total ;;
  }

  dimension: discount_amount_net {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_net ;;
  }

  dimension: discount_amount_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_gross ;;
  }

  dimension: discount_amount_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_reduced_net ;;
  }

  dimension: vat_discount_amount_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_discount_amount_reduced ;;
  }

  dimension: discount_amount_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_standard_net ;;
  }

  dimension: vat_discount_amount_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_discount_amount_standard ;;
  }

  dimension: vat_discount_amount_total {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_discount_amount_total ;;
  }

  dimension: refund_amount_net {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_net ;;
  }

  dimension: refund_amount_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_gross ;;
  }

  dimension: refund_amount_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_reduced_net ;;
  }

  dimension: refund_amount_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_standard_net ;;
  }

  dimension: vat_refund_amount_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_refund_amount_reduced ;;
  }

  dimension: vat_refund_amount_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_refund_amount_standard ;;
  }

  dimension: vat_refund_amount_total {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_refund_amount_total ;;
  }

  dimension: total_net {
    hidden: yes
    type: number
    sql: ${TABLE}.total_net ;;
  }

  dimension: total_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.total_gross ;;
  }

  dimension: total_vat {
    hidden: yes
    type: number
    sql: ${TABLE}.total_VAT ;;
  }


  ############################  Measures   #######################

  ############################  Items.     #######################
  measure: total_sum_items_price_net {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${sum_items_price_net} ;;
  }

  measure: total_sum_items_price_gross {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${sum_items_price_gross} ;;
  }

  measure: total_sum_items_price_reduced_gross {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${sum_items_price_reduced_gross} ;;
  }

  measure: total_sum_items_price_reduced_net {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${sum_items_price_reduced_net} ;;
  }

  measure: total_sum_items_price_standard_gross {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${sum_items_price_reduced_gross} ;;
  }

  measure: total_sum_items_price_standard_net {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${sum_items_price_reduced_net} ;;
  }

  measure: sum_vat_items_reduced {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_items_reduced} ;;
  }

  measure: sum_vat_items_standard {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_items_standard} ;;
  }

  measure: sum_vat_items_total {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_items_total} ;;
  }


  ##################### Delivery Fees ##########################


  measure: sum_delivery_fee_net {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_net} ;;
  }

  measure: sum_delivery_fee_gross {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_gross} ;;
  }

  ## add df_reduced gross and df standard gross

  measure: sum_delivery_fee_reduced_net {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_reduced_net} ;;
  }


  measure: sum_delivery_fee_standard_net {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_standard_net} ;;
  }

  measure: sum_vat_delivery_fee_reduced {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_delivery_fee_reduced} ;;
  }

  measure: sum_vat_delivery_fee_standard {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_delivery_fee_standard} ;;
  }

  measure: sum_vat_delivery_fee_total {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_delivery_fee_total} ;;
  }


    ##################### Discounts  ##########################


  measure: sum_discount_amount_net {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_net} ;;
  }

  measure: sum_discount_amount_gross {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_gross} ;;
  }

  ## add df_reduced gross and df standard gross

  measure: sum_discount_amount_reduced_net {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_reduced_net} ;;
  }


  measure: sum_discount_amount_standard_net {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_standard_net} ;;
  }

  measure: sum_vat_discount_amount_reduced {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_amount_reduced} ;;
  }

  measure: sum_vat_discount_amount_standard {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_amount_standard} ;;
  }

  measure: sum_vat_discount_amount_total {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_amount_total} ;;
  }



    #####################  Refunds  ##########################


  measure: sum_refund_amount_net {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_net} ;;
  }

  measure: sum_refund_amount_gross {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_gross} ;;
  }

  ## add df_reduced gross and df standard gross

  measure: sum_refund_amount_reduced_net {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_reduced_net} ;;
  }


  measure: sum_refund_amount_standard_net {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_standard_net} ;;
  }

  measure: sum_vat_refund_amount_reduced {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_refund_amount_reduced} ;;
  }

  measure: sum_vat_refund_amount_standard {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_refund_amount_standard} ;;
  }

  measure: sum_vat_refund_amount_total {
    group_label: "* Refunds *"
    value_format: "#,##0.00€"
    type: sum
    sql: ${vat_refund_amount_total} ;;
  }


    #####################  Total VAT  ##########################

  measure: sum_total_gross {
    group_label: "* Total *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${total_gross} ;;
  }

  measure: sum_total_net {
    group_label: "* Total *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${total_net} ;;
  }

  measure: sum_total_vat {
    group_label: "* Total *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${total_vat} ;;
  }



  set: detail {
    fields: [
      order_id,
      country_iso,
      user_email,
      hub_name,
      hub_code,
      tax_rate_weighted,
      sum_items_price_net,
      sum_items_price_gross,
      sum_items_price_reduced_net,
      sum_items_price_reduced_gross,
      sum_items_price_standard_net,
      sum_items_price_standard_gross,
      vat_items_reduced,
      vat_items_standard,
      vat_items_total,
      delivery_fee_net,
      delivery_fee_gross,
      delivery_fee_reduced_net,
      delivery_fee_standard_net,
      vat_delivery_fee_reduced,
      vat_delivery_fee_standard,
      vat_delivery_fee_total,
      discount_amount_net,
      discount_amount_gross,
      discount_amount_reduced_net,
      vat_discount_amount_reduced,
      discount_amount_standard_net,
      vat_discount_amount_standard,
      vat_discount_amount_total,
      refund_amount_net,
      refund_amount_gross,
      refund_amount_reduced_net,
      refund_amount_standard_net,
      vat_refund_amount_reduced,
      vat_refund_amount_standard,
      vat_refund_amount_total,
      total_net,
      total_gross,
      total_vat
    ]
  }
}
