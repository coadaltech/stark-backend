-- Converted from MySQL procedure `chat_update_deviceid`.
DROP ROUTINE IF EXISTS "chat_update_deviceid";
CREATE OR REPLACE FUNCTION "chat_update_deviceid"(
    varLoginId bigint,
    varDeviceId varchar
)
RETURNS TABLE("InsertId" integer)
LANGUAGE plpgsql AS $$
#variable_conflict use_column
BEGIN
    UPDATE "login" SET "DeviceId" = varDeviceId
    WHERE "login"."LoginId" = varLoginId;

    RETURN QUERY SELECT 1 AS "InsertId";
END;
$$;
