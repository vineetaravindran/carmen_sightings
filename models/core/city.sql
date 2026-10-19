-- HQ cities that field agents file reports to, with their region. Region belongs to
-- the HQ: each regional sheet groups the reports filed to that region's HQs.

with cities as (

    select distinct
        city_agent as city_name
        , region
    from {{ ref('int_sightings_unioned') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['city_name']) }} as city_id
    , city_name
    , region
from cities
