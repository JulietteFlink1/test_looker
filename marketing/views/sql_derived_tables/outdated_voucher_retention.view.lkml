view: outdated_voucher_retention {
  derived_table: {
    sql: with voucher_codes_orders as
        (
              select o.country_iso,
              o.user_email,
              o.id,
              o.created,
              CASE WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
                    WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
                    ELSE JSON_EXTRACT_SCALAR(metadata, '$.warehouse') end as warehouse,
              v.code,
              ROW_NUMBER() OVER ( PARTITION BY o.country_iso, o.user_email ORDER BY o.created asc) AS rank
              from `flink-data-prod.saleor_prod_global.order_order` o
              left join `flink-data-prod.saleor_prod_global.discount_voucher` v
              on o.voucher_id = v.id and o.country_iso=v.country_iso
              where v.code is not null and o.status in ('fulfilled', 'partially fulfilled')
          ),

          first_order_with_voucher as
          (
            select country_iso,
            user_email,
            created,
            id,
            code,
            warehouse
            from voucher_codes_orders
            where rank = 1
          ),

          lead_orders as
          (
            select first_order_with_voucher.country_iso,
            first_order_with_voucher.user_email,
            order_order.created,
            first_order_with_voucher.created as first_order_with_voucher,
            code,
            order_order.id,
            first_order_with_voucher.warehouse,
            DATE_DIFF(DATE(order_order.created), DATE(first_order_with_voucher.created), DAY) as time_difference
            from `flink-data-prod.saleor_prod_global.order_order` order_order
            left join first_order_with_voucher
            on order_order.country_iso = first_order_with_voucher.country_iso and order_order.user_email = first_order_with_voucher.user_email
            where order_order.id != first_order_with_voucher.id and order_order.user_email in (select user_email from first_order_with_voucher) and order_order.status in ('fulfilled', 'partially fulfilled')
            order by 1, 2, 3 asc
          ),

          retention as
          (
            select distinct country_iso,
            user_email,
            warehouse,
            code,
            max(case when (time_difference <= 7 and date_diff(CURRENT_DATE(), date(first_order_with_voucher), DAY) >= 7) then 1 else 0 end) as _7_day_retention,
            max(case when (time_difference <= 14 and time_difference > 7 and date_diff(CURRENT_DATE(), date(first_order_with_voucher), DAY) >= 14) then 1 else 0 end) as _14_day_retention,
            max(case when (time_difference <= 30 and time_difference > 14 and date_diff(CURRENT_DATE(), date(first_order_with_voucher), DAY) >= 30) then 1 else 0 end) as _30_day_retention
            from lead_orders
            group by 1, 2, 3, 4
          ),

          base_7 as
          (
            select country_iso,
            code,
            warehouse,
            count(distinct(user_email)) as count,
            from first_order_with_voucher
            where date_diff(CURRENT_DATE(), date(first_order_with_voucher.created), DAY) >= 7
            group by 1, 2, 3
            order by 4 desc
          ),

          base_14 as
          (
            select country_iso,
            code,
            warehouse,
            count(distinct(user_email)) as count,
            from first_order_with_voucher
            where date_diff(CURRENT_DATE(), date(first_order_with_voucher.created), DAY) >= 14
            group by 1, 2, 3
            order by 4 desc
          ),

          base_30 as
          (
            select country_iso,
            code,
            warehouse,
            count(distinct(user_email)) as count,
            from first_order_with_voucher
            where date_diff(CURRENT_DATE(), date(first_order_with_voucher.created), DAY) >= 30
            group by 1, 2, 3
            order by 4 desc
          ),

          _7_day_retention as
          (
            select country_iso,
            code,
            warehouse,
            sum(_7_day_retention) as count
            from retention
            group by 1, 2, 3
            order by 4 desc
          ),

          _14_day_retention as
          (
            select country_iso,
            code,
            warehouse,
            sum(_14_day_retention) as count
            from retention
            group by 1, 2, 3
            order by 3 desc
          ),

          _30_day_retention as
          (
            select country_iso,
            code,
            warehouse,
            sum(_30_day_retention) as count
            from retention
            group by 1, 2, 3
            order by 3 desc
          )

          select base_7.country_iso,
          base_7.code,
          base_7.count as base_7,
          base_14.count as base_14,
          base_30.count as base_30,
          hubs.hub_name,
          hubs.city,
          _7_day_retention.count as _7_day_retention,
          _14_day_retention.count as _14_day_retention,
          _30_day_retention.count as _30_day_retention
          from base_7
          left join base_14
          on base_7.country_iso = base_14.country_iso and base_7.code=base_14.code and base_7.warehouse=base_14.warehouse
          left join base_30
          on base_7.country_iso = base_30.country_iso and base_7.code=base_30.code and base_7.warehouse=base_30.warehouse
          left join `flink-backend.gsheet_store_metadata.hubs` hubs
          on base_7.warehouse = lower(hubs.hub_code)
          left join _7_day_retention
          on base_7.country_iso = _7_day_retention.country_iso and base_7.code = _7_day_retention.code and base_7.warehouse = _7_day_retention.warehouse
          left join _14_day_retention
          on base_7.country_iso = _14_day_retention.country_iso and base_7.code = _14_day_retention.code and base_7.warehouse = _14_day_retention.warehouse
          left join _30_day_retention
          on base_7.country_iso = _30_day_retention.country_iso and base_7.code = _30_day_retention.code and base_7.warehouse = _30_day_retention.warehouse
          order by base_7 desc
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: code {
    type: string
    sql: ${TABLE}.code ;;
  }

  dimension: base_7 {
    type: number
    sql: ${TABLE}.base_7 ;;
  }

  dimension: base_14 {
    type: number
    sql: ${TABLE}.base_14 ;;
  }

  dimension: base_30 {
    type: number
    sql: ${TABLE}.base_30 ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: _7_day_retention {
    type: number
    sql: ${TABLE}._7_day_retention ;;
  }

  dimension: _14_day_retention {
    type: number
    sql: ${TABLE}._14_day_retention ;;
  }

  dimension: _30_day_retention {
    type: number
    sql: ${TABLE}._30_day_retention ;;
  }

  dimension: country_name {
    type: string
    sql: CASE WHEN ${country_iso} = "DE" then "Germany"
    WHEN ${country_iso} = "NL" then "Netherlands"
    ELSE 'France' end ;;
  }

  ######## Measures

  measure: cnt_base_7 {
    type: sum
    sql: ${base_7} ;;
  }

  measure: cnt_base_14 {
    type: sum
    sql: ${base_14} ;;
  }

  measure: cnt_base_30 {
    type: sum
    sql: ${base_30} ;;
  }

  measure: cnt_7_day_retention {
    type: sum
    sql: ${_7_day_retention} ;;
  }

  measure: cnt_14_day_retention {
    type: sum
    sql: ${_14_day_retention} ;;
  }

  measure: cnt_30_day_retention {
    type: sum
    sql: ${_30_day_retention} ;;
  }

  set: detail {
    fields: [
      country_iso,
      city,
      code,
      base_7,
      base_14,
      base_30,
      hub_name,
      _7_day_retention,
      _14_day_retention,
      _30_day_retention
    ]
  }
}
