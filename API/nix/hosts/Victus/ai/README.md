# Victus AI Services

`default.nix` enables CPU-only Ollama on loopback and imports the Hermes team.
Ollama loads `qwen3:4b-instruct` after activation, with one inference slot and
an 8192-token default context. Building alone does not pull
model weights or start either service.

Hermes uses the local model for the main gateway, `receptionist` and `local`.
The new `planner`, `coder`, `researcher` and `reviewer` profiles use the existing
OpenAI Codex login, seeded from the runtime root `auth.json` when their own auth
file is absent. Existing profile authentication and model choices remain writable.
Built-in persistent memory and user memory are enabled throughout the team;
the external memory provider is unset because no local Hindsight service is
provisioned here.

All 26 existing profiles and the five starter profiles receive desktop Bot
metadata and Bot Chat launchers. The shared gateway multiplexes them. Existing
messaging credentials stay in runtime files; no new messaging accounts are
created. The main gateway handles unrouted messages locally.

Kanban dispatch and automatic decomposition are enabled with one worker total
and one per profile. The cloud planner coordinates tasks; the main gateway's
runtime login authenticates the auxiliary planning model. Every currently
installed profile, plus `default`, is admitted. Upstream planning discovers all
installed profiles independently of this declaration: add any future runtime
profile to the declared roster before automatic planning assigns it work.
These limits cover Kanban workers; they do not limit interactive Bot chats.

After switching, check `systemctl status ollama ollama-model-loader` and
`systemctl --user status hermes-agent`. Open `hermes-bot-planner` to initialise
its canonical Bot Chat. Cloud login expiry, model downloads and live message
delivery require runtime checks after activation.
