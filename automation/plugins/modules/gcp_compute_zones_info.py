#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import absolute_import, division, print_function

__metaclass__ = type

DOCUMENTATION = r"""
---
module: gcp_compute_zones_info
short_description: List the Compute Engine zones of a region
description:
  - Lists all zones of a region, including unavailable zones, in name order.
  - Optionally checks whether a machine type is available in each running zone.
  - Requires C(compute.zones.list) and, when I(machine_type) is specified, C(compute.machineTypes.get).
options:
  region:
    description: The region whose zones should be returned.
    required: true
    type: str
  machine_type:
    description: Optional machine type to check in each zone with status C(UP).
    type: str
  project:
    description: The Google Cloud project to use.
    required: true
    type: str
  auth_kind:
    description: The credential type.
    required: true
    type: str
    choices: [application, machineaccount, serviceaccount, accesstoken]
  service_account_contents:
    description: Service account JSON, as a dictionary or JSON string.
    type: jsonarg
  service_account_file:
    description: Path to a service account JSON file.
    type: path
  service_account_email:
    description: Service account email for machine account authentication.
    type: str
  access_token:
    description: OAuth2 token for access token authentication.
    type: str
  scopes:
    description: OAuth scopes. Defaults to the Compute Engine read-only scope.
    type: list
    elements: str
  env_type:
    description: Optional Ansible environment identifier used in the user agent.
    type: str
requirements:
  - google-auth
  - requests
"""

EXAMPLES = r"""
- name: List zones where the requested VM type is available
  vitabaks.autobase.gcp_compute_zones_info:
    project: my-project
    region: europe-west1
    machine_type: c3-standard-4
    auth_kind: serviceaccount
    service_account_contents: "{{ gcp_service_account_contents }}"
"""

RETURN = r"""
resources:
  description: Zones of the requested region, sorted by name.
  returned: always
  type: list
  elements: dict
  contains:
    name:
      description: Zone name.
      type: str
      returned: always
    region:
      description: Region resource URL.
      type: str
      returned: always
    status:
      description: Zone status, UP or DOWN.
      type: str
      returned: always
    supports_machine_type:
      description: Whether the machine type exists in this zone. Unavailable zones return false.
      type: bool
      returned: when machine_type is specified
"""

from urllib.parse import quote

from ansible_collections.google.cloud.plugins.module_utils.gcp_utils import GcpModule, GcpSession


def decode_response(module, response):
    module.raise_for_status(response)
    try:
        result = response.json()
    except ValueError:
        module.fail_json(msg="Compute Engine returned an invalid JSON response.")
    if result.get("error"):
        module.fail_json(msg="Compute Engine returned an error: {0}".format(result["error"]))
    return result


def list_zones(module, session):
    project = quote(module.params["project"], safe="")
    region = module.params["region"]
    url = "https://compute.googleapis.com/compute/v1/projects/{0}/zones".format(project)
    # Filter locally: the API returns region URLs, not bare region names.
    zones = session.list(url, decode_response, timeout=60)
    zones = sorted((zone for zone in zones if zone["region"].rsplit("/", 1)[-1] == region),
                   key=lambda zone: zone["name"])
    machine_type = module.params.get("machine_type")
    if machine_type:
        for zone in zones:
            supported = False
            if zone["status"] == "UP":
                machine_url = "{0}/{1}/machineTypes/{2}".format(
                    url, quote(zone["name"], safe=""), quote(machine_type, safe=""))
                response = session.full_get(machine_url, timeout=60)
                # A missing machine type is not an API/authentication error.
                if response.status_code != 404:
                    decode_response(module, response)
                    supported = True
            zone["supports_machine_type"] = supported
    return zones


def main():
    module = GcpModule(
        argument_spec=dict(
            project=dict(type="str", required=True),
            region=dict(type="str", required=True),
            machine_type=dict(type="str"),
        ),
        supports_check_mode=True,
    )
    if not module.params["project"]:
        module.fail_json(msg="A Google Cloud project must be specified.")
    if not module.params["scopes"]:
        module.params["scopes"] = ["https://www.googleapis.com/auth/compute.readonly"]
    module.exit_json(changed=False, resources=list_zones(module, GcpSession(module, "compute")))


if __name__ == "__main__":
    main()
