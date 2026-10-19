with behaviors as (

    select distinct behavior as behavior_name
    from {{ ref('int_sightings_unioned') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['behavior_name']) }} as behavior_id
    , behavior_name
from behaviors
