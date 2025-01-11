// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/oauth2;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string clientId = os:getEnv("HUBSPOT_CLIENT_ID");
final string clientSecret = os:getEnv("HUBSPOT_CLIENT_SECRET");
final string refreshToken = os:getEnv("HUBSPOT_REFRESH_TOKEN");
final string serviceUrl = isLiveServer ? "https://api.hubapi.com/crm/v3/objects/products" : "http://localhost:9090";

final Client hubSpotProducts = check initClient();

function initClient() returns Client|error {
    if isLiveServer {
        OAuth2RefreshTokenGrantConfig auth = {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        };
        return check new ({auth}, serviceUrl);
    }
    return check new ({
        auth: {
            token: "test-token"
        }
    }, serviceUrl);
}

string newId = "";
string[] batchIds = [];
SimplePublicObjectId[] inputs = [];

@test:Config {
    dependsOn: [testCreateProducts],
    groups: ["live_tests", "mock_tests"]
}
function testListProducts() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubSpotProducts->/;
    test:assertTrue(response?.results.length() > 0);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateProducts() returns error? {
    SimplePublicObjectInputForCreate payload = {
        "properties": {
            "name": "Coffee Grinder",
            "hs_sku": "CMK12346",
            "price": "540.00",
            "description": "A high-quality coffee grinder that powders excellent coffee."
        }
    };
    SimplePublicObject response = check hubSpotProducts->/.post(payload);
    newId = response?.id;
    test:assertTrue(response?.id.length() > 0);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testUpdateProductProperties() returns error? {
    SimplePublicObjectInput payload = {
        "properties": {
            "price": "600.00",
            "description": "A high-quality coffee grinder that powders coffee. Your ideal grinder for cafes, restaurants and smaller coffeeshops."
        }
    };
    SimplePublicObject response = check hubSpotProducts->/[newId].patch(payload);
    test:assertTrue(response?.id.length() > 0);
}

@test:Config {
    dependsOn: [testUpdateProductProperties],
    groups: ["live_tests", "mock_tests"]
}
function testReadProduct() returns error? {
    SimplePublicObjectWithAssociations response = check hubSpotProducts->/[newId];
    test:assertEquals(response?.id, newId);
}

@test:Config {
    dependsOn: [testCreateProducts, testListProducts, testUpdateProductProperties, testReadProduct],
    groups: ["live_tests", "mock_tests"]
}
function testDeleteProduct() returns error? {
    http:Response response = check hubSpotProducts->/[newId].delete();
    test:assertEquals(response.statusCode, 204);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateBatch() returns error? {
    BatchInputSimplePublicObjectInputForCreate payload = {
        inputs: [
            {
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
        ]
    };
    BatchResponseSimplePublicObject response = check hubSpotProducts->/batch/create.post(payload);
    test:assertTrue(response?.completedAt.length() > 0);
    foreach SimplePublicObject item in response.results {
        batchIds.push(item.id);
    }
    foreach string id in batchIds {
        SimplePublicObjectId newRecord = {id};
        inputs.push(newRecord);
    }
}

@test:Config {
    dependsOn: [testCreateBatch, testReadBatch, testSearchProduct, testUpdateBatch, testUpsertBatch],
    groups: ["live_tests", "mock_tests"]
}
function testArchiveBatch() returns error? {
    BatchInputSimplePublicObjectId payload = {inputs};
    http:Response response = check hubSpotProducts->/batch/archive.post(payload);
    test:assertEquals(response.statusCode, 204);
}

@test:Config {
    dependsOn: [testCreateBatch],
    groups: ["live_tests", "mock_tests"]
}
function testUpsertBatch() returns error? {
    BatchInputSimplePublicObjectBatchInputUpsert payload = {
        inputs: [
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
        ]
    };
    BatchResponseSimplePublicUpsertObject response = check hubSpotProducts->/batch/upsert.post(payload);
    test:assertTrue(response?.completedAt.length() > 0);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testReadBatch() returns error? {
    BatchReadInputSimplePublicObjectId payload = {
        propertiesWithHistory: ["price", "description"],
        inputs: inputs,
        properties: ["name", "hs_sku"]
    };
    BatchResponseSimplePublicObject response = check hubSpotProducts->/batch/read.post(payload);
    test:assertTrue(response?.completedAt.length() > 0);
}

@test:Config {
    dependsOn: [testCreateBatch],
    groups: ["live_tests", "mock_tests"]
}
function testUpdateBatch() returns error? {
    BatchInputSimplePublicObjectBatchInput payload = {
        inputs: [
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
        ]
    };
    BatchResponseSimplePublicObject response = check hubSpotProducts->/batch/update.post(payload);
    test:assertTrue(response?.completedAt.length() > 0);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testSearchProduct() returns error? {
    PublicObjectSearchRequest payload = {
        filterGroups: [
            {
                filters: [
                    {
                        propertyName: "price",
                        value: "500",
                        operator: "GTE"
                    }
                ]
            }
        ]
    };
    CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check hubSpotProducts->/search.post(payload);
    test:assertTrue(response?.total >= 0);
}
