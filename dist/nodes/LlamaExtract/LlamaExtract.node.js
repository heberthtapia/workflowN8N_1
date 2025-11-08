"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LlamaExtract = void 0;
const utils_1 = require("./utils");
class LlamaExtract {
    constructor() {
        this.description = {
            displayName: 'LlamaExtract',
            name: 'llamaExtract',
            icon: 'file:llamacloud.svg',
            group: ['transform'],
            version: 1,
            description: 'Extract content from files through LlamaExtract agents!',
            defaults: {
                name: 'LlamaExtract',
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
                            name: 'Extract Data',
                            value: 'extracting',
                        },
                    ],
                    default: 'extracting',
                    noDataExpression: true,
                    required: true,
                    description: 'Extract Data From a File and Get Elegant Structured Information about it',
                },
                {
                    displayName: 'Operation',
                    name: 'operation',
                    type: 'options',
                    displayOptions: {
                        show: {
                            resource: [
                                'extracting',
                            ],
                        },
                    },
                    options: [
                        {
                            name: 'Extract',
                            value: 'extract',
                            description: 'Extract Data from a File',
                            action: 'Extract data from a file',
                        },
                    ],
                    default: 'extract',
                    noDataExpression: true,
                },
                {
                    displayName: 'Agent ID',
                    name: 'agentId',
                    type: 'string',
                    required: true,
                    displayOptions: {
                        show: {
                            operation: [
                                'extract',
                            ],
                            resource: [
                                'extracting',
                            ],
                        },
                    },
                    default: '',
                    placeholder: '',
                    description: 'Extraction Agent ID',
                },
                {
                    displayName: 'File Path',
                    name: 'filePath',
                    type: 'string',
                    required: true,
                    displayOptions: {
                        show: {
                            operation: [
                                'extract',
                            ],
                            resource: [
                                'extracting',
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
            if (resource === 'extracting') {
                if (operation === 'extract') {
                    const filePath = this.getNodeParameter('filePath', i);
                    const credentials = await this.getCredentials("LlamaCloudApi");
                    const apiKey = credentials.apiKey;
                    const agentId = this.getNodeParameter('agentId', i);
                    const result = await (0, utils_1.extractDataFromFile)(apiKey, agentId, filePath);
                    returnData.push(result);
                }
            }
        }
        return [this.helpers.returnJsonArray(returnData)];
    }
}
exports.LlamaExtract = LlamaExtract;
//# sourceMappingURL=LlamaExtract.node.js.map