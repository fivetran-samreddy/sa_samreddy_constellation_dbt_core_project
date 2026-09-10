-- Rounds HIGH to the nearest whole number (so it lands on ".00") whenever
-- HIGH is >= 75.00. Values below the threshold are passed through unchanged.
--
-- Adjust the threshold (75.00) or swap `round(..., 0)` for `floor(...)` if you
-- actually want truncation instead of standard rounding.

with source as (

    select *
    from {{ source('constellation_demo', 'COFFEE_PRICES_LATEST') }}

),

transformed as (

    select
        ID,
        C_DATE,
        OPEN,
        LOW,
        CLOSE,
        VOLUME,
        CURRENCY,
        _fivetran_deleted,
        _fivetran_synced,

        cast(
            case
                when HIGH >= 75.00 then round(HIGH, 0)
                else HIGH
            end
        as decimal(6,2)) as HIGH

    from source

)

select * from transformed
