DECLARE
    cursor data_cursor is
       select
         all_cons_columns.owner as schema_name , all_cons_columns.table_name, all_cons_columns.column_name, all_constraints.constraint_type
       from all_constraints, all_cons_columns 
       where 
         all_constraints.constraint_type = 'P'
         and all_constraints.constraint_name = all_cons_columns.constraint_name
         and all_constraints.owner = all_cons_columns.owner
         and all_cons_columns.owner  = 'PRO_USER'; 

begin 
    for data_record in data_cursor loop 
        execute immediate 'CREATE SEQUENCE ' ||data_record.table_name||'_SEQ START WITH 600 increment by 1 MAXVALUE 999999999999999999999999999'; 
        execute immediate 'CREATE OR REPLACE TRIGGER  '||data_record.table_name||'_trg BEFORE INSERT ON  '||data_record.table_name||  
                 ' FOR EACH ROW 
                 BEGIN 
                 :new.'|| data_record.column_name ||' := '|| data_record.table_name||'_SEQ.nextval;
        END; ';
    end loop;
end;