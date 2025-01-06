import ballerina/test;
import ballerina/oauth2;
import ballerina/io;
import ballerina/http;

configurable boolean isLiveServer = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;


OAuth2RefreshTokenGrantConfig testAuth = {
       clientId: clientId,
       clientSecret: clientSecret,
       refreshToken: refreshToken,
       credentialBearer: oauth2:POST_BODY_BEARER // this line should be added in to when you are going to create auth object.
   };

configurable string serviceUrl = ?;

ConnectionConfig hubSpotConfig = {
    auth: testAuth
};

Client hubspotCrmObjectProducts = test:mock(Client);

string newId = "";
string[] batchIds = [];
SimplePublicObjectId[] inputs = [];

@test:BeforeSuite
function setup() returns error? {
    if (isLiveServer) {
        io:println("Running tests on actual server");
    } else {
        io:println("Running tests on mock server");
    }

    hubspotCrmObjectProducts = check new (hubSpotConfig, serviceUrl);
}

// List a page of products
@test:Config {dependsOn: [testCreateProducts]}
function testListProducts() returns error?{
    io:println("Listing products!");
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubspotCrmObjectProducts-> /;
    io:println(response);
    test:assertTrue(response?.results.length() > 0, "No products found."); 
}

// Create a product with the given properties and return a copy of the object, including the ID. 
@test:Config
function testCreateProducts() returns  error? {
    io:println("Creating products!");
    SimplePublicObjectInputForCreate payload = {
      "properties": {
        "name": "Coffee Grinder",
        "hs_sku": "CMK12346",
        "price": "540.00",
        "description": "A high-quality coffee grinder that powders excellent coffee."
      }
};
    SimplePublicObject response = check hubspotCrmObjectProducts-> /.post(payload);
    newId = response?.id;
    test:assertTrue(response?.id.length() > 0, "No products found."); 
}

// Perform a partial update of an Object identified by {productId}.
@test:Config 
function testUpdateProductProperties() returns error?{
  io:println("Updating product properties!");
  SimplePublicObjectInput payload = {
    "properties": {
    "price": "600.00",
    "description": "A high-quality coffee grinder that powders coffee. Your ideal grinder for cafes, restaurants and smaller coffeeshops."
  }
  };
  SimplePublicObject response = check hubspotCrmObjectProducts-> /[newId].patch(payload);
  test:assertTrue(response?.id.length() >0, "Error response received.");
}

// Read an Object identified by {productId}.
@test:Config {dependsOn: [testUpdateProductProperties]}
function testReadProduct() returns error? {
  io:println("Reading a product!");
  SimplePublicObjectWithAssociations response = check hubspotCrmObjectProducts-> /[newId];
  test:assertEquals(response?.id, newId);
  
}

// Move an Object identified by {productId} to the recycling bin.
@test:Config {dependsOn: [testCreateProducts, testListProducts, testUpdateProductProperties, testReadProduct]}
function testDeleteProduct() returns error? {
  io:println("Deleting product!");
  http:Response response = check hubspotCrmObjectProducts-> /[newId].delete();
  test:assertEquals(response.statusCode, 204);
}

// Create a batch of products
@test:Config
function  testCreateBatch() returns error? {
  io:println("Creating a batch of products!");
  BatchInputSimplePublicObjectInputForCreate payload = {inputs: [{
      properties: {
        "name": "Espresso Machine",
        "hs_sku": "ESM67890",
        "price": "120.00",
        "description": "An advanced espresso machine for the perfect cup of espresso."
      }
    },

    {
      properties: {
        "name": "Tea Kettle",
        "hs_sku": "TKL11223",
        "price": "25.00",
        "description": "A sleek stainless steel kettle for boiling water for tea or coffee."
      }
    },

    {
      properties: {
        "name": "French Press",
        "hs_sku": "FP34567",
        "price": "30.00",
        "description": "A classic French press for brewing delicious coffee or tea."
      }
    }
  ]};
  BatchResponseSimplePublicObject response = check hubspotCrmObjectProducts-> /batch/create.post(payload);
  test:assertTrue(response?.completedAt.length()>0, "Error response received.");
  foreach SimplePublicObject item in response.results {
    batchIds.push(item.id);
  }
  foreach string id in batchIds {
    SimplePublicObjectId newRecord = {id};
    inputs.push(newRecord);
  }
}

// Archive a batch of products
@test:Config {dependsOn: [testCreateBatch, testReadBatch, testSearchProduct, testUpdateBatch, testUpsertBatch]}
function testArchiveBatch() returns error? {
  BatchInputSimplePublicObjectId payload = {inputs};
  http:Response response = check hubspotCrmObjectProducts-> /batch/archive.post(payload);
  test:assertEquals(response.statusCode, 204);
}

// Create or update a batch of products by unique property values
@test:Config {dependsOn: [testCreateBatch]}
function testUpsertBatch() returns error? {
  BatchInputSimplePublicObjectBatchInputUpsert payload = {inputs: [
    {
      idProperty: "hs_sku",
      id: "ESM67890",
      properties: {
        "price": "920.00"
      }
    },

    {
      idProperty: "hs_sku",
      id: "CBM56789",
      properties: {
        "name": "Cold Brew Maker",
        "price": "860.00",
        "description": "A cold brew maker for brewing smooth and rich cold coffee at home."
      }
    }
  ]};
  BatchResponseSimplePublicUpsertObject response = check hubspotCrmObjectProducts-> /batch/upsert.post(payload);
  test:assertTrue(response?.completedAt.length()>0, "Error response received.");
}

// Read a batch of products by internal ID, or unique property values
@test:Config
function testReadBatch() returns error? {
  BatchReadInputSimplePublicObjectId payload = {
    propertiesWithHistory: ["price", "description"],
    inputs: inputs,
    properties: ["name", "hs_sku"]
  };
  BatchResponseSimplePublicObject response = check hubspotCrmObjectProducts-> /batch/read.post(payload);
  test:assertTrue(response?.completedAt.length()>0, "Error response received.");
}

// Update a batch of products
@test:Config {dependsOn: [testCreateBatch]}
function testUpdateBatch() returns error? {
  BatchInputSimplePublicObjectBatchInput payload = {inputs: [
    {
      id: batchIds[0],
      properties: {
        "price": "780.00"
      }
    },

    {
      id: batchIds[2],
      properties: {
        "price": "625.00"
      }
    }
  ]};
  BatchResponseSimplePublicObject response = check hubspotCrmObjectProducts-> /batch/update.post(payload);
  test:assertTrue(response?.completedAt.length()>0, "Error response received.");
}

// Search and filter products
@test:Config
function testSearchProduct() returns error? {
  PublicObjectSearchRequest payload = {filterGroups: [{
    filters: [
        {
          propertyName: "price",
          value: "500",
          operator: "GTE"
        }
      ]
    }
  ]};
  CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check hubspotCrmObjectProducts-> /search.post(payload);
  test:assertTrue(response?.total >= 0, "Error found");
  io:println(response);
}