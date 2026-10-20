# Varietyctl Changes

Round 2 below supersedes the Round 1 backend fallback, session export and
unsupported Wayland lock-screen behaviour. Earlier results remain historical.

The controller remains POSIX `sh`, keeps `set -u` and the existing actions, and
retains the modern tool paths and their POSIX fallbacks. Run its regression suite
with `sh Libraries/posix/tasks/varietyctl.test` from the repository root.

## Round 1

### Requested Items

| Item | Status | Change |
| --- | --- | --- |
| 1 | Done | Dispatch the four Variety actions first, resolving only Variety. |
| 2 | Done | Resolve tools on demand and cache both found and missing tools in shell variables. |
| 3 | Done | Probe `xargs -0` only in `get_swaybg`; reuse the result for every process read. |
| 4 | Done | Match desktop names with case-insensitive shell patterns, without `tr`. |
| 5 | Done | Discover monitors with JSON and `jq`, then `rg --no-config`, then POSIX `sed`. |
| 6 | Done | Validate and convert relative paths to absolute paths using shell parameter expansion and one directory subshell. Leading dashes and trailing newlines remain data. |
| 7 | Done | Capture the current user's old swaybg PIDs, launch with detached input/output and optional `setsid`, check survival after a short delay, then retire only captured PIDs. Failed startup returns 1 and retains the old processes. |
| 8 | Done | Require `ok` from every hyprpaper wallpaper call. All failures allow the next backend in auto mode; an explicit backend returns failure. Commas produce a clear diagnostic and allow fallback. |
| 9 | Done | Check fallback dependencies before invoking them, including `sed`, `awk`, `ps`, `od`, `xargs` and `sh`. |
| 10 | Done; live desktop checks limited | Percent-encode file URLs; support kwriteconfig6 and kwriteconfig5; document the KDE URL choice and map mode to Qt FillMode. Unsupported desktops mention manual hyprlock configuration. See verification below. |
| 11 | Done | Serialise setters with a per-user `flock` file, or an atomic mkdir lock with recorded-owner stale checks and guarded reclamation. Both paths have bounded waits. |
| 12 | Done | Prefer `VARIETYCTL_BACKEND`; retain `WALLPAPER_BACKEND` as the deprecated alias. |
| 13 | Done | Log backend choices, tool resolution and suppressed backend errors to stderr with `VARIETYCTL_DEBUG=1`. |
| 14 | Done | Force the requested parser/process fallbacks with `VARIETYCTL_POSIX_ONLY=1`. |
| 15 | Done | Document image, change reason, original image and mode. Installed Variety source confirms mode is argument 4 after the action. |

The user also approved treating DMS `ERROR:` replies as failures even when IPC
exits successfully. This enables its per-monitor setter and auto fallback.

## Nix Integration

- Package the controller with coreutils, ripgrep, jq, procps, findutils, GNU sed,
  gawk, a shell and util-linux in its runtime PATH.
- Export `VARIETYCTL_BACKEND` from Home Manager. The controller wrapper honours
  an explicit new variable, then the deprecated alias, then the declared default.
- Install swaybg for auto mode as well as the explicit swaybg backend.
- Connect set, get and set-lockscreen hooks to the packaged controller. Add the
  custom `scripts.set-lockscreen` option and generate `set_lock_screen_script`.
- Repair the current Variety module's `mkConfig` composition and supply the
  missing default `paths.wallpapers.all`, preserving an explicitly supplied list.
- Retain the current keyboard actions and the existing Variety profile wrapper.

## Installed Tool Verification

- **Variety 0.9.0b1:** `--help` confirms `--next`, `--previous`, `--favorite`,
  `--preferences` and `--show-preferences`. Installed `VarietyWindow.py` passes
  image, change reason, original image and display mode to either setter hook.
