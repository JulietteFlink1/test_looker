# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-11-22

view: stock_checks_acum {
  derived_table: {
    sql: with

completed_checks as (
  select
    date(prep_event_stock_check.fe_finished_at_timestamp) as finished_at
  , daily_hub_tasks.country_iso
  , daily_hub_tasks.hub_code
  , daily_hub_tasks.task_type
  , daily_hub_tasks.task_reason
  , daily_hub_tasks.finished_by
  , count(distinct prep_event_stock_check.check_id) as number_of_completed_checks
  , count(distinct if(daily_hub_tasks.is_correction,prep_event_stock_check.check_id, null)) as number_of_corrections
  from `flink-data-prod.reporting.prep_event_stock_check` as prep_event_stock_check
  left join `flink-data-prod.curated.daily_hub_tasks` as daily_hub_tasks
    on daily_hub_tasks.task_id = prep_event_stock_check.check_id
    and date(created_at_timestamp) >= '2023-01-01'


  where
    {% condition global_filters_and_parameters.datasource_filter %} date(prep_event_stock_check.fe_started_at_timestamp) {% endcondition %}

  group by 1,2,3,4,5,6
)

, raw_hub_tasks as (
          select
    date(created_at_timestamp) as created_at
  , hub_code
  , country_iso
  , task_type
  , task_reason
  , task_status
  , finished_by
  , date(updated_at_timestamp) as updated_at
  , task_id
  from `flink-data-prod.curated.daily_hub_tasks`
        where date(created_at_timestamp) >= '2023-01-01'

  union all

  select
   created_at
   , hub_code
   , country_iso
   , task_type
   , task_reason
   , null task_status
   , null as finished_by
   , null as updated_at
   , null as task_id
  from
    (select
      date(created_at_timestamp) as created_at
    , hub_code
    , country_iso
    from `flink-data-prod.curated.daily_hub_tasks`
    where
      {% condition global_filters_and_parameters.datasource_filter %} date(created_at_timestamp) {% endcondition %}

    group by 1,2,3)
    cross join
    (select distinct task_type, task_reason
    from `flink-data-prod.curated.daily_hub_tasks`
          where date(created_at_timestamp) >= '2023-01-01')
)

, available_checks as (
  select
    created_at
  , hub_code
  , country_iso
  , task_type
  , task_reason
  , finished_by
  , number_of_created_checks
  , number_of_remaining_checks
  from
    (
      select
        created_at
      , hub_code
      , country_iso
      , task_type
      , task_reason
      , finished_by
      -- adding a partition by clause to number_of_created_checks to be able to run the count of acum_checks in the same CTE
      -- to do so I need to avoid using group by
      , count(if((task_status not in ('CANCELED'))
          or (task_status in ('CANCELED') and updated_at>created_at), task_id, null))
          over (partition by created_at, hub_code, task_type, task_reason, finished_by) as number_of_created_checks
      , count(if(task_status in ('OPEN', 'SKIPPED', 'IN_PROGRESS')
              or (task_status in ('DONE', 'CANCELED') and updated_at>created_at)
              , task_id, null))
          over (partition by hub_code, task_type, task_reason, finished_by order by UNIX_DATE(created_at)
      RANGE BETWEEN 30 PRECEDING AND 1 preceding) AS number_of_remaining_checks
      from raw_hub_tasks
    )
  group by 1,2,3,4,5,6,7,8
)

select
    available_checks.country_iso
  , available_checks.hub_code
  , available_checks.created_at
  , available_checks.task_type
  , available_checks.task_reason
  , available_checks.finished_by
  , available_checks.number_of_created_checks
  , available_checks.number_of_remaining_checks
  , completed_checks.number_of_completed_checks
  , completed_checks.number_of_corrections
from
  available_checks
  left join completed_checks on available_checks.hub_code = completed_checks.hub_code
    and available_checks.created_at = completed_checks.finished_at
    and available_checks.task_type = completed_checks.task_type
    and available_checks.task_reason = completed_checks.task_reason
    and available_checks.finished_by = completed_checks.finished_by

 ;;
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    dimension: country_iso {
      description: "Country ISO based on 'hub_code'."
    }
    dimension: hub_code {
      description: "Code of a hub identical to back-end source tables."
    }
    dimension: created_at {
      description: "Date for when the task has been created. Corresponds to created_at timestamp in hub_task schema."
    }
    # dimension: is_automatic_check {
    #   description: "TRUE when the check was scheduled."
    #   type: yesno
    # }
    dimension: task_type {
      description: "  Type of task. Corresponds to the type in hub_task schema. Possible values are: STOCK_CHECK, FRESHNESS_CHECK."
    }
    dimension: task_reason {
      description: "  Reason why we performed task. Corresponds to the reason in hub_task schema. Possible values are: MISSING, TOBACCO, EXPENSIVE, FRESHNESS, ROLLING_8_WEEKS, ROLLING_12_WEEKS, LOW_STOCK."
    }

  dimension: finished_by {
    description: "Quinyx_badge_number of the employee who finished the task. Corresponds to ended_by in hub_task schema."
  }

    # dimension: number_of_open_checks {
    #   label: "1 Hub One Inventory Checking # of Open Tasks"
    #   description: "Number of open tasks (task_status = open)."
    #   type: number
    # }
    # dimension: number_of_skipped_checks {
    #   label: "1 Hub One Inventory Checking # of Skipped Tasks"
    #   description: "Number of skipped tasks (task_status = skipped)."
    #   type: number
    # }
    # dimension: number_of_completed_checks {
    #   label: "1 Hub One Inventory Checking # of Completed Tasks"
    #   description: "Number of completed tasks (task_status = done)."
    #   type: number
    # }
    # dimension: number_of_open_completed_skipped_checks {
    #   label: "1 Hub One Inventory Checking # of Open, Completed and Skipped Tasks"
    #   description: "Number of open and completed tasks (task_status = open, done, skipped)."
    #   type: number
    # }
    measure: number_of_created_checks {
      label: "# of Created Tasks"
      description: "Number of Tasks created that day."
      type: sum
    }

  measure: number_of_remaining_checks {
    label: "# of Remaining Tasks"
    description: "Number of Remaining Tasks from previous days."
    type: sum
  }

  measure: number_of_completed_checks {
    label: "# of Completed Tasks"
    description: "Number of completed tasks (task_status = done)."
    type: sum
  }

  measure: number_of_corrections {
    label: "# of Corrections"
    description: "Number of corrections."
    type: sum
  }

  measure: pct_of_completion {
    label: "% of Completion"
    description: "Number of corrections."
    sql: ${number_of_completed_checks}/nullif((${number_of_created_checks}+${number_of_remaining_checks}),0)  ;;
  }
    # dimension: number_of_items_corrected {
    #   label: "1 Hub One Inventory Checking # of Items Corrected"
    #   description: "Number of items corrected (count_distinct skus with corrections)."
    #   type: number
    # }
    # dimension: number_of_corrections {
    #   label: "1 Hub One Inventory Checking # of Corrections"
    #   description: "Number of corrections."
    #   type: number
    # }
    # dimension: pct_of_completion {
    #   label: "1 Hub One Inventory Checking % of Completion"
    #   description: "# of Completed Tasks/ (# of Completed Tasks + # of Open Tasks + # of Skipped Tasks)"
    #   value_format: "0%"
    #   type: number
    # }
    # dimension: corrections_per_completed_checks {
    #   label: "1 Hub One Inventory Checking % of Corrections"
    #   description: "# of Corrections/ # of Completed Tasks."
    #   value_format: "0%"
    #   type: number
    # }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # Note that for this measures to be accurate we need to use sum_distinct with sql_distinct_key = primary_key
  # This is because this view is being joined to event_inbound_progressed and if we use a normal sum it will be suming
  # duplicate values

}
