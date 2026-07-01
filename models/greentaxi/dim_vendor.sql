{{ config(materialized='table') }}

-- Static lookup: VendorID -> vendor name
-- (mirrors vendor_mapping in etl_greentaxi_summer2026.ipynb)

select
    column1::integer as vendor_id,
    column2::varchar as vendor_name
from values
    (1, 'Creative Mobile Technologies, LLC'),
    (2, 'Curb Mobility, LLC'),
    (6, 'Myle Technologies Inc')
