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

    hsproducts:PublicObjectSearchRequest search_payload = {
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

    hsproducts:CollectionResponseWithTotalSimplePublicObjectForwardPaging searchResponse = check hubSpotProducts->/search.post(search_payload);

    hsproducts:SimplePublicObjectId[] inputs = [];

    foreach hsproducts:SimplePublicObject line in searchResponse.results {
        hsproducts:SimplePublicObjectId newRecord = {id: line.id};
        inputs.push(newRecord);
    }

    hsproducts:BatchInputSimplePublicObjectId archivePayload = {inputs};

    http:Response response = check hubSpotProducts->/batch/archive.post(archivePayload);

    if response.statusCode == 204 {
        io:println("Archived successfully");
    }
}
