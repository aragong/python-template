# python-template

[![Python](https://img.shields.io/badge/Python-3.9+-blue.svg)](https://python.org)
[![License](https://img.shields.io/badge/License-CC--BY--NC--ND--4.0-orange.svg)](LICENSE)

General-purpose Python project template with built-in environment variable management and OpenTelemetry observability.

## 🚀 Quick Start

## 🚀 Quick Start

### Prerequisites

- **Python** ≥ 3.9 (tested up to 3.13)
- **uv** — package manager ([install](https://docs.astral.sh/uv/))

### Setup

```bash
git clone https://github.com/IHCantabria/python-template.git
cd python-template

# Install dependencies
uv sync

# Copy and edit environment file (optional)
cp .env.example .env

# Run the project
python -m src

# Run tests
uv run pytest
```

## 📁 Project Structure

```text
src/
├── __init__.py          # Package metadata exports
├── __version__.py       # Dynamic version from pyproject.toml
├── __main__.py          # Entry point  (`python -m src`)
├── config/
│   └── env.py           # Environment variable management
└── core/
    └── telemetry.py     # OpenTelemetry setup
tests/
└── test_example.py      # Example tests
```

## 🔧 Environment Variables

Configure your application with a `.env` file:

```bash
# App settings
APP_ENVIRONMENT=local          # local | development | production
TMP_DIR=./tmp                  # Temporary directory

# Observability (optional — skip to disable tracing)
EXPORT_TRACES=false
OTEL_SERVICE_NAME=python-template
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318
```

## 📦 Dependencies

### Production

- **OpenTelemetry** — distributed tracing and log correlation
- **python-dotenv** — `.env` file loading

### Development & Testing

- **pytest** — testing framework
- **coverage** — code coverage
- **ruff** — linter and formatter

## 🧪 Testing

```bash
# Run all tests
uv run pytest

# Generate coverage report
uv run coverage run && uv run coverage report

# HTML report → htmlcov/index.html
uv run coverage html
```

## 🛠️ Code Quality

```bash
# Format code
uv run ruff format .

# Check and auto-fix issues
uv run ruff check . --fix
```

## 🐳 Docker

```bash
# Build image (deployment target)
docker build --target deployment -t python-template:latest .

# Run container
docker run -e APP_ENVIRONMENT=production python-template:latest
```

### VS Code Dev Container

1. Install the **Dev Containers** extension.
2. Press `Ctrl+Shift+P` → **Dev Containers: Reopen in Container**.

## 📋 License

This project is licensed under **CC-BY-NC-ND-4.0**. See [LICENSE](LICENSE) for details.

## © Credits

Developed by [Germán Aragón](https://github.com/aragong) @ [IHCantabria](https://ihcantabria.com/en)
