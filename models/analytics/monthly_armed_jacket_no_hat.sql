-- (b) For each calendar month, the probability Carmen is armed AND wearing a jacket
-- but NOT a hat. The single-trait probabilities support general observations.

with monthly_counts as (

    select
        dim_date.month        as sighting_month
        , dim_date.month_name as sighting_month_name
        , count(*)            as sightings
        , count_if(sighting.has_weapon and sighting.has_jacket and not sighting.has_hat) as armed_jacket_no_hat_sightings
        , count_if(sighting.has_weapon) as armed_sightings
        , count_if(sighting.has_jacket) as jacket_sightings
        , count_if(sighting.has_hat)    as hat_sightings
    from {{ ref('sighting') }} as sighting
    inner join {{ ref('dim_date') }} as dim_date on sighting.date_witness = dim_date.date_day
    group by all

)

select
    sighting_month
    , sighting_month_name
    , sightings
    , armed_jacket_no_hat_sightings
    , armed_jacket_no_hat_sightings / sightings as probability_armed_jacket_no_hat
    , armed_sightings
    , armed_sightings / sightings               as probability_armed
    , jacket_sightings
    , jacket_sightings / sightings              as probability_jacket
    , hat_sightings
    , hat_sightings / sightings                 as probability_hat
from monthly_counts
order by sighting_month
