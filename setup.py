# -*- coding: utf-8 -*-
"""A setuptools based setup module.

See:
https://packaging.python.org/en/latest/distributing.html
"""

from setuptools import setup, find_packages

setup(
    name="aws-hexagonal-adapters",
    version="0.0.1",
    description="Adapters following hexagonal architecture to connect various AWS services.",
    long_description="Adapters following hexagonal architecture to connect various AWS services",
    license="MIT",
    package_dir={"": "."},
    packages=find_packages(where="."),
    install_requires=[
        "boto3>=1.26.71,<2.0.0",
        "botocore>=1.29.71,<2.0.0",
        "aws_lambda_powertools>=2.8.0,<3.0.0",
    ],
    python_requires=">=3.9",
)
