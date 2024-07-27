# Makefile for setting up and activating a Python virtual environment

# Set the desired Python interpreter (change if needed)
PYTHON := python3.11

# Virtual environment directory
VENV := .venv

STAGE?=ppe

# Default target
all: venv activate install

# Create the virtual environment
venv:
	@echo "Creating Python virtual environment..."
	$(PYTHON) -m venv $(VENV)

# Activate the virtual environment
activate:
	@echo "Activating Python virtual environment..."
	@echo "Run 'deactivate' to exit the virtual environment."
	@. $(VENV)/bin/activate

install:
	@echo "Installing dependencies from requirements files"
	pip install uv pur hatchling build twine
	pip install --upgrade pip
	uv pip install -r requirements.txt
	uv pip install pre-commit pytest pytest-snapshot

pre-commit:
	@echo "Running pre-commit"
	pre-commit run --files aws_hexagonal_adapters/*.py

test:
	@echo "Running pytest for stage "
	STAGE=$(STAGE) pytest tests

update:
	@echo "Updating used tools and scripts"
	pur -r requirements.txt
	pre-commit autoupdate

clean:
	@echo "Cleaning up..."
	rm -rf $(VENV)

build_upload:
	@echo "Building and uploading to PyPi"
	rm -rf dist/*
	python -m build
	twine upload dist/*
	rm -rf dist/*

help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  all        : Set up the virtual environment (default target)"
	@echo "  venv       : Create the virtual environment"
	@echo "  activate   : Activate the virtual environment"
	@echo "  update     : Download and update custom configuration files"
	@echo "  clean      : Remove the virtual environment"
	@echo "  build_upload	: Build python package and upload it to the pypi repository"
	@echo "  help       : Display this help message"


.PHONY: all venv activate test clean pre-commit update help
