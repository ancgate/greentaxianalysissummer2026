{{ config(materialized='table') }}

-- Static lookup: RatecodeID -> description
-- (mirrors ratecode_mapping in etl_greentaxi_summer2026.ipynb)

select
    column1::integer as rate_code_id,
    column2::varchar as rate_code_name
from values
    (1,  'Standard rate'),
    (2,  'JFK'),
    (3,  'Newark'),
    (4,  'Nassau or Westchester'),
    (5,  'Negotiated fare'),
    (6,  'Group ride'),
    (99, 'Unknown')
