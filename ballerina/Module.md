## Overview

[HubSpot](https://www.hubspot.com/our-story) is an AI-powered customer relationship management (CRM) platform.

The `ballerinax/hubspot.crm.obj.products` package offers APIs to connect and interact with [HubSpot CRM Object Products API](https://developers.hubspot.com/docs/reference/api/crm/objects/products) endpoints, specifically based on [HubSpot REST API v3](https://github.com/HubSpot/HubSpot-public-api-spec-collection/blob/main/PublicApiSpecs/CRM/Products/Rollouts/424/v3/products.json).

## Setup guide

To use the HubSpot CRM Object Products connector, you must have access to the HubSpot API through a HubSpot developer account and an associated HubSpot app. Therefore, if you don't have one already, you need to register for a developer account on HubSpot.

### Step 1: Create/Login to a HubSpot Developer Account

If you already have an account, go to the [HubSpot developer portal](https://app.hubspot.com/)

If you don't have a HubSpot Developer Account, you can sign up to a free account [here](https://developers.hubspot.com/get-started)

### Step 2 (Optional): Create a [Developer Test Account](https://developers.hubspot.com/beta-docs/getting-started/account-types#developer-test-accounts) under your account

Within app developer accounts, you can create developer test accounts to test apps and integrations without affecting any real HubSpot data.

**Note:** _These accounts are intended only for development and testing purposes and should not be used production environments._

1. Go to 'Test Account' section from the left sidebar.

![Hubspot developer portal](https://raw.githubusercontent.com/ballerina-platform/https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.products/main/docs/setup/resources/test_acc_1.png)

2. Click 'Create developer test account'. In the dialog box, give a name to your test account and click 'Create'.

![Hubspot developer portal](https://raw.githubusercontent.com/ballerina-platform/https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.products/main/docs/setup/resources/test_acc_2.png)

### Step 3: Create a HubSpot App under your account.

1. In your developer account, navigate to the 'Apps' section. Click on 'Create App'.

![Hubspot app creation 1](https://raw.githubusercontent.com/ballerina-platform/https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.products/main/docs/setup/resources/create_app_1.png)

2. Provide the necessary details, including the app name and description.

### Step 4: Configure the Authentication Flow.

1. Move to the Auth Tab.

![Hubspot app auth setup 1](https://raw.githubusercontent.com/ballerina-platform/https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.products/main/docs/setup/resources/create_app_2.png)

2. In the Scopes section, add the following scope for your app using the 'Add new scope' button.

   `e-commerce`

![Hubspot app auth setup 2](https://raw.githubusercontent.com/ballerina-platform/https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.products/main/docs/setup/resources/scope_set.png)

3. Add your Redirect URI in the relevant section. You can also use localhost addresses for local development purposes. Click 'Create App'.

![Hubspot app auth setup 3](https://raw.githubusercontent.com/ballerina-platform/https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.products/main/docs/setup/resources/create_app_final.png)

### Step 5: Get your Client ID and Client Secret

- Navigate to the 'Auth' section of your app. Make sure to save the provided Client ID and Client Secret.

![Hubspot app auth setup 5](https://raw.githubusercontent.com/ballerina-platform/https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.products/main/docs/setup/resources/get_credentials.png)

### Step 6: Setup Authentication Flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token using the following steps:

1. Create an authorization URL using the following format:

   ```
   https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
   ```

   Replace the **YOUR_CLIENT_ID**, **YOUR_REDIRECT_URI** and **YOUR_SCOPES** with your specific value.

   **NOTE:** _If you are using a localhost redirect url, make sure to have a listener running at the relevant port before executing the next step._

2. Paste it in the browser and select your developer test account to install the app when prompted.

![Hubspot app install](https://raw.githubusercontent.com/ballerina-platform/https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.products/main/docs/setup/resources/install_app.png)

3. A code will be displayed in the browser. Copy the code.

4. Run the following curl command. Replace the **YOUR_CLIENT_ID**, **YOUR_REDIRECT_URI** and **YOUR_CLIENT_SECRET** with your specific value. Use the code you received in the above step 3 as the **CODE**.

   - Linux/macOS

     ```bash
     curl --request POST \
     --url https://api.hubapi.com/oauth/v1/token \
     --header 'content-type: application/x-www-form-urlencoded' \
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   - Windows

     ```bash
     curl --request POST ^
     --url https://api.hubapi.com/oauth/v1/token ^
     --header 'content-type: application/x-www-form-urlencoded' ^
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   This command will return the access token necessary for API calls.

   ```json
   {
     "token_type": "bearer",
     "refresh_token": "<Refresh Token>",
     "access_token": "<Access Token>",
     "expires_in": 1800
   }
   ```

5. Store the access token securely for use in your application.

## Quickstart

To use the **HubSpot CRM Object Products** connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `hubspot.crm.obj.products` module and `oauth2` module.

```ballerina
import ballerina/oauth2;
mport ballerinax/hubspot.crm.obj.products as hsproducts;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and, configure the obtained credentials in the above steps as follows:

   ```toml
    clientId = <Client Id>
    clientSecret = <Client Secret>
    refreshToken = <Refresh Token>
   ```

2. Instantiate a `hsproducts:OAuth2RefreshTokenGrantConfig` with the obtained credentials and initialize the connector with it.

   ```ballerina
   configurable string clientId = ?;
   configurable string clientSecret = ?;
   configurable string refreshToken = ?;

   hsproducts:OAuth2RefreshTokenGrantConfig auth = {
       clientId,
       clientSecret,
       refreshToken,
       credentialBearer: oauth2:POST_BODY_BEARER
   };

   hsproducts:Client hubSpotProducts = check new ({ auth });
   ```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations. A sample usecase is shown below.

#### Create a product

```ballerina
public function main() returns error? {
  products: SimplePublicObjectInputForCreate payload = {
        "properties": {
            "name": "Coffee Grinder",
            "hs_sku": "CMK12346",
            "price": "540.00",
            "description": "A high-quality coffee grinder that powders excellent coffee."
        }
    };
    products: SimplePublicObject response = check hubspotCrmObjectProducts->/.post(payload);
}
```

## Examples

The `Ballerina HubSpot CRM Products Connector` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-hubspot.crm.object.products/tree/main/examples/), covering the following use cases:

1. [Update Batch of Products](https://github.com/module-ballerinax-hubspot.crm.object.products/tree/main/examples/Update-products) - Integrate Ballerina Hubspot CRM Products Connector to update the properties of a batch of products.

2. [Filter and Archive Batch](https://github.com/module-ballerinax-hubspot.crm.object.products/tree/main/examples/search-and-archive) - Integrate Ballerina Hubspot CRM Products Connector to filter products based on the price and then archive the batch.
