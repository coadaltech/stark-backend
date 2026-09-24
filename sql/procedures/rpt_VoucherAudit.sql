-- Converted from MySQL procedure `rpt_VoucherAudit`.
DROP ROUTINE IF EXISTS "rpt_VoucherAudit";
CREATE OR REPLACE FUNCTION "rpt_VoucherAudit"(
    varOrganizationId bigint,
    varFromDate date,
    varToDate date,
    /*, in varLedgerId bigint(21)*/
    varAuditStatus integer)
RETURNS TABLE(
    "VoucherDetailId" bigint,
    "OrganizationId" bigint,
    "VoucherId" bigint,
    "ShiftId" bigint,
    "LedgerId" bigint,
    "OppositeLedgerId" bigint,
    "FromLedgerId" bigint,
    "VoucherType" integer,
    "VoucherDetailType" integer,
    "VoucherDate" date,
    "Amount" double precision,
    "AmountType" text,
    "OpenAmount" bigint,
    "SelfHissa" double precision,
    "OtherHissa" double precision,
    "Flag1" text,
    "Remark" text,
    "MondayFinalFlag" text,
    "VoucherMode" text,
    "RecordStatus" text,
    "AddedBy" text,
    "AddedDate" timestamp,
    "UpdatedBy" text,
    "UpdatedDate" timestamp,
    "LedgerName" text,
    "OppositLedgerName" text,
    "VoucherAuditId_voucher_audit" bigint,
    "OrganizationId_voucher_audit" bigint,
    "VoucherId_voucher_audit" bigint,
    "LedgerId_voucher_audit" bigint,
    "OppositeLedgerId_voucher_audit" bigint,
    "VoucherDate_voucher_audit" date,
    "VoucherType_voucher_audit" integer,
    "Amount_voucher_audit" double precision,
    "AmountType_voucher_audit" text,
    "Remark_voucher_audit" text,
    "AuditType_voucher_audit" integer,
    "AuditStatus_voucher_audit" integer,
    "RecordStatus_voucher_audit" text,
    "AddedBy_voucher_audit" text,
    "AddedDate_voucher_audit" timestamp,
    "UpdatedBy_voucher_audit" text,
    "UpdatedDate_voucher_audit" timestamp,
    "LedgerName_voucher_audit" text,
    "OppositLedgerName_voucher_audit" text)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    RETURN QUERY
    SELECT vd."VoucherDetailId",
           vd."OrganizationId",
           vd."VoucherId",
           vd."ShiftId",
           vd."LedgerId",
           vd."OppositeLedgerId",
           vd."FromLedgerId",
           vd."VoucherType",
           vd."VoucherDetailType"::integer,
           vd."VoucherDate",
           vd."Amount",
           vd."AmountType"::text,
           vd."OpenAmount",
           vd."SelfHissa",
           vd."OtherHissa",
           vd."Flag1"::text,
           vd."Remark"::text,
           vd."MondayFinalFlag"::text,
           vd."VoucherMode"::text,
           vd."RecordStatus"::text,
           vd."AddedBy"::text,
           vd."AddedDate",
           vd."UpdatedBy"::text,
           vd."UpdatedDate",
           COALESCE(l."LedgerName"::text, '') AS "LedgerName", COALESCE(ol."LedgerName"::text, '') AS "OppositLedgerName",
           va."VoucherAuditId" AS "VoucherAuditId_voucher_audit",
           va."OrganizationId" AS "OrganizationId_voucher_audit",
           va."VoucherId" AS "VoucherId_voucher_audit",
           va."LedgerId" AS "LedgerId_voucher_audit",
           va."OppositeLedgerId" AS "OppositeLedgerId_voucher_audit",
           va."VoucherDate" AS "VoucherDate_voucher_audit",
           va."VoucherType"::integer AS "VoucherType_voucher_audit",
           va."Amount" AS "Amount_voucher_audit",
           va."AmountType"::text AS "AmountType_voucher_audit",
           va."Remark" AS "Remark_voucher_audit",
           va."AuditType"::integer AS "AuditType_voucher_audit",
           va."AuditStatus"::integer AS "AuditStatus_voucher_audit",
           va."RecordStatus"::text AS "RecordStatus_voucher_audit",
           va."AddedBy"::text AS "AddedBy_voucher_audit",
           va."AddedDate" AS "AddedDate_voucher_audit",
           va."UpdatedBy"::text AS "UpdatedBy_voucher_audit",
           va."UpdatedDate" AS "UpdatedDate_voucher_audit",
           COALESCE(l_audit."LedgerName"::text, '') AS "LedgerName_voucher_audit", COALESCE(ol_audit."LedgerName"::text, '') AS "OppositLedgerName_voucher_audit"
    FROM
        (SELECT x.* FROM "voucher_audit" x
          WHERE (x."AddedDate"::date BETWEEN varFromDate AND varToDate OR varAuditStatus = 1)
            AND (x."OrganizationId" = varOrganizationId)
            AND (x."AuditStatus" = varAuditStatus OR varAuditStatus = 0)
            AND x."RecordStatus" != 'D'
            AND x."VoucherId" != 0
         ) AS va
    JOIN "voucher_detail" vd ON va."VoucherId" = vd."VoucherId" AND (CASE WHEN va."AuditType" IN (2,3) THEN true ELSE vd."RecordStatus" != 'D' END)
    LEFT JOIN "voucher_detail" MinVoucher ON va."VoucherId" = MinVoucher."VoucherId"
                                         AND (CASE WHEN va."AuditType" IN (2,3) THEN true ELSE MinVoucher."RecordStatus" != 'D' END)
                                         AND vd."VoucherDetailId" > MinVoucher."VoucherDetailId"
