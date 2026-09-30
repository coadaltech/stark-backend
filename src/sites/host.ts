// Host names for sites (spec §5.3): the main app host and organization domains.

// A host name with an optional port, lower case: "lgaikhai.com", "app.lgaikhai.com",
// "acme.localhost:3000", "localhost:5000". No scheme, path, spaces or trailing dot.
const HOST_PATTERN =
  /^(?=[^:]{1,253}(?::|$))[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?(?:\.[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)*(?::([0-9]{1,5}))?$/;

/** True for a lower-case `host[:port]` with a port in 1–65535 (if given). */
export function isValidHost(host: string): boolean {
  const match = HOST_PATTERN.exec(host);
  if (!match) return false;
  const port = match[1];
  return port === undefined || (Number(port) >= 1 && Number(port) <= 65535);
}

/** How a request's Host header is compared with saved hosts: trimmed and lower-cased. */
export const normalizeHost = (host: string) => host.trim().toLowerCase();
