_Author_:  <!-- TODO: Add author name --> \
_Created_: <!-- TODO: Add date --> \
_Updated_: <!-- TODO: Add date --> \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Ballerina HubSpot CRM Products Connector. 
The OpenAPI specification is obtained from [HubSpot CRM Object Products API v3 OpenAPI spec](https://github.com/HubSpot/HubSpot-public-api-spec-collection/blob/main/PublicApiSpecs/CRM/Tickets/Rollouts/424/v3/tickets.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

[//]: # (TODO: Add sanitation details)
1. **Change the `url` property of the `servers` object**:
   - **Original**: `https://api.hubapi.com`
   - **Updated**: `https://api.hubapi.com/crm/v3/objects/products`
   - **Reason**: This change is made to ensure that all API paths are relative to the versioned base URL (`/crm/v3/objects/products`), which improves the consistency and usability of the APIs.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client -o ballerina
```
Note: The license year is hardcoded to 2024, change if necessary.
