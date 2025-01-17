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

import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.obj.products as hsproducts;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

function updateProductField(string fieldName, string? currentValue) returns string? {
    if currentValue is string {
        io:println(fieldName, ": ", currentValue);
        io:println("Does this ", fieldName, " need to change? (Y|N)");

        if io:readln() == "Y" {
            io:println("Enter new ", fieldName, ":");
            return io:readln();
        }
    }
    return currentValue; // Return the original value if no update is needed
}

public function main() returns error? {
    hsproducts:OAuth2RefreshTokenGrantConfig auth = {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    };

    hsproducts:Client hubSpotProducts = check new ({auth});

    hsproducts:BatchInputSimplePublicObjectBatchInput payload = {inputs: []};

    hsproducts:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging productsResponse = check hubSpotProducts->/;

    foreach hsproducts:SimplePublicObjectWithAssociations product in productsResponse.results {
        io:println(product.properties);

        hsproducts:SimplePublicObjectBatchInput line = {id: product.id, properties: {}};

        string? name = product.properties.get("name");
        line.properties["name"] = check updateProductField("Product name", name);

        string? price = product.properties.get("price");
        line.properties["price"] = check updateProductField("Product price", price);

        string? description = product.properties.get("description");
        line.properties["description"] = check updateProductField("Product description", description);

        payload.inputs.push(line);
    }

    hsproducts:BatchResponseSimplePublicObject batchResponse = check hubSpotProducts->/batch/update.post(payload);

    if batchResponse.status == "COMPLETE" {
        io:println("Successfully updated the response.");
    }
}

