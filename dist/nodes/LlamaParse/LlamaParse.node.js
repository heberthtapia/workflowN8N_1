"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LlamaParse = void 0;
const llamaindex_1 = require("llamaindex");
class LlamaParse {
    constructor() {
        this.description = {
            displayName: 'LlamaParse',
            name: 'llamaParse',
            icon: 'file:llamacloud.svg',
            group: ['transform'],
            version: 1,
            description: 'Parse PDF files and get their content in markdown!',
            defaults: {
                name: 'LlamaParse',
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
                    displayName: 'Resource',
                    name: 'resource',
                    type: 'options',
                    options: [
                        {
                            name: 'Parse the File',
                            value: 'parsing',
                        },
                    ],
                    default: 'parsing',
                    noDataExpression: true,
                    required: true,
                    description: 'Parse a PDF file and get the markdown content!',
                },
                {
                    displayName: 'Operation',
                    name: 'operation',
                    type: 'options',
                    displayOptions: {
                        show: {
                            resource: [
                                'parsing',
                            ],
                        },
                    },
                    options: [
                        {
                            name: 'Parse',
                            value: 'parse',
                            description: 'Parse a PDF File',
                            action: 'Parse a pdf file',
                        },
                    ],
                    default: 'parse',
                    noDataExpression: true,
                },
                {
                    displayName: 'File Path',
                    name: 'filePath',
                    type: 'string',
                    required: true,
                    displayOptions: {
                        show: {
                            operation: [
                                'parse',
                            ],
                            resource: [
                                'parsing',
                            ],
                        },
                    },
                    default: '',
                    placeholder: '/User/user/Desktop/file.pdf',
                    description: 'Path to your file',
                },
            ],
        };
    }
    async execute() {
        const items = this.getInputData();
        const returnData = [];
        const resource = this.getNodeParameter('resource', 0);
        const operation = this.getNodeParameter('operation', 0);
        for (let i = 0; i < items.length; i++) {
            if (resource === 'parsing') {
                if (operation === 'parse') {
                    const filePath = this.getNodeParameter('filePath', i);
                    const credentials = await this.getCredentials("LlamaCloudApi");
                    const apiKey = credentials.apiKey;
                    const reader = new llamaindex_1.LlamaParseReader({ resultType: "markdown", apiKey: apiKey });
                    const documents = await reader.loadData(filePath);
                    for (let j = 0; j < documents.length; j++) {
                        returnData.push(documents[i].toJSON());
                    }
                }
            }
        }
        return [this.helpers.returnJsonArray(returnData)];
    }
}
exports.LlamaParse = LlamaParse;
//# sourceMappingURL=LlamaParse.node.js.map