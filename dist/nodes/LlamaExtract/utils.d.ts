interface UploadResponse {
    id: string;
    name: string;
    status: string;
}
interface ExtractionJobResponse {
    id: string;
    status: string;
    extraction_agent_id: string;
    file_id: string;
}
interface JobStatusResponse {
    id: string;
    status: 'PENDING' | 'RUNNING' | 'SUCCESS' | 'FAILED';
    extraction_agent_id: string;
    file_id: string;
    created_at: string;
    updated_at: string;
}
interface ExtractionResult {
    [key: string]: any;
}
declare function extractDataFromFile(apiKey: string, agentId: string, filePath: string, fileName?: string, pollInterval?: number, maxRetries?: number): Promise<ExtractionResult>;
export { extractDataFromFile, UploadResponse, ExtractionJobResponse, JobStatusResponse, ExtractionResult };
