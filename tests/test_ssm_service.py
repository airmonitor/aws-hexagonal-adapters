import boto3
import pytest

from moto import mock_kms, mock_ssm

from aws_hexagonal_adapters.ssm_service import SSMService

constants = {
    "parameter_name": "hexagonal-adapter/test-parameter",
    "parameter_value": "test-value",
}


@pytest.fixture(scope="module")
def ssm_client():
    with mock_ssm():
        yield boto3.client("ssm", region_name="us-east-1")


@pytest.fixture(scope="module")
def kms_client():
    with mock_kms():
        yield boto3.client("kms", region_name="us-east-1")


@pytest.fixture(scope="module")
def ssm_service(ssm_client):
    yield SSMService(region_name="us-east-1")


@pytest.fixture(scope="module")
def kms_key(kms_client):
    key = kms_client.create_key()
    yield key


@pytest.fixture(scope="module")
def created_ssm_parameter(ssm_service: SSMService, kms_key):
    parameter_name = constants["parameter_name"]
    parameter = ssm_service.create_parameter(
        parameter_name=parameter_name,
        value=constants["parameter_value"],
        description="test-description",
        parameter_type="SecureString",
        key_id=kms_key.get("KeyMetadata", {}).get("KeyId"),
    )
    yield parameter


def test_get_parameter(ssm_service: SSMService, created_ssm_parameter):
    parameter_name = constants["parameter_name"]
    parameter = ssm_service.get_parameter(parameter=parameter_name)
    assert parameter == constants.get("parameter_value")


def test_get_parameters(ssm_service: SSMService, created_ssm_parameter):
    parameter_name = constants["parameter_name"]
    parameters = ssm_service.get_parameters(parameters=[parameter_name])

    assert isinstance(parameters, list)
    assert parameters[0] == constants["parameter_value"]


def test_get_parameters_dict(ssm_service: SSMService, created_ssm_parameter):
    parameter_name = constants["parameter_name"]
    parameters = ssm_service.get_parameters_dict(parameters=[parameter_name])

    assert isinstance(parameters, dict)
    assert parameters[parameter_name] == constants.get("parameter_value")


def test_delete_parameter(ssm_service: SSMService, created_ssm_parameter):
    parameter_name = constants["parameter_name"]
    parameters = ssm_service.delete_parameter(parameter_name=parameter_name)

    assert parameters is None
