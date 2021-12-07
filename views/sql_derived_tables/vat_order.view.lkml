view: vat_order {
  derived_table: {
    sql:WITH
      country_tax_rates as (
          SELECT country_iso,
                 COALESCE(AVG(CASE WHEN tax_name = 'Reduced tax category' THEN tax_rate END),0)  as tax_rate_reduced,
                 COALESCE(AVG(CASE WHEN tax_name = 'Standard tax category' THEN tax_rate END),0) as tax_rate_standard,
                 COALESCE(AVG(CASE WHEN tax_name = 'Special tax category' THEN tax_rate END) ,0) as tax_rate_special
          FROM `flink-data-prod.curated.products`
          GROUP BY 1
      ),
      orderline as (
                SELECT o.order_id,
                    oo.order_uuid,
                    oo.country_iso,
                    oo.hub_code,
                    o.customer_email as user_email,
                    o.order_date,
                    d.is_free_delivery_discount,
                    CASE WHEN p.tax_rate is NULL then 0.19 else p.tax_rate END as tax_rate ,
                    amt_unit_price_gross * quantity / (1+CASE WHEN p.tax_rate is NULL then 0.19 else p.tax_rate END)                           as item_price_net,
                    amt_unit_price_gross * quantity                                                                                            as item_price_gross,
                    CASE WHEN p.tax_name = 'Reduced tax category'
                         THEN amt_unit_price_gross * quantity / (1+CASE WHEN p.tax_rate is NULL then 0.19 else p.tax_rate END) END             as item_price_reduced_net,
                    CASE WHEN p.tax_name = 'Standard tax category' or  p.tax_name is null
                         THEN amt_unit_price_gross * quantity / (1+CASE WHEN p.tax_rate is NULL then 0.19 else p.tax_rate END) END             as item_price_standard_net,
                    CASE WHEN p.tax_name = 'Special tax category'
                         THEN amt_unit_price_gross * quantity / (1+CASE WHEN p.tax_rate is NULL then 0.19 else p.tax_rate END) END             as item_price_special_net,
                    CASE WHEN p.tax_name = 'Standard tax category' or  p.tax_name is null
                         THEN amt_unit_price_gross * quantity END                              as item_price_standard_gross,
                    CASE WHEN p.tax_name = 'Reduced tax category'
                         THEN amt_unit_price_gross * quantity END                              as item_price_reduced_gross,
                    CASE WHEN p.tax_name = 'Special tax category'
                         THEN amt_unit_price_gross * quantity END                              as item_price_special_gross,
                    CASE WHEN p.tax_name = 'Reduced tax category'
                         THEN oo.amt_discount  end                                             as discount_amount_reduced_gross,
                    CASE WHEN p.tax_name = 'Standard tax category' or p.tax_name is null
                         THEN oo.amt_discount end                                              as discount_amount_standard_gross,
                    CASE WHEN p.tax_name = 'Special tax category'
                         THEN oo.amt_discount end                                              as discount_amount_special_gross,
                    CASE WHEN p.tax_name = 'Standard tax category' or p.tax_name is null
                         THEN oo.amt_discount / (1+CASE WHEN p.tax_rate is NULL then 0.19 else p.tax_rate END) END                             as discount_amount_standard_net,
                    CASE WHEN p.tax_name = 'Reduced tax category'
                         THEN oo.amt_discount / (1+p.tax_rate) END                             as discount_amount_reduced_net,
                    CASE WHEN p.tax_name = 'Special tax category'
                         THEN oo.amt_discount / (1+p.tax_rate) END                             as discount_amount_special_net,
                    oo.amt_discount                                                            as discount_amount,
                    oo.amt_discount/(1+p.tax_rate)                                             as discount_amount_net,
                    o.amt_delivery_fee_gross                                                   as delivery_fee_gross,
                    CASE WHEN d.is_free_delivery_discount is true then o.amt_discount_gross  else 0 end  as discount_free_delivery_gross
                FROM `flink-data-prod.curated.order_lineitems` oo
                LEFT JOIN `flink-data-prod.curated.products` p ON p.country_iso = oo.country_iso and p.product_sku = oo.sku
                LEFT JOIN `flink-data-prod.curated.orders` o ON o.country_iso = oo.country_iso and o.order_uuid = oo.order_uuid
                LEFT JOIN `flink-data-prod.curated.discounts` d ON d.discount_code = o.discount_code and d.discount_id = o.discount_id
                WHERE TRUE
                AND is_successful_order is true
               -- AND p.tax_rate is not null
                --AND date_trunc(date(o.order_timestamp),month) = '2021-09-01'
                --AND date_trunc(date(o.order_timestamp),month) = '2021-09-01'
)
,
            weighted_tax_rate as (
                SELECT order_id,
                  order_uuid,
                  order_date,
                  country_iso,
                  hub_code,
                  user_email,
                  delivery_fee_gross,
                  is_free_delivery_discount,
                  discount_free_delivery_gross,
                  SUM(tax_rate * item_price_net)/SUM(item_price_net) as tax_rate_weighted,
                  SUM(item_price_net)                               as items_price_net,
                  SUM(item_price_gross)                             as items_price_gross,
                  SUM(item_price_standard_net)                      as items_price_standard_net,
                  SUM(item_price_standard_gross)                    as items_price_standard_gross,
                  SUM(item_price_special_gross)                     as items_price_special_gross,
                  SUM(item_price_reduced_gross)                     as items_price_reduced_gross,
                  SUM(item_price_reduced_net)                       as items_price_reduced_net,
                  SUM(item_price_special_net)                       as items_price_special_net,
                  SUM(discount_amount_reduced_gross)                as discount_amount_reduced_gross,
                  SUM(discount_amount_reduced_net)                  as discount_amount_reduced_net,
                  SUM(discount_amount_special_net)                  as discount_amount_special_net,
                  SUM(discount_amount_special_gross)                as discount_amount_special_gross,
                  SUM(discount_amount_standard_gross)               as discount_amount_standard_gross,
                  SUM(discount_amount_standard_net)                 as discount_amount_standard_net,
                  SUM(discount_amount)                              as discount_amount_gross,
                  SUM(discount_amount_net)                          as discount_amount_net

                FROM orderline
                GROUP BY 1,2,3,4,5,6,7,8,9
            )
            ,
            delivery_fees_discount as (
                SELECT  order_id,
                        order_uuid,
                        country_iso,
                        order_date,
                        hub_code,
                        user_email,
                        tax_rate_weighted ,
                        is_free_delivery_discount,
                        discount_free_delivery_gross,
                        items_price_net,
                        items_price_gross,
                        delivery_fee_gross,
                        CASE WHEN is_free_delivery_discount is true then 0 else delivery_fee_gross / ( 1 + tax_rate_weighted) end as delivery_fee_net,
                        items_price_standard_net,
                        items_price_standard_gross,
                        items_price_reduced_gross,
                        items_price_reduced_net,
                        items_price_special_gross,
                        items_price_special_net,
                        discount_amount_gross,
                        discount_amount_net,
                        discount_amount_reduced_net,
                        discount_amount_standard_net,
                        discount_amount_special_net,
                        discount_amount_reduced_gross,
                        discount_amount_standard_gross,
                        discount_amount_special_gross
                FROM weighted_tax_rate
            ),

            refund as (
            select order_uuid,
                  country_iso,
                  STRING_AGG(case when record_type in ('Refunded','RefundedExternally','Chargeback') then payment_method end) as payment_type,
                  SUM(case when record_type in ('Refunded','RefundedExternally','Chargeback') then captured_pc end) as refund_amount
                  from `flink-data-prod.curated.psp_transactions`
                  group by 1,2
            ),

            net_gross as (
            SELECT d.order_id,
                   order_date,
                   d.country_iso,
                   hub_code,
                   d.user_email,
                   payment_type,
                   tax_rate_weighted,
                   is_free_delivery_discount,
                   discount_free_delivery_gross,
                   COALESCE(delivery_fee_gross,0)                           as delivery_fee_gross,
                   COALESCE(delivery_fee_net,0)                             as delivery_fee_net,
                   COALESCE(discount_amount_net,0)                          as discount_amount_net,
                   COALESCE(discount_amount_gross,0)                        as discount_amount_gross,
                   COALESCE(discount_amount_reduced_net,0)                  as discount_amount_reduced_net,
                   COALESCE(discount_amount_reduced_gross,0)                as discount_amount_reduced_gross,
                   COALESCE(discount_amount_standard_net,0)                 as discount_amount_standard_net,
                   COALESCE(discount_amount_standard_gross,0)               as discount_amount_standard_gross,
                   COALESCE(discount_amount_special_net,0)                  as discount_amount_special_net,
                   COALESCE(discount_amount_special_gross,0)                as discount_amount_special_gross,
                   COALESCE(items_price_net,0)                              as items_price_net,
                   COALESCE(items_price_gross,0)                            as items_price_gross,
                   COALESCE(items_price_standard_gross,0)                   as items_price_standard_gross,
                   COALESCE(items_price_standard_net,0)                     as items_price_standard_net,
                   COALESCE(items_price_reduced_gross,0)                    as items_price_reduced_gross,
                   COALESCE(items_price_reduced_net,0)                      as items_price_reduced_net,
                   COALESCE(items_price_special_gross,0)                    as items_price_special_gross,
                   COALESCE(items_price_special_net,0)                      as items_price_special_net,
                   COALESCE(refund_amount / ( 1 + tax_rate_weighted),0)     as refund_amount_net,
                   COALESCE(refund_amount, 0)                               as refund_amount_gross,
            FROM delivery_fees_discount d
            LEFT JOIN refund r ON r.order_uuid = d.order_uuid and r.country_iso = d.country_iso
      )
--,final as (
      SELECT order_id,
            n.country_iso,
            order_date,
            user_email,
            hub_name,
            cost_center,
            n.hub_code,
            tax_rate_weighted,
            payment_type,
            is_free_delivery_discount,
            discount_free_delivery_gross,
            -- Items Data
            items_price_net,
            items_price_gross,
            items_price_reduced_net,
            items_price_reduced_gross,
            items_price_standard_net,
            items_price_standard_gross,
            items_price_special_net,
            items_price_special_gross,
            items_price_reduced_gross - items_price_reduced_net                                                             as vat_items_reduced,
            items_price_standard_gross - items_price_standard_net                                                           as vat_items_standard,
            items_price_special_gross - items_price_special_net                                                             as vat_items_special,
            items_price_reduced_gross+items_price_standard_gross+items_price_special_gross
            -items_price_reduced_net-items_price_standard_net - items_price_special_net                                     as vat_items_total,

            --Delivery Fees Data
            delivery_fee_net,
            delivery_fee_gross,
            delivery_fee_net * (items_price_reduced_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net))                           as delivery_fee_reduced_net,
            delivery_fee_net * (items_price_standard_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net))                          as delivery_fee_standard_net,
            delivery_fee_net * (items_price_special_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net))                           as delivery_fee_special_net,
            delivery_fee_net * (items_price_standard_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * (1+tax_rate_standard)  as delivery_fee_standard_gross,
            delivery_fee_net * (items_price_reduced_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * (1+tax_rate_reduced)    as delivery_fee_reduced_gross,
            delivery_fee_net * (items_price_special_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * (1+tax_rate_special)    as delivery_fee_special_gross,
            delivery_fee_net * (items_price_reduced_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * tax_rate_reduced        as vat_delivery_fee_reduced,
            delivery_fee_net * (items_price_standard_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * tax_rate_standard      as vat_delivery_fee_standard,
            delivery_fee_net * (items_price_special_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * tax_rate_special        as vat_delivery_fee_special,
            delivery_fee_net * (items_price_reduced_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * tax_rate_reduced
            + delivery_fee_net * (items_price_standard_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * tax_rate_standard
            + delivery_fee_net * (items_price_special_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * tax_rate_special      as vat_delivery_fee_total,

            -- Discount Data
            discount_amount_net,
            discount_amount_gross,
            discount_amount_reduced_net,
            discount_amount_standard_net,
            discount_amount_special_net,
            discount_amount_reduced_gross,
            discount_amount_standard_gross,
            discount_amount_special_gross,
            discount_amount_reduced_gross  - discount_amount_reduced_net                                                                 as vat_discount_amount_reduced,
            discount_amount_standard_gross - discount_amount_standard_net                                                                as vat_discount_amount_standard,
            discount_amount_special_gross  - discount_amount_special_net                                                                 as vat_discount_amount_special,
            discount_amount_reduced_gross + discount_amount_standard_gross + discount_amount_special_gross
            - discount_amount_reduced_net - discount_amount_standard_net - discount_amount_special_net                                   as vat_discount_amount_total,

            --Refund Data
            refund_amount_net,
            refund_amount_gross,
            refund_amount_net * (items_price_reduced_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net))                            as refund_amount_reduced_net,
            refund_amount_net * (items_price_standard_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net))                           as refund_amount_standard_net,
            refund_amount_net * (items_price_special_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net))                            as refund_amount_special_net,
            refund_amount_net * (items_price_reduced_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * (1+tax_rate_reduced)     as refund_amount_reduced_gross,
            refund_amount_net * (items_price_standard_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * (1+tax_rate_standard)   as refund_amount_standard_gross,
            refund_amount_net * (items_price_special_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * (1+tax_rate_special)     as refund_amount_special_gross,
            refund_amount_net * (items_price_reduced_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * tax_rate_reduced         as vat_refund_amount_reduced,
            refund_amount_net * (items_price_standard_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * tax_rate_standard       as vat_refund_amount_standard,
            refund_amount_net * (items_price_special_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * tax_rate_special         as vat_refund_amount_special,
            refund_amount_net * (items_price_reduced_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * tax_rate_reduced
            + refund_amount_net * (items_price_standard_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * tax_rate_standard
            + refund_amount_net * (items_price_special_net/(items_price_reduced_net+items_price_standard_net+items_price_special_net)) * tax_rate_special       as vat_refund_amount_total,

            --Total VAT data
            delivery_fee_net+items_price_net-refund_amount_net-discount_amount_net                                                                                  as total_net,
            delivery_fee_gross+items_price_gross-refund_amount_gross-discount_amount_gross                                                                          as total_gross,
            delivery_fee_gross+items_price_gross-refund_amount_gross-discount_amount_gross-delivery_fee_net-items_price_net+refund_amount_net+discount_amount_net   as total_VAT
      FROM net_gross n
      LEFT JOIN `flink-data-prod.curated.hubs` g ON lower(g.hub_code) = lower(n.hub_code )
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

  dimension_group: order {
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

  dimension: is_free_delivery_discount {
    type: yesno
    sql: ${TABLE}.is_free_delivery_discount ;;
  }

  dimension: discount_free_delivery_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.discount_free_delivery_gross ;;
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

  dimension: cost_center {
    type: string
    sql: ${TABLE}.cost_center ;;
  }

  dimension: payment_type {
    type: string
    sql: ${TABLE}.payment_type ;;
  }
######## ITEMS ############
  dimension: items_price_net {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_net ;;
  }

  dimension: items_price_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_gross ;;
  }

  dimension: items_price_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_reduced_net ;;
  }

  dimension: items_price_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_reduced_gross ;;
  }

  dimension: items_price_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_special_net ;;
  }

  dimension: items_price_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_special_gross ;;
  }

  dimension: items_price_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_standard_net ;;
  }

  dimension: items_price_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_standard_gross ;;
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

  dimension: vat_items_special{
    hidden: yes
    type: number
    sql: ${TABLE}.vat_items_special ;;
  }

  dimension: vat_items_total {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_items_total ;;
  }

############## DELIVERY FEES #############
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

  dimension: delivery_fee_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_special_net ;;
  }

  dimension: delivery_fee_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_reduced_gross ;;
  }

  dimension: delivery_fee_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_standard_gross ;;
  }

  dimension: delivery_fee_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_special_gross ;;
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

  dimension: vat_delivery_fee_special {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_delivery_fee_special ;;
  }

  dimension: vat_delivery_fee_total {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_delivery_fee_total ;;
  }


  ############## DISCOUNTS #############

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

  dimension: discount_amount_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_reduced_gross ;;
  }

  dimension: discount_amount_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_special_net ;;
  }

  dimension: discount_amount_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_special_gross ;;
  }

  dimension: discount_amount_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_standard_gross ;;
  }

  dimension: discount_amount_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_standard_net ;;
  }

  dimension: vat_discount_amount_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_discount_amount_reduced ;;
  }

  dimension: vat_discount_amount_special {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_discount_amount_special ;;
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

  ############### REFUNDS #############

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

  dimension: refund_amount_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_special_net ;;
  }

  dimension: refund_amount_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_reduced_gross ;;
  }

  dimension: refund_amount_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_standard_gross ;;
  }

  dimension: refund_amount_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_special_gross ;;
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

  dimension: vat_refund_amount_special{
    hidden: yes
    type: number
    sql: ${TABLE}.vat_refund_amount_special ;;
  }

  dimension: vat_refund_amount_total {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_refund_amount_total ;;
  }


