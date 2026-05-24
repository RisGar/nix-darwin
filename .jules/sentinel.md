## 2025-05-24 - [Remove Hardcoded Secret in Grafana Settings]
**Vulnerability:** A hardcoded `client_secret` was found in `hosts/homelab/metrics.nix` for `services.grafana.settings."auth.generic_oauth".client_secret`.
**Learning:** This repo uses `agenix` to manage secrets. The hardcoded secret should be moved into an age-encrypted file in `secrets/` and referenced in the nix config using `$__file{}` as Grafana settings support expanding environment variables or file contents.
**Prevention:** Always verify that no secrets are committed directly in Nix expressions or configuration attributes. Use `agenix` along with file-based secret expansion natively supported by applications (e.g. `$__file{/run/agenix/...}`).
