import { LlamaParse } from './nodes/LlamaParse/LlamaParse.node';
import { LlamaExtract } from './nodes/LlamaExtract/LlamaExtract.node';
import { LlamaCloud } from './nodes/LlamaCloud/LlamaCloud.node';
import { LlamaCloudApi } from './credentials/LlamaCloudApi.credentials';

export { LlamaParse, LlamaExtract, LlamaCloud, LlamaCloudApi };

// Also provide a default map for convenience
const nodes = {
  LlamaParse,
  LlamaExtract,
  LlamaCloud,
};

const credentials = {
  LlamaCloudApi,
};

export default {
  nodes,
  credentials,
};