######## TOTALS #########

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

  dimension: total_gross_bins {
    hidden: no
    type: string
    sql: case when ${total_gross} < 10 THEN '<10'
          when ${total_gross}  >= 10 and ${total_gross}  < 12 THEN '10-12'
          when ${total_gross}  >= 12 and ${total_gross}  < 14 THEN '12-14'
          when ${total_gross}  >= 14 and ${total_gross}  < 20 THEN '14-20'
          when ${total_gross}  >= 20 and ${total_gross}  < 30 THEN '20-30'
          when ${total_gross}  >= 30 THEN '>30' end;;
  }

  dimension: total_item_delivery_fee_bins {
    hidden: no
    type: string
    sql: case when ${items_price_gross} + ${delivery_fee_gross} < 10 THEN '<10'
          when ${items_price_gross} + ${delivery_fee_gross}  >= 10 and ${items_price_gross} + ${delivery_fee_gross}   < 12 THEN '10-12'
          when ${items_price_gross} + ${delivery_fee_gross}   >= 12 and ${items_price_gross} + ${delivery_fee_gross}  < 14 THEN '12-14'
          when ${items_price_gross} + ${delivery_fee_gross}  >= 14 and ${items_price_gross} + ${delivery_fee_gross}  < 20 THEN '14-20'
          when ${items_price_gross} + ${delivery_fee_gross}  >= 20 and ${items_price_gross} + ${delivery_fee_gross} < 30 THEN '20-30'
          when ${items_price_gross} + ${delivery_fee_gross} >= 30 THEN '>30' end;;
  }


  dimension: total_vat {
    hidden: yes
    type: number
    sql: ${TABLE}.total_VAT ;;
  }


  ############################  Measures   #######################

  ############################  Items.     #######################
  measure: sum_items_price_net {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_net} ;;
  }

  measure: sum_items_price_gross {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_gross} ;;
  }

  measure: sum_items_price_reduced_gross {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_reduced_gross} ;;
  }

  measure: sum_items_price_reduced_net {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_reduced_net} ;;
  }

  measure: sum_items_price_special_gross {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_special_gross} ;;
  }

  measure: sum_items_price_special_net {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_special_net} ;;
  }

  measure: sum_items_price_standard_gross {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_standard_gross} ;;
  }

  measure: sum_items_price_standard_net {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_standard_net} ;;
  }

  measure: sum_vat_items_reduced {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_items_reduced} ;;
  }

  measure: sum_vat_items_special {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_items_special} ;;
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

  measure: sum_delivery_fee_special_net {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_special_net} ;;
  }

  measure: sum_delivery_fee_special_gross {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_special_gross} ;;
  }

  measure: sum_delivery_fee_reduced_gross {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_reduced_gross} ;;
  }

  measure: sum_delivery_fee_standard_gross {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_standard_gross} ;;
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

  measure: sum_vat_delivery_fee_special {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_delivery_fee_special} ;;
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

  measure: sum_discount_amount_special_net {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_special_net} ;;
  }

  measure: sum_discount_amount_reduced_gross {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_reduced_gross} ;;
  }

  measure: sum_discount_amount_special_gross {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_special_gross} ;;
  }

  measure: sum_discount_amount_standard_gross {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_standard_gross} ;;
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

  measure: sum_vat_discount_amount_special {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_amount_special} ;;
  }

  measure: sum_vat_discount_amount_total {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_amount_total} ;;
  }

  measure: sum_discount_amount_free_delivery_gross {
    group_label: "* Discounts *"
    value_format: "#,##0.00€"
    type: sum
    sql: ${discount_free_delivery_gross} ;;
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

  measure: sum_refund_amount_special_net {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_special_net} ;;
  }

  measure: sum_refund_amount_reduced_gross {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_reduced_gross} ;;
  }

  measure: sum_refund_amount_standard_gross {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_standard_gross} ;;
  }

  measure: sum_refund_amount_special_gross {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_special_gross} ;;
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

  measure: sum_vat_refund_amount_special {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_refund_amount_special} ;;
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
    description: "Items Gross + DF Gross - Discounts Gross - Refunds Gross"
    value_format: "#,##0.00€"
    sql: ${total_gross} ;;
  }

  measure: sum_total_net {
    group_label: "* Total *"
    type: sum
    description: "Items Net + DF Net - Discounts Net - Refunds Net"
    value_format: "#,##0.00€"
    sql: ${total_net} ;;
  }

  measure: sum_total_vat {
    group_label: "* Total *"
    type: sum
    description: "Total Gross - Total Net"
    value_format: "#,##0.00€"
    sql: ${total_vat} ;;
  }



  set: detail {
    fields: [
    ]
  }
}
