with agents as (

    select distinct agent as agent_name
    from {{ ref('int_sightings_unioned') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['agent_name']) }} as agent_id
    , agent_name
from agents
