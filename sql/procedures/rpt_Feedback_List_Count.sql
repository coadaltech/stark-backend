-- Converted from MySQL procedure `rpt_Feedback_List_Count`.
DROP ROUTINE IF EXISTS "rpt_Feedback_List_Count";
CREATE OR REPLACE FUNCTION "rpt_Feedback_List_Count"(FromDate date, ToDate date, varOrganizationId bigint, varGroupAgentId bigint, varLedgerId bigint)
RETURNS TABLE(
    "CommanFeedbackId" bigint,
    "FeedbackName" text,
    "NoOfFeedBack" numeric
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT lf."CommanFeedbackId", COALESCE(feedback."CommanMasterName"::text, 'NA') AS "FeedbackName",
           sum(lf."NoOfFeedBack")::numeric AS "NoOfFeedBack"
    FROM (SELECT f."CommanFeedbackId",
                 count(f."CommanFeedbackId") AS "NoOfFeedBack"
          FROM "ledger_feedback" f
          WHERE f."FeedbackDate" BETWEEN FromDate AND ToDate
            AND f."OrganizationId" = varOrganizationId
            AND (COALESCE(varGroupAgentId, 0) = 0 OR f."AsignAgentLedgerId" = varGroupAgentId)
            AND f."RecordStatus" != 'D'
            AND (f."LedgerId" = COALESCE(varLedgerId, 0) OR COALESCE(varLedgerId, 0) = 0)
          GROUP BY f."CommanFeedbackId"
         ) AS lf
    LEFT JOIN "comman_master" feedback ON feedback."CommanMasterId" = lf."CommanFeedbackId"
    GROUP BY lf."CommanFeedbackId", feedback."CommanMasterName"
    ORDER BY 2;
END;
$$;
