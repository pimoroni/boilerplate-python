# Local QA with Docker

A Docker-based testing image is provided so checks can be run on any machine without
installing tooling locally. Python 3.11 is the first version set up; others will follow.

## Build the image

Pass your host UID and GID so that files written inside the container are owned by your
user, not root:

```bash
docker build -f Dockerfile.testing \
  --build-arg UID=$(id -u) \
  --build-arg GID=$(id -g) \
  -t boilerplate-dev:python3.11-v0.0.1 .
```

> **Image tag convention:** `boilerplate-dev:python<python-ver>-v<testing-ver>`
> The testing version is independent of any library release. Start at `v0.0.1` and
> increment: patch for dependency bumps/minor tweaks, minor for new tools or a Python
> version bump, major for breaking changes to the dev workflow.

## Run checks

All commands below mount the repository into the container so changes are picked up
without a rebuild. Run them from the repository root.

**Integrity checks** (trailing whitespace, DOS line-endings, CHANGELOG entry, git tag):

```bash
docker run --rm -v "$(pwd)":/app boilerplate-dev:python3.11-v0.0.1 make check
```

**Shell script linting:**

```bash
docker run --rm -v "$(pwd)":/app boilerplate-dev:python3.11-v0.0.1 make shellcheck
```

**QA** (ruff, isort, codespell, check-manifest, build, twine check):

```bash
docker run --rm -v "$(pwd)":/app boilerplate-dev:python3.11-v0.0.1 make qa
```

**Tests:**

```bash
docker run --rm -v "$(pwd)":/app boilerplate-dev:python3.11-v0.0.1 make pytest
```

## Dependency lock file

The image installs from `requirements-dev.lock`. Regenerate it when `requirements-dev.txt`
changes, using the same uv version as the Dockerfile `FROM` pin:

```bash
uv self update 0.11.17  # align host uv with Dockerfile pin
uv pip compile requirements-dev.txt --output-file requirements-dev.lock --python-version 3.11
```

Then rebuild the image.
