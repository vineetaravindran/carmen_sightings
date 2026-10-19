-- (d) For each calendar month, the probability Carmen exhibits one of her three
-- most occurring behaviours (as defined in top_behaviors).

select
    dim_date.month                     as sighting_month
    , dim_date.month_name              as sighting_month_name
    , count(*)                         as sightings
    , count(top_behaviors.behavior_id) as top_behavior_sightings
    , count(top_behaviors.behavior_id) / count(*) as probability_top_behavior
from {{ ref('sighting') }} as sighting
inner join {{ ref('dim_date') }} as dim_date on sighting.date_witness = dim_date.date_day
left join {{ ref('top_behaviors') }} as top_behaviors
    on  sighting.behavior_id = top_behaviors.behavior_id
    and top_behaviors.behavior_rank <= 3
group by all
order by 1