- **Hyprland 0.56.2 / hyprpaper 0.8.4:** verified installed versions. Outside the
  filesystem sandbox, `hyprctl hyprpaper listactive` exits 0 with empty stdout;
  there are no active entries to inspect. The documented format is
  `MONITOR: /path`, and the current IPC accepts an optional third fit mode.
  The controller targets the 0.8.x contract introduced with the rewrite; see the
  [Hyprpaper documentation](https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/)
  and [0.8.0 release](https://github.com/hyprwm/hyprpaper/releases/tag/v0.8.0).
  Actual wallpaper mutations and an installed stdout-error response remain
  **unverified**; stubs cover both call forms and false success replies.
- **DMS 1.6.3:** live IPC lists `get`, `getFor`, `set` and `setFor`. Both the live
  getter and the revised controller's DMS getter return the current image with
  exit 0. Installed QML source confirms the argument order and textual `ERROR:`
  responses. Setter mutations were tested with stubs.
- **GNOME:** gnome-shell is not installed, so visible lock-screen behaviour is
  **unverified locally**. Current upstream
  [unlockDialog.js](https://github.com/GNOME/gnome-shell/blob/main/js/ui/unlockDialog.js)
  uses BackgroundManager, whose default schema in
  [background.js](https://github.com/GNOME/gnome-shell/blob/main/js/ui/background.js)
  is `org.gnome.desktop.background`. The resulting source-based conclusion is
  that changing only `screensaver.picture-uri` does not change the stock blurred
  unlock background. The compatibility write remains, as requested.
- **KDE:** neither kwriteconfig generation is installed. The URL choice is based
  on the upstream [image component](https://github.com/KDE/plasma-workspace/blob/master/wallpapers/image/imagepackage/contents/ui/main.qml)
  and [image backend](https://github.com/KDE/plasma-workspace/blob/master/wallpapers/image/plugin/imagebackend.cpp).
  Both kwriteconfig branches, URL encoding and FillMode are stub-tested; live
  Plasma rendering remains **unverified**.
- **Shells:** system sh and dash are available. `checkbashisms` is unavailable.

## Validation And Boundaries

ShellCheck passes without suppression directives for both controller and test.
The suite passes under system sh and dash, with 91 explicit assertions per run,
plus command failures guarded by `set -e`. It covers both parser modes, unusual
filenames, empty argv entries, monitor discovery, backend failures, dependency
errors, ten concurrent setters with each lock method, failed replacement,
stale-lock recovery, lock-screen arguments and environment precedence.

The focused Nix wallpaper and keyboard suites pass: 10 and 22 tests respectively.
Victus Home Manager evaluates with the controller and both wallpaper fallback
packages. The generated configuration and all three hook derivations were
inspected without building. The evaluated wrapper also passes isolated stub
checks for its declared default, deprecated alias, new-variable precedence and
next dispatch.

The swaybg survival check confirms startup survival, not compositor readiness or
continued operation. An empty mkdir lock left by a crash before its PID is written
is not reclaimed automatically; the bounded wait returns failure. No system build,
switch, activation, commit or push was performed. Existing user changes remain.

Craole can review the diff next. No further implementation decision is required;
a build or activation requires the usual separate publication and deployment step.

## Round 2

### Implementation Status

| Item | Status | Result |
| --- | --- | --- |
| One backend | Done | Auto probes once per invocation: reachable DMS first, otherwise reachable hyprpaper on Hyprland, otherwise swaybg. Explicit selection uses only that backend. Getter/setter failure is final and names it. Compositor monitor discovery remains part of the same DMS per-monitor retry. |
| 1. pkill | Done | Installed procps-ng 4.0.7 **does** list `-p, --pid` in `pkill --help`, separately from `-P, --parent`. Removed the branch, resolver, POSIX_ONLY entry and stub anyway, as requested. Captured, user-filtered PIDs use the kill builtin. |
| 2. Wayland lock-screen hook | Done; niri runtime unverified | Hyprland/niri silently update the image symlink with a same-directory temporary link and atomic rename. There are POSIX ln/mv forms for implementations without `--`. Existing GNOME/KDE behaviour is retained; GNOME debug output explains the compatibility write. |
| 3. Monitor discovery | Done; installed niri verification unavailable | Hyprland uses its JSON monitor array, then rg/sed text fallbacks. Niri uses its output-map keys and requires a JSON parser; missing or malformed JSON fails clearly. No hyprctl call is made for niri discovery. |
| 4. Nix wrapper | Done | An unconditional, separately shell-escaped assignment fixes the backend to the module option. Removed the backend session export. Tests cover stale ambient values and quote/dollar/command-substitution text as literal data. |
| 5. Extra Nix edits | Done | Retained the proven mkConfig repair. Renamed the wallpaper path list and its sole consumer to folders. Module checks preserve both its default and a supplied ordered list. Swaybg remains installed in auto mode. |
| 6. Smaller items | Done | See the detailed checks below. |

The backend option is an enum: `auto`, `dms`, `hyprpaper`, `swaybg`. A repository
search found no backend session-variable consumer outside the controller,
wrapper, tests and documentation. No replacement session export is needed. The
standalone script retains the deprecated alias; the Nix wrapper always wins.

A comma remains a hard hyprpaper encoding error. A possible future workaround is
a stable, comma-free symlink whose full path also contains no comma. Hyprpaper
would receive that alias, and `get` would return the alias rather than the original
image unless dereferencing were deliberately added. No workaround was implemented.

### Lockers And The Separate Hyprlock Change

The managed `programs.hyprlock` background now points to
`${config.xdg.stateHome}/varietyctl/lockscreen`, while retaining its existing blur
settings. The default evaluated path on Victus is
`/home/craole/.local/state/varietyctl/lockscreen`. The addon imports now pass the
configuration context needed for that path. This is a separate Nix configuration
change; Hyprland/niri script handling never edits locker configuration.

Installed DMS 1.6.3 follows the current per-monitor wallpaper unless its
`lockScreenWallpaperPath` setting is non-empty. Source evidence is
`Modules/Lock/LockScreenBackground.qml` and `Services/LockPlacementService.qml`.
The live setting returned `""`, so the link is only needed for hyprlock in the
current DMS setup. DMS also exposes a custom lock-screen image setting.

The checked-in `Configuration/niri/default.kdl` lock binding launches swaylock.
No niri executable or running niri session was available here, so the active
niri locker is **unverified**. Its configuration was not changed.

### Evaluation Evidence For The Nix Repairs

Replaying the old mkConfig invocation without outputs produced:

```text
error: function 'mkConfig' called without required argument 'outputs'
at Libraries/nix/modules/construction.nix:337:14
```

Evaluating the original source defaults without the injected list produced:

```text
error: attribute 'all' missing
at Modules/nix/home/interface/components/wallpaper/variety/options/sources.nix:148:32
148|       ++ map (source "folder") paths.wallpapers.all
```

That source generator is the sole consumer. Both it and the parent now use
`paths.wallpapers.folders`. The existing recursive merge preserves a supplied list.
A module-level check produced default `[/test/default]` and explicit
`[/test/first /test/second]`, in that order.

### Smaller Items And Verification Boundaries

- **Done:** the controller header contains only the minimum hyprpaper version.
  The Round 1 verification account remains above as historical evidence.
- **Done:** swaybg is polled throughout a default 0.5-second settling period.
  `VARIETYCTL_SWAYBG_SETTLE` accepts positive seconds with at most one decimal
  place, for example `0.2` or `1`. Integer-only POSIX sleep uses longer,
  one-second polling delays. The delayed-death test checks a process that exits
  after 0.2 seconds and verifies that the previous process survives.
- **Done:** after the bounded directory-lock wait, an empty lock with no observed
  owner PID can be reclaimed. Reclamation checks directory identity and rereads
  its owner under a reaper lock; a live owner's lock is retained.
- **Done:** `flock -E 200 -w 5` uses 200 only for lock conflict/timeout. Other
  nonzero statuses close the descriptor and use the mkdir lock. Installed
  util-linux help confirms these options.
- **Done:** the /tmp fallback uses a per-user 0700 directory, with numeric-owner
  and mode verification. GNU stat is preferred; POSIX ls/awk provide the metadata
  fallback. Symlink roots and foreign owners are rejected.
- **Done:** installed Variety 0.9.0b1 `Options.py:126` reads
  `config["set_lock_screen_script"]`; line 649 supplies its default script path.
- **Done:** usage and validation list exactly the four final backend values.

Live Hyprland 0.56.2 monitor JSON is an array with a `name` field; the stub models
that shape with fixture connector labels. Niri is absent locally. Its upstream
[IPC types](https://github.com/niri-wm/niri/blob/main/niri-ipc/src/lib.rs) define
Outputs as a map from name to Output, and its
[CLI implementation](https://github.com/niri-wm/niri/blob/main/src/ipc/client.rs)
serialises that map directly for `msg --json outputs`. The niri stub models this
source-verified shape; installed-version/live behaviour remains **unverified**.
Forced POSIX mode intentionally reports the missing JSON parser for niri
per-monitor operations. Ordinary DMS operations still work in either mode.

The ten-setter stress test uses the supported 0.1-second settle override to stay
within the existing five-second lock wait. Individual setter tests and the
separate delayed-death test use the default period. Stub comments describe the
real argv/output contract being modelled, and backing utilities retain their
basenames for Nix's multicall coreutils.

Nix wrapper regression checks accept evaluated wrapper fixtures through
`VARIETYCTL_TEST_WRAPPER`, `VARIETYCTL_TEST_QUOTED_WRAPPER` and
`VARIETYCTL_TEST_QUOTED_BACKEND`. The quote test exercises the production wrapper
generator with input that the real enum rejects before code generation.

No commit, build, switch, activation or live wallpaper mutation was performed.
Craole owns the next step: review the Round 2 patch and separate hyprlock patch.
No further implementation decision is required; live niri acceptance remains a
follow-up in a niri session.

### Round 2 Validation Results

Each stage below passed ShellCheck and the complete suite in both shells. Every
suite run exercises normal and forced POSIX modes; counts are per run, not an
aggregate across stages. The later wrapper stages include the evaluated Nix
fixtures described above.

| Stage | sh Assertions | dash Assertions | Result |
| --- | ---: | ---: | --- |
| design | 100 | 100 | Passed |
| item1 | 100 | 100 | Passed |
| item2 | 124 | 124 | Passed |
| item3 | 127 | 127 | Passed |
| item4 | 131 | 131 | Passed |
| item5 | 131 | 131 | Passed |
| item6 | 159 | 159 | Passed |

The focused Nix suites passed with zero failures: 10 wallpaper tests and 22
keyboard tests. Nix evaluation confirmed the hyprlock background, absent backend
session export, literal wrapper assignment, and folders-list preservation.


## Round 3

This round builds on the uncommitted Round 2 tree. Its notes supersede the older
five-second lock wait, burst settle override and niri JSON-only limitation.
No commit, build, switch or activation is authorised for this round.

### 1. Scope The Lock — Done

Only the swaybg setter takes the lock. DMS and hyprpaper do not resolve lock tools,
create lock files or wait on a lock. Regression tests cover a missing lock file
and an existing directory lock owned by the test runner. Ten concurrent swaybg
setters now use the default 0.5-second settle, for both flock and mkdir and both
tool modes. All ten must succeed and leave one surviving wallpaper process.
The wait is now ten seconds (`flock -w 10`, 100 mkdir attempts): ten serial survival
checks consume about five seconds before process and scheduling overhead.
The mkdir fallback retains its whole-second sleep fallback on POSIX-only sleep
implementations, where the wall-clock wait can consequently be longer.

### 2. Lock Hook Eligibility — Done

Hyprland and niri desktop matches use the link even without WAYLAND_DISPLAY.
Other sessions with a non-empty WAYLAND_DISPLAY also use it. KDE and GNOME retain
their existing handlers. An unsupported session returns success, writing only a
VARIETYCTL_DEBUG message when debugging is enabled.

### 3. Lock Screen Consumers — Done

Installed Variety 0.9.0-b1 `VarietyWindow.py:1499–1559` runs filters, layout, quotes,
clock and optional copy operations before invoking both hooks with the resulting
image. Lines 2761–2778 pass the processed image as argument 1 and the original
source as argument 3. Lines 2742–2757 prune old generated wallpaper images, so a
link to the processed file can dangle after later changes. The link now prefers
an existing original file from argument 3; direct calls without one retain
argument 1. A relative original is made absolute. Tests remove a simulated clock
image and verify that the original remains reachable through the link.
This avoids Variety's generated-image cleanup; deleting the original externally
can still break the link. The lock image uses the original without clock, quote
or other generated effects.

The installed source is:
`/nix/store/pm4g77axzl7ygsxaw5x7m6i6ik7gkqsx-variety-0.9.0-b1/lib/python3.14/site-packages/variety/VarietyWindow.py`.
DMS 1.6.3 `Modules/Lock/LockScreenBackground.qml:14,33–54` uses a custom image only
when `SettingsData.lockScreenWallpaperPath` is non-empty; otherwise it reads
`SessionData.getMonitorWallpaper(screenName)`. A fresh read of the live setting
returned `""`. Thus the link does not affect DMS's default locker on Hyprland or
niri. A niri session using swaylock is a different consumer: the checked-in
`Configuration/niri/default.kdl:367` currently launches `swaylock` without `-i`.
The active niri locker is **unverified**, since niri is absent here.

**Proposals only; neither locker configuration was changed in Round 3:**

- Change the niri binding to a shell wrapper that resolves
  `link=${XDG_STATE_HOME:-$HOME/.local/state}/varietyctl/lockscreen`, then runs
  `exec swaylock -i "$link"` when `[ -f "$link" ]`; otherwise run `exec swaylock`
  for its ordinary colour background. A shell wrapper is needed for variable
  expansion; a literal KDL spawn argument does not perform shell expansion.
- Give hyprlock an explicit opaque fallback `color = "rgba(24, 25, 38, 1.0)"`
  while retaining its link path. Hyprlock documents `color` as the fallback
  background colour, so the first lock can render before an image exists.
  See [the official hyprlock background options](https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/).

### 4. Niri POSIX Fallback — Partial: Locally Unverified

Without a JSON parser, niri monitor discovery runs `niri msg outputs` and uses
POSIX sed to extract connectors from headers of the form
`Output "make model serial" (DP-2)`. Indented details are ignored, including
`Disabled`, matching the JSON map's inclusion of disabled connectors. The fixture
models [upstream print_output](https://github.com/niri-wm/niri/blob/main/src/ipc/client.rs)
and names that provenance in its comments. The text and JSON paths produce the
same two connector names in tests. **Unverified against an installed niri:**
`command -v niri` found no executable, so no real local output could be captured.

### 5. Hyprpaper Reachability — Partial: Absent Endpoint Verified

Auto selection uses a dedicated listactive probe: non-zero status or leading IPC
error text means unreachable. Empty successful output remains valid for a daemon
with no active images. Tests model both the installed failure status and an
exit-zero error response, and assert swaybg is selected without a hyprpaper
wallpaper call. A selected backend's later failure remains final.

Installed hyprctl against an isolated endpoint with no hyprpaper daemon returned:

```text
status=1
error: can't send: failed to connect to hyprpaper (is it running?)
```

The command was `HYPRLAND_INSTANCE_SIGNATURE=varietyctl-round3-absent hyprctl
hyprpaper listactive`. The running live hyprpaper 0.8.4 daemon returned status 0
with empty output on its normal endpoint. **Not performed:** stopping the live
daemon and repeating the command there. The absent-endpoint check verifies
connection failure without changing the live wallpaper; a literal stopped-live-
daemon check remains unverified.

### 6. JSON Chain And Nix Runtime — Done

Monitor discovery tries jaq, then jq, using shared filters: `.[].name` on
Hyprland arrays and `keys[]` on niri objects. Hyprland then tries rg with
`--no-config`, then sed. Niri uses its sed text path when neither JSON tool is
available; malformed JSON with available parsers remains an error.
VARIETYCTL_POSIX_ONLY blanks both JSON tools as well as rg. Parser stubs verify
identical output and per-monitor calls for jaq and jq, jaq failure followed by
jq, and neither parser being invoked in POSIX-only mode. Ordinary discovery also
exercises installed jaq against compositor fixtures. The pinned nixpkgs input
provides jaq 3.1.1; `jaq` is now included before `jq` in the Nix runtime tools.

### 7. Link Swap And Wrapper Shell — Done

The symlink swap tries `mv -f -T` first, then plain `mv -f` for implementations
without `-T`. Absolute operands keep the fallback safe for leading dashes.
Tests record one successful modern swap and an option-rejecting POSIX fixture
that requires two attempts. The Nix wrapper uses `pkgs.writeShellScriptBin`, so
it runs under **bash**, despite the embedded source's `#!/bin/sh` comment.
The standalone controller remains POSIX sh and is tested under sh and dash.

### Backend Candidates Requiring Approval

No backends were added. `swww` is a possible separate backend for animated images;
its IPC, lifecycle and failure contract would need approval and dedicated tests.

### Validation

ShellCheck is clean for the controller and test suite. The complete suite passed
after each item under sh and dash; each run covers both ordinary and
VARIETYCTL_POSIX_ONLY modes:

| Item | sh Checks | dash Checks | Result |
| --- | ---: | ---: | --- |
| 1 | 159 | 159 | Passed |
| 2 | 172 | 172 | Passed |
| 3 | 178 | 178 | Passed |
| 4 | 178 | 178 | Passed |
| 5 | 182 | 182 | Passed |
| 6 | 190 | 190 | Passed |
| 7 | 197 | 197 | Passed |

The final run includes four additional checks against freshly evaluated Nix
wrappers: the declared backend overrides ambient values, and a metacharacter
fixture remains literal. Both wrappers embed the final controller source.
Evaluation confirms jaq 3.1.1 in the runtime PATH and no backend session export.
The changed Nix module parses; the focused wallpaper Nix suite reports ten tests
and no failures. The standalone source retains `set -u` and POSIX syntax.

The concurrent stale-directory stress sometimes prints an existing, non-fatal
missing-pid-file diagnostic if another process releases its lock between the
readability check and opening the PID file. That read failure is already handled
as an absent owner; every concurrent setter still succeeded. No unlisted change
to that handling was applied.

Logs and the Round 3-only patch are in `/tmp/varietyctl-round3/`. No commit, build,
switch, activation or live wallpaper change was performed. No backend was added.
Items 4 and 5 retain the explicit verification limits above; no user decision is
needed for the implemented patch. The locker proposals and backend candidate
require approval before a future implementation.
