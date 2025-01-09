import ballerina/http;
import ballerina/log;

listener http:Listener httpListener = new (9091);

http:Service mockService = service object {
    # List
    #
    # + return - successful operation 
    resource isolated function get .() returns CollectionResponseSimplePublicObjectWithAssociationsForwardPaging| http:Response => {
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

    # Create
    #
    # + return - successful operation 
    resource isolated function post .(@http:Payload SimplePublicObjectInputForCreate payload) returns SimplePublicObject|http:Response => {
      "createdAt":"2025-01-08T05:47:44.605Z","archived":false,"id":"18363186830","properties":{"hs_sku":"CMK12346","hs_lastmodifieddate":"2025-01-08T05:47:44.605Z","hs_object_source_id":"5670736","price":"540.00","hs_object_id":"18363186830","name":"Coffee Grinder","createdate":"2025-01-08T05:47:44.605Z","description":"A high-quality coffee grinder that powders excellent coffee.","hs_object_source":"INTEGRATION","hs_object_source_label":"INTEGRATION"},"updatedAt":"2025-01-08T05:47:44.605Z"
    };
    // resource function post .(http:Caller caller, http:Request request) returns error? {
    //   json response = {
    //     "createdAt":"2025-01-08T05:47:44.605Z","archived":false,"id":"18363186830","properties":{"hs_sku":"CMK12346","hs_lastmodifieddate":"2025-01-08T05:47:44.605Z","hs_object_source_id":"5670736","price":"540.00","hs_object_id":"18363186830","name":"Coffee Grinder","createdate":"2025-01-08T05:47:44.605Z","description":"A high-quality coffee grinder that powders excellent coffee.","hs_object_source":"INTEGRATION","hs_object_source_label":"INTEGRATION"},"updatedAt":"2025-01-08T05:47:44.605Z"
    //   };
    //   return caller->respond(response);
    // }

    # Archive
    #
    # + return - No content 
    resource isolated function delete [string productId]() returns http:Response => {
      object http:Response
    };
};

function init() returns error? {
    if isLiveServer {
        log:printInfo("Skiping mock server initialization as the tests are running on live server");
        return;
    }
    log:printInfo("Initiating mock server");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}
