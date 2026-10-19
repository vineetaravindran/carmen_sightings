-- One row per field report. Keys are looked up from each dimension, so every key is
-- defined once, in its own model. Where she was seen is reached through location_id;
-- the HQ city the report was filed to (and so its region) through city_id.
-- Left joins keep every report: a missing dimension match shows up as a null key
-- (caught by the not_null tests) rather than a silently dropped row.

with sightings as (

    select * from {{ ref('int_sightings_unioned') }}

)

select
    {{ dbt_utils.generate_surrogate_key([
        'sightings.date_witness'
        , 'sightings.witness'
        , 'sightings.agent'
        , 'sightings.latitude'
        , 'sightings.longitude'
    ]) }} as sighting_id
    , witness_date.date_day as date_witness
    , agent_date.date_day   as date_agent
    , location.location_id
    , city.city_id
    , agent.agent_id
    , witness.witness_id
    , behavior.behavior_id
    , sightings.has_weapon
    , sightings.has_hat
    , sightings.has_jacket
from sightings
left join {{ ref('dim_date') }} as witness_date
    on sightings.date_witness = witness_date.date_day
left join {{ ref('dim_date') }} as agent_date
    on sightings.date_agent = agent_date.date_day
left join {{ ref('location') }} as location
    on  sightings.latitude = location.latitude
    and sightings.longitude = location.longitude
left join {{ ref('city') }} as city
    on sightings.city_agent = city.city_name
left join {{ ref('agent') }} as agent
    on sightings.agent = agent.agent_name
left join {{ ref('witness') }} as witness
    on sightings.witness = witness.witness_name
left join {{ ref('behavior') }} as behavior
    on sightings.behavior = behavior.behavior_name
