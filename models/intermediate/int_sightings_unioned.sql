-- All regional reports in one relation, still in 1NF.
-- Single input for every core model.

{% set regions = ['africa', 'america', 'asia', 'atlantic', 'australia', 'europe', 'indian', 'pacific'] %}

{% for region in regions %}
select * from {{ ref('stg_carmen_' ~ region) }}
{% if not loop.last %}union all{% endif %}
{% endfor %}
