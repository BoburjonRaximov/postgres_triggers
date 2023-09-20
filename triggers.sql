"1-"
CREATE OR REPLACE FUNCTION check_branch_products() 
   RETURNS TRIGGER 
   LANGUAGE PLPGSQL
AS $$
BEGIN
       IF new.type = 'minus' and NEW.quantity > (select quantity from branch_products as bt
       where NEW.branch_id = bt.branch_id and NEW.product_id = bt.product_id) then
        RAISE EXCEPTION 'error exception';
        RETURN NULL;
       END IF;
       RETURN NEW;  
END;
$$;

CREATE TRIGGER branch_name_validate_trigger 
   BEFORE INSERT OR UPDATE
   ON branch_pr_transaction
   FOR EACH ROW
       EXECUTE PROCEDURE check_branch_products();  

DROP TRIGGER check_branch_products ON branch_pr_transaction;
drop FUNCTION check_branch_products;

"2-"
CREATE OR REPLACE FUNCTION update_branch_products() 
   RETURNS TRIGGER 
   LANGUAGE PLPGSQL
AS $$
BEGIN
      UPDATE branch_products
      set quantity = quantity-NEW.quantity
      where branch_id = NEW.branch_id and product_id = new.product_id
END;
$$;

CREATE TRIGGER branch_name_validate_trigger 
   BEFORE INSERT OR UPDATE
   ON branch_pr_transaction
   FOR EACH ROW
       EXECUTE PROCEDURE update_branch_products();




select usename, query, xact_start from PG_STAT_ACTIVITY order by xact_start;

select relname, indexrelname from PG_STAT_USER_INDEXES order by relname,indexrelname;