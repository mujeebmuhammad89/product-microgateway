// Copyright (c)  WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file   except
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

@http:ServiceConfig {
    basePath:"/userinfo"
}
service userInfoService on tokenListenerEndpoint {

    @http:ResourceConfig {
        path: "/*"
    }
    resource function userInfoResource(http:Caller caller, http:Request req) {
        checkExpectHeaderPresent(req);
        var response = keyValidationEndpoint->forward(getConfigValue(KM_CONF_INSTANCE_ID, KM_TOKEN_CONTEXT, "/oauth2") +
                untaint req.rawPath, req);
        if(response is http:Response) {
            _ = caller->respond(response);
        }
        else {
            http:Response errorResponse = new;
            json errMsg = { "error": "error occurred while invoking the user info endpoint" };
            errorResponse.setJsonPayload(errMsg);
            _ = caller->respond(errorResponse);
        }
    }
}