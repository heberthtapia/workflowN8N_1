"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.extractDataFromFile = extractDataFromFile;
async function extractDataFromFile(apiKey, agentId, filePath, fileName, pollInterval = 2000, maxRetries = 150) {
    console.log('Uploading file...');
    const fileId = await uploadFile(apiKey, filePath, fileName);
    console.log(`File uploaded with ID: ${fileId}`);
    console.log('Starting extraction job...');
    const jobId = await runExtractionJob(apiKey, agentId, fileId);
    console.log(`Extraction job started with ID: ${jobId}`);
    console.log('Polling for job completion...');
    await pollForJobCompletion(apiKey, jobId, pollInterval, maxRetries);
    console.log('Job completed successfully!');
    console.log('Retrieving extraction results...');
    const results = await getExtractionResults(apiKey, jobId);
    console.log('Extraction completed successfully!');
    return results;
}
async function uploadFile(apiKey, filePath, fileName) {
    const fs = require('fs');
    const path = require('path');
    if (!fs.existsSync(filePath)) {
        throw new Error(`File not found: ${filePath}`);
    }
    const fileBuffer = fs.readFileSync(filePath);
    const finalFileName = fileName || path.basename(filePath);
    const formData = new FormData();
    const fileBlob = new Blob([fileBuffer], {
        type: getContentType(finalFileName)
    });
    formData.append('upload_file', fileBlob, finalFileName);
    const response = await fetch('https://api.cloud.llamaindex.ai/api/v1/files', {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${apiKey}`,
            'accept': 'application/json',
        },
        body: formData
    });
    if (!response.ok) {
        throw new Error(`File upload failed: ${response.status} ${response.statusText}`);
    }
    const result = await response.json();
    return result.id;
}
function getContentType(fileName) {
    const ext = fileName.toLowerCase().split('.').pop();
    switch (ext) {
        case 'pdf':
            return 'application/pdf';
        case 'docx':
            return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        case 'doc':
            return 'application/msword';
        case 'txt':
            return 'text/plain';
        case 'html':
            return 'text/html';
        case 'md':
            return 'text/markdown';
        default:
            return 'application/octet-stream';
    }
}
async function runExtractionJob(apiKey, agentId, fileId) {
    const response = await fetch('https://api.cloud.llamaindex.ai/api/v1/extraction/jobs', {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${apiKey}`,
            'accept': 'application/json',
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            extraction_agent_id: agentId,
            file_id: fileId,
        })
    });
    if (!response.ok) {
        throw new Error(`Extraction job failed to start: ${response.status} ${response.statusText}`);
    }
    const result = await response.json();
    return result.id;
}
async function pollForJobCompletion(apiKey, jobId, pollInterval, maxRetries) {
    let retries = 0;
    while (retries < maxRetries) {
        const response = await fetch(`https://api.cloud.llamaindex.ai/api/v1/extraction/jobs/${jobId}`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${apiKey}`,
                'accept': 'application/json',
            }
        });
        if (!response.ok) {
            throw new Error(`Failed to get job status: ${response.status} ${response.statusText}`);
        }
        const status = await response.json();
        if (status.status === 'SUCCESS') {
            return;
        }
        if (status.status === 'FAILED') {
            throw new Error(`Extraction job failed`);
        }
        await new Promise(resolve => setTimeout(resolve, pollInterval));
        retries++;
    }
    throw new Error(`Job polling timed out after ${maxRetries} attempts`);
}
async function getExtractionResults(apiKey, jobId) {
    const response = await fetch(`https://api.cloud.llamaindex.ai/api/v1/extraction/jobs/${jobId}/result`, {
        method: 'GET',
        headers: {
            'Authorization': `Bearer ${apiKey}`,
            'accept': 'application/json',
        }
    });
    if (!response.ok) {
        throw new Error(`Failed to get extraction results: ${response.status} ${response.statusText}`);
    }
    return await response.json();
}
//# sourceMappingURL=utils.js.map