/*
    join (select min(VoucherDetailId)VoucherDetailId
    ,min(case when voucher_detail.RecordStatus != 'D' then 9223372036854000000 else VoucherDetailId end)VoucherDetailIdWithoutDeleted
    from voucher_detail
    group by voucher_detail.VoucherId) as MinVoucher on (case when voucher_audit.AuditType in (2,3) then
                                            MinVoucher.VoucherDetailId = vd.VoucherDetailId
                                        else
                                            MinVoucher.VoucherDetailIdWithoutDeleted = vd.VoucherDetailId
                                        end)
*/
    JOIN "ledger" l ON vd."LedgerId" = l."LedgerId"
    JOIN "ledger" ol ON vd."OppositeLedgerId" = ol."LedgerId"
    LEFT JOIN "ledger" l_audit ON va."LedgerId" = l_audit."LedgerId"
    LEFT JOIN "ledger" ol_audit ON va."OppositeLedgerId" = ol_audit."LedgerId"
    WHERE MinVoucher."VoucherId" IS NULL

    UNION ALL

    SELECT 0::bigint AS "VoucherDetailId",
           varOrganizationId AS "OrganizationId",
           0::bigint AS "VoucherId",
           0::bigint AS "ShiftId",
           0::bigint AS "LedgerId",
           0::bigint AS "OppositeLedgerId",
           0::bigint AS "FromLedgerId",
           0 AS "VoucherType",
           0 AS "VoucherDetailType",
           varFromDate AS "VoucherDate",
           0::double precision AS "Amount",
           'Dr'::text AS "AmountType",
           0::bigint AS "OpenAmount",
           0::double precision AS "SelfHissa",
           0::double precision AS "OtherHissa",
           '0'::text AS "Flag1",
           ''::text AS "Remark",
           '0'::text AS "MondayFinalFlag",
           '0'::text AS "VoucherMode",
           ''::text AS "RecordStatus",
           ''::text AS "AddedBy",
           varFromDate::timestamp AS "AddedDate",
           ''::text AS "UpdatedBy",
           varFromDate::timestamp AS "UpdatedDate",
           ''::text AS "LedgerName", ''::text AS "OppositLedgerName",
           va."VoucherAuditId" AS "VoucherAuditId_voucher_audit",
           va."OrganizationId" AS "OrganizationId_voucher_audit",
           va."VoucherId" AS "VoucherId_voucher_audit",
           va."LedgerId" AS "LedgerId_voucher_audit",
           va."OppositeLedgerId" AS "OppositeLedgerId_voucher_audit",
           va."VoucherDate" AS "VoucherDate_voucher_audit",
           va."VoucherType"::integer AS "VoucherType_voucher_audit",
           va."Amount" AS "Amount_voucher_audit",
           va."AmountType"::text AS "AmountType_voucher_audit",
           va."Remark" AS "Remark_voucher_audit",
           va."AuditType"::integer AS "AuditType_voucher_audit",
           va."AuditStatus"::integer AS "AuditStatus_voucher_audit",
           va."RecordStatus"::text AS "RecordStatus_voucher_audit",
           va."AddedBy"::text AS "AddedBy_voucher_audit",
           va."AddedDate" AS "AddedDate_voucher_audit",
           va."UpdatedBy"::text AS "UpdatedBy_voucher_audit",
           va."UpdatedDate" AS "UpdatedDate_voucher_audit",
           COALESCE(l_audit."LedgerName"::text, '') AS "LedgerName_voucher_audit", COALESCE(ol_audit."LedgerName"::text, '') AS "OppositLedgerName_voucher_audit"
    FROM
        (SELECT x.* FROM "voucher_audit" x
          WHERE (x."AddedDate"::date BETWEEN varFromDate AND varToDate OR varAuditStatus = 1)
            AND (x."OrganizationId" = varOrganizationId)
            AND (x."AuditStatus" = varAuditStatus OR varAuditStatus = 0)
            AND x."RecordStatus" != 'D'
            AND x."VoucherId" = 0
         ) AS va
    LEFT JOIN "ledger" l_audit ON va."LedgerId" = l_audit."LedgerId"
    LEFT JOIN "ledger" ol_audit ON va."OppositeLedgerId" = ol_audit."LedgerId"

    ORDER BY "VoucherAuditId_voucher_audit"
    /*
    and (voucher_detail.LedgerId = varLedgerId or ifnull(varLedgerId,0) = 0 )
    */
    ;
END;
$$;
