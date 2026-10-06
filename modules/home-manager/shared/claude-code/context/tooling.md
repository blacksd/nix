## Tooling

Prefer the native Read, Grep, and Glob tools when the harness provides them. In Bash, use these CLIs instead of the generic ones:

| Task | Use | Not |
|---|---|---|
| find files | `fd` | `find` |
| search text | `rg` | `grep`, `cat \| grep` |
| search code structure | `ast-grep` | regex over source |
| JSON | `jq` | ad-hoc parsing |
| YAML / XML | `yq` (`yq -p xml` for XML) | ad-hoc parsing |
| GitHub | `gh` (`gh pr view`, `gh pr diff`, `gh api`) | WebFetch |

Never WebFetch a GitHub URL: private organizations return 404. Use `gh` for every GitHub URL you encounter.
