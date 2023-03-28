# Owner
#   > Andreas / Lauti
#
# Created: 2023-02-14
#
# Purpose:
#   > Show unfiltered Oracle master data

view: erp_product_hub_vendor_assignment_unfiltered {
  sql_table_name: `flink-data-prod.curated.erp_product_hub_vendor_assignment_unfiltered`
    ;;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Main
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension_group: report {
    type: time
    description: "Date on which the bikes uptime metrics are computed."
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
    sql: ${TABLE}.report_date ;;
  }

  dimension: sku {
    type: string
    description: "SKU of the product, as available in the backend."
    sql: ${TABLE}.sku ;;
  }

  dimension: country_iso {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }




  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Item Location Data
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: item_at_location_status {
    type: string
    description: "The assignment status of a given product to a given hub as defined in Oracle"
    group_label: "Item-Location"
    sql: ${TABLE}.item_at_location_status ;;
  }

  dimension: location_id {
    type: number
    description: "The Id of a location (a hub, warehouse, etc) according to our ERP system Oracle"
    group_label: "Item-Location"
    sql: ${TABLE}.location_id ;;
  }

  dimension_group: item_location_introduction {
    type: time
    description: "The date, when the item was assigned to a location according to our ERP system Oracle"
    group_label: "Item-Location"
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
    sql: ${TABLE}.item_location_introduction_date ;;
  }

  dimension: source_method {
    label: "Source Method"
    description: "This value will be used to specify how the ad-hoc PO/TSF creation process should source the item/location request. If the value is Warehouse, the process will attempt to fill the request by creating a transfer from the warehouse mentioned in the source_wh field. If this warehouse doesn't have enough inventory to fill the request, a purchase order will be created for the item/location's primary supplier. For warehouses, it is used by Oracle Retail Allocation to determine the valid sources and destinations for warehouse to warehouse allocations."
    group_label: "Item-Location"
    type: string
    sql: ${TABLE}.source_method ;;
    hidden: no
  }

  dimension: source_warehouse {
    label: "Source Warehouse"
    description: "This value will be used by the ad-hoc PO/Transfer creation process to determine which warehouse to fill the stores request from. It will also be used by the Allocation process to support warehouse to warehouse allocations. A value will be required in this field if the sourcing method is Warehouse."
    group_label: "Item-Location"
    type: number
    sql: ${TABLE}.source_warehouse ;;
    hidden: no
  }




  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Item Data
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: ean {
    type: string
    description: "The european article number (EAN) of a product"
    group_label: "Item"
    sql: ${TABLE}.ean ;;
  }

  dimension: ean_hu {
    type: string
    description: "The European Article Number for the handling unit of a delivered product"
    group_label: "Item"
    sql: ${TABLE}.ean_hu ;;
  }

  dimension: max_shelf_life_days {
    type: number
    description: "SKU's max amount of days on shelf."
    group_label: "Item"
    sql: ${TABLE}.max_shelf_life_days ;;
  }

  dimension: item_replenishment_substitute_group {
    type: string
    description: "The replenishment substitute group defined by the Supply Chain team to tag substitute products for replenishment."
    group_label: "Item"
    sql: ${TABLE}.item_replenishment_substitute_group ;;
  }

  dimension: item_weight {
    type: number
    description: "The height of a product"
    group_label: "Item"
    sql: ${TABLE}.item_weight ;;
  }

  dimension: item_width {
    type: number
    description: "The width of a product"
    group_label: "Item"
    sql: ${TABLE}.item_width ;;
  }

  dimension: item_name {
    type: string
    description: "Name of the product, as specified in the backend."
    group_label: "Item"
    sql: ${TABLE}.item_name ;;
  }

  dimension: item_parent_sku {
    type: string
    description: "Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    group_label: "Item"
    sql: ${TABLE}.item_parent_sku ;;
  }

  dimension: item_producer {
    type: string
    description: "The producing company of a product."
    group_label: "Item"
    sql: ${TABLE}.item_producer ;;
  }

  dimension: item_shelf_life {
    type: string
    description: "The overall shelf live in days of a product until its best before date (BBD)"
    group_label: "Item"
    sql: ${TABLE}.item_shelf_life ;;
  }

  dimension: item_shelf_life_consumer {
    type: string
    description: "The minimum days a product should be consumable for a customer befores its best before date (BBD)"
    group_label: "Item"
    sql: ${TABLE}.item_shelf_life_consumer ;;
  }

  dimension: item_shelf_life_dc {
    type: string
    description: "The shelf live within a distribution center in days of a product until its best before date (BBD)"
    group_label: "Item"
    sql: ${TABLE}.item_shelf_life_dc ;;
  }

  dimension: item_shelf_life_hub {
    type: string
    description: "The shelf live in days of a product defining how long a product can be stored in a hub until its best before date (BBD)"
    group_label: "Item"
    sql: ${TABLE}.item_shelf_life_hub ;;
  }

  dimension: item_storage_types {
    type: string
    description: "The type of storage, that is requried for a given product"
    group_label: "Item"
    sql: ${TABLE}.item_storage_types ;;
  }

  dimension: item_subclass_name {
    type: string
    description: "Level 5 of new item class hierarchie: indicates the subclass of a product (e.g. Pizza - Class - SC or Other Sweets)"
    group_label: "Item"
    sql: ${TABLE}.item_subclass_name ;;
  }

  dimension: item_substitute_group {
    type: string
    description: "The substitute group according to CommerceTools defining substitute products from the customer perspective."
    group_label: "Item"
    sql: ${TABLE}.item_substitute_group ;;
  }

  dimension: item_temperature_zone {
    alias: [temperature_zone]
    type: string
    description: "Temperature a product needs to have while being delivered and stored in order to be consumable"
    group_label: "Item"
    sql: ${TABLE}.item_temperature_zone ;;
  }

  dimension_group: item_location_termination {
    type: time
    datatype: date
    label: "Item Location Termination"
    description: "Date when a hub was launched."
    group_label: "Item-Location"
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.item_location_termination_date ;;
  }

  dimension: item_base_uom {
    type: string
    description: "The base unit of measure of a product"
    group_label: "Item"
    sql: ${TABLE}.item_base_uom ;;
  }

  dimension: item_category {
    type: string
    description: "Category of the product, as available in the backend tables."
    group_label: "Item"
    sql: ${TABLE}.item_category ;;
  }

  dimension: item_class_name {
    type: string
    description: "Level 4 of new item class hierarchie: indicates a more specific class of products (e.g. Wine or Heat & Eat)"
    group_label: "Item"
    sql: ${TABLE}.item_class_name ;;
  }

  dimension: item_department_name {
    type: string
    description: "Level 3 of new item class hierarchie: indicates a high level class of products (e.g. Milk Alternatives Dry or Chocolate & Confectionary)"
    group_label: "Item"
    sql: ${TABLE}.item_department_name ;;
  }

  dimension: item_division_name {
    type: string
    description: "Level 1 of new item class hierarchie: indicates, if the product is food or non-food"
    group_label: "Item"
    sql: ${TABLE}.item_division_name ;;
  }

  dimension: item_brand_name {
    type: string
    description: "The brand of a product as defined in the ERP System"
    group_label: "Item"
    sql: ${TABLE}.item_brand_name ;;
  }

  dimension: item_ean_13 {
    type: string
    description: "The 13 digit long EAN (European Article Number) code to identify a product"
    group_label: "Item"
    sql: ${TABLE}.item_ean_13 ;;
  }

  dimension: item_ean_8 {
    type: string
    description: "The 8 digit long EAN (European Article Number) code to identify a product"
    group_label: "Item"
    sql: ${TABLE}.item_ean_8 ;;
  }

  dimension: item_group_company {
    type: string
    description: "The producing company of a product."
    group_label: "Item"
    sql: ${TABLE}.item_group_company ;;
  }

  dimension: item_group_name {
    type: string
    description: "Level 2 of new item class hierarchie: indicates, if the product is e.g. a fresh or dry product"
    group_label: "Item"
    sql: ${TABLE}.item_group_name ;;
  }

  dimension: item_handling_unit_height {
    type: number
    description: "The height of a handling unit"
    group_label: "Item"
    sql: ${TABLE}.item_handling_unit_height ;;
  }

  dimension: item_handling_unit_length {
    type: number
    description: "The length of a handling unit"
    group_label: "Item"
    sql: ${TABLE}.item_handling_unit_length ;;
  }

  dimension: item_handling_unit_width {
    type: number
    description: "The width of a handling unit"
    group_label: "Item"
    sql: ${TABLE}.item_handling_unit_width ;;
  }

  dimension: item_height {
    type: number
    description: "The height of a product"
    group_label: "Item"
    sql: ${TABLE}.item_height ;;
  }

  dimension: item_hub_type {
    type: string
    description: "The hub type indicates, to which kind of hubs a given product is usually assigned to. Hereby, an assignment to an M-hub indicates, that the product is usually offered in all M hubs or bigger (L hubs)"
    group_label: "Item"
    sql: ${TABLE}.item_hub_type ;;
  }

  dimension: item_hub_type_de {
    type: string
    description: "The type of hub, an SKU is sold in (in Germany)"
    group_label: "Item"
    sql: ${TABLE}.item_hub_type_de ;;
  }

  dimension: item_hub_type_fr {
    type: string
    description: "The type of hub, an SKU is sold in (in France)"
    group_label: "Item"
    sql: ${TABLE}.item_hub_type_fr ;;
  }

  dimension: item_hub_type_nl {
    type: string
    description: "The type of hub, an SKU is sold in (in the Netherlands)"
    group_label: "Item"
    sql: ${TABLE}.item_hub_type_nl ;;
  }

  dimension: item_is_orderable {
    type: yesno
    description: "This boolean field is an indicator, whether an SKU is orderable by the Supply Chain department"
    group_label: "Item"
    sql: ${TABLE}.item_is_orderable ;;
  }

  dimension: item_is_perishable {
    type: yesno
    description: "This boolean field is an indicator, whether an SKU can perish"
    group_label: "Item"
    sql: ${TABLE}.item_is_perishable ;;
  }

  dimension: item_is_sellable {
    type: yesno
    description: "This boolean field is an indicator, whether an SKU is sellable"
    group_label: "Item"
    sql: ${TABLE}.item_is_sellable ;;
  }

  dimension: item_length {
    type: number
    description: "The length of a product"
    group_label: "Item"
    sql: ${TABLE}.item_length ;;
  }



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Hub Data
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension_group: hub_acquiration {
    type: time
    description: "The date, when the physical location of a hub was bought"
    group_label: "Location/Hub"
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
    sql: ${TABLE}.hub_acquiration_date ;;
  }

  dimension: hub_buyer_id {
    group_label: "Location/Hub"
    type: string
    sql: ${TABLE}.hub_buyer_id ;;
  }

  dimension: hub_city {
    type: string
    description: "City where a hub is located. May be deprecated in the future in favour of city extracted from hub_code."
    group_label: "Location/Hub"
    sql: ${TABLE}.hub_city ;;
  }

  dimension: hub_code {
    type: string
    description: "Code of a hub identical to back-end source tables."
    group_label: "Location/Hub"
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_gln {
    type: number
    description: "The location identifier according to our ERP systems"
    group_label: "Location/Hub"
    sql: ${TABLE}.hub_gln ;;
  }

  dimension: hub_id {
    type: string
    description: "The identifier of a hub"
    group_label: "Location/Hub"
    sql: ${TABLE}.hub_id ;;
  }

  dimension_group: hub_launch {
    type: time
    description: "Date when a hub was launched."
    group_label: "Location/Hub"
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
    sql: ${TABLE}.hub_launch_date ;;
  }

  dimension: hub_name {
    type: string
    description: "Name assigned to a hub based on the combination of country ISO code, city and district."
    group_label: "Location/Hub"
    sql: ${TABLE}.hub_name ;;
  }

  dimension: hub_postal_code {
    type: string
    description: "Zip Code where a hub is located."
    group_label: "Location/Hub"
    sql: ${TABLE}.hub_postal_code ;;
  }

  dimension: hub_size {
    type: string
    description: "Physical size/space of a hub (measured as S, M or L)."
    group_label: "Location/Hub"
    sql: ${TABLE}.hub_size ;;
  }

  dimension: hub_state {
    type: string
    description: "The state, a hub is located in"
    group_label: "Location/Hub"
    sql: ${TABLE}.hub_state ;;
  }

  dimension: hub_store_manager {
    type: string
    description: "The hub manager of a given hub"
    group_label: "Location/Hub"
    sql: ${TABLE}.hub_store_manager ;;
  }

  dimension: hub_street {
    type: string
    description: "Street location where a hub is located."
    group_label: "Location/Hub"
    sql: ${TABLE}.hub_street ;;
  }

  dimension_group: hub_termination {
    type: time
    description: "Date when a hub was terminated."
    group_label: "Location/Hub"
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
    sql: ${TABLE}.hub_termination_date ;;
  }



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Item-Supplier Data
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: edi {
    type: string
    description: "Transaction codes that correspond to information in business documents between Flink and Suppliers."
    group_label: "Item-Supplier"
    sql: ${TABLE}.edi ;;
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Supplier Data
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  dimension: supplier_city {
    type: string
    description: "The city, a supplier is located in"
    group_label: "Supplier"
    sql: ${TABLE}.supplier_city ;;
  }

  dimension: supplier_country_iso {
    type: string
    description: "Country ISO based on 'hub_code'."
    group_label: "Supplier"
    sql: ${TABLE}.supplier_country_iso ;;
  }

  dimension: supplier_currency {
    type: string
    group_label: "Supplier"
    description: "Currency ISO code."
    sql: ${TABLE}.supplier_currency ;;
  }

  dimension: supplier_gln {
    type: number
    description: "The location identifier according to our ERP systems"
    group_label: "Supplier"
    sql: ${TABLE}.supplier_gln ;;
  }

  dimension: supplier_id {
    type: string
    description: "The supplier ID as defined in Oracle - which is a representation of a supplier and its related supplier-location"
    group_label: "Supplier"
    sql: ${TABLE}.supplier_id ;;
  }

  dimension: supplier_name {
    type: string
    description: "Name of the supplier/vendor of a product (e.g. REWE or Carrefour)."
    group_label: "Supplier"
    sql: ${TABLE}.supplier_name ;;
  }

  dimension: supplier_parent_id {
    type: number
    description: "ID of a supplier/vendor as define in our ERP system"
    group_label: "Supplier"
    sql: ${TABLE}.supplier_parent_id ;;
  }

  dimension: supplier_parent_name {
    type: string
    description: "no need"
    group_label: "Supplier"
    sql: ${TABLE}.supplier_parent_name ;;
  }

  dimension: supplier_postal_code {
    type: string
    description: "The postal code part of the address of the supplier"
    group_label: "Supplier"
    sql: ${TABLE}.supplier_postal_code ;;
  }

  dimension: supplier_site {
    type: string
    description: "Site of the supplier/vendor of a product, defined as Supplier Name + Location."
    group_label: "Supplier"
    sql: ${TABLE}.supplier_site ;;
  }

  dimension: supplier_state {
    type: string
    description: "The state, a supplier is located in"
    group_label: "Supplier"
    sql: ${TABLE}.supplier_state ;;
  }

  dimension: supplier_status {
    type: string
    description: "The activity status of a supplier as defined in our ERP system"
    group_label: "Supplier"
    sql: ${TABLE}.supplier_status ;;
  }

  dimension: supplier_street {
    type: string
    description: "The street part of the address of the supplier"
    group_label: "Supplier"
    sql: ${TABLE}.supplier_street ;;
  }

  dimension: supplier_tax_region {
    type: number
    description: "Tax region of a supplier according to our ERP system Oracle"
    group_label: "Supplier"
    sql: ${TABLE}.supplier_tax_region ;;
  }

  dimension: supplier_terms {
    type: string
    description: "Terms of the supplier according to our ERP system Oracle"
    group_label: "Supplier"
    sql: ${TABLE}.supplier_terms ;;
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Item-Supplier Data
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dimension: unit_cost {
    # ------ ATTENTION: this is a protected field: buying price --
    required_access_grants: [can_view_buying_information] #-------
    # ------------------------------------------------------------
    label: "Unit Cost"
    description: "The buying price of a product we buy from the suppliers - this information is hub-specific."
    group_label: "Item-Supplier"
    type: number
    sql: ${TABLE}.unit_cost ;;
    hidden: no
  }

  dimension: vpn {
    label: "Vpn"
    description: "Transaction codes that correspond to information in business documents between Flink and Suppliers."
    group_label: "Item-Supplier"
    type: string
    sql: ${TABLE}.vpn ;;
    hidden: no
  }

  dimension: vpn2 {
    label: "Vpn2"
    description: "Supplier facing vpn number"
    group_label: "Item-Supplier"
    type: string
    sql: ${TABLE}.vpn2 ;;
    hidden: no
  }

  dimension: manufacturer_id {
    label: "Manufacturer Id"
    description: "Identifies partner type of supplier hierarchy level 1.This field will always have the partner type S1 which indicates manufacturer."
    group_label: "Item-Supplier"
    type: string
    sql: ${TABLE}.manufacturer_id ;;
    hidden: no
  }

  dimension: manufacturer_name {
    label: "Manufacturer Name"
    description: "Highest level of supplier hierarchy which is uder to indicate a partner, such as a manufacturer, in the supply chain that gives rebates to the retailer. This information is stored on item_supp_country for defaulting into item_supp_country_loc."
    group_label: "Item-Supplier"
    type: string
    sql: ${TABLE}.manufacturer_name ;;
    hidden: no
  }

  dimension: distributor_id {
    label: "Distributor Id"
    description: "Identifies partner type of supplier hierarchy level 2 . This field will always have the partner type S2 which indicates distributor."
    group_label: "Item-Supplier"
    type: string
    sql: ${TABLE}.distributor_id ;;
    hidden: no
  }

  dimension: distributor_name {
    label: "Distributor Name"
    description: "Second highest level of supplier hierarchy which is uder to indicate a partner, such as a distributor in the supply chain that gives rebates to the retailer. This information is stored on item_supp_country for defaulting into item_supp_country_loc."
    group_label: "Item-Supplier"
    type: string
    sql: ${TABLE}.distributor_name ;;
    hidden: no
  }

  dimension: wholesaler_id {
    label: "Wholesaler Id"
    description: "Identifies partner type of supplier hierarchy level 3. This field will always have the partner type S3 which indicates wholesaler."
    group_label: "Item-Supplier"
    type: string
    sql: ${TABLE}.wholesaler_id ;;
    hidden: no
  }

  dimension: wholesaler_name {
    label: "Wholesaler Name"
    description: "Third highest level of supplier hierarchy which is uder to indicate a partner, such as a wholesaler in the supply chain that gives rebates to the retailer. This information is stored on item_supp_country for defaulting into item_supp_country_loc."
    group_label: "Item-Supplier"
    type: string
    sql: ${TABLE}.wholesaler_name ;;
    hidden: no
  }

  dimension: inner_pack_size {
    label: "Inner Pack Size"
    description: "This field contains the units of an item contained in an inner pack supplied by the supplier."
    group_label: "Item-Supplier"
    type: number
    sql: ${TABLE}.inner_pack_size ;;
    hidden: no
  }

  dimension: item_presentation_method {
    label: "Item Presentation Method"
    description: "Describes the packaging (if any) being taken into consideration in the specified dimensions. Valid values for this field are in the code type PCKT on the code_head and code_detail tables."
    group_label: "Item-Supplier"
    type: string
    sql: ${TABLE}.item_presentation_method ;;
    hidden: no
  }

  dimension: min_order_quantity {
    label: "Min Order Quantity"
    description: "Minimun quantity of a product that needs to be ordered from a supplier"
    group_label: "Item-Supplier"
    type: number
    sql: ${TABLE}.min_order_quantity ;;
    hidden: no
  }

  dimension: max_order_quantity {
    label: "Max Order Quantity"
    description: "This field contains the maximum quantity that can be ordered at one time from the supplier for the item."
    group_label: "Item-Supplier"
    type: number
    sql: ${TABLE}.max_order_quantity ;;
    hidden: no
  }

  dimension: item_lwh_uom {
    label: "Item Lwh Uom"
    description: "Unit of measurement for length, width, and height (e.g. inches, centimeters, feet). Valid values for this field are contained in uom field on uom_class table where uom_class field = DIMEN."
    group_label: "Item-Supplier"
    type: string
    sql: ${TABLE}.item_lwh_uom ;;
    hidden: no
  }

  dimension: item_net_weight {
    label: "Item Net Weight"
    description: "Net weight of the dim_object (weight without packaging) measured in units specified in weight_uom."
    group_label: "Item-Supplier"
    type: number
    sql: ${TABLE}.item_net_weight ;;
    hidden: no
  }

  dimension: item_weight_uom {
    label: "Item Weight Uom"
    description: "Unit of measurement for weight (e.g. pounds, kilograms). Valid values for this field are contained in uom field on uom_class table where uom_class field = MASS."
    group_label: "Item-Supplier"
    type: string
    sql: ${TABLE}.item_weight_uom ;;
    hidden: no
  }

  dimension: item_liquid_volume {
    label: "Item Liquid Volume"
    description: "Liquid volume, or capacity, of dim_object measured in units specified in volume_uom. Liquid volumes are only convertible to other liquid volumes."
    group_label: "Item-Supplier"
    type: number
    sql: ${TABLE}.item_liquid_volume ;;
    hidden: no
  }

  dimension: item_liquid_volume_uom {
    label: "Item Liquid Volume Uom"
    description: "Unit of measurement for liquid_volume (e.g. ounces, liters). Liquid volumes are only convertible to other liquid volumes. Valid values for this field are contained in uom field on uom_class table where uom_class field = LVOL."
    group_label: "Item-Supplier"
    type: string
    sql: ${TABLE}.item_liquid_volume_uom ;;
    hidden: no
  }

  dimension: item_stat_cube {
    label: "Item Stat Cube"
    description: "Statistical value of the dim_objects dimensions to be used for loading purposes."
    group_label: "Item-Supplier"
    type: number
    sql: ${TABLE}.item_stat_cube ;;
    hidden: no
  }

  dimension: item_tare_weight {
    label: "Item Tare Weight"
    description: "Amount of weight to be subtracted for packaging materials. Used to calculate the true net weight of the dim_object."
    group_label: "Item-Supplier"
    type: number
    sql: ${TABLE}.item_tare_weight ;;
    hidden: no
  }

  dimension: item_tare_type {
    label: "Item Tare Type"
    description: "TARE_TYPE - Indicates if tare weight for this dim_object is wet or dry. Valid values are found on the code_detail table with the code_type TARE and include: W = Wet tare weight D = Dry tare weight"
    group_label: "Item-Supplier"
    type: string
    sql: ${TABLE}.item_tare_type ;;
    hidden: no
  }

  dimension: purchase_unit {
    label: "Units per Handling Unit"
    type: number
    description: "The ERP defined puchase unit code of a product. It defines, which aggregation was bought (examples: STÜCK, PK14, PK06)"
    group_label: "Item-Supplier"
    sql: ${TABLE}.purchase_unit ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Measures
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      supplier_parent_name,
      item_division_name,
      warehouse_name,
      hub_name,
      item_subclass_name,
      supplier_name,
      item_group_name,
      item_name,
      item_department_name,
      item_class_name
    ]
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Hidden Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: table_uuid {
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: _dbt_source_relation {
    type: string
    description: "This is a dbt internal field used by the DATA-team. It refers to the origin of the data"
    sql: ${TABLE}._dbt_source_relation ;;
    hidden: yes
  }



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    LEGACY: Lexbizz only columns
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dimension: vendor_id_dc_corrected {
    type: string
    group_label: "Legacy - Lexbizz"
    description: "Legacy: In cases, when the items were delivered from a warehouse, this field gives the supplier_id of the actual supplier that delivered to the warehouse (only valid for Lexbizz, does not apply to Oracle)"
    sql: ${TABLE}.vendor_id_dc_corrected ;;
    hidden: yes
  }

  dimension: warehouse_id {
    type: string
    group_label: "Legacy - Lexbizz"
    description: "The warehouse_id as defined in Oracle, that identifies both, physical and virtual warehouses/distribution centers"
    sql: ${TABLE}.warehouse_id ;;
    hidden: yes
  }

  dimension: warehouse_name {
    type: string
    group_label: "Legacy - Lexbizz"
    description: "The name of a warehouse/distribution center"
    sql: ${TABLE}.warehouse_name ;;
    hidden: yes
  }

  dimension: noos_item {
    type: yesno
    group_label: "Legacy - Lexbizz"
    description: "Defines a set of fields, that should never be out of stock"
    sql: ${TABLE}.noos_item ;;
    hidden: yes
  }

  dimension: noos_leading_product {
    type: yesno
    group_label: "Legacy - Lexbizz"
    description: "True if this product is the leading product of a never-out-of-stock group"
    sql: ${TABLE}.noos_leading_product ;;
    hidden: yes
  }

  dimension: item_at_vendor_status {
    type: yesno
    group_label: "Legacy - Lexbizz"
    description: "The status of an item in relation to a supplier (is the supplier delivering this product?). Only applies to Lexbizz data, not valid for Oracle data"
    sql: ${TABLE}.item_at_vendor_status ;;
    hidden: yes
  }

  dimension: is_hub_active {
    type: yesno
    group_label: "Legacy - Lexbizz"
    description: "This boolean field indicates, whether of not a hub is active"
    sql: ${TABLE}.is_hub_active ;;
    hidden: yes
  }

  dimension: is_vendor_dc {
    type: yesno
    group_label: "Legacy - Lexbizz"
    description: "True, if the products are coming from a warehoue (only valid for Lexbizz data, does not apply to Oracle)"
    sql: ${TABLE}.is_vendor_dc ;;
    hidden: yes
  }

  dimension: is_warehouse_active {
    type: yesno
    group_label: "Legacy - Lexbizz"
    description: "Legacy: True, if the warehouse that send the data was is active (only valid for Lexbizz, does not apply to Oracle)"
    sql: ${TABLE}.is_warehouse_active ;;
    hidden: yes
  }

  dimension: is_warehouse_dc {
    type: yesno
    group_label: "Legacy - Lexbizz"
    description: "Legacy: True, if the warehouse that send the data was a distribution center (only valid for Lexbizz, does not apply to Oracle)"
    sql: ${TABLE}.is_warehouse_dc ;;
    hidden: yes
  }

  dimension: item_status {
    type: string
    group_label: "Legacy - Lexbizz"
    description: "The activity/listing status of a product according to our ERP system"
    sql: ${TABLE}.item_status ;;
    hidden: yes
  }
}
