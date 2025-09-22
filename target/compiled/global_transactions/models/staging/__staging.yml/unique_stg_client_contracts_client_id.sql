
    
    

select
    client_id as unique_field,
    count(*) as n_records

from main_staging."stg_client_contracts"
where client_id is not null
group by client_id
having count(*) > 1


