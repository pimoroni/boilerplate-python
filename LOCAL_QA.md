# Local QA with Docker

A Docker-based testing image is provided so checks can be run on any machine without
installing tooling locally. Four Python versions are supported, each on the Debian release
that shipped it:

| Target | Python | Debian base |
|---|---|---|
| `testing-3.9` | 3.9 | Bullseye (11) |
| `testing-3.10` | 3.10 | Bookworm (12) |
| `testing-3.11` | 3.11 | Bookworm (12) |
| `testing-3.13` | 3.13 | Trixie (13) — default |

## Build the image

Pass your host UID and GID so that files written inside the container are owned by your
user, not root. Use `--target` to select a Python version; omit it to get the default
(Python 3.13 / Trixie):

```bash
# Default (Python 3.13 / Trixie)
docker build -f Dockerfile.testing \
  --build-arg UID=$(id -u) \
  --build-arg GID=$(id -g) \
  -t boilerplate-dev:python3.13-v0.0.1 .

# Specific version
docker build -f Dockerfile.testing \
  --build-arg UID=$(id -u) \
  --build-arg GID=$(id -g) \
  --target testing-3.11 \
  -t boilerplate-dev:python3.11-v0.0.1 .
```

> **Image tag convention:** `boilerplate-dev:python<python-ver>-v<testing-ver>`
> The testing version is independent of any library release. Start at `v0.0.1` and
> increment: patch for dependency bumps/minor tweaks, minor for new tools or a Python
> version bump, major for breaking changes to the dev workflow.

## Run checks

All commands below mount the repository into the container so changes are picked up
without a rebuild. Run them from the repository root. Substitute the tag for whichever
Python version you built.

**Integrity checks** (trailing whitespace, DOS line-endings, CHANGELOG entry, git tag):

```bash
docker run --rm -v "$(pwd)":/app boilerplate-dev:python3.13-v0.0.1 make check
```

**Shell script linting:**

```bash
docker run --rm -v "$(pwd)":/app boilerplate-dev:python3.13-v0.0.1 make shellcheck
```

**QA** (ruff, isort, codespell, check-manifest, build, twine check):

```bash
docker run --rm -v "$(pwd)":/app boilerplate-dev:python3.13-v0.0.1 make qa
```

**Tests:**

```bash
docker run --rm -v "$(pwd)":/app boilerplate-dev:python3.13-v0.0.1 make pytest
```

## Dependency lock file

The `testing-3.10`, `testing-3.11`, and `testing-3.13` targets install from
`requirements-dev.lock`. Regenerate it when `requirements-dev.txt` changes, using the
same uv version as the Dockerfile pin:

```bash
uv self update 0.11.17  # align host uv with Dockerfile pin
uv pip compile requirements-dev.txt --output-file requirements-dev.lock --python-version 3.11
```

Then rebuild the affected images.

> **Note on Python 3.9:** the `testing-3.9` target uses plain `pip` directly from
> `requirements-dev.txt` (no lockfile) because the shared lockfile was compiled for
> Python 3.11 and several transitive dependencies require Python ≥ 3.10.
