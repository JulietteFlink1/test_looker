view: voucher_retention {
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
              from `flink-backend.saleor_db_global.order_order` o
              left join `flink-backend.saleor_db_global.discount_voucher` v
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
            select order_order.country_iso,
            order_order.user_email,
            order_order.created,
            first_order_with_voucher.created as first_order_with_voucher,
            code,
            order_order.id,
            warehouse,
            DATE_DIFF(DATE(order_order.created), DATE(first_order_with_voucher.created), DAY) as time_difference
            from `flink-backend.saleor_db_global.order_order` order_order
            left join first_order_with_voucher
            on order_order.country_iso = first_order_with_voucher.country_iso and order_order.user_email = first_order_with_voucher.user_email
            where order_order.id != first_order_with_voucher.id and order_order.user_email in (select user_email from first_order_with_voucher) and order_order.status in ('fulfilled', 'partially fulfilled')
            order by 1, 2,3 asc
          ),

          base as
          (
            select country_iso,
            code,
            warehouse,
            count(user_email) as count,
            from first_order_with_voucher
            group by 1, 2, 3
            order by 4 desc
          ),

          _7_day_retention as
          (
            select country_iso,
            code,
            warehouse,
            count(distinct(user_email)) as count
            from lead_orders
            where time_difference <= 7
            group by 1, 2, 3
            order by 4 desc
          ),

          _14_day_retention as
          (
            select country_iso,
            code,
            warehouse,
            count(distinct(user_email)) as count
            from lead_orders
            where time_difference > 7 and time_difference <= 14
            group by 1, 2, 3
            order by 3 desc
          ),

          _30_day_retention as
          (
            select country_iso,
            code,
            warehouse,
            count(distinct(user_email)) as count
            from lead_orders
            where time_difference > 14 and time_difference <= 30
            group by 1, 2, 3
            order by 3 desc
          )

          select base.country_iso,
          base.code,
          base.count as base,
          hubs.hub_name,
          _7_day_retention.count as _7_day_retention,
          _14_day_retention.count as _14_day_retention,
          _30_day_retention.count as _30_day_retention
          from base
          left join `flink-backend.gsheet_store_metadata.hubs` hubs
          on base.warehouse = lower(hubs.hub_code)
          left join _7_day_retention
          on base.country_iso = _7_day_retention.country_iso and base.code = _7_day_retention.code and base.warehouse = _7_day_retention.warehouse
          left join _14_day_retention
          on base.country_iso = _14_day_retention.country_iso and base.code = _14_day_retention.code and base.warehouse = _14_day_retention.warehouse
          left join _30_day_retention
          on base.country_iso = _30_day_retention.country_iso and base.code = _30_day_retention.code and base.warehouse = _30_day_retention.warehouse
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

  dimension: base {
    type: number
    sql: ${TABLE}.base ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
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

  ########### Measures

  measure: cnt_base {
    label: "Unique users"
    description: "Count of unique customers that used a particular code"
    type: sum
    sql: ${base} ;;
  }

  measure: cnt_7_day_retention {
    description: "Count of unique customers that used a particular code and return within 7 days after used it"
    type: sum
    sql: ${_7_day_retention} ;;
  }

  measure: cnt_14_day_retention {
    description: "Count of unique customers that used a particular code and return within 14 days after used it"
    type: sum
    sql: ${_14_day_retention} ;;
  }

  measure: cnt_30_day_retention {
    description: "Count of unique customers that used a particular code and return within 30 days after used it"
    type: sum
    sql: ${_30_day_retention} ;;
  }

  ##### Percentages

  measure: pct_7_day_retention{
    label: "% Retained users after 7 days"
    description: "Share of customers that return within 7 days after first used a voucher code"
    hidden:  no
    type: number
    sql: ${cnt_7_day_retention} / ${cnt_base};;
    value_format: "0%"
  }

  measure: pct_14_day_retention{
    label: "% Retained users after 14 days"
    description: "Share of customers that return within 14 days after first used a voucher code"
    hidden:  no
    type: number
    sql: ${cnt_14_day_retention} / ${cnt_base};;
    value_format: "0%"
  }

  measure: pct_30_day_retention{
    label: "% Retained users after 30 days"
    description: "Share of customers that return within 30 days after first used a voucher code"
    hidden:  no
    type: number
    sql: ${cnt_30_day_retention} / ${cnt_base};;
    value_format: "0%"
  }


  set: detail {
    fields: [
      country_iso,
      code,
      base,
      hub_name,
      _7_day_retention,
      _14_day_retention,
      _30_day_retention
    ]
  }
}
