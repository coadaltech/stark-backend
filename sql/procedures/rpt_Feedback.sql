-- Converted from MySQL procedure `rpt_Feedback`.
-- TODO(convert): MySQL returned two columns both labelled `LedgerId` (l.LedgerId and
-- ifnull(ledger_feedback.LedgerId,0)); PG RETURNS TABLE cannot repeat a name, so the second
-- one is exposed as "FeedbackLedgerId". (A MySQL client building row objects would have seen
-- only the second value under `LedgerId`.)
-- FeedbackDate/AddedDate/UpdatedDate: MySQL ifnull(date,'01/01/2001') yields a string, kept as text.
DROP ROUTINE IF EXISTS "rpt_Feedback";
CREATE OR REPLACE FUNCTION "rpt_Feedback"(
    FromDate date,
    ToDate date,
    varOrganizationId bigint,
    varGroupAgentId bigint,
    varLedgerId bigint,
    varCommanFeedbackId bigint,
    varIsFeedback bigint
)
RETURNS TABLE(
    "LedgerId" bigint,
    "LedgerName" text,
    "GroupId" integer,
    "Mobile" text,
    "AgentName" text,
    "FeedbackId" bigint,
    "OrganizationId" bigint,
    "CommanFeedbackId" bigint,
    "FeedbackLedgerId" bigint,
    "FeedbackDate" text,
    "Balance" double precision,
    "Remark" text,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" text,
    "UpdatedBy" text,
    "UpdatedDate" text,
    "FeedbackName" text,
    "Closing" double precision
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT l."LedgerId", l."LedgerName"::text, l."GroupId", login."Mobile"::text,
           COALESCE(agent."CommanMasterName", 'NA')::text AS "AgentName",
           COALESCE(ledger_feedback."FeedbackId", 0) AS "FeedbackId",
           COALESCE(ledger_feedback."OrganizationId", 0) AS "OrganizationId",
           COALESCE(ledger_feedback."CommanFeedbackId", 0) AS "CommanFeedbackId",
           COALESCE(ledger_feedback."LedgerId", 0) AS "FeedbackLedgerId",
           COALESCE(ledger_feedback."FeedbackDate"::text, '01/01/2001') AS "FeedbackDate",
           COALESCE(ledger_feedback."Balance", 0) AS "Balance",
           COALESCE(ledger_feedback."Remark", '')::text AS "Remark",
           COALESCE(ledger_feedback."RecordStatus"::text, '') AS "RecordStatus",
           COALESCE(ledger_feedback."AddedBy", '')::text AS "AddedBy",
           COALESCE(ledger_feedback."AddedDate"::text, '01/01/2001') AS "AddedDate",
           COALESCE(ledger_feedback."UpdatedBy", '')::text AS "UpdatedBy",
           COALESCE(ledger_feedback."UpdatedDate"::text, '01/01/2001') AS "UpdatedDate",
           COALESCE(feedback."CommanMasterName", 'NA')::text AS "FeedbackName",
           ledger_limit."LedgerBalance" AS "Closing"
    FROM (
        SELECT ledger."LedgerId", ledger."LedgerName", ledger."GroupId", ledger."AgentLedgerId"
        FROM "ledger" ledger
        WHERE ledger."OrganizationId" = varOrganizationId
          AND ledger."ParentLedgerId" = 0
          AND (ledger."LedgerId" = COALESCE(varLedgerId, 0) OR COALESCE(varLedgerId, 0) = 0)
          AND ledger."RecordStatus" != 'D'
    ) AS l
    LEFT JOIN (
        SELECT lf."FeedbackId", lf."OrganizationId", lf."CommanFeedbackId", lf."LedgerId", lf."FeedbackDate",
               lf."Balance", lf."Remark", lf."RecordStatus", lf."AddedBy", lf."AddedDate", lf."UpdatedBy", lf."UpdatedDate"
        FROM "ledger_feedback" lf
        WHERE lf."FeedbackDate" BETWEEN FromDate AND ToDate
          AND (lf."CommanFeedbackId" = varCommanFeedbackId OR COALESCE(varCommanFeedbackId, 0) = 0)
          AND (COALESCE(varGroupAgentId, 0) = 0 OR lf."AsignAgentLedgerId" = varGroupAgentId)
          AND lf."RecordStatus" != 'D'
    ) AS ledger_feedback ON ledger_feedback."LedgerId" = l."LedgerId"
    LEFT JOIN "comman_master" agent ON agent."CommanMasterId" = l."AgentLedgerId" AND agent."CommanMasterType" = 1
    LEFT JOIN "comman_master" feedback ON feedback."CommanMasterId" = ledger_feedback."CommanFeedbackId"
    LEFT JOIN "ledger_limit" ledger_limit ON ledger_limit."LedgerId" = l."LedgerId"
    LEFT JOIN "login" login ON login."LedgerId" = l."LedgerId"
    WHERE (CASE WHEN varIsFeedback = 1
                THEN ledger_feedback."FeedbackId" IS NOT NULL
                ELSE ledger_feedback."FeedbackId" IS NULL END)
    ORDER BY 10 /* FeedbackDate (string) */, 2 /* LedgerName */, 18 /* FeedbackName */;
END;
$$;
