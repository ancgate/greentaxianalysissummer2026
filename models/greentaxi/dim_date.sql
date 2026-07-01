{{ config(materialized='table') }}

-- Hourly date dimension: 2022-01-01 00:00 through 2026-12-31 00:00
-- Snowflake port of the Python pd.date_range(freq='H') build.

with hours as (

    -- one row per hour, generated from a row sequence
    select
        dateadd(hour, seq4(), '2022-01-01'::timestamp_ntz) as date
    from table(generator(rowcount => 50000))

),

filtered as (

    select date
    from hours
    where date <= '2026-12-31 00:00:00'::timestamp_ntz

)

select
    date,
    year(date)                                          as year_number,
    month(date)                                         as month_number,
    day(date)                                           as day_number,
    to_char(date, 'MMMM')                               as month_name,
    -- Snowflake has no full-weekday format token, so decode it (0 = Sunday)
    case dayofweek(date)
        when 0 then 'Sunday'
        when 1 then 'Monday'
        when 2 then 'Tuesday'
        when 3 then 'Wednesday'
        when 4 then 'Thursday'
        when 5 then 'Friday'
        when 6 then 'Saturday'
    end                                                 as day_name,
    hour(date)                                          as hour_number,
    to_char(date, 'YYYY-MM-DD"T"HH24:MI:SS')            as timestamp_is_isoformat,
    to_char(date, 'YYYYMMDDHH24')                       as date_id,
    floor((day(date) - 1) / 7) + 1                      as week_of_month,
    quarter(date)                                       as quarter_number,
    -- Python strftime('%U'): weeks start Sunday, days before first Sunday = week 00
    lpad(floor((dayofyear(date) - 1 + 7 - dayofweek(date)) / 7), 2, '0') as week_of_year,
    case
        when month(date) in (12, 1, 2) then 'Winter'
        when month(date) in (3, 4, 5)  then 'Spring'
        when month(date) in (6, 7, 8)  then 'Summer'
        else 'Fall'
    end                                                 as season_name,
    dayofweek(date) in (0, 6)                           as is_weekend
from filtered
order by date
