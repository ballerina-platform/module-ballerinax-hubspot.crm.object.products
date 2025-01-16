
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

service on new http:Listener(9090) {
    resource isolated function get .() returns CollectionResponseSimplePublicObjectWithAssociationsForwardPaging|http:Response => {
        "results": [
            {
                "id": "18084920834",
                "properties": {
                    "createdate": "2025-01-03T09:26:50.490Z",
                    "description": "A cold brew maker for brewing smooth and rich cold coffee at home.",
                    "hs_lastmodifieddate": "2025-01-07T11:10:43.723Z",
                    "hs_object_id": "18084920834",
                    "name": "Cold Brew Maker",
                    "price": "860.00"
                },
                "createdAt": "2025-01-03T09:26:50.490Z",
                "updatedAt": "2025-01-07T11:10:43.723Z",
                "archived": false
            }
        ]
    };

    resource isolated function post .(@http:Payload SimplePublicObjectInputForCreate payload) returns SimplePublicObject|http:Response => {
        "createdAt": "2025-01-08T05:47:44.605Z",
        "archived": false,
        "id": "18363186830",
        "properties": {"hs_sku": "CMK12346", "hs_lastmodifieddate": "2025-01-08T05:47:44.605Z", "hs_object_source_id": "5670736", "price": "540.00", "hs_object_id": "18363186830", "name": "Coffee Grinder", "createdate": "2025-01-08T05:47:44.605Z", "description": "A high-quality coffee grinder that powders excellent coffee.", "hs_object_source": "INTEGRATION", "hs_object_source_label": "INTEGRATION"},
        "updatedAt": "2025-01-08T05:47:44.605Z"
    };

    resource isolated function delete [string productId]() returns http:Response {
        http:Response obj = new;
        obj.statusCode = 204;
        return obj;
    };

    resource isolated function get [string productId]() returns SimplePublicObjectWithAssociations => {
        "createdAt": "2025-01-08T05:47:44.605Z",
        "archived": false,
        "id": "18363186830",
        "properties": {"hs_sku": "CMK12346", "hs_lastmodifieddate": "2025-01-08T05:47:44.605Z", "hs_object_source_id": "5670736", "price": "540.00", "hs_object_id": "18363186830", "name": "Coffee Grinder", "createdate": "2025-01-08T05:47:44.605Z", "description": "A high-quality coffee grinder that powders excellent coffee.", "hs_object_source": "INTEGRATION", "hs_object_source_label": "INTEGRATION"},
        "updatedAt": "2025-01-08T05:47:44.605Z"
    };

    resource isolated function patch [string productId](@http:Payload SimplePublicObjectInput payload) returns SimplePublicObject => {
        "createdAt": "2025-01-09T07:18:05.905Z",
        "archived": false,
        "id": "18399438102",
        "properties": {"hs_lastmodifieddate": "2025-01-09T07:18:08.238Z", "hs_object_source_id": "5670736", "price": "600.00", "hs_object_id": "18399438102", "createdate": "2025-01-09T07:18:05.905Z", "description": "A high-quality coffee grinder that powders coffee. Your ideal grinder for cafes, restaurants and smaller coffeeshops.", "hs_object_source": "INTEGRATION", "hs_object_source_label": "INTEGRATION"},
        "updatedAt": "2025-01-09T07:18:08.238Z"
    };

    resource isolated function post batch/archive(@http:Payload BatchInputSimplePublicObjectId payload) returns http:Response {
        http:Response obj = new;
        obj.statusCode = 204;
        return obj;
    };

    resource isolated function post batch/create(@http:Payload BatchInputSimplePublicObjectInputForCreate payload) returns BatchResponseSimplePublicObject => {
        "completedAt": "2025-01-09T07:18:03.849Z",
        "startedAt": "2025-01-09T07:18:03.640Z",
        "results": [{"createdAt": "2025-01-09T07:18:03.656Z", "archived": false, "id": "18401814138", "properties": {"hs_sku": "TKL11223", "hs_lastmodifieddate": "2025-01-09T07:18:03.656Z", "hs_object_source_id": "5670736", "price": "25.00", "hs_object_id": "18401814138", "name": "Tea Kettle", "createdate": "2025-01-09T07:18:03.656Z", "description": "A sleek stainless steel kettle for boiling water for tea or coffee.", "hs_object_source": "INTEGRATION", "hs_object_source_label": "INTEGRATION"}, "updatedAt": "2025-01-09T07:18:03.656Z"}, {"createdAt": "2025-01-09T07:18:03.656Z", "archived": false, "id": "18401814137", "properties": {"hs_sku": "FP34567", "hs_lastmodifieddate": "2025-01-09T07:18:03.656Z", "hs_object_source_id": "5670736", "price": "30.00", "hs_object_id": "18401814137", "name": "French Press", "createdate": "2025-01-09T07:18:03.656Z", "description": "A classic French press for brewing delicious coffee or tea.", "hs_object_source": "INTEGRATION", "hs_object_source_label": "INTEGRATION"}, "updatedAt": "2025-01-09T07:18:03.656Z"}, {"createdAt": "2025-01-09T07:18:03.656Z", "archived": false, "id": "18401814139", "properties": {"hs_sku": "ESM67890", "hs_lastmodifieddate": "2025-01-09T07:18:03.656Z", "hs_object_source_id": "5670736", "price": "120.00", "hs_object_id": "18401814139", "name": "Espresso Machine", "createdate": "2025-01-09T07:18:03.656Z", "description": "An advanced espresso machine for the perfect cup of espresso.", "hs_object_source": "INTEGRATION", "hs_object_source_label": "INTEGRATION"}, "updatedAt": "2025-01-09T07:18:03.656Z"}],
        "status": "COMPLETE"
    };

    resource isolated function post batch/read(@http:Payload BatchReadInputSimplePublicObjectId payload) returns BatchResponseSimplePublicObject => {
        "completedAt": "2025-01-09T07:18:06.939Z",
        "startedAt": "2025-01-09T07:18:06.928Z",
        "results": [{"createdAt": "2025-01-09T07:18:03.656Z", "archived": false, "propertiesWithHistory": {"price": [{"sourceId": "5670736", "sourceType": "INTEGRATION", "value": "780.00", "timestamp": "2025-01-09T07:18:04.947Z"}, {"sourceId": "5670736", "sourceType": "INTEGRATION", "value": "25.00", "timestamp": "2025-01-09T07:18:03.656Z"}], "description": [{"sourceId": "5670736", "sourceType": "INTEGRATION", "value": "A sleek stainless steel kettle for boiling water for tea or coffee.", "timestamp": "2025-01-09T07:18:03.656Z"}]}, "id": "18401814138", "properties": {"hs_sku": "TKL11223", "hs_lastmodifieddate": "2025-01-09T07:18:04.947Z", "hs_object_id": "18401814138", "name": "Tea Kettle", "createdate": "2025-01-09T07:18:03.656Z"}, "updatedAt": "2025-01-09T07:18:04.947Z"}, {"createdAt": "2025-01-09T07:18:03.656Z", "archived": false, "propertiesWithHistory": {"price": [{"sourceId": "5670736", "sourceType": "INTEGRATION", "value": "920.00", "timestamp": "2025-01-09T07:18:05.433Z"}, {"sourceId": "5670736", "sourceType": "INTEGRATION", "value": "625.00", "timestamp": "2025-01-09T07:18:04.947Z"}, {"sourceId": "5670736", "sourceType": "INTEGRATION", "value": "120.00", "timestamp": "2025-01-09T07:18:03.656Z"}], "description": [{"sourceId": "5670736", "sourceType": "INTEGRATION", "value": "An advanced espresso machine for the perfect cup of espresso.", "timestamp": "2025-01-09T07:18:03.656Z"}]}, "id": "18401814139", "properties": {"hs_sku": "ESM67890", "hs_lastmodifieddate": "2025-01-09T07:18:05.433Z", "hs_object_id": "18401814139", "name": "Espresso Machine", "createdate": "2025-01-09T07:18:03.656Z"}, "updatedAt": "2025-01-09T07:18:05.433Z"}, {"createdAt": "2025-01-09T07:18:03.656Z", "archived": false, "propertiesWithHistory": {"price": [{"sourceId": "5670736", "sourceType": "INTEGRATION", "value": "30.00", "timestamp": "2025-01-09T07:18:03.656Z"}], "description": [{"sourceId": "5670736", "sourceType": "INTEGRATION", "value": "A classic French press for brewing delicious coffee or tea.", "timestamp": "2025-01-09T07:18:03.656Z"}]}, "id": "18401814137", "properties": {"hs_sku": "FP34567", "hs_lastmodifieddate": "2025-01-09T07:18:04.799Z", "hs_object_id": "18401814137", "name": "French Press", "createdate": "2025-01-09T07:18:03.656Z"}, "updatedAt": "2025-01-09T07:18:04.799Z"}],
        "status": "COMPLETE"
    };

    resource isolated function post batch/update(@http:Payload BatchInputSimplePublicObjectBatchInput payload, map<string|string[]> headers = {}) returns BatchResponseSimplePublicObject => {
        "completedAt": "2025-01-09T07:18:05.033Z",
        "startedAt": "2025-01-09T07:18:04.925Z",
        "results": [{"createdAt": "2025-01-09T07:18:03.656Z", "archived": false, "id": "18401814139", "properties": {"hs_lastmodifieddate": "2025-01-09T07:18:04.947Z", "hs_object_source_id": "5670736", "price": "625.00", "hs_object_id": "18401814139", "createdate": "2025-01-09T07:18:03.656Z", "hs_object_source": "INTEGRATION", "hs_object_source_label": "INTEGRATION"}, "updatedAt": "2025-01-09T07:18:04.947Z"}, {"createdAt": "2025-01-09T07:18:03.656Z", "archived": false, "id": "18401814138", "properties": {"hs_lastmodifieddate": "2025-01-09T07:18:04.947Z", "hs_object_source_id": "5670736", "price": "780.00", "hs_object_id": "18401814138", "createdate": "2025-01-09T07:18:03.656Z", "hs_object_source": "INTEGRATION", "hs_object_source_label": "INTEGRATION"}, "updatedAt": "2025-01-09T07:18:04.947Z"}],
        "status": "COMPLETE"
    };

    resource isolated function post batch/upsert(@http:Payload BatchInputSimplePublicObjectBatchInputUpsert payload, map<string|string[]> headers = {}) returns BatchResponseSimplePublicUpsertObject => {
        "completedAt": "2025-01-09T07:18:05.522Z",
        "startedAt": "2025-01-09T07:18:05.421Z",
        "results": [{"createdAt": "2025-01-03T09:26:50.490Z", "archived": false, "new": false, "id": "18084920834", "properties": {"hs_lastmodifieddate": "2025-01-07T11:10:43.723Z", "hs_object_source_id": "5670736", "price": "860.00", "hs_object_id": "18084920834", "name": "Cold Brew Maker", "createdate": "2025-01-03T09:26:50.490Z", "description": "A cold brew maker for brewing smooth and rich cold coffee at home.", "hs_object_source": "INTEGRATION", "hs_object_source_label": "INTEGRATION"}, "updatedAt": "2025-01-07T11:10:43.723Z"}, {"createdAt": "2025-01-09T07:18:03.656Z", "archived": false, "new": false, "id": "18401814139", "properties": {"hs_lastmodifieddate": "2025-01-09T07:18:05.433Z", "hs_object_source_id": "5670736", "price": "920.00", "hs_object_id": "18401814139", "createdate": "2025-01-09T07:18:03.656Z", "hs_object_source": "INTEGRATION", "hs_object_source_label": "INTEGRATION"}, "updatedAt": "2025-01-09T07:18:05.433Z"}],
        "status": "COMPLETE"
    };

    resource isolated function post search(@http:Payload PublicObjectSearchRequest payload) returns CollectionResponseWithTotalSimplePublicObjectForwardPaging => {
        "total": 1,
        "results": [{"createdAt": "2025-01-03T09:26:50.490Z", "archived": false, "id": "18084920834", "properties": {"hs_lastmodifieddate": "2025-01-07T11:10:43.723Z", "price": "860.00", "hs_object_id": "18084920834", "name": "Cold Brew Maker", "createdate": "2025-01-03T09:26:50.490Z", "description": "A cold brew maker for brewing smooth and rich cold coffee at home."}, "updatedAt": "2025-01-07T11:10:43.723Z"}]
    };
};
