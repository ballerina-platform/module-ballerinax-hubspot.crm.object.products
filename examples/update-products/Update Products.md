# Hubspot product detail update

This use case demonstrates how to interact with the HubSpot CRM Object Products API to retrieve and update product details in HubSpot CRM. The main functionality includes fetching product data, allowing the user to modify specific properties, and performing a batch update to apply the changes to the products.

## Prerequisites

### 1. Configuration

Update the related configurations in the `Config.toml` file in the example root directory:

```toml
    clientId = <Client Id>
    clientSecret = <Client Secret>
    refreshToken = <Refresh Token>
```

## Run the example

Execute the following command to run the example:

```ballerina
bal run
```
