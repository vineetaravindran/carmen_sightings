-- Assumes a name identifies one person; the source has no witness IDs.

with witnesses as (

    select distinct witness as witness_name
    from {{ ref('int_sightings_unioned') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['witness_name']) }} as witness_id
    , witness_name
from witnesses
