include: "/views/sql_derived_tables/cs_fraudulent_customers.view.lkml"

explore: cs_fraudulent_customers {
  hidden: yes
  view_name: cs_fraudulent_customers
  label: "CS Fraudulent Customers"
  view_label: "CS Fraudulent Customers"
  group_label: "07) Customer Service"
  description: "Potential fraudulent customers (Complaints via CS)"
}
