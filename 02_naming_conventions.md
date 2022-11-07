# 02 Naming Conventions




### [1] Use lowercase letters and underscores for spaces in all LookML objects

```yaml
✅dimension_group: has_ordered { ✅✅✅
🙅dimension_group: Has_Ordered { ❌❌❌
type: yesno
sql: ${TABLE}.has_ordered ;;
}
```


### [2] Use **sum_of_[field]** for sum measures

```yaml
✅measure: sum_of_order_value { ✅✅✅
🙅measure: order_value_sum { ❌❌❌
🙅measure: order_value { ❌❌❌
  type: sum
  sql: ${total} ;;
}
```


### [3] Use **number_of_[field]** for count measures

```yaml
✅measure: number_of_orders { ✅✅✅
🙅measure: orders_count { ❌❌❌
🙅measure: orders { ❌❌❌
  type: count
}
```

### [3] Use **number_of_unique_[field]** for count distinct measures

```yaml
✅measure: number_of_unique_customers  ✅✅✅
🙅measure: customers_count_distinct { ❌❌❌
🙅measure: customers { ❌❌❌
  type: count_distinct
}
```


### [4] Use **avg_[field]** for average measures

```yaml
✅measure: avg_order_value { ✅✅✅
🙅measure: order_value_avg { ❌❌❌
  type: average
  sql: ${total} ;;
}
```


### [5] Use **share_of_X_with_Y** for ratios, to ensure clear understanding

```yaml
✅measure: share_of_orders_with_missing_products  ✅✅✅
🙅measure: pct_missing_products { ❌❌❌
  type: number
  sql: 1.0*${number_of_orders_missing_products}/nullif(${number_of_orders},0) ;;
}
```


### [6] Use **is_[field]** or **has_[field]** for yes/no dimensions

```yaml
✅measure: is_first_customer_order { ✅✅✅
🙅measure: first_customer_order { ❌❌❌
  type: yesno
  sql:  ${TABLE}.is_first_customer_order ;;
}
```


### [7] **Do not reference date/time in time dimension groups** to avoid, for example, date_date

```yaml
✅measure: ordered { ✅✅✅
🙅measure: ordered_date { ❌❌❌
  type: time
  timeframes: [
    date,
    week,
    month,
    year
  ]
  sql: ${TABLE}.ordered_at_timestamp ;;
}
```
