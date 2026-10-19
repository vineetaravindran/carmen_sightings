{#-
    Builds the staging view for one region: renames and casts the region's seed columns
    into the common data dictionary declared in models/staging/_staging.yml, matching each
    dictionary column to its seed column through meta.synonyms.
-#}

{% macro stg_carmen(region) %}

    {%- set seed = ref('carmen_sightings_20220629061307_' ~ region) -%}

    {%- if execute -%}
        {%- set seed_columns = adapter.get_columns_in_relation(seed) | map(attribute='name') | list -%}
        {{- log('stg_carmen(' ~ region ~ '): mapping ' ~ seed_columns | length ~ ' columns from ' ~ seed, info=True) -}}
    {%- else -%}
        {%- set seed_columns = [] -%}
    {%- endif %}

    select
    {%- for column in model.columns.values() if column.name != 'region' %}

        {%- set meta = column.get('config', {}).get('meta') or column.get('meta', {}) -%}
        {%- set synonyms = meta.get('synonyms', []) | map('lower') | list -%}

        {#- The seed column whose name is one of this column's synonyms -#}
        {%- set matches = [] -%}
        {%- for seed_column in seed_columns if seed_column | lower in synonyms -%}
            {%- do matches.append(seed_column) -%}
        {%- endfor -%}

        {%- if execute and matches | length != 1 -%}
            {{ exceptions.raise_compiler_error(
                region ~ ': "' ~ column.name ~ '" should match exactly one seed column from '
                ~ synonyms ~ ', but matched ' ~ matches
            ) }}
        {%- endif -%}

        {%- if execute -%}
            {{- log('stg_carmen(' ~ region ~ '):   "' ~ matches[0] ~ '" -> ' ~ column.name ~ ' (' ~ column.data_type ~ ')', info=True) -}}
        {%- endif %}
        {{ ', ' if not loop.first }}cast("{{ matches[0] if execute else column.name }}" as {{ column.data_type }}) as {{ column.name }}

    {%- endfor %}
        , cast('{{ region }}' as varchar) as region
    from {{ seed }}

    {%- if execute -%}
        {{- log('stg_carmen(' ~ region ~ '): mapped ' ~ (model.columns | length - 1) ~ ' dictionary columns, added region', info=True) -}}
    {%- endif %}

{% endmacro %}
