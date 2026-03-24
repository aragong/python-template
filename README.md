# python-template

[![Python](https://img.shields.io/badge/Python-3.9%2B-blue.svg)](https://python.org)
[![License](https://img.shields.io/badge/License-CC--BY--NC--ND--4.0-orange.svg)](LICENSE)

General-purpose Python template with `uv`-managed dependencies, environment-based configuration, and optional OpenTelemetry instrumentation.

## Overview

This repository is a lightweight starting point for Python services, CLIs, or scientific utilities that need:

- modern dependency management with `uv`
- runtime configuration through environment variables
- built-in logging and OpenTelemetry hooks
- test and lint tooling preconfigured through `pytest` and `ruff`

The package entry point lives in `src/__main__.py` and runs with `python -m src`.

## Quick Start

### Prerequisites

- Python 3.9 or newer
- [uv](https://docs.astral.sh/uv/)

### Setup

```bash
git clone https://github.com/IHCantabria/python-template.git
cd python-template

# Install runtime and development dependencies
uv sync --all-groups

# Run the project
uv run python -m src
```

### Local configuration

If you want to override defaults, create a `.env` file in the repository root:

```bash
cat > .env <<'EOF'
APP_ENVIRONMENT=local
TMP_DIR=./tmp
EXPORT_TRACES=false
OTEL_SERVICE_NAME=python-template
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318
EOF
```

The application starts without a `.env` file. OpenTelemetry setup is skipped when `OTEL_EXPORTER_OTLP_ENDPOINT` is not defined.

## Project Structure

```text
src/
├── __init__.py
├── __main__.py          # Package entry point
├── __version__.py       # Project metadata from pyproject.toml
├── config/
│   ├── __init__.py
│   └── env.py           # Environment loading and validation
└── core/
    ├── __init__.py
    └── telemetry.py     # OpenTelemetry setup
tests/
└── test_example.py      # Template sanity checks
```

## Environment Variables

The current template reads the following variables:

```bash
APP_ENVIRONMENT=local
TMP_DIR=./tmp
EXPORT_TRACES=true
OTEL_SERVICE_NAME=python-template
OTEL_SERVICE_VERSION=
OTEL_TRACES_EXPORTER=
OTEL_LOGS_EXPORTER=
OTEL_EXPORTER_OTLP_ENDPOINT=
OTEL_EXPORTER_OTLP_PROTOCOL=
ENV=development
```

### Notes

- `APP_ENVIRONMENT` accepts `local`, `development`, or `production`.
- `TMP_DIR` is created automatically if it does not exist.
- Traces are exported only when both `EXPORT_TRACES=true` and `OTEL_EXPORTER_OTLP_ENDPOINT` is set.
- If no OTLP endpoint is configured, the application logs a warning and continues running.

## Development

### Run the application

```bash
uv run python -m src
```

### Run tests

```bash
uv run pytest
```

### Coverage

```bash
uv run coverage run -m pytest
uv run coverage report
uv run coverage html
```

### Lint and format

```bash
uv run ruff check .
uv run ruff check . --fix
uv run ruff format .
```

## Docker

The repository includes a multi-stage Dockerfile with local and deployment targets.

```bash
# Build the deployment image
docker build --target deployment -t python-template:latest .

# Run the container
docker run --rm -e APP_ENVIRONMENT=production python-template:latest
```

## VS Code Dev Container

The repository includes a dev container configuration that installs `uv` and common Python tooling.

1. Install the Dev Containers extension.
2. Open the command palette.
3. Run `Dev Containers: Reopen in Container`.

## License

This project is licensed under **CC-BY-NC-ND-4.0**. See [LICENSE](LICENSE) for details.

## Credits

Developed by [German Aragon](https://github.com/aragong) at [IHCantabria](https://ihcantabria.com/en).
