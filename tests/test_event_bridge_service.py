import boto3
import pytest

from moto import mock_events

from aws_hexagonal_adapters.event_bridge_service import EventsService

constants = {
    "event_bus_name": "custom_bus",
}


@pytest.fixture(scope="module")
def events_client():
    with mock_events():
        yield boto3.client("events", region_name="us-east-1")


@pytest.fixture(scope="module")
def events_service(events_client):
    yield EventsService(region_name="us-east-1", event_bus_name=constants["event_bus_name"])


def test_put_event(events_service: EventsService, events_client):
    events_service.put_event(item={"Source": "test", "EventBusName": constants["event_bus_name"]})
