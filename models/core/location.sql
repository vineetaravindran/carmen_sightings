-- Places where Carmen was sighted: one per sighting city, with its country and
-- coordinates. No region here, as region is a property of the HQ, not the place.

with locations as (

    select distinct
        latitude
        , longitude
        , city
        , country
    from {{ ref('int_sightings_unioned') }}

)

select
    {{ dbt_utils.generate_surrogate_key([
        'latitude'
        , 'longitude'
    ]) }} as location_id
    , latitude
    , longitude
    , city    as city_name
    , country as country_code
from locations
