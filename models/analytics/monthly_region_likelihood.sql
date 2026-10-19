-- (a) For each calendar month, how likely Carmen is to be found in each agency region:
-- the region's share of that month's sightings. region_rank = 1 is the most likely.

with sightings_by_region as (

    select
        dim_date.month        as sighting_month
        , dim_date.month_name as sighting_month_name
        , city.region         as region_name
        , count(*)            as sightings
    from {{ ref('sighting') }} as sighting
    inner join {{ ref('dim_date') }} as dim_date on sighting.date_witness = dim_date.date_day
    inner join {{ ref('city') }}     as city     on sighting.city_id = city.city_id
    group by all

),

monthly_totals as (

    select
        dim_date.month as sighting_month
        , count(*)     as month_sightings
    from {{ ref('sighting') }} as sighting
    inner join {{ ref('dim_date') }} as dim_date on sighting.date_witness = dim_date.date_day
    group by all

)

select
    sightings_by_region.sighting_month
    , sightings_by_region.sighting_month_name
    , sightings_by_region.region_name
    , sightings_by_region.sightings
    , monthly_totals.month_sightings
    , sightings_by_region.sightings / monthly_totals.month_sightings as probability
    , rank() over (
        partition by sightings_by_region.sighting_month
        order by sightings_by_region.sightings desc
    ) as region_rank
from sightings_by_region
inner join monthly_totals
    on sightings_by_region.sighting_month = monthly_totals.sighting_month
order by sightings_by_region.sighting_month, region_rank
