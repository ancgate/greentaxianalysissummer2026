{{ config(materialized='table') }}

-- Static lookup: payment_type code -> description
-- (mirrors payment_mapping in etl_greentaxi_summer2026.ipynb)

select
    column1::integer as payment_type_id,
    column2::varchar as payment_type_name
from values
    (0, 'Flex Fare trip'),
    (1, 'Credit card'),
    (2, 'Cash'),
    (3, 'No Charge'),
    (4, 'Dispute'),
    (5, 'Unknown'),
    (6, 'Voided trip')
