-- One row per calendar day, spanning every sighting and filing date.
-- Role-playing dimension for sighting.date_witness and sighting.date_agent.

with days as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="(select min(date_witness) from " ~ ref('int_sightings_unioned') ~ ")",
        end_date="(select dateadd(day, 1, max(date_agent)) from " ~ ref('int_sightings_unioned') ~ ")"
    ) }}

)

select
    cast(date_day as date)                        as date_day
    , year(date_day)                              as year
    , quarter(date_day)                           as quarter
    , month(date_day)                             as month
    , monthname(date_day)                         as month_name
    , cast(date_trunc('month', date_day) as date) as year_month
    , day(date_day)                               as day_of_month
    , dayname(date_day)                           as day_name
from days
