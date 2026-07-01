{{ config(materialized='table') }}

-- Static lookup: trip_type -> description
-- (mirrors tripType_mapping in etl_greentaxi_summer2026.ipynb)

select
    column1::integer as trip_type_id,
    column2::varchar as trip_type_name
from values
    (1, 'Street-hail'),
    (2, 'Dispatch'),
    (3, 'Other'),
    (4, 'Other'),
    (5, 'Other')
