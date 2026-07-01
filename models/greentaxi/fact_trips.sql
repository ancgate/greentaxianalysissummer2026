{{
    config(
        materialized='table'
    )
}}

-- Green taxi fact (grain = one trip).
-- Raw pickup/dropoff datetimes are stored as Unix MICROSECONDS, so divide by
-- 1000/1000 to get seconds before TO_TIMESTAMP, then format the date_id the same
-- way dim_date builds it: TO_CHAR(..., 'YYYYMMDDHH24')  (HH24 = 24-hour).

WITH raw_fact_cte AS (

    SELECT
        *,
        TO_CHAR(TO_TIMESTAMP(lpep_pickup_datetime  / 1000 / 1000), 'YYYYMMDDHH24') AS pickup_date_id,
        TO_CHAR(TO_TIMESTAMP(lpep_dropoff_datetime / 1000 / 1000), 'YYYYMMDDHH24') AS dropoff_date_id,
        DATEDIFF(
            SECOND,
            TO_TIMESTAMP(lpep_pickup_datetime  / 1000 / 1000),
            TO_TIMESTAMP(lpep_dropoff_datetime / 1000 / 1000)
        ) AS trip_duration
    FROM public.taxi_green_raw

),

fact_cte AS (

    SELECT
        -- foreign keys (cast to INTEGER; raw codes land as FLOAT)
        CAST(vendorid       AS INTEGER)  AS vendor_id,
        CAST(ratecodeid     AS INTEGER)  AS rate_code_id,
        CAST(payment_type   AS INTEGER)  AS payment_type_id,
        CAST(trip_type      AS INTEGER)  AS trip_type_id,
        CAST(pulocationid   AS INTEGER)  AS pickup_location_id,
        CAST(dolocationid   AS INTEGER)  AS dropoff_location_id,
        pickup_date_id,
        dropoff_date_id,

        -- measures
        passenger_count,
        trip_distance,
        fare_amount,
        extra                   AS extra_amount,
        mta_tax,
        tip_amount              AS tips_amount,
        tolls_amount,
        ehail_fee,
        improvement_surcharge   AS improvement_charges,
        congestion_surcharge    AS congestion_amount,
        cbd_congestion_fee,
        total_amount,
        trip_duration
    FROM raw_fact_cte

)

SELECT * FROM fact_cte
