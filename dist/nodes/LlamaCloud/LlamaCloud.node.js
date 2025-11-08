"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LlamaCloud = void 0;
const llamaindex_1 = require("llamaindex");
class LlamaCloud {
    constructor() {
        this.description = {
            displayName: 'LlamaCloud',
            name: 'llamaCloud',
            icon: 'file:llamacloud.svg',
            group: ['action'],
            version: 1,
            description: 'Retrieve context from your LlamaCloud Index',
            defaults: {
                name: 'LlamaCloud',
            },
            inputs: ["main"],
            outputs: ["main"],
            credentials: [
                {
                    name: "LlamaCloudApi",
                    required: true,
                }
            ],
            properties: [
                {
                    displayName: 'Index Name',
                    name: 'indexName',
                    type: 'string',
                    required: true,
                    default: '',
                    placeholder: 'my-index-name',
                    description: 'Your LlamaCloud index name',
                },
            ],
        };
    }
    async execute() {
        const credentials = await this.getCredentials("LlamaCloudApi");
        const apiKey = credentials.apiKey;
        const indexName = this.getNodeParameter('indexName', 0);
        const items = this.getInputData();
        const chatMessage = typeof items[0].json.chatInput === 'string'
            ? items[0].json.chatInput
            : '';
        const index = new llamaindex_1.LlamaCloudIndex({
            apiKey: apiKey,
            name: indexName,
            projectName: 'Default'
        });
        const retriever = index.asRetriever({
            similarityTopK: 5,
        });
        const contexts = await retriever.retrieve({
            query: chatMessage,
        });
        const contextTexts = Array.isArray(contexts)
            ? contexts.map((item) => (item.node && typeof item.node.getContent === 'function') ? item.node.getContent(llamaindex_1.MetadataMode.NONE) : null).filter(Boolean)
            : [];
        return [[{ json: { context: contextTexts } }]];
    }
}
exports.LlamaCloud = LlamaCloud;
//# sourceMappingURL=LlamaCloud.node.js.map