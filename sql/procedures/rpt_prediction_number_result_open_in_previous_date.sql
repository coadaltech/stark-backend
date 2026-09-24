-- Converted from MySQL procedure `rpt_prediction_number_result_open_in_previous_date`.
DROP ROUTINE IF EXISTS "rpt_prediction_number_result_open_in_previous_date";
CREATE OR REPLACE FUNCTION "rpt_prediction_number_result_open_in_previous_date"(
    varOrganizationId bigint,
    varShiftId bigint,
    varFromDate date,
    varToDate date,
    varDeclareNumber smallint
)
RETURNS TABLE("DeclareDate" date)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    -- note: varOrganizationId is not used by the original query
    RETURN QUERY
    SELECT dr."DeclareDate"
    FROM "declare_result" dr
    WHERE dr."ShiftId" = varShiftId
      AND dr."DeclareDate" BETWEEN varFromDate AND varToDate
      AND dr."RecordStatus" != 'D'
      AND dr."DeclareNumber" = varDeclareNumber;
END;
$$;
