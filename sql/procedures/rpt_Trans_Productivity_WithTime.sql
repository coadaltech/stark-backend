-- Converted from MySQL procedure `rpt_Trans_Productivity_WithTime`.
-- MySQL computed the "previous row" values with session variables (@varEndDate, @varCheckShiftId,
-- @varCheckAddedBy) assigned row-by-row in TransactionStartTime order; this is emulated with lag()
-- over the same ordering (initial values: varFromDate, 0, '').
-- The last three columns keep the MySQL auto-generated labels of the assignment expressions.
DROP ROUTINE IF EXISTS "rpt_Trans_Productivity_WithTime";
CREATE OR REPLACE FUNCTION "rpt_Trans_Productivity_WithTime"(
	varOrganizationId bigint
	, varFromDate date
	, varToDate date
	, varShiftId integer
	, varAddedBy varchar
	, varDiffInMin integer)
RETURNS TABLE(
	"@varEndDate" timestamp
	,"TransactionStartTime" timestamp
	,"AddedDate" timestamp
	,"StartDiffrence" text
	,"FreeTime" bigint
	,"FreeTimeInMin" numeric
	,"Diff" integer
	,"TransactionId" bigint
	,"TransactionDate" date
	,"ShiftId" bigint
	,"LedgerId" bigint
	,"KFlag" text
	,"ClientRemarks" text
	,"IsHissa" text
	,"DaraRate" double precision
	,"DaraCommission" double precision
	,"AkharRate" double precision
	,"AkharCommission" double precision
	,"TotalAmount" double precision
	,"RecordStatus" text
	,"AddedBy" text
	,"UpdatedBy" text
	,"UpdatedDate" timestamp
	,"Timetaken" text
	,"LedgerName" text
	,"NoofTrans" bigint
	,"ShiftName" text
	,"@varEndDate:=AA.AddedDate" timestamp
	,"@varCheckShiftId:=AA.ShiftId" bigint
	,"@varCheckAddedBy:= AA.AddedBy" text
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
	RETURN QUERY
	SELECT AA."PrevEndDate"
	,AA."TransactionStartTime"
	,AA."AddedDate"
	-- MySQL: ifnull(date_format(timediff(start, ref), '%H:%i:%s'), 'START'); date_format on a TIME
	-- wraps the hours into a day, emulated by adding the interval to a fixed midnight.
	,coalesce(to_char(timestamp '2000-01-01 00:00:00' + (AA."TransactionStartTime" - AA."RefTime"), 'HH24:MI:SS'), 'START')::text
	,AA."FreeTime"
	,AA."FreeTimeInMin"
	,varDiffInMin
	,AA."TransactionId"
	,AA."TransactionDate"
	,AA."ShiftId"
	,AA."LedgerId"
	,AA."KFlag"::text
	,AA."ClientRemarks"::text
	,AA."IsHissa"::text
	,AA."DaraRate"
	,AA."DaraCommission"
	,AA."AkharRate"
	,AA."AkharCommission"
	,AA."TotalAmount"
	,AA."RecordStatus"::text
	,AA."AddedBy"::text
	,AA."UpdatedBy"::text
	,AA."UpdatedDate"
	-- MySQL timediff(AddedDate, TransactionStartTime) rendered as [-]HH:MM:SS
	,(CASE WHEN AA."TimetakenSec" IS NULL THEN NULL
		ELSE (CASE WHEN AA."TimetakenSec" < 0 THEN '-' ELSE '' END)
			|| lpad((abs(AA."TimetakenSec") / 3600)::text, 2, '0') || ':'
			|| lpad(((abs(AA."TimetakenSec") / 60) % 60)::text, 2, '0') || ':'
			|| lpad((abs(AA."TimetakenSec") % 60)::text, 2, '0') END)::text
	,AA."LedgerName"::text
	,AA."NoofTrans"
	,AA."ShiftName"::text
	,AA."AddedDate"
	,AA."ShiftId"
	,AA."AddedBy"::text
	FROM (
		SELECT AA.*
		,trunc(extract(epoch FROM (AA."TransactionStartTime" - AA."RefTime")))::bigint AS "FreeTime"
		,round(trunc(extract(epoch FROM (AA."TransactionStartTime" - AA."RefTime")))::numeric / 60, 4) AS "FreeTimeInMin"
		FROM (
			SELECT AA.*
			,(CASE WHEN AA."PrevShiftId" = 0 OR AA."PrevAddedBy" <> AA."AddedBy" THEN AA."TransactionStartTime" ELSE AA."PrevEndDate" END) AS "RefTime"
			FROM (
				SELECT AA.*
				,lag(AA."AddedDate", 1, varFromDate::timestamp) OVER w AS "PrevEndDate"
				,lag(AA."ShiftId", 1, 0::bigint) OVER w AS "PrevShiftId"
				,lag(AA."AddedBy"::text, 1, ''::text) OVER w AS "PrevAddedBy"
				FROM (
					SELECT t."TransactionId",
						t."TransactionDate",
						t."ShiftId",
						t."LedgerId",
						t."KFlag",
						t."ClientRemarks",
						t."IsHissa",
						t."DaraRate",
						t."DaraCommission",
						t."AkharRate",
						t."AkharCommission",
						t."TotalAmount",
						t."TransactionStartTime",
						t."RecordStatus",
						t."AddedBy",
						t."AddedDate",
						t."UpdatedBy",
						t."UpdatedDate",
						trunc(extract(epoch FROM (t."AddedDate" - t."TransactionStartTime")))::bigint AS "TimetakenSec"
						,ledger."LedgerName"
						,count(td."TransactionId") AS "NoofTrans"
						,shift."ShiftName"
					FROM "transaction" AS t
					JOIN "transaction_detail" td ON td."TransactionId" = t."TransactionId"
					LEFT JOIN "ledger" ledger ON ledger."LedgerId" = t."LedgerId"
					LEFT JOIN "shift" shift ON shift."ShiftId" = t."ShiftId"
					WHERE (t."RecordStatus" <> 'D')
					AND (t."TransactionDate" BETWEEN varFromDate AND varToDate)
					AND (coalesce(varShiftId, 0) = 0 OR t."ShiftId" = varShiftId)
					AND t."OrganizationId" = varOrganizationId
					AND t."AddedBy" = varAddedBy
					GROUP BY t."TransactionId",
						t."TransactionDate",
						t."ShiftId",
						t."LedgerId",
						t."KFlag",
						t."ClientRemarks",
						t."IsHissa",
						t."DaraRate",
						t."DaraCommission",
						t."AkharRate",
						t."AkharCommission",
						t."TotalAmount",
						t."TransactionStartTime",
						t."RecordStatus",
						t."AddedBy",
						t."AddedDate",
						t."UpdatedBy",
						t."UpdatedDate"
						,ledger."LedgerName"
						,shift."ShiftName"
					UNION ALL
					SELECT tmp."TransactionId",
						tmp."TransactionDate",
						tmp."ShiftId",
						tmp."LedgerId",
						tmp."KFlag",
						tmp."ClientRemarks",
						tmp."IsHissa",
						tmp."DaraRate",
						tmp."DaraCommission",
						tmp."AkharRate",
						tmp."AkharCommission",
						tmp."TotalAmount",
						tmp."TransactionStartTime",
						tmp."RecordStatus",
						tmp."AddedBy",
						tmp."AddedDate",
						tmp."UpdatedBy",
						tmp."UpdatedDate",
						trunc(extract(epoch FROM (tmp."AddedDate" - tmp."TransactionStartTime")))::bigint AS "TimetakenSec"
						,ledger."LedgerName"
						,count(tdtmp."TransactionId") AS "NoofTrans"
						,shift."ShiftName"
					FROM "transaction_declare" AS tmp
					JOIN "transaction_detail_declare" tdtmp ON tdtmp."TransactionId" = tmp."TransactionId"
					LEFT JOIN "ledger" ledger ON ledger."LedgerId" = tmp."LedgerId"
					LEFT JOIN "shift" shift ON shift."ShiftId" = tmp."ShiftId"
					WHERE (tmp."RecordStatus" <> 'D')
					AND (tmp."TransactionDate" BETWEEN varFromDate AND varToDate)
					AND (coalesce(varShiftId, 0) = 0 OR tmp."ShiftId" = varShiftId)
					AND tmp."OrganizationId" = varOrganizationId
					AND tmp."AddedBy" = varAddedBy
					GROUP BY tmp."TransactionId",
						tmp."TransactionDate",
						tmp."ShiftId",
						tmp."LedgerId",
						tmp."KFlag",
						tmp."ClientRemarks",
						tmp."IsHissa",
						tmp."DaraRate",
						tmp."DaraCommission",
						tmp."AkharRate",
						tmp."AkharCommission",
						tmp."TotalAmount",
						tmp."TransactionStartTime",
						tmp."RecordStatus",
						tmp."AddedBy",
						tmp."AddedDate",
						tmp."UpdatedBy",
						tmp."UpdatedDate"
						,ledger."LedgerName"
						,shift."ShiftName"
				) AS AA
				WINDOW w AS (ORDER BY AA."TransactionStartTime" ASC)
			) AS AA
		) AS AA
	) AS AA
	WHERE AA."FreeTimeInMin" >= varDiffInMin
	ORDER BY AA."TransactionStartTime" ASC
	;
END;
$$;
