# Filter products and archive as a batch

This example demonstrates how to interact with the HubSpot Products API to search for products based on specific criteria (such as price) and then archive those products in bulk. The main steps include performing a filtered search, and executing a batch archive operation for the matching products.

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
