---
name: initialize-repository
description: Use this skill to bootstrap a new project from the `python-template` by renaming all template placeholders, updating metadata fields, and generating a tailored `README.md` based on user-provided information. Triggered when the user asks to "initialize the repo", "set up the project", or "rename the template".
--- 

# SKILL: initialize_repository

## Definition
- **Purpose**: Bootstrap a new project from the `python-template` using `uv` for dependency management and environment isolation.
- **Activation**: Triggered by phrases like "initialize the repo", "set up the project", or "rename the template".

## Protocol (Step-by-Step)

### Phase 1 — Collect user inputs
Before making any change, resolve the default project name and then ask the user to confirm or override each input:

1. **project_name**: Infer the default by running `git remote get-url origin 2>/dev/null` and extracting the repository slug (last path segment, strip `.git`). If no remote exists, fall back to the current directory name (`basename $PWD`). Present the inferred name to the user and ask: *"Project name will be `<inferred>`— keep it or change it?"*. Use the confirmed value as `{project_name}`.
2. description (one-sentence description)
3. author_name (Full Name)
4. author_email (Contact Email)
5. repo_url (GitHub/GitLab URL, optional)

### Phase 2 — Update pyproject.toml
Replace the following fields in `pyproject.toml`:
- project.name: "python-template" -> {project_name}
- project.description: "Add description here" -> {description}
- project.authors[0].name: {author_name}
- project.authors[0].email: {author_email}
- project.urls.github: "" -> {repo_url}

### Phase 3 — Update Docker & DevContainer & github workflows
- **Dockerfile**: Replace `ARG APP_NAME=python-template` with `ARG APP_NAME={project_name}`.
- **.devcontainer/devcontainer.json**: Replace `"name": "python-template"` with `"{project_name}"`.
- **GitHub Workflows**: Search for `python-template` in `.github/workflows/` and replace it with `{project_name}` when present.

### Phase 4 — Generate UV-Native README.md
Overwrite `README.md` entirely using the following structure:

# {project_name}
{description}

## Quick Start
### Prerequisites
- **uv** (Modern Python package manager)

### Setup
git clone {repo_url}
cd {project_name}

# Install dependencies and create .venv
uv sync --all-packages

# Run the package
uv run python -m src

# Run tests
uv run pytest

# Lint
uv run ruff check .

## Environment Variables
APP_ENV=local
OTEL_SERVICE_NAME={project_name}
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317

## License / Credits
Author: {author_name} <{author_email}>
Repository: {repo_url}

### Phase 5 — Generate .env file
Create the `.env` file on-the-fly. This file must **never** be committed to the repository.

1. **Verify `.gitignore` contains `.env`**: Run `grep -q '^.env$' .gitignore || echo '.env' >> .gitignore`.
2. **Extract variables from `README.md`**: Read the `## Environment Variables` section generated in Phase 4. That section is the canonical source of variables and default values.
3. **Generate the file** using those exact variables and defaults.

### Phase 6 — Environment Synchronization (UV)
1. **Update Lockfile**: Run `uv lock`. This is mandatory after changing the project name.
2. **Synchronize Environment**: Run `uv sync --all-packages`. This will create the .venv and install the project in editable mode under the new name.
3. **Internal Validation**: Run `uv run python --version` to confirm the environment is correctly linked.

### Phase 7 — Verification Checklist
The agent MUST run these commands and confirm success:
- [ ] `grep -r "python-template" . --exclude-dir=.git` (must return zero matches)
- [ ] `uv run python -c "from src.__version__ import __api_name__; print(__api_name__)"` (must match {project_name})
- [ ] `uv run pytest` (must exit with code 0)
- [ ] `uv run ruff check .` (must exit with code 0)

## Knowledge Base / Reference
- The file `src/__version__.py` reads metadata from `pyproject.toml` at runtime.
- `uv sync` handles the creation of the virtual environment automatically.
- All observability configurations (OpenTelemetry) depend on the correct `OTEL_SERVICE_NAME`.

## Constraints
- **ONLY UV**: Forbidden to suggest `pip` or `venv` commands. Use `uv run` for all executions.
- **MANDATORY ENGLISH**: All content written to files (README, pyproject, docstrings) must be in English.
- **No Clutter**: Do not leave temporary files; use one-liners or terminal-based execution for checks.
- **Verification First**: Do not proceed to Phase 2 without all Phase 1 inputs.
