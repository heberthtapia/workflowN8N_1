"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LlamaCloudApi = void 0;
class LlamaCloudApi {
    constructor() {
        this.name = 'LlamaCloudApi';
        this.displayName = 'LlamaCloud API Key API';
        this.documentationUrl = 'https://cloud.docs.llamaindex.ai/llamacloud/';
        this.properties = [
            {
                displayName: 'API Key',
                name: 'apiKey',
                type: 'string',
                typeOptions: { password: true },
                default: '',
            },
        ];
        this.authenticate = {
            type: 'generic',
            properties: {
                headers: {
                    Accept: 'application/json',
                    Authorization: '=Bearer {{$credentials.apiKey}}',
                },
            },
        };
        this.test = {
            request: {
                baseURL: 'https://api.cloud.llamaindex.ai/api/v1/projects',
            },
        };
    }
}
exports.LlamaCloudApi = LlamaCloudApi;
//# sourceMappingURL=LlamaCloudApi.credentials.js.map
