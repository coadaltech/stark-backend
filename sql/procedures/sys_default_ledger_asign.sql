-- Converted from MySQL procedure `sys_default_ledger_asign`.
-- Enum values written as 'No' in MySQL are stored in canonical enum case; the PG CHECK
-- constraints are case-sensitive, so LimitType/TPVapsi/IsHissa/IsDibba use 'NO'
-- (TPCommission's allowed values are ('No','YES'), so it stays 'No').
DROP ROUTINE IF EXISTS "sys_default_ledger_asign";
CREATE OR REPLACE PROCEDURE "sys_default_ledger_asign"(varOrganization integer)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO "ledger"("OrganizationId","ParentLedgerId","LedgerName","GroupId","AgentLedgerId","LimitType","DaraRate","DaraCommission","AkharRate","AkharCommission","Vapsi","TPVapsi","TPCommission","IsHissa","IsDibba","DibbaAmount","RefLedgerId","IsReport","TransactionMode","AccountStatus","RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
    VALUES (varOrganization,0,UPPER('Mandi Sale A/c'),11,0,'NO','0','0','0','0','0','NO','No','NO','NO',0,0,'0',0,'1','S','SYSTEM',localtimestamp,'SYSTEM',localtimestamp);
    INSERT INTO "ledger"("OrganizationId","ParentLedgerId","LedgerName","GroupId","AgentLedgerId","LimitType","DaraRate","DaraCommission","AkharRate","AkharCommission","Vapsi","TPVapsi","TPCommission","IsHissa","IsDibba","DibbaAmount","RefLedgerId","IsReport","TransactionMode","AccountStatus","RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
    VALUES (varOrganization,0,UPPER('Mandi Purchase A/c'),12,0,'NO','0','0','0','0','0','NO','No','NO','NO',0,0,'0',0,'1','S','SYSTEM',localtimestamp,'SYSTEM',localtimestamp);
    INSERT INTO "ledger"("OrganizationId","ParentLedgerId","LedgerName","GroupId","AgentLedgerId","LimitType","DaraRate","DaraCommission","AkharRate","AkharCommission","Vapsi","TPVapsi","TPCommission","IsHissa","IsDibba","DibbaAmount","RefLedgerId","IsReport","TransactionMode","AccountStatus","RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
    VALUES (varOrganization,0,UPPER('Mandi P&L A/c'),10,0,'NO','0','0','0','0','0','NO','No','NO','NO',0,0,'0',0,'1','S','SYSTEM',localtimestamp,'SYSTEM',localtimestamp);
    INSERT INTO "ledger"("OrganizationId","ParentLedgerId","LedgerName","GroupId","AgentLedgerId","LimitType","DaraRate","DaraCommission","AkharRate","AkharCommission","Vapsi","TPVapsi","TPCommission","IsHissa","IsDibba","DibbaAmount","RefLedgerId","IsReport","TransactionMode","AccountStatus","RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
    VALUES (varOrganization,0,UPPER('Mandi Commission A/c'),8,0,'NO','0','0','0','0','0','NO','No','NO','NO',0,0,'0',0,'1','S','SYSTEM',localtimestamp,'SYSTEM',localtimestamp);
    INSERT INTO "ledger"("OrganizationId","ParentLedgerId","LedgerName","GroupId","AgentLedgerId","LimitType","DaraRate","DaraCommission","AkharRate","AkharCommission","Vapsi","TPVapsi","TPCommission","IsHissa","IsDibba","DibbaAmount","RefLedgerId","IsReport","TransactionMode","AccountStatus","RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
    VALUES (varOrganization,0,UPPER('Vapsi A/c'),9,0,'NO','0','0','0','0','0','NO','No','NO','NO',0,0,'0',0,'1','S','SYSTEM',localtimestamp,'SYSTEM',localtimestamp);
    INSERT INTO "ledger"("OrganizationId","ParentLedgerId","LedgerName","GroupId","AgentLedgerId","LimitType","DaraRate","DaraCommission","AkharRate","AkharCommission","Vapsi","TPVapsi","TPCommission","IsHissa","IsDibba","DibbaAmount","RefLedgerId","IsReport","TransactionMode","AccountStatus","RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
    VALUES (varOrganization,0,UPPER('Limit A/c'),13,0,'NO','0','0','0','0','0','NO','No','NO','NO',0,0,'0',0,'1','S','SYSTEM',localtimestamp,'SYSTEM',localtimestamp);
    INSERT INTO "ledger"("OrganizationId","ParentLedgerId","LedgerName","GroupId","AgentLedgerId","LimitType","DaraRate","DaraCommission","AkharRate","AkharCommission","Vapsi","TPVapsi","TPCommission","IsHissa","IsDibba","DibbaAmount","RefLedgerId","IsReport","TransactionMode","AccountStatus","RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
    VALUES (varOrganization,0,UPPER('Kist A/c'),13,0,'NO','0','0','0','0','0','NO','No','NO','NO',0,0,'0',0,'1','S','SYSTEM',localtimestamp,'SYSTEM',localtimestamp);
    INSERT INTO "ledger"("OrganizationId","ParentLedgerId","LedgerName","GroupId","AgentLedgerId","LimitType","DaraRate","DaraCommission","AkharRate","AkharCommission","Vapsi","TPVapsi","TPCommission","IsHissa","IsDibba","DibbaAmount","RefLedgerId","IsReport","TransactionMode","AccountStatus","RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
    VALUES (varOrganization,0,UPPER('Suspense A/c'),9,0,'NO','0','0','0','0','0','NO','No','NO','NO',0,0,'0',0,'1','S','SYSTEM',localtimestamp,'SYSTEM',localtimestamp);
    INSERT INTO "ledger"("OrganizationId","ParentLedgerId","LedgerName","GroupId","AgentLedgerId","LimitType","DaraRate","DaraCommission","AkharRate","AkharCommission","Vapsi","TPVapsi","TPCommission","IsHissa","IsDibba","DibbaAmount","RefLedgerId","IsReport","TransactionMode","AccountStatus","RecordStatus","AddedBy","AddedDate","UpdatedBy","UpdatedDate")
    VALUES (varOrganization,0,UPPER('Expense A/c'),8,0,'NO','0','0','0','0','0','NO','No','NO','NO',0,0,'0',0,'1','S','SYSTEM',localtimestamp,'SYSTEM',localtimestamp);
END;
$$;
