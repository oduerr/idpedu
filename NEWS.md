# idpedu 0.2.0

- Enable KaTeX for HTML math in headers; add callouts fixture and tests (HTML/PDF).
- Improve HTML artifact handling when not self-contained.
- Add concise README notes and `dev/package_howto.md` for release steps.

# idpedu 0.101

- Added workflow tests (HTML/PDF/remote) and fixtures.
- Persist latest test artifacts under `tests/artifacts/` (gitignored).
- Pruned legacy R code: removed `CreateArbeitsblatt*`, `MergeRMD*`, `PraktikumsUtils`.
- Switched to `utils::download.file()` and documented `verbose`.
- Added package-level docs; cleaned stale Rd files.
- R CMD check is clean (0 errors, 0 warnings; 2 notes about top-level files/time).



