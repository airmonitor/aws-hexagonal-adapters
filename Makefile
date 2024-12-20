# Makefile for setting up and activating a Python virtual environment

# Set the desired Python interpreter (change if needed)
PYTHON := python3.13
VERSION := 1.4.1

# Virtual environment directory
VENV := .venv

STAGE?=ppe

# Default target
all: venv activate install

# Create the virtual environment
venv:
	@echo "Creating Python virtual environment..."
	uv venv --seed --python  $(PYTHON) $(VENV)

# Activate the virtual environment
activate:
	@echo "Activating Python virtual environment..."
	@echo "Run 'deactivate' to exit the virtual environment."
	@. $(VENV)/bin/activate

install:
	@echo "Installing dependencies from requirements files"
	pip install --upgrade pip
	pip install uv
	uv pip install --system --native-tls --upgrade pip
	uv pip install --system --native-tls pre-commit pytest pytest-snapshot


local_install:
	@echo "Installing dependencies from requirements files"
	pip install --upgrade pip
	pip install uv
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

build:
	@echo "Building and uploading to PyPi"
	rm -rf dist/*
	uv build

upload:
	@echo "Building and uploading to PyPi"
	uv publish --token $(PYPI_TOKEN)
	rm -rf dist/*

build_upload:
	@echo "Building and uploading to PyPi"
	rm -rf dist/*
	uv build
	uv publish --token $(PYPI_TOKEN)
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
