-- Converted from MySQL procedure `restore_transactions`.
DROP ROUTINE IF EXISTS "restore_transactions";
CREATE OR REPLACE PROCEDURE "restore_transactions"(
	varTransactionIds bigint
)
LANGUAGE plpgsql AS $$
BEGIN
	UPDATE "transaction_detail_declare" SET "RecordStatus" = 'A'
	WHERE "TransactionId" = varTransactionIds
	;

	UPDATE "transaction_declare" SET "RecordStatus" = 'A'
	WHERE "TransactionId" = varTransactionIds
	;
END;
$$;
