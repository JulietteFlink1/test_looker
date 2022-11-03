# Created by: Andreas Stueber
# Created for: Pricing and Commercial teams

# Context:
# The data was provide by a company called Targomo. It shows demographic data already on aggregated on the level of a hub_code

view: hub_demographics {
  sql_table_name: `flink-data-prod.curated.hub_demographics`
    ;;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Exposed Dimensions
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Join Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Hidden Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: area_sqkm {
    label: "Area (square km)"
    type: number
    sql: ${TABLE}.area_sqkm ;;
    hidden: yes
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: hub_demographics_uuid {
    type: string
    sql: ${TABLE}.hub_demographics_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: avg_household_spending_power {
    type: number
    sql: ${TABLE}.avg_household_spending_power ;;
    hidden: yes
  }

  dimension: avg_inhabitant_spending_power {
    type: number
    sql: ${TABLE}.avg_inhabitant_spending_power ;;
    hidden: yes
  }

  dimension: spending_power {
    type: number
    sql: ${TABLE}.spending_power ;;
    hidden: yes
  }

  dimension: supermarket {
    type: number
    sql: ${TABLE}.supermarket ;;
    hidden: yes
  }

  dimension: food_and_beverages_stores {
    type: number
    sql: ${TABLE}.food_and_beverages_stores ;;
    hidden: yes
  }

  dimension: unemployed {
    type: number
    sql: ${TABLE}.unemployed ;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~  Age Distribution  ~~~~~~~~~~~~~~

  dimension: age_0_to_14_years {
    label: "Age 0-14 years"
    description: "The share of residents in the age range of 0 and 14"
    group_label: "Age Distribution"
    type: number
    sql: ${TABLE}.age_0_to_14_years ;;
    hidden: yes
  }

  dimension: age_15_to_29_years {
    label: "Age 15-29 years"
    description: "The share of residents in the age range of 15 and 29"
    group_label: "Age Distribution"
    type: number
    sql: ${TABLE}.age_15_to_29_years ;;
    hidden: yes
  }

  dimension: age_30_to_44_years {
    label: "Age 30-44 years"
    description: "The share of residents in the age range of 30 and 44"
    group_label: "Age Distribution"
    type: number
    sql: ${TABLE}.age_30_to_44_years ;;
    hidden: yes
  }

  dimension: age_45_to_59_years {
    label: "Age 45-59 years"
    description: "The share of residents in the age range of 45 and 59"
    group_label: "Age Distribution"
    type: number
    sql: ${TABLE}.age_45_to_59_years ;;
    hidden: yes
  }

  dimension: age_60_plus_years {
    label: "Age 60+ years"
    description: "The share of residents in the age range of 60+"
    group_label: "Age Distribution"
    type: number
    sql: ${TABLE}.age_60_plus_years ;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~  Population  ~~~~~~~~~~~~~~
  dimension: population {
    label: "Residents"
    description: "The number of people living in the specified hub turf"
    group_label: "Population Based Metrics"
    type: number
    sql: ${TABLE}.population ;;
    hidden: yes
  }

  dimension: population_female {
    label: "Residents Female"
    description: "The number of female people living in the specified hub turf"
    group_label: "Population Based Metrics"
    type: number
    sql: ${TABLE}.population_female ;;
    hidden: yes
  }

  dimension: population_male {
    label: "Residents Male"
    description: "The number of male people living in the specified hub turf"
    group_label: "Population Based Metrics"
    type: number
    sql: ${TABLE}.population_male ;;
    hidden: yes
  }

  dimension: total_households {
    label: "Total Households"
    description: "The number of households located in the specified hub turf"
    group_label: "Population Based Metrics"
    type: number
    sql: ${TABLE}.total_households ;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~  Household Income  ~~~~~~~~~~~~~~

  dimension: income_group_1 {
    label: "Income Group 1"
    description: "According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    For DE, Targomo provided 6 income groups - hereby group 1 and 2 have been combined, resulting in the following income ranges: DE: 0-1500€ monthly, FR: 0-20976€ yearly, NL: 0-20726€ yearly, AT: 0-23821€ yearly"
    group_label: "Income Based Metrics"
    hidden: yes
    type: number
    sql: ${TABLE}.income_group_1 ;;
  }

  dimension: income_group_2 {
    label: "Income Group 2"
    description: "According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group
    Group 2 has the following income ranges: DE: 1500-2500€ monthly, FR: 20976-31570€ yearly, NL: 20726-30548€ yearly, AT: 23821-36842€ yearly"
    group_label: "Income Based Metrics"
    hidden: yes
    type: number
    sql: ${TABLE}.income_group_2 ;;
  }

  dimension: income_group_3 {
    label: "Income Group 3"
    description: "According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 3 has the following income ranges: DE: 2500-3500€ monthly, FR: 31570-44502€ yearly, NL: 30548-42958€ yearly, AT: 36842-51485€ yearly"
    group_label: "Income Based Metrics"
    hidden: yes
    type: number
    sql: ${TABLE}.income_group_3 ;;
  }

  dimension: income_group_4 {
    label: "Income Group 4"
    description: "According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 4 has the following income ranges: DE: 3500-5000€ monthly, FR: 44502-63178€ yearly, NL: 42958-61041€ yearly, AT: 51485-72697€ yearly"
    group_label: "Income Based Metrics"
    hidden: yes
    type: number
    sql: ${TABLE}.income_group_4 ;;
  }

  dimension: income_group_5 {
    label: "Income Group 5"
    description: "According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 5 has the following income ranges: DE: 5000+€ monthly, FR: 63178+€ yearly, NL: 61041+€ yearly, AT: 72697+€ yearly"
    group_label: "Income Based Metrics"
    hidden: yes
    type: number
    sql: ${TABLE}.income_group_5 ;;
  }



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Exposed Measures
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # ~~~~~~~~~~~~~~  Area  ~~~~~~~~~~~~~~
  measure: sum_supermarkets {
    label: "# Supermarkets"
    description: "The total amount of all supermarkets"
    group_label: "Area Based Metrics"
    type: sum
    sql: ${supermarket} ;;
    value_format_name: decimal_0
  }

  measure: avg_supermarkets {
    label: "AVG # Supermarkets"
    description: "The average number of supermarkets"
    group_label: "Area Based Metrics"
    type: average
    sql: ${supermarket} ;;
    value_format_name: decimal_0
  }

  measure: sum_food_and_beverages_stores {
    label: "# Food & Beverages Stores"
    description: "The total amount of all food & beverages stores"
    group_label: "Area Based Metrics"
    type: sum
    sql: ${food_and_beverages_stores} ;;
    value_format_name: decimal_0
  }

  measure: avg_food_and_beverages_stores {
    label: "AVG # Food & Beverages Stores"
    description: "The average amount of all food & beverages stores"
    group_label: "Area Based Metrics"
    type: average
    sql: ${food_and_beverages_stores} ;;
    value_format_name: decimal_0
  }

  measure: sum_area_sqkm {
    label: "Total Area (square km)"
    description: "The total area in square kilometers"
    group_label: "Area Based Metrics"
    type: sum
    sql: ${area_sqkm} ;;
    value_format_name: decimal_0
  }

  measure: avg_area_sqkm {
    label: "AVG Area (square km)"
    description: "The average area in square kilometers across hub turfs"
    group_label: "Area Based Metrics"
    type: average
    sql: ${area_sqkm} ;;
    value_format_name: decimal_1
  }

  # ~~~~~~~~~~~~~~  Population  ~~~~~~~~~~~~~~

  measure: sum_population {
    label: "# Residents"
    description: "The number of people living in the specified hub turf"
    group_label: "Population Based Metrics"
    type: sum
    sql: ${population} ;;
    value_format_name: decimal_0
  }

  measure: sum_population_female {
    label: "# Female Residents"
    description: "The number of female people living in the specified hub turf"
    group_label: "Population Based Metrics"
    type: sum
    sql: ${population_female} ;;
    value_format_name: decimal_0
  }

  measure: sum_population_male {
    label: "# Male Residents"
    description: "The number of male people living in the specified hub turf"
    group_label: "Population Based Metrics"
    type: sum
    sql: ${population_male} ;;
    value_format_name: decimal_0
  }

  measure: sum_total_households {
    label: "# Households"
    description: "The number of households located in the specified hub turf"
    group_label: "Population Based Metrics"
    type: sum
    sql: ${total_households} ;;
    value_format_name: decimal_0
  }

  measure: avg_population {
    label: "AVG # Residents"
    description: "The average number of people living in the specified hub turf"
    group_label: "Population Based Metrics"
    type: average
    sql: ${population} ;;
    value_format_name: decimal_1
  }

  measure: avg_population_female {
    label: "AVG # Female Residents"
    description: "The average number of female people living in the specified hub turf"
    group_label: "Population Based Metrics"
    type: average
    sql: ${population_female} ;;
    value_format_name: decimal_1
  }

  measure: avg_population_male {
    label: "AVG # Male Residents"
    description: "The average number of male people living in the specified hub turf"
    group_label: "Population Based Metrics"
    type: average
    sql: ${population_male} ;;
    value_format_name: decimal_1
  }

  measure: avg_total_households {
    label: "AVG # Households"
    description: "The average number of households located in the specified hub turf"
    group_label: "Population Based Metrics"
    type: average
    sql: ${total_households} ;;
    value_format_name: decimal_1
  }

  measure: sum_unemployed {
    label: "# Unemployed Residents"
    description: "The total number of unemployed residents"
    group_label: "Population Based Metrics"
    type: sum
    sql: ${unemployed} ;;
    value_format_name: decimal_0
  }

  measure: avg_unemployed {
    label: "AVG # Unemployed Residents"
    description: "The average number of unemployed residents"
    group_label: "Population Based Metrics"
    type: average
    sql: ${unemployed} ;;
    value_format_name: decimal_1
  }

  measure: pct_female_residents {
    label: "% Female Residents"
    description: "The share of female residents compared to the total number of residents"
    group_label: "Population Based Metrics"
    type: number
    sql: safe_divide(${sum_population_female}, ${sum_population}) ;;
    value_format_name: percent_0
  }

  measure: pct_male_residents {
    label: "% Male Residents"
    description: "The share of male residents compared to the total number of residents"
    group_label: "Population Based Metrics"
    type: number
    sql: safe_divide(${sum_population_male}, ${sum_population}) ;;
    value_format_name: percent_0
  }

  measure: pct_unemployed {
    label: "% Unemployed Residents"
    description: "The share of unemployed residents compared to the total number of residents"
    group_label: "Population Based Metrics"
    type: number
    sql: safe_divide(if(${sum_unemployed} > 0, ${sum_unemployed}, null), ${sum_population});;
    value_format_name: percent_0
  }

  measure: share_residents_per_household{
    label: "# Residents per Household"
    description: "The average number of residents living in a household"
    group_label: "Population Based Metrics"
    type: number
    sql: safe_divide(${sum_population}, ${sum_total_households}) ;;
    value_format_name: decimal_1
  }

  # ~~~~~~~~~~~~~~  Household Income  ~~~~~~~~~~~~~~

  measure: sum_income_group_1 {
    label: "# Households Income Group 1"
    description: "Number of households in income group 1. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    For DE, Targomo provided 6 income groups - hereby group 1 and 2 have been combined, resulting in the following income ranges: DE: 0-1500€ monthly, FR: 0-20976€ yearly, NL: 0-20726€ yearly, AT: 0-23821€ yearly"
    group_label: "Income Based Metrics"
    type: sum
    sql: ${income_group_1} ;;
    value_format_name: decimal_0
  }

  measure: sum_income_group_2 {
    label: "# Households Income Group 2"
    description: "Number of households in income group 2. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 2 has the following income ranges: DE: 1500-2500€ monthly, FR: 20976-31570€ yearly, NL: 20726-30548€ yearly, AT: 23821-36842€ yearly"
    group_label: "Income Based Metrics"
    type: sum
    sql: ${income_group_2} ;;
    value_format_name: decimal_0
  }

  measure: sum_income_group_3 {
    label: "# Households Income Group 3"
    description: "Number of households in income group 3. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 3 has the following income ranges: DE: 2500-3500€ monthly, FR: 31570-44502€ yearly, NL: 30548-42958€ yearly, AT: 36842-51485€ yearly"
    group_label: "Income Based Metrics"
    type: sum
    sql: ${income_group_3} ;;
    value_format_name: decimal_0
  }

  measure: sum_income_group_4 {
    label: "# Households Income Group 4"
    description: "Number of households in income group 4. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 4 has the following income ranges: DE: 3500-5000€ monthly, FR: 44502-63178€ yearly, NL: 42958-61041€ yearly, AT: 51485-72697€ yearly"
    group_label: "Income Based Metrics"
    type: sum
    sql: ${income_group_4} ;;
    value_format_name: decimal_0
  }

  measure: sum_income_group_5 {
    label: "#  Households Income Group 5"
    description: "Number of households in income group 5. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 5 has the following income ranges: DE: 5000+€ monthly, FR: 63178+€ yearly, NL: 61041+€ yearly, AT: 72697+€ yearly"
    group_label: "Income Based Metrics"
    type: sum
    sql: ${income_group_5} ;;
    value_format_name: decimal_0
  }

  measure: avg_income_group_1 {
    label: "AVG # Households Income Group 1"
    description: "Average number of households in income group 1. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    For DE, Targomo provided 6 income groups - hereby group 1 and 2 have been combined, resulting in the following income ranges: DE: 0-1500€ monthly, FR: 0-20976€ yearly, NL: 0-20726€ yearly, AT: 0-23821€ yearly"
    group_label: "Income Based Metrics"
    type: average
    sql: ${income_group_1} ;;
    value_format_name: decimal_1
  }

  measure: avg_income_group_2 {
    label: "AVG # Households Income Group 2"
    description: "Average number of households in income group 2. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 2 has the following income ranges: DE: 1500-2500€ monthly, FR: 20976-31570€ yearly, NL: 20726-30548€ yearly, AT: 23821-36842€ yearly"
    group_label: "Income Based Metrics"
    type: average
    sql: ${income_group_2} ;;
    value_format_name: decimal_1
  }

  measure: avg_income_group_3 {
    label: "AVG # Households Income Group 3"
    description: "Average number of households in income group 3. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 3 has the following income ranges: DE: 2500-3500€ monthly, FR: 31570-44502€ yearly, NL: 30548-42958€ yearly, AT: 36842-51485€ yearly"
    group_label: "Income Based Metrics"
    type: average
    sql: ${income_group_3} ;;
    value_format_name: decimal_1
  }

  measure: avg_income_group_4 {
    label: "AVG # Households Income Group 4"
    description: "Average number of households in income group 4. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 4 has the following income ranges: DE: 3500-5000€ monthly, FR: 44502-63178€ yearly, NL: 42958-61041€ yearly, AT: 51485-72697€ yearly"
    group_label: "Income Based Metrics"
    type: average
    sql: ${income_group_4} ;;
    value_format_name: decimal_1
  }

  measure: avg_income_group_5 {
    label: "AVG # Households Income Group 5"
    description: "Average number of households in income group 5. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 5 has the following income ranges: DE: 5000+€ monthly, FR: 63178+€ yearly, NL: 61041+€ yearly, AT: 72697+€ yearly"
    group_label: "Income Based Metrics"
    type: average
    sql: ${income_group_5} ;;
    value_format_name: decimal_1
  }

  measure: avg_avg_household_spending_power {
    label: "AVG € Household Spending Power"
    description: "The average spending power per household of a given hub turf"
    group_label: "Income Based Metrics"
    type: average
    sql: ${avg_household_spending_power} ;;
    value_format_name: eur
  }

  measure: avg_avg_inhabitant_spending_power {
    label: "AVG Household Inhabitant Spending Power (€)"
    description: "The average spending power per inhabitant of a given hub turf"
    group_label: "Income Based Metrics"
    type: average
    sql: ${avg_inhabitant_spending_power} ;;
    value_format_name: eur
  }

  measure: sum_spending_power {
    label: "Total Spending Power (€)"
    description: "The total spending power within a hub turf. Approximates the number of residents multiplied with the average inhabitant spending power"
    group_label: "Income Based Metrics"
    type: sum
    sql: ${spending_power} ;;
    value_format_name: eur
  }

  measure: avg_spending_power {
    label: "AVG Spending Power (€)"
    description: "The average total spending power. Approximates the number of residents multiplied with the average inhabitant spending power"
    group_label: "Income Based Metrics"
    type: average
    sql: ${spending_power} ;;
    value_format_name: eur
  }

  measure: pct_income_group_1 {
    label: "% Households Income Group 1"
    description: "Share of households in income group 1. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    For DE, Targomo provided 6 income groups - hereby group 1 and 2 have been combined, resulting in the following income ranges: DE: 0-1500€ monthly, FR: 0-20976€ yearly, NL: 0-20726€ yearly, AT: 0-23821€ yearly"
    group_label: "Income Based Metrics"
    type: number
    sql: safe_divide(${sum_income_group_1}, ${sum_total_households}) ;;
    value_format_name: percent_0
  }

  measure: pct_income_group_2 {
    label: "% Households Income Group 2"
    description: "Share of households in income group 2. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 2 has the following income ranges: DE: 1500-2500€ monthly, FR: 20976-31570€ yearly, NL: 20726-30548€ yearly, AT: 23821-36842€ yearly"
    group_label: "Income Based Metrics"
    type: number
    sql: safe_divide(${sum_income_group_2}, ${sum_total_households}) ;;
    value_format_name: percent_0
  }

  measure: pct_income_group_3 {
    label: "% Households Income Group 3"
    description: "Share of households in income group 3. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 3 has the following income ranges: DE: 2500-3500€ monthly, FR: 31570-44502€ yearly, NL: 30548-42958€ yearly, AT: 36842-51485€ yearly"
    group_label: "Income Based Metrics"
    type: number
    sql: safe_divide(${sum_income_group_3}, ${sum_total_households}) ;;
    value_format_name: percent_0
  }

  measure: pct_income_group_4 {
    label: "% Households Income Group 4"
    description: "Share of households in income group 4. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 4 has the following income ranges: DE: 3500-5000€ monthly, FR: 44502-63178€ yearly, NL: 42958-61041€ yearly, AT: 51485-72697€ yearly"
    group_label: "Income Based Metrics"
    type: number
    sql: safe_divide(${sum_income_group_4}, ${sum_total_households}) ;;
    value_format_name: percent_0
  }

  measure: pct_income_group_5 {
    label: "%  Households Income Group 5"
    description: "Share of households in income group 5. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    Group 5 has the following income ranges: DE: 5000+€ monthly, FR: 63178+€ yearly, NL: 61041+€ yearly, AT: 72697+€ yearly"
    group_label: "Income Based Metrics"
    type: number
    sql: safe_divide(${sum_income_group_5}, ${sum_total_households}) ;;
    value_format_name: percent_0
  }

  measure: pct_income_group_4_5 {
    label: "%  Households Income Group 4 & 5"
    description: "Share of households in income group 4 and 5. According to the data we received from Targomo, there are several income groups that differ in range. For this data, all countries are assigned to an income group between 1-5, whereby 1 is the lowest and 5 is the highest income group.
    The combined group 4 and 5 has the following income ranges: DE: 3500+€ monthly, FR: 44502+€ yearly, NL: 42958+€ yearly, AT: 51485+€ yearly"
    group_label: "Income Based Metrics"
    type: number
    sql: safe_divide((${sum_income_group_5} + ${sum_income_group_4}), ${sum_total_households}) ;;
    value_format_name: percent_0
  }

  # ~~~~~~~~~~~~~~  Age Distribution  ~~~~~~~~~~~~~~

  measure: sum_age_0_to_14_years {
    label: "# Residents Age 0-14 years"
    description: "The total number of residents in the age range of 0 and 14"
    group_label: "Age Distribution Based Metrics"
    type: sum
    sql: ${age_0_to_14_years} ;;
    value_format_name: decimal_0
  }

  measure: sum_age_15_to_29_years {
    label: "# Residents Age 15-29 years"
    description: "The total number of residents in the age range of 15 and 29"
    group_label: "Age Distribution Based Metrics"
    type: sum
    sql: ${age_15_to_29_years} ;;
    value_format_name: decimal_0
  }

  measure: sum_age_30_to_44_years {
    label: "# Residents Age 30-44 years"
    description: "The total number of residents in the age range of 30 and 44"
    group_label: "Age Distribution Based Metrics"
    type: sum
    sql: ${age_30_to_44_years} ;;
    value_format_name: decimal_0
  }

  measure: sum_age_45_to_59_years {
    label: "# Residents Age 45-59 years"
    description: "The total number of residents in the age range of 45 and 59"
    group_label: "Age Distribution Based Metrics"
    type: sum
    sql: ${age_45_to_59_years} ;;
    value_format_name: decimal_0
  }

  measure: sum_age_60_plus_years {
    label: "# Residents Age 60+ years"
    description: "The total number of residents in the age range of 60+"
    group_label: "Age Distribution Based Metrics"
    type: sum
    sql: ${age_60_plus_years} ;;
    value_format_name: decimal_0
  }

  measure: avg_age_0_to_14_years {
    label: "AVG # Residents Age 0-14 years"
    description: "The average number of residents in the age range of 0 and 14"
    group_label: "Age Distribution Based Metrics"
    type: average
    sql: ${age_0_to_14_years} ;;
    value_format_name: decimal_1
  }

  measure: avg_age_15_to_29_years {
    label: "AVG # Residents Age 15-29 years"
    description: "The average number of residents in the age range of 15 and 29"
    group_label: "Age Distribution Based Metrics"
    type: average
    sql: ${age_15_to_29_years} ;;
    value_format_name: decimal_1
  }

  measure: avg_age_30_to_44_years {
    label: "AVG # Residents Age 30-44 years"
    description: "The average number of residents in the age range of 30 and 44"
    group_label: "Age Distribution Based Metrics"
    type: average
    sql: ${age_30_to_44_years} ;;
    value_format_name: decimal_1
  }

  measure: avg_age_45_to_59_years {
    label: "AVG # Residents Age 45-59 years"
    description: "The average number of residents in the age range of 45 and 59"
    group_label: "Age Distribution Based Metrics"
    type: average
    sql: ${age_45_to_59_years} ;;
    value_format_name: decimal_1
  }

  measure: avg_age_60_plus_years {
    label: "AVG # Residents Age 60+ years"
    description: "The average number of residents in the age range of 60+"
    group_label: "Age Distribution Based Metrics"
    type: average
    sql: ${age_60_plus_years} ;;
    value_format_name: decimal_1
  }

  measure: pct_age_0_to_14_years {
    label: "% Residents Age 0-14 years"
    description: "The share of residents in the age range of 0 and 14"
    group_label: "Age Distribution Based Metrics"
    type: number
    sql: safe_divide(${sum_age_0_to_14_years}, ${sum_population}) ;;
    value_format_name: percent_0
  }

  measure: pct_age_15_to_29_years {
    label: "% Residents Age 15-29 years"
    description: "The share of residents in the age range of 15 and 29"
    group_label: "Age Distribution Based Metrics"
    type: number
    sql: safe_divide(${sum_age_15_to_29_years}, ${sum_population}) ;;
    value_format_name: percent_0
  }

  measure: pct_age_30_to_44_years {
    label: "% Residents Age 30-44 years"
    description: "The share of residents in the age range of 30 and 44"
    group_label: "Age Distribution Based Metrics"
    type: number
    sql: safe_divide(${sum_age_30_to_44_years}, ${sum_population}) ;;
    value_format_name: percent_0
  }

  measure: pct_age_45_to_59_years {
    label: "% Residents Age 45-59 years"
    description: "The share of residents in the age range of 45 and 59"
    group_label: "Age Distribution Based Metrics"
    type: number
    sql: safe_divide(${sum_age_45_to_59_years}, ${sum_population}) ;;
    value_format_name: percent_0
  }

  measure: pct_age_60_plus_years {
    label: "% Residents Age 60+ years"
    description: "The share of residents in the age range of 60+"
    group_label: "Age Distribution Based Metrics"
    type: number
    sql: safe_divide(${sum_age_60_plus_years}, ${sum_population}) ;;
    value_format_name: percent_0
  }
}
