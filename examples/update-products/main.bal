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

public function main() returns error? {

    hsproducts:OAuth2RefreshTokenGrantConfig auth = {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    };

    hsproducts:Client hubSpotProducts = check new ({auth});

    hsproducts:BatchInputSimplePublicObjectBatchInput payload = {inputs: []};

    hsproducts:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubSpotProducts->/;

    foreach hsproducts:SimplePublicObjectWithAssociations item in response.results {
        io:println(item.properties);

        hsproducts:SimplePublicObjectBatchInput line = {id: item.id, properties: {}};

        string? name = item.properties.get("name");

        if name is string {
            io:println("Product name: ", name);
            io:println("Does this name need to change? (Y|N)");

            if io:readln() == "Y" {
                io:println("Enter new name:");
                string new_name = io:readln();
                line.properties["name"] = new_name;
            }
        }

        string? price = item.properties.get("price");

        if price is string {
            io:println("Product Price: ", price);
            io:println("Does this price need to change? (Y|N)");

            if io:readln() == "Y" {
                io:println("Enter new price:");
                string new_price = io:readln();
                line.properties["price"] = new_price;
            }
        }

        string? description = item.properties.get("description");

        if description is string {
            io:println("Product description: ", description);
            io:println("Does this description need to change? (Y|N)");

            if io:readln() == "Y" {
                io:println("Enter new description:");
                string new_description = io:readln();
                line.properties["description"] = new_description;
            }
        }

        payload.inputs.push(line);
    }

    hsproducts:BatchResponseSimplePublicObject batch_response = check hubSpotProducts->/batch/update.post(payload);

    if batch_response.status == "COMPLETE" {
        io:println("Successfully updated the response.");
    }
}
