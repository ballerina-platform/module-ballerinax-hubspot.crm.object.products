// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
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
import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.obj.products as products;

// Configurable values for API authentication and server details  
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

public function main() returns error? {

    // OAuth2 configuration for refreshing the authentication token using the provided client credentials.
    products:OAuth2RefreshTokenGrantConfig testAuth = {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER // Use POST_BODY_BEARER to send OAuth2 credentials in the request body.
    };

    // Initialize the HubSpot CRM client with the connection configuration and the service URL.
    products:Client hubspotCrmObjectProducts = check new ({auth: testAuth});

    // Define the search payload to filter products with a price less than or equal to 500
    products:PublicObjectSearchRequest search_payload = {
        filterGroups: [
            {
                filters: [
                    {
                        propertyName: "price",
                        value: "500",
                        operator: "LTE"
                    }
                ]
            }
        ]
    };

    // Perform the search API call to HubSpot with the provided filter conditions
    products:CollectionResponseWithTotalSimplePublicObjectForwardPaging search_response = check hubspotCrmObjectProducts->/search.post(search_payload);

    // Prepare the payload for batch archiving products that match the search criteria
    products:SimplePublicObjectId[] inputs = [];

    // Iterate through the search results and create a new record for each product to be archived
    foreach products:SimplePublicObject line in search_response.results {
        products:SimplePublicObjectId newRecord = {id: line.id};
        inputs.push(newRecord);
    }

    // Prepare the batch input payload with all product IDs to be archived
    products:BatchInputSimplePublicObjectId archive_payload = {inputs};

    // Perform the batch archive operation on the HubSpot API
    http:Response response = check hubspotCrmObjectProducts->/batch/archive.post(archive_payload);

    if response.statusCode == 204 {
        io:println("Archived successfully");
    }
}
