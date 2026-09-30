// Minimal HS256 JSON Web Tokens on Web Crypto — no third-party libraries.
// Only HS256 is accepted: the header is checked exactly, so "alg: none" or algorithm swaps fail.

export type JwtPayload = Record<string, unknown> & {
  exp: number;
  iat: number;
  iss: string;
};

export type VerifyResult<T> =
  | { ok: true; payload: T }
  | { ok: false; reason: "malformed" | "signature" | "expired" | "issuer" };

const encoder = new TextEncoder();
const HEADER = { alg: "HS256", typ: "JWT" } as const;
/** Allowed clock difference between issuer and verifier, in seconds. */
const CLOCK_SKEW_SECONDS = 5;

const base64url = (bytes: ArrayBuffer | Uint8Array) =>
  Buffer.from(bytes as ArrayBuffer).toString("base64url");
const encodeJson = (value: unknown) =>
  base64url(encoder.encode(JSON.stringify(value)));
const decodeJson = (part: string): unknown =>
  JSON.parse(Buffer.from(part, "base64url").toString("utf8"));

const keys = new Map<string, Promise<CryptoKey>>();
function hmacKey(secret: string) {
  let key = keys.get(secret);
  if (!key) {
    key = crypto.subtle.importKey(
      "raw",
      encoder.encode(secret),
      { name: "HMAC", hash: "SHA-256" },
      false,
      ["sign", "verify"],
    );
    keys.set(secret, key);
  }
  return key;
}

export const nowSeconds = () => Math.floor(Date.now() / 1000);

/** Signs `claims`, adding iat / exp / iss. */
export async function signJwt(
  claims: Record<string, unknown>,
  secret: string,
  ttlSeconds: number,
  issuer: string,
) {
  const iat = nowSeconds();
  const payload: JwtPayload = {
    ...claims,
    iat,
    exp: iat + ttlSeconds,
    iss: issuer,
  };
  const data = `${encodeJson(HEADER)}.${encodeJson(payload)}`;
  const signature = await crypto.subtle.sign(
    "HMAC",
    await hmacKey(secret),
    encoder.encode(data),
  );
  return { token: `${data}.${base64url(signature)}`, payload };
}

/** Checks structure, algorithm, signature (constant-time via Web Crypto), issuer and expiry. */
export async function verifyJwt<T extends JwtPayload>(
  token: string,
  secret: string,
  issuer: string,
): Promise<VerifyResult<T>> {
  const parts = token.split(".");
  if (parts.length !== 3 || parts.some((p) => !/^[A-Za-z0-9_-]+$/.test(p)))
    return { ok: false, reason: "malformed" };
  const [headerPart, payloadPart, signaturePart] = parts as [
    string,
    string,
    string,
  ];

  let header: { alg?: unknown; typ?: unknown };
  let payload: T;
  try {
    header = decodeJson(headerPart) as typeof header;
    payload = decodeJson(payloadPart) as T;
  } catch {
    return { ok: false, reason: "malformed" };
  }
  if (
    header?.alg !== HEADER.alg ||
    header?.typ !== HEADER.typ ||
    typeof payload !== "object" ||
    payload === null
  ) {
    return { ok: false, reason: "malformed" };
  }

  const valid = await crypto.subtle.verify(
    "HMAC",
    await hmacKey(secret),
    new Uint8Array(Buffer.from(signaturePart, "base64url")),
    encoder.encode(`${headerPart}.${payloadPart}`),
  );
  if (!valid) return { ok: false, reason: "signature" };
  if (payload.iss !== issuer) return { ok: false, reason: "issuer" };
  if (
    typeof payload.exp !== "number" ||
    payload.exp + CLOCK_SKEW_SECONDS < nowSeconds()
  ) {
    return { ok: false, reason: "expired" };
  }
  return { ok: true, payload };
}

/** SHA-256 hex digest — refresh tokens are stored only as this hash. */
export async function sha256Hex(value: string) {
  return Buffer.from(
    await crypto.subtle.digest("SHA-256", encoder.encode(value)),
  ).toString("hex");
}
