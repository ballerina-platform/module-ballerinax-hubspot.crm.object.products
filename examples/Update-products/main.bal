import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.obj.products as products;

// Configurable values for the API authentication and server details.
configurable boolean isLiveServer = ?;  
configurable string clientId = ?;  
configurable string clientSecret = ?;  
configurable string refreshToken = ?;  
configurable string serviceUrl = ?;  

public function main() returns error? {

    // OAuth2 configuration for refreshing the authentication token using the provided client credentials.
    products:OAuth2RefreshTokenGrantConfig testAuth = {
        clientId: clientId,  
        clientSecret: clientSecret,  
        refreshToken: refreshToken,  
        credentialBearer: oauth2:POST_BODY_BEARER  // Use POST_BODY_BEARER to send OAuth2 credentials in the request body.
    };

    // Create the HubSpot connection configuration with the authentication details.
    products:ConnectionConfig hubSpotConfig = {
        auth: testAuth  
    };

    // Initialize the HubSpot CRM client with the connection configuration and the service URL.
    products:Client hubspotCrmObjectProducts = check new (hubSpotConfig, serviceUrl);
    
    // Create an empty BatchInput object to store updates for products.
    products:BatchInputSimplePublicObjectBatchInput payload = {inputs: []};

    // Fetch all products from HubSpot using the GET method.
    products:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubspotCrmObjectProducts-> /;

    // Iterate through each product in the response.
    foreach products:SimplePublicObjectWithAssociations item in response.results {
        io:println(item.properties);  // Print product properties (fields).

        // Create a BatchInput object for each product to store potential updates.
        products:SimplePublicObjectBatchInput line = {id: item.id, properties: {}};

        // Access the 'name' property of the product and check if it exists.
        string? name = item.properties.get("name");

        // If the 'name' property exists, prompt the user to decide if it should be changed.
        if (name is string) {
            io:println("Product name: ", name);  
            io:println("Does this name need to change? (Y|N)");  
            
            // If the user wants to change the name, ask for the new name and update the product.
            if(io:readln() == "Y") {
                io:println("Enter new name:");  
                string new_name = io:readln();  
                line.properties["name"] = new_name;  
            }
        }

        // Access the 'price' property of the product and check if it exists.
        string? price = item.properties.get("price");

        // If the 'price' property exists, prompt the user to decide if it should be changed.
        if (price is string) {
            io:println("Product Price: ", price);  
            io:println("Does this price need to change? (Y|N)");  
            
            // If the user wants to change the price, ask for the new price and update the product.
            if(io:readln() == "Y") {
                io:println("Enter new price:");  
                string new_price = io:readln();  
                line.properties["price"] = new_price;  
            }
        }

        // Access the 'description' property of the product and check if it exists.
        string? description = item.properties.get("description");

        // If the 'description' property exists, prompt the user to decide if it should be changed.
        if (description is string) {
            io:println("Product description: ", description);  
            io:println("Does this description need to change? (Y|N)");  
            
            // If the user wants to change the description, ask for the new description and update the product.
            if(io:readln() == "Y") {
                io:println("Enter new description:");  
                string new_description = io:readln();  
                line.properties["description"] = new_description;  
            }
        }

        // Add the updated product information to the payload (batch update).
        payload.inputs.push(line);
    }

    // Perform a batch update request to update the products in HubSpot.
    products:BatchResponseSimplePublicObject batch_response = check hubspotCrmObjectProducts-> /batch/update.post(payload);

    // Print the response from the batch update operation (to check the result).
    io:println(batch_response);
}
