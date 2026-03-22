# AGENTS.md

Guidance for coding agents working in `/private/etc/nix-darwin`.

## Mission

- Maintain this repository as the source of truth for macOS (`nix-darwin` + Home Manager) and homelab (`NixOS`) systems.
- Prefer minimal, reversible changes that match existing Nix style.
- Keep secrets out of the Nix store and out of committed files.
- Validate affected targets before finishing.
- Always use Context7 when I need library/API documentation, code generation, setup or configuration steps without me having to explicitly ask.

## Repository Shape

- `flake.nix`: entry point with two primary outputs:
  - `darwinConfigurations."Rishabs-MacBook-Pro"`
  - `nixosConfigurations."Rishabs-Homelab"`
- `hosts/macbook/`: nix-darwin host modules.
- `hosts/homelab/`: NixOS host modules.
- `home/rishab/`: Home Manager user config and submodules.
- `secrets/`: agenix secret declarations (public keys + secret names), not plaintext secrets.
- `pkgs/`: custom derivations.

## Build Commands

Run from repo root: `/private/etc/nix-darwin`.

- Evaluate flake outputs:
  - `nix flake show`
- Validate flake metadata and checks:
  - `nix flake check --print-build-logs`
- Build macOS config without switching:
  - `sudo -i darwin-rebuild build --flake .#Rishabs-MacBook-Pro`
- Switch/apply macOS config:
  - `sudo -i darwin-rebuild switch --flake .#Rishabs-MacBook-Pro`
- Build homelab config without switching:
  - `nix build .#nixosConfigurations.Rishabs-Homelab.config.system.build.toplevel`
- Switch homelab config locally/remotely (as configured in fish aliases):
  - `nixos-rebuild switch --flake .#Rishabs-Homelab --target-host homelab --sudo`

## Lint / Format Commands

- Format Nix files (repo style tool is `nixfmt`):
  - `nixfmt flake.nix`
  - `nixfmt hosts/macbook/default.nix`
  - `nixfmt home/rishab/default.nix`
- Format multiple files when needed:
  - `nixfmt $(rg --files -g '*.nix')`
- Optional static analysis if available in dev shell/environment:
  - `statix check .`
  - `deadnix .`

## Test / Validation Strategy

There is no conventional unit-test suite in this repo; validation is done by evaluation/builds.

- Fastest safety check after edits:
  - `nix flake check --print-build-logs`
- Validate only one target host after host-specific changes:
  - macOS: `sudo -i darwin-rebuild build --flake .#Rishabs-MacBook-Pro`
  - homelab: `nix build .#nixosConfigurations.Rishabs-Homelab.config.system.build.toplevel`
- Validate only one module path via evaluation when possible:
  - `nix eval .#darwinConfigurations."Rishabs-MacBook-Pro".config.programs.fish.enable`
  - `nix eval .#nixosConfigurations."Rishabs-Homelab".config.services.openssh.enable`

## Running a Single Test (Equivalent)

Since there are no per-test binaries, a “single test” means a focused evaluation/build:

1. Pick the narrowest affected output path.
2. Run `nix eval` on that exact config path for quick checks.
3. Run one host build (`darwin-rebuild build` or `nix build ...toplevel`) before finishing.

Examples:

- Single option check:
  - `nix eval .#darwinConfigurations."Rishabs-MacBook-Pro".config.programs.mcp.enable`
- Single service check:
  - `nix eval .#nixosConfigurations."Rishabs-Homelab".config.services.dnscrypt-proxy.enable`

## Code Style (Nix)

- Indentation: two spaces.
- Prefer trailing semicolons for all Nix attr assignments.
- Keep attribute sets grouped logically (system, services, networking, programs, etc.).
- Keep imports sorted in stable, readable order.
- Preserve existing file-local patterns before introducing new abstractions.
- Avoid large refactors unless explicitly requested.

## Imports and Module Structure

- Add modules to existing `imports` lists near related modules.
- Keep host-specific behavior in `hosts/*` modules.
- Keep user/tooling behavior in `home/rishab/*` modules.
- Keep package definitions in `pkgs/*.nix` and consume through overlays.
- Pass shared values through `specialArgs`/`extraSpecialArgs` when needed.

## Naming Conventions

- Match existing output names exactly:
  - `Rishabs-MacBook-Pro`
  - `Rishabs-Homelab`
- Use clear lowercase names for modules/files (e.g., `dnscrypt-proxy.nix`).
- Prefer descriptive attr names over abbreviations unless already established.

## Types and Option Values

- Use correct Nix types strictly:
  - booleans: `true`/`false`
  - strings quoted
  - lists with homogeneous intent
  - attrsets for structured options
- Prefer `lib.mk*` helpers when merging precedence matters.
- Do not coerce values through shell snippets when native Nix options exist.

## Error Handling and Safety

- Fail early with explicit checks where practical (`nix eval` before full builds).
- For shell init logic, guard file reads (`test -r`) before reading.
- Never commit plaintext secrets, tokens, or private keys.
- Keep agenix workflow intact:
  - secret declarations in `secrets/secrets.nix`
  - secret material encrypted externally as `.age`
- Avoid reading secret contents at Nix evaluation time.

## Secrets and Environment Variables

- Prefer runtime secret access (process start) over embedding in declarative values.
- If that is not possible, prefer runtime env templates already used in repo.
- When adjusting secret flow, verify both shell startup and consuming process behavior.

## Git and Change Hygiene

- Do not revert unrelated working tree changes.
- Keep diffs minimal and scoped to the request.
- Update docs when behavior or commands change.
- If command output is long, summarize key failures/success paths in PR notes.

## Agent Workflow Checklist

1. Read nearby modules before editing.
2. Edit minimally and keep style consistent.
3. Format changed `.nix` files with `nixfmt`.
4. Run focused validation for impacted host/module.
5. Run `nix flake check --print-build-logs` when feasible.
6. Report what changed, what was validated, and what remains manual.

## When Unsure

- Prefer the most conservative change that preserves current behavior.
- Ask for clarification only when ambiguity materially affects infrastructure behavior.
- Document assumptions in the final handoff message.
