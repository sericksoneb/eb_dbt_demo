SELECT 
    {{ dbt_utils.surrogate_key(['dp.name', 'dp.completed_date']) }} AS DIM_PARTICIPATION_ID
    ,dp.name
    ,dp.completed_date
FROM {{source('datalake', 'participation_users')}}

