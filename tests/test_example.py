"""Basic sanity tests for the template package."""

from src import __api_name__, __version__


def test_version_is_defined():
    """Package version should be a non-empty string."""
    assert isinstance(__version__, str)
    assert len(__version__) > 0


def test_api_name_is_defined():
    """Package name should be a non-empty string."""
    assert isinstance(__api_name__, str)
    assert len(__api_name__) > 0
