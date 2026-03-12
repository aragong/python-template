"""Entry point for the python-template package.

Run with:
    python -m src
"""

import logging
from src.__version__ import __api_name__, __version__
from src.config.env import env
from src.core.telemetry import setup_opentelemetry

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(name)s: %(message)s")
logger = logging.getLogger(__name__)


def main() -> None:
    """Bootstrap the application: telemetry → env validation → run."""
    setup_opentelemetry()
    env.validate()

    logger.info("Starting %s v%s (env: %s)", __api_name__, __version__, env.APP_ENVIRONMENT)
    # TODO: add your application logic here


if __name__ == "__main__":
    main()
