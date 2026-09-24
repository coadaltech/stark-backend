-- Converted from MySQL procedure `dashbaord_jantri_collection_of_organization`.
-- NOTE: MySQL used SELECT DISTINCT together with GROUP BY s.ShiftId (the PK, which is in the select list),
-- so DISTINCT was a no-op; it is dropped because PG rejects DISTINCT with ORDER BY columns not in the select list.
DROP ROUTINE IF EXISTS "dashbaord_jantri_collection_of_organization";
CREATE OR REPLACE FUNCTION "dashbaord_jantri_collection_of_organization"(
    varOrganizationId bigint,
    varLedgerId bigint,
    varAgentId bigint
)
RETURNS TABLE(
    "CollectionAmount" double precision,
    "JantriAmount" double precision,
    "ShiftDate" date,
    "ShiftId" bigint,
    "ShiftName" text,
    "ShiftFor" text,
    "DeclareDate" date,
    "DeclareNumber" integer
)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT
        sum(CASE WHEN t."EntryType" = 'Main' THEN td."Amount" ELSE 0 END) AS "CollectionAmount",
        round(sum(CASE WHEN t."EntryType" = 'Main' THEN (CASE WHEN t."TransactionMode" = 1 THEN

                    td."FinalAmount"
                    -
                    (
                        (td."FinalAmount")
                        - (td."FinalAmount"
                        * (COALESCE((
                                t."SelfHissa"
                        / 100), 0))
                        )
                    ) * (COALESCE((
                            (SELECT sum(h."Hissa") FROM
                             "hissa" h
                             WHERE h."RecordStatus" != 'D' AND h."LedgerId" = t."LedgerId" AND h."LedgerId" != h."HissaLedgerId")
                    / 100), 0))

                    - (td."FinalAmount"
                    * (COALESCE((
                            t."SelfHissa"
                    / 100), 0))
                    )

        ELSE 0 END) ELSE 0 END)) AS "JantriAmount",
        s."ShiftDate", s."ShiftId", s."ShiftName"::text, s."ShiftFor"::text
        , declare_result."DeclareDate"
        , (SELECT d."DeclareNumber" FROM "declare_result" AS d WHERE d."RecordStatus" != 'D' AND d."OrganizationId" = varOrganizationId AND d."ShiftId" = s."ShiftId" AND d."DeclareDate" = declare_result."DeclareDate") AS "DeclareNumber"
    FROM "transaction" t
    INNER JOIN "ledger" l ON t."LedgerId" = l."LedgerId"
    INNER JOIN "transaction_detail" td ON td."TransactionId" = t."TransactionId" AND td."RecordStatus" != 'D'
        AND t."OrganizationId" = varOrganizationId AND t."RecordStatus" != 'D'
        AND (COALESCE(varLedgerId, 0) = 0 OR t."LedgerId" = varLedgerId OR l."ParentLedgerId" = varLedgerId
            OR l."ParentLedgerId" IN (SELECT dis."LedgerId" FROM "ledger" AS dis WHERE dis."ParentLedgerId" = varLedgerId)
            OR (SELECT lg."UserName" FROM "ledger" lx
                INNER JOIN "login" lg ON lg."LedgerId" = lx."LedgerId"
                WHERE lg."LoginType" IN (11, 12) AND lx."LedgerId" = COALESCE(varLedgerId, 0)) = t."AddedBy"
            )
        AND COALESCE((SELECT lx."GroupId" FROM "ledger" lx WHERE lx."LedgerId" = varLedgerId), 0) <> 6
    RIGHT JOIN "shift" s ON s."ShiftId" = t."ShiftId"
    LEFT JOIN (SELECT max(dr."DeclareDate") AS "DeclareDate", dr."ShiftId" FROM "declare_result" dr
               WHERE dr."RecordStatus" != 'D' AND dr."OrganizationId" = varOrganizationId GROUP BY dr."ShiftId") AS declare_result
        ON declare_result."ShiftId" = s."ShiftId"
    WHERE 1 = 1
      AND s."IsActive" = '1'
      AND s."OrganizationId" = varOrganizationId
      AND s."RecordStatus" != 'D'
    -- declare_result.DeclareDate added to GROUP BY: one row per ShiftId in that derived table, so equivalent.
    GROUP BY s."ShiftId", s."ShiftOrder", s."ShiftName", declare_result."DeclareDate"
    ORDER BY s."ShiftOrder", s."ShiftName";
END;
$$;
