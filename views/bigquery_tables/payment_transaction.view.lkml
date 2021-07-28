view: payment_transaction {
  sql_table_name: `flink-data-prod.saleor_prod_global.payment_transaction`
    ;;
  drill_fields: [id]
  view_label: "* Payments *"

  dimension: id {
    primary_key: no
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: unique_id {
    group_label: "* IDs *"
    hidden: yes
    primary_key: yes
    type: number
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: action_required {
    hidden: yes
    type: yesno
    sql: ${TABLE}.action_required ;;
  }

  dimension: action_required_data {
    hidden: yes
    type: string
    sql: ${TABLE}.action_required_data ;;
  }

  dimension: already_processed {
    group_label: "* Payment Status / Type *"
    type: yesno
    sql: ${TABLE}.already_processed ;;
  }

  dimension: amount {
    hidden: yes
    group_label: "* Monetary Values *"
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: amount_logic {
    group_label: "* Monetary Values *"
    label: "Amount"
    sql:
    {% if kind._value == 'refund' %}
      ${amount} * -1
    {% else %}
      ${amount}
    {% endif %};;
  }

  dimension: country_iso {
    hidden: yes
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: created {
    group_label: "* Dates and Timestamps *"
    label: "Transaction Created"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created ;;
  }

  dimension: currency {
    hidden: yes
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: error {
    group_label: "* Payment Status / Type *"
    type: string
    sql: ${TABLE}.error ;;
  }

  dimension: gateway_response {
    hidden: yes
    type: string
    sql: ${TABLE}.gateway_response ;;
  }

  dimension: is_success {
    group_label: "* Payment Status / Type *"
    type: yesno
    sql: ${TABLE}.is_success ;;
  }

  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
  }

  dimension: payment_id {
    group_label: "* IDs *"
    type: number
    hidden: yes
    sql: ${TABLE}.payment_id ;;
  }

  dimension: searchable_key {
    hidden: yes
    type: string
    sql: ${TABLE}.searchable_key ;;
  }

  dimension: token {
    label: "Transaction Token"
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.token ;;
  }

  ####### Measures

  measure: number_of_payment_transactions {
    label: "# Transactions"
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    type: count
    drill_fields: [id]
  }

  measure: sum_amount {
    group_label: "* Monetary Values *"
    description: "If the transaction kind is refund the amount takes a negative value"
    label: "Sum Payment Transaction Amount"
    type: sum
    sql: case when ${kind} = 'refund' then ${amount} * -1 else ${amount} end ;;
  }


}
