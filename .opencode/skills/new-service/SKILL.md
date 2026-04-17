---
name: new-service
description: Use this skill whenever deploying a new service, adding a new application, setting up a new container, exposing a new web service, or configuring any new network-accessible service on mainframe or any other host in the nix-forge infrastructure. This includes Docker containers, NixOS services, reverse proxy entries, or anything that needs to be reachable over the network. Always consult this checklist before finalizing a new service deployment.
---

# New Service Deployment Checklist

When deploying any new service, these dependent systems must be updated together. Missing any of them will result in the service being unreachable or returning errors.

## 1. Caddy Reverse Proxy (`modules/services/caddy.nix`)

Every web service needs a Caddy virtual host entry. Without it, the service has no public URL.

- Add a new entry in `services.caddy.virtualHosts`
- Use the pattern `"subdomain.connorrhodes.com"` (or `*.rhodes.contact` for that domain)
- Decide on TLS: either use the wildcard cert (`tls /etc/caddy/certs/...`) or Caddy's automatic HTTPS (no `tls` directive needed for auto)
- Add `${robotsTxt}` unless the service needs to be indexed
- Add `${autheliaSSO}` if the service should be behind Authelia (see step 2)
- Set `reverse_proxy 127.0.0.1:<PORT>` to the service's local port

## 2. Authelia SSO (`modules/services/authelia.nix`)

If the service uses Authelia SSO, it **must** be added to the access control rules. Without this, Authelia will return 403 Forbidden because the default policy is deny.

There are two Authelia instances:
- `connorrhodes-com` (port 9091) — for `*.connorrhodes.com`
- `connor-engineer` (port 9092) — for `*.connor.engineer`

Add the domain to the appropriate instance's `access_control.rules` list:

- For family-accessible services: add to the `group:parents` rule
- For admin-only services: add to the `group:admins` rule (the large domain list)

The domain goes in the `domain` list of the appropriate rule block. Match the same group membership as similar existing services.

## 3. Host Configuration (`hosts/<host>/configuration.nix`)

Import the new service module file in the host's `configuration.nix` imports list.

## 4. Firewall Ports

If the service listens on a non-standard port that needs external access, add it to `networking.firewall.allowedTCPPorts`. Most services behind Caddy only need ports 80/443 (already open).

## 5. DNS

For `*.connorrhodes.com` subdomains, Caddy handles TLS automatically or uses the wildcard cert. No separate DNS entry is needed if using the wildcard cert or Caddy auto-HTTPS with a DNS challenge.

## Common Patterns

### All-Docker service
Multiple containers (app + database + cache) using `virtualisation.oci-containers.containers`. Use `--network=host` for inter-container communication via localhost. Watch for port conflicts with existing services.

### NixOS native service
Use the NixOS module (`services.<name>`) and bind to `127.0.0.1`. Caddy handles public access.

## Port Conflict Check

Before assigning a port, check for conflicts.

Always verify with `ss -tlnp | grep <port>` if unsure
