-- (c) Carmen's observed behaviours ranked by frequency. behavior_rank <= 3 gives her
-- three most occurring behaviours (ties share a rank).

with behavior_counts as (

    select
        behavior.behavior_id
        , behavior.behavior_name
        , count(*) as sightings
    from {{ ref('sighting') }} as sighting
    inner join {{ ref('behavior') }} as behavior on sighting.behavior_id = behavior.behavior_id
    group by all

),

totals as (

    select count(*) as total_sightings
    from {{ ref('sighting') }}

)

select
    behavior_counts.behavior_id
    , behavior_counts.behavior_name
    , behavior_counts.sightings
    , totals.total_sightings
    , behavior_counts.sightings / totals.total_sightings    as probability
    , rank() over (order by behavior_counts.sightings desc) as behavior_rank
from behavior_counts
cross join totals
order by behavior_rank